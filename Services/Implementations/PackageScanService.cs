using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Project3.DTOs;
using Project3.Models;
using Project3.Repositories.Interfaces;
using Project3.Services.Interfaces;

namespace Project3.Services.Implementations;

public class PackageScanService
    : CrudService<
        PackageScan,
        PackageScanDto,
        CreatePackageScanDto>,
      IPackageScanService
{
    private readonly Pj3Context _context;

    public PackageScanService(
        ICrudRepository<PackageScan> repository,
        IMapper mapper,
        Pj3Context context)
        : base(repository, mapper)
    {
        _context = context;
    }

    public async Task<PackageScanResultDto> ScanAsync(
        CreatePackageScanDto dto,
        Guid userId)
    {
        // ========================================================
        // 1. Find current employee
        // ========================================================

        var employee = await _context.Employees
            .FirstOrDefaultAsync(e =>
                e.UserId == userId);

        if (employee == null)
        {
            throw new InvalidOperationException(
                "Current user is not an employee.");
        }

        // ========================================================
        // 2. Find shipment
        // ========================================================

        var shipment = await _context.Shipments
            .FirstOrDefaultAsync(s =>
                s.Id == dto.ShipmentId);

        if (shipment == null)
        {
            throw new KeyNotFoundException(
                "Shipment not found.");
        }

        // ========================================================
        // 3. Normalize scan type
        // ========================================================

        var scanType =
            string.IsNullOrWhiteSpace(dto.ScanType)
                ? throw new InvalidOperationException(
                    "Scan type is required.")
                : dto.ScanType.Trim().ToLowerInvariant();

        var validScanTypes = new[]
        {
            "pickup",
            "load",
            "depart",
            "arrive",
            "unload",
            "out_for_delivery",
            "delivered"
        };

        if (!validScanTypes.Contains(scanType))
        {
            throw new InvalidOperationException(
                $"Invalid scan type '{dto.ScanType}'. " +
                "Allowed values: pickup, load, depart, arrive, " +
                "unload, out_for_delivery, delivered.");
        }

        // ========================================================
        // 4. Pickup can happen before a manifest exists
        //
        //    Example:
        //
        //    Customer
        //       ↓
        //    Employee picks package up
        //       ↓
        //    Package arrives at facility
        //       ↓
        //    Transport planning
        //
        // ========================================================

        if (scanType == "pickup")
        {
            return await CreatePickupScanAsync(
                dto,
                shipment,
                employee);
        }

        // ========================================================
        // 5. All transport-related scans require an active
        //    ManifestItem.
        //
        //    Shipment
        //       ↓
        //    TransportOrder
        //       ↓
        //    ManifestItem
        //       ↓
        //    ShipmentManifest
        //
        // ========================================================

        var manifestItems = await _context.ManifestItems
            .Include(mi => mi.Manifest)
            .Include(mi => mi.TransportOrder)
            .Where(mi =>
                mi.TransportOrder.ShipmentId == shipment.Id &&
                mi.Manifest.Status != "completed" &&
                mi.Manifest.Status != "cancelled")
            .ToListAsync();

        if (manifestItems.Count == 0)
        {
            throw new InvalidOperationException(
                "Shipment is not assigned to an active transport manifest.");
        }

        if (manifestItems.Count > 1)
        {
            throw new InvalidOperationException(
                "Shipment is assigned to multiple active manifests.");
        }

        var manifestItem = manifestItems[0];

        var manifest = manifestItem.Manifest;

        // ========================================================
        // 6. Validate scan based on operation
        // ========================================================

        switch (scanType)
        {
            case "load":
                ValidateLoadScan(
                    dto,
                    manifestItem,
                    manifest,
                    employee);

                break;

            case "depart":
                ValidateDepartScan(
                    dto,
                    manifestItem,
                    manifest,
                    employee);

                break;

            case "arrive":
                ValidateArriveScan(
                    dto,
                    manifestItem,
                    manifest,
                    employee);

                break;

            case "unload":
                ValidateUnloadScan(
                    dto,
                    manifestItem,
                    manifest,
                    employee);

                break;

            case "out_for_delivery":
                ValidateOutForDeliveryScan(
                    dto,
                    manifestItem,
                    manifest,
                    employee);

                break;

            case "delivered":
                // Final delivery can happen after the manifest
                // lifecycle, so it has separate validation.
                ValidateDeliveredScan(
                    dto,
                    shipment,
                    employee);

                break;
        }

        // ========================================================
        // 7. Create PackageScan
        // ========================================================

        var now = DateTime.UtcNow;

        var scan = new PackageScan
        {
            Id = Guid.NewGuid(),

            ScanNumber = GenerateScanNumber(),

            ShipmentId = shipment.Id,

            // NEVER trust EmployeeId from client.
            EmployeeId = employee.Id,

            FacilityId = dto.FacilityId,

            VehicleId = dto.VehicleId,

            LocationType =
                NormalizeLocationType(dto.LocationType),

            ScanType = scanType,

            ScanTime = now,

            Latitude = dto.Latitude,

            Longitude = dto.Longitude,

            // Do not accept IP from client.
            // If you later need it, get it from HttpContext.
            IpAddress = null,

            Notes = dto.Notes,

            CreatedAt = now
        };

        _context.PackageScans.Add(scan);

        // ========================================================
        // 8. Update ManifestItem
        // ========================================================

        UpdateManifestItem(
            manifestItem,
            scanType,
            dto,
            now);

        // ========================================================
        // 9. Update Manifest
        // ========================================================

        await UpdateManifestAsync(
            manifest,
            manifestItem,
            scanType,
            now);

        // ========================================================
        // 10. Determine shipment status
        // ========================================================

        var shipmentStatus =
            GetShipmentStatus(scanType);

        shipment.CurrentStatus = shipmentStatus;
        shipment.UpdatedAt = now;

        if (scanType == "delivered")
        {
            shipment.ActualDelivery = now;
        }

        // ========================================================
        // 11. Tracking status
        // ========================================================

        var trackingStatusCode =
            GetTrackingStatusCode(scanType);

        var trackingStatus =
            await GetOrCreateTrackingStatusAsync(
                trackingStatusCode,
                now);

        // ========================================================
        // 12. Create TrackingEvent
        // ========================================================

        var trackingEvent = new TrackingEvent
        {
            Id = Guid.NewGuid(),

            ShipmentId = shipment.Id,

            PackageScanId = scan.Id,

            TrackingStatusId = trackingStatus.Id,

            EventLocation =
                GetEventLocation(
                    dto,
                    manifest),

            EventTime = now,

            IsPublic = true,

            CreatedAt = now
        };

        _context.TrackingEvents.Add(trackingEvent);

        // ========================================================
        // 13. Save everything together
        // ========================================================

        await _context.SaveChangesAsync();

        // ========================================================
        // 14. Return result
        // ========================================================

        return new PackageScanResultDto
        {
            ScanId = scan.Id,

            ScanNumber = scan.ScanNumber,

            TrackingEventId = trackingEvent.Id,

            TrackingStatus = trackingStatus.Code,

            Message = "Package scanned successfully."
        };
    }

    // ============================================================
    // PICKUP
    // ============================================================

    private async Task<PackageScanResultDto> CreatePickupScanAsync(
        CreatePackageScanDto dto,
        Shipment shipment,
        Employee employee)
    {
        var now = DateTime.UtcNow;

        var scan = new PackageScan
        {
            Id = Guid.NewGuid(),

            ScanNumber = GenerateScanNumber(),

            ShipmentId = shipment.Id,

            EmployeeId = employee.Id,

            FacilityId = dto.FacilityId,

            VehicleId = dto.VehicleId,

            LocationType =
                NormalizeLocationType(dto.LocationType),

            ScanType = "pickup",

            ScanTime = now,

            Latitude = dto.Latitude,

            Longitude = dto.Longitude,

            IpAddress = null,

            Notes = dto.Notes,

            CreatedAt = now
        };

        _context.PackageScans.Add(scan);

        shipment.CurrentStatus = "picked_up";
        shipment.UpdatedAt = now;

        var trackingStatus =
            await GetOrCreateTrackingStatusAsync(
                "PICKED_UP",
                now);

        var trackingEvent = new TrackingEvent
        {
            Id = Guid.NewGuid(),

            ShipmentId = shipment.Id,

            PackageScanId = scan.Id,

            TrackingStatusId = trackingStatus.Id,

            EventLocation = "Facility",

            EventTime = now,

            IsPublic = true,

            CreatedAt = now
        };

        _context.TrackingEvents.Add(trackingEvent);

        await _context.SaveChangesAsync();

        return new PackageScanResultDto
        {
            ScanId = scan.Id,

            ScanNumber = scan.ScanNumber,

            TrackingEventId = trackingEvent.Id,

            TrackingStatus = trackingStatus.Code,

            Message = "Package picked up successfully."
        };
    }

    // ============================================================
    // LOAD VALIDATION
    // ============================================================

    private void ValidateLoadScan(
        CreatePackageScanDto dto,
        ManifestItem item,
        ShipmentManifest manifest,
        Employee employee)
    {
        if (item.Status?.ToLowerInvariant() == "loaded")
        {
            throw new InvalidOperationException(
                "Shipment is already loaded onto this manifest.");
        }

        if (item.Status?.ToLowerInvariant() == "unloaded")
        {
            throw new InvalidOperationException(
                "Shipment has already been unloaded from this manifest.");
        }

        if (dto.FacilityId != manifest.DepartureFacilityId)
        {
            throw new InvalidOperationException(
                "Shipment must be loaded at the manifest departure facility.");
        }
    }

    // ============================================================
    // DEPART VALIDATION
    // ============================================================

    private void ValidateDepartScan(
        CreatePackageScanDto dto,
        ManifestItem item,
        ShipmentManifest manifest,
        Employee employee)
    {
        if (manifest.DriverId != employee.Id)
        {
            throw new UnauthorizedAccessException(
                "Only the assigned driver can depart this manifest.");
        }

        if (manifest.VehicleId != dto.VehicleId)
        {
            throw new InvalidOperationException(
                "Scanned vehicle does not match the manifest vehicle.");
        }

        if (!string.Equals(
                item.Status,
                "loaded",
                StringComparison.OrdinalIgnoreCase))
        {
            throw new InvalidOperationException(
                "Shipment must be loaded before departure.");
        }

        if (manifest.Status != "planned")
        {
            throw new InvalidOperationException(
                "Manifest is not ready for departure.");
        }
    }

    // ============================================================
    // ARRIVAL VALIDATION
    // ============================================================

    private void ValidateArriveScan(
        CreatePackageScanDto dto,
        ManifestItem item,
        ShipmentManifest manifest,
        Employee employee)
    {
        if (manifest.DriverId != employee.Id)
        {
            throw new UnauthorizedAccessException(
                "Only the assigned driver can report arrival.");
        }

        if (manifest.Status != "in_progress")
        {
            throw new InvalidOperationException(
                "Manifest is not currently in progress.");
        }

        if (!dto.FacilityId.HasValue)
        {
            throw new InvalidOperationException(
                "FacilityId is required for arrival.");
        }
    }

    // ============================================================
    // UNLOAD VALIDATION
    // ============================================================

    private void ValidateUnloadScan(
        CreatePackageScanDto dto,
        ManifestItem item,
        ShipmentManifest manifest,
        Employee employee)
    {
        if (!dto.FacilityId.HasValue)
        {
            throw new InvalidOperationException(
                "FacilityId is required when unloading a shipment.");
        }

        if (manifest.Status != "in_progress")
        {
            throw new InvalidOperationException(
                "Manifest is not currently in progress.");
        }

        if (!string.Equals(
                item.Status,
                "loaded",
                StringComparison.OrdinalIgnoreCase))
        {
            throw new InvalidOperationException(
                "Shipment is not currently loaded on this manifest.");
        }
    }

    // ============================================================
    // OUT FOR DELIVERY
    // ============================================================

    private void ValidateOutForDeliveryScan(
        CreatePackageScanDto dto,
        ManifestItem item,
        ShipmentManifest manifest,
        Employee employee)
    {
        if (!dto.VehicleId.HasValue)
        {
            throw new InvalidOperationException(
                "VehicleId is required for out-for-delivery.");
        }

        if (dto.VehicleId.Value != manifest.VehicleId)
        {
            throw new InvalidOperationException(
                "Vehicle does not match the manifest vehicle.");
        }
    }

    // ============================================================
    // DELIVERED
    // ============================================================

    private void ValidateDeliveredScan(
        CreatePackageScanDto dto,
        Shipment shipment,
        Employee employee)
    {
        if (shipment.CurrentStatus != "out_for_delivery")
        {
            throw new InvalidOperationException(
                "Shipment must be out for delivery before it can be delivered.");
        }
    }

    // ============================================================
    // MANIFEST ITEM UPDATE
    // ============================================================

    private void UpdateManifestItem(
        ManifestItem item,
        string scanType,
        CreatePackageScanDto dto,
        DateTime now)
    {
        switch (scanType)
        {
            case "load":

                item.Status = "loaded";

                item.LoadedAt = now;

                break;

            case "unload":

                item.Status = "unloaded";

                item.UnloadedAt = now;

                item.UnloadedFacilityId =
                    dto.FacilityId;

                break;
        }

        item.UpdatedAt = now;
    }

    // ============================================================
    // MANIFEST UPDATE
    // ============================================================

    private async Task UpdateManifestAsync(
        ShipmentManifest manifest,
        ManifestItem currentItem,
        string scanType,
        DateTime now)
    {
        switch (scanType)
        {
            case "depart":

                manifest.Status = "in_progress";

                break;

            case "arrive":

                manifest.ArrivalTime = now;

                break;

            case "unload":

                var remainingItems =
                    await _context.ManifestItems
                        .AnyAsync(mi =>
                            mi.ManifestId == manifest.Id &&
                            mi.Id != currentItem.Id &&
                            mi.Status != "unloaded");

                if (!remainingItems)
                {
                    manifest.Status = "completed";
                }

                break;
        }

        manifest.UpdatedAt = now;
    }

    // ============================================================
    // SHIPMENT STATUS
    // ============================================================

    private string GetShipmentStatus(
        string scanType)
    {
        return scanType switch
        {
            "pickup" =>
                "picked_up",

            "load" =>
                "loaded",

            "depart" =>
                "in_transit",

            "arrive" =>
                "arrived_at_facility",

            "unload" =>
                "received_at_facility",

            "out_for_delivery" =>
                "out_for_delivery",

            "delivered" =>
                "delivered",

            _ =>
                "created"
        };
    }

    // ============================================================
    // TRACKING STATUS
    // ============================================================

    private string GetTrackingStatusCode(
        string scanType)
    {
        return scanType switch
        {
            "pickup" =>
                "PICKED_UP",

            "load" =>
                "LOADED",

            "depart" =>
                "IN_TRANSIT",

            "arrive" =>
                "ARRIVED_AT_FACILITY",

            "unload" =>
                "RECEIVED_AT_FACILITY",

            "out_for_delivery" =>
                "OUT_FOR_DELIVERY",

            "delivered" =>
                "DELIVERED",

            _ =>
                "IN_TRANSIT"
        };
    }

    // ============================================================
    // TRACKING STATUS GET / CREATE
    // ============================================================

    private async Task<TrackingStatus>
        GetOrCreateTrackingStatusAsync(
            string code,
            DateTime now)
    {
        var status =
            await _context.TrackingStatuses
                .FirstOrDefaultAsync(ts =>
                    ts.Code == code);

        if (status != null)
        {
            return status;
        }

        status = new TrackingStatus
        {
            Id = Guid.NewGuid(),

            Code = code,

            Description =
                code.Replace("_", " "),

            IsPublic = true,

            CreatedAt = now
        };

        _context.TrackingStatuses.Add(status);

        return status;
    }

    // ============================================================
    // LOCATION TYPE
    // ============================================================

    private string NormalizeLocationType(
        string? locationType)
    {
        if (string.IsNullOrWhiteSpace(locationType))
        {
            return "branch";
        }

        var value =
            locationType.Trim().ToLowerInvariant();

        var validValues = new[]
        {
            "branch",
            "distribution_center",
            "vehicle"
        };

        if (!validValues.Contains(value))
        {
            throw new InvalidOperationException(
                $"Invalid location type '{locationType}'. " +
                "Allowed values: branch, distribution_center, vehicle.");
        }

        return value;
    }

    // ============================================================
    // EVENT LOCATION
    // ============================================================

    private string GetEventLocation(
        CreatePackageScanDto dto,
        ShipmentManifest manifest)
    {
        if (dto.VehicleId.HasValue)
        {
            return "Vehicle";
        }

        if (dto.FacilityId.HasValue)
        {
            return "Facility";
        }

        return "Unknown";
    }

    // ============================================================
    // SCAN NUMBER
    // ============================================================

    private string GenerateScanNumber()
    {
        return
            "SCN-" +
            DateTime.UtcNow.ToString("yyyyMMddHHmmss") +
            "-" +
            Guid.NewGuid()
                .ToString("N")
                .Substring(0, 4)
                .ToUpperInvariant();
    }
}