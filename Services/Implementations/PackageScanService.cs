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
        // 4. Pickup
        //
        // Pickup can happen before a transport manifest exists.
        // ========================================================

        if (scanType == "pickup")
        {
            return await CreatePickupScanAsync(
                dto,
                shipment,
                employee);
        }

        // ========================================================
        // 5. Delivered
        //
        // Delivered does NOT require an active line-haul manifest.
        // ========================================================

        if (scanType == "delivered")
        {
            ValidateDeliveredScan(
                dto,
                shipment,
                employee);

            return await CreateStandaloneScanAsync(
                dto,
                shipment,
                employee,
                scanType,
                null);
        }

        // ========================================================
        // 6. Find active manifest item
        // ========================================================

        var manifestItems = await _context.ManifestItems
            .Include(mi => mi.Manifest)
                .ThenInclude(m => m.Route)
                    .ThenInclude(r => r.RouteStops)
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
        // 7. Validate operation
        // ========================================================

        switch (scanType)
        {
            case "load":

                await ValidateLoadScanAsync(
                    dto,
                    shipment,
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

                await ValidateArriveScanAsync(
                    dto,
                    shipment,
                    manifestItem,
                    manifest,
                    employee);

                break;

            case "unload":

                await ValidateUnloadScanAsync(
                    dto,
                    shipment,
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
        }

        // ========================================================
        // 8. Create PackageScan
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

            IpAddress = null,

            Notes = dto.Notes,

            CreatedAt = now
        };

        _context.PackageScans.Add(scan);

        // ========================================================
        // 9. Update ManifestItem
        // ========================================================

        UpdateManifestItem(
            manifestItem,
            scanType,
            dto,
            now);

        // ========================================================
        // 10. Update Manifest
        // ========================================================

        await UpdateManifestAsync(
            manifest,
            manifestItem,
            scanType,
            dto.FacilityId,
            now);

        // ========================================================
        // 11. Update Shipment status
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
        // 12. Tracking status
        // ========================================================

        var trackingStatusCode =
            GetTrackingStatusCode(scanType);

        var trackingStatus =
            await GetOrCreateTrackingStatusAsync(
                trackingStatusCode,
                now);

        // ========================================================
        // 13. Tracking event
        // ========================================================

        var trackingEvent = new TrackingEvent
        {
            Id = Guid.NewGuid(),

            ShipmentId = shipment.Id,

            PackageScanId = scan.Id,

            TrackingStatusId = trackingStatus.Id,

            EventLocation =
                await GetEventLocationAsync(
                    dto,
                    manifest),

            EventTime = now,

            IsPublic = true,

            CreatedAt = now
        };

        _context.TrackingEvents.Add(trackingEvent);

        // ========================================================
        // 14. Save everything
        // ========================================================

        await _context.SaveChangesAsync();

        // ========================================================
        // 15. Return
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

        shipment.CurrentStatus = "in_sorting";
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

            EventLocation =
                await GetFacilityLocationAsync(
                    dto.FacilityId),

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

    private async Task ValidateLoadScanAsync(
        CreatePackageScanDto dto,
        Shipment shipment,
        ManifestItem item,
        ShipmentManifest manifest,
        Employee employee)
    {
        if (item.Status?.Equals(
                "loaded",
                StringComparison.OrdinalIgnoreCase) == true)
        {
            throw new InvalidOperationException(
                "Shipment is already loaded onto this manifest.");
        }

        if (item.Status?.Equals(
                "unloaded",
                StringComparison.OrdinalIgnoreCase) == true)
        {
            throw new InvalidOperationException(
                "Shipment has already been unloaded from this manifest.");
        }

        if (!dto.FacilityId.HasValue)
        {
            throw new InvalidOperationException(
                "FacilityId is required when loading a shipment.");
        }

        if (dto.FacilityId.Value != manifest.DepartureFacilityId)
        {
            throw new InvalidOperationException(
                "Shipment must be loaded at the manifest departure facility.");
        }

        // --------------------------------------------------------
        // Determine shipment's current physical facility.
        // --------------------------------------------------------

        var currentFacilityId =
            await GetCurrentShipmentFacilityAsync(
                shipment.Id);

        // If we know where the shipment currently is,
        // it must be at the manifest departure facility.
        if (currentFacilityId.HasValue &&
            currentFacilityId.Value != manifest.DepartureFacilityId)
        {
            throw new InvalidOperationException(
                "Shipment is not currently at the manifest departure facility.");
        }

        // --------------------------------------------------------
        // Manifest must be planned before loading.
        // --------------------------------------------------------

        if (!string.Equals(
                manifest.Status,
                "planned",
                StringComparison.OrdinalIgnoreCase))
        {
            throw new InvalidOperationException(
                "Shipment can only be loaded onto a planned manifest.");
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

        if (!dto.VehicleId.HasValue)
        {
            throw new InvalidOperationException(
                "VehicleId is required for departure.");
        }

        if (manifest.VehicleId != dto.VehicleId.Value)
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

        if (!string.Equals(
                manifest.Status,
                "planned",
                StringComparison.OrdinalIgnoreCase))
        {
            throw new InvalidOperationException(
                "Manifest is not ready for departure.");
        }
    }

    // ============================================================
    // ARRIVAL VALIDATION
    // ============================================================

    private async Task ValidateArriveScanAsync(
        CreatePackageScanDto dto,
        Shipment shipment,
        ManifestItem item,
        ShipmentManifest manifest,
        Employee employee)
    {
        if (manifest.DriverId != employee.Id)
        {
            throw new UnauthorizedAccessException(
                "Only the assigned driver can report arrival.");
        }

        if (!string.Equals(
                manifest.Status,
                "in_progress",
                StringComparison.OrdinalIgnoreCase))
        {
            throw new InvalidOperationException(
                "Manifest is not currently in progress.");
        }

        if (!dto.FacilityId.HasValue)
        {
            throw new InvalidOperationException(
                "FacilityId is required for arrival.");
        }

        // ========================================================
        // Find current shipment location
        // ========================================================

        var currentFacilityId =
            await GetCurrentShipmentFacilityAsync(
                shipment.Id);

        // ========================================================
        // Determine expected next facility
        // ========================================================

        var expectedFacilityId =
            await GetNextRouteFacilityAsync(
                manifest,
                currentFacilityId);

        if (expectedFacilityId != dto.FacilityId.Value)
        {
            var expectedFacility =
                await _context.Facilities
                    .FirstOrDefaultAsync(f =>
                        f.Id == expectedFacilityId);

            var expectedName =
                expectedFacility?.Name ??
                expectedFacilityId.ToString();

            throw new InvalidOperationException(
                $"Shipment cannot arrive at this facility. " +
                $"Expected next facility: {expectedName}.");
        }
    }

    // ============================================================
    // UNLOAD VALIDATION
    // ============================================================

    private async Task ValidateUnloadScanAsync(
        CreatePackageScanDto dto,
        Shipment shipment,
        ManifestItem item,
        ShipmentManifest manifest,
        Employee employee)
    {
        if (!dto.FacilityId.HasValue)
        {
            throw new InvalidOperationException(
                "FacilityId is required when unloading a shipment.");
        }

        if (!string.Equals(
                manifest.Status,
                "in_progress",
                StringComparison.OrdinalIgnoreCase))
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

        // ========================================================
        // The shipment must currently be at the unload facility.
        //
        // Example:
        //
        // arrive Bac Ninh
        // unload Bac Ninh      ← valid
        //
        // arrive Bac Ninh
        // unload Hai Duong     ← invalid
        // ========================================================

        var currentFacilityId =
            await GetCurrentShipmentFacilityAsync(
                shipment.Id);

        if (!currentFacilityId.HasValue)
        {
            throw new InvalidOperationException(
                "Current shipment facility could not be determined.");
        }

        if (currentFacilityId.Value != dto.FacilityId.Value)
        {
            throw new InvalidOperationException(
                "Shipment must be unloaded at its current facility.");
        }

        // ========================================================
        // Verify that this facility is actually on the route.
        // ========================================================

        var validRouteFacility =
            await IsFacilityOnManifestRouteAsync(
                manifest,
                dto.FacilityId.Value);

        if (!validRouteFacility)
        {
            throw new InvalidOperationException(
                "Shipment cannot be unloaded at a facility that is not on the manifest route.");
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

        if (!string.Equals(
                item.Status,
                "loaded",
                StringComparison.OrdinalIgnoreCase) &&
            !string.Equals(
                item.Status,
                "unloaded",
                StringComparison.OrdinalIgnoreCase))
        {
            throw new InvalidOperationException(
                "Shipment must have been processed by the manifest before going out for delivery.");
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
        if (!string.Equals(
                shipment.CurrentStatus,
                "out_for_delivery",
                StringComparison.OrdinalIgnoreCase))
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

                item.UnloadedAt = null;

                item.UnloadedFacilityId = null;

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
    Guid? facilityId,
    DateTime now)
    {
        switch (scanType)
        {
            case "depart":

                manifest.Status = "in_progress";

                break;

            case "arrive":

                var isDestination =
                    await IsDestinationFacilityAsync(
                        manifest,
                        facilityId);

                if (isDestination)
                {
                    manifest.ArrivalTime = now;
                }

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
    // CURRENT SHIPMENT FACILITY
    // ============================================================

    private async Task<Guid?> GetCurrentShipmentFacilityAsync(
        Guid shipmentId)
    {
        /*
         * We intentionally derive the shipment's current location
         * from PackageScan history.
         *
         * We look for the newest scan that has a FacilityId.
         *
         * Example:
         *
         * load Hanoi
         * depart Hanoi
         * arrive Bac Ninh
         *
         * Latest facility scan = Bac Ninh
         *
         * Therefore:
         *
         * CurrentFacility = Bac Ninh
         */

        var latestFacilityScan =
            await _context.PackageScans
                .Where(ps =>
                    ps.ShipmentId == shipmentId &&
                    ps.FacilityId.HasValue)
                .OrderByDescending(ps => ps.ScanTime)
                .ThenByDescending(ps => ps.CreatedAt)
                .FirstOrDefaultAsync();

        return latestFacilityScan?.FacilityId;
    }

    // ============================================================
    // NEXT ROUTE FACILITY
    // ============================================================

    private async Task<Guid> GetNextRouteFacilityAsync(
        ShipmentManifest manifest,
        Guid? currentFacilityId)
    {
        var route =
            await _context.Routes
                .Include(r => r.RouteStops)
                .FirstOrDefaultAsync(r =>
                    r.Id == manifest.RouteId);

        if (route == null)
        {
            throw new InvalidOperationException(
                "Manifest route not found.");
        }

        var stops =
            route.RouteStops
                .Where(rs => rs.IsActive != false)
                .OrderBy(rs => rs.StopSequence)
                .ToList();

        // ========================================================
        // No current facility means we are at the manifest origin.
        // ========================================================

        if (!currentFacilityId.HasValue)
        {
            return stops.Count > 0
                ? stops[0].FacilityId
                : route.DestinationFacilityId;
        }

        // ========================================================
        // Current facility = origin
        // ========================================================

        if (currentFacilityId.Value == route.OriginFacilityId)
        {
            return stops.Count > 0
                ? stops[0].FacilityId
                : route.DestinationFacilityId;
        }

        // ========================================================
        // Current facility = intermediate stop
        // ========================================================

        var currentStop =
            stops.FirstOrDefault(rs =>
                rs.FacilityId == currentFacilityId.Value);

        if (currentStop != null)
        {
            var nextStop =
                stops.FirstOrDefault(rs =>
                    rs.StopSequence >
                    currentStop.StopSequence);

            if (nextStop != null)
            {
                return nextStop.FacilityId;
            }

            // No more intermediate stops.
            // Therefore destination is next.
            return route.DestinationFacilityId;
        }

        // ========================================================
        // Current facility = destination
        // ========================================================

        if (currentFacilityId.Value ==
            route.DestinationFacilityId)
        {
            throw new InvalidOperationException(
                "Shipment has already reached the route destination.");
        }

        throw new InvalidOperationException(
            "Shipment's current facility is not part of the manifest route.");
    }

    // ============================================================
    // IS FACILITY ON ROUTE
    // ============================================================

    private async Task<bool> IsFacilityOnManifestRouteAsync(
        ShipmentManifest manifest,
        Guid facilityId)
    {
        var route =
            await _context.Routes
                .Include(r => r.RouteStops)
                .FirstOrDefaultAsync(r =>
                    r.Id == manifest.RouteId);

        if (route == null)
        {
            throw new InvalidOperationException(
                "Manifest route not found.");
        }

        if (route.OriginFacilityId == facilityId ||
            route.DestinationFacilityId == facilityId)
        {
            return true;
        }

        return route.RouteStops.Any(rs =>
            rs.IsActive != false &&
            rs.FacilityId == facilityId);
    }

    // ============================================================
    // IS DESTINATION
    // ============================================================

    private async Task<bool> IsDestinationFacilityAsync(
        ShipmentManifest manifest,
        Guid? facilityId)
    {
        if (!facilityId.HasValue)
        {
            return false;
        }

        var route =
            await _context.Routes
                .FirstOrDefaultAsync(r =>
                    r.Id == manifest.RouteId);

        if (route == null)
        {
            return false;
        }

        return route.DestinationFacilityId ==
               facilityId.Value;
    }

    // ============================================================
    // STANDALONE SCAN
    //
    // Used for delivered because there may no longer be
    // an active manifest.
    // ============================================================

    private async Task<PackageScanResultDto>
        CreateStandaloneScanAsync(
            CreatePackageScanDto dto,
            Shipment shipment,
            Employee employee,
            string scanType,
            ShipmentManifest? manifest)
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

            ScanType = scanType,

            ScanTime = now,

            Latitude = dto.Latitude,

            Longitude = dto.Longitude,

            IpAddress = null,

            Notes = dto.Notes,

            CreatedAt = now
        };

        _context.PackageScans.Add(scan);

        var shipmentStatus =
            GetShipmentStatus(scanType);

        shipment.CurrentStatus = shipmentStatus;
        shipment.UpdatedAt = now;

        if (scanType == "delivered")
        {
            shipment.ActualDelivery = now;
        }

        var trackingStatusCode =
            GetTrackingStatusCode(scanType);

        var trackingStatus =
            await GetOrCreateTrackingStatusAsync(
                trackingStatusCode,
                now);

        var trackingEvent = new TrackingEvent
        {
            Id = Guid.NewGuid(),

            ShipmentId = shipment.Id,

            PackageScanId = scan.Id,

            TrackingStatusId = trackingStatus.Id,

            EventLocation =
                await GetEventLocationAsync(
                    dto,
                    manifest),

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

            Message =
                scanType == "delivered"
                    ? "Package delivered successfully."
                    : "Package scanned successfully."
        };
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
            _ =>
                "created"
        };
    }

    // ============================================================
    // TRACKING STATUS
    // ============================================================

    private string GetShipmentStatus(string scanType)
    {
        return scanType switch
        {
            "pickup" =>
                "in_sorting",

            "load" =>
                "loaded",

            "depart" =>
                "in_transit",

            "arrive" =>
                "in_sorting",

            "unload" =>
                "in_sorting",

            "out_for_delivery" =>
                "out_for_delivery",

            "delivered" =>
                "delivered",

            _ =>
                "created"
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

    private async Task<string> GetEventLocationAsync(
        CreatePackageScanDto dto,
        ShipmentManifest? manifest)
    {
        if (dto.FacilityId.HasValue)
        {
            var facility =
                await _context.Facilities
                    .FirstOrDefaultAsync(f =>
                        f.Id == dto.FacilityId.Value);

            if (facility != null)
            {
                return facility.Name;
            }
        }

        if (dto.VehicleId.HasValue)
        {
            var vehicle =
                await _context.Vehicles
                    .FirstOrDefaultAsync(v =>
                        v.Id == dto.VehicleId.Value);

            if (vehicle != null)
            {
                return vehicle.Id.ToString();
            }

            return "Vehicle";
        }

        return "Unknown";
    }

    // ============================================================
    // FACILITY LOCATION
    // ============================================================

    private async Task<string> GetFacilityLocationAsync(
        Guid? facilityId)
    {
        if (!facilityId.HasValue)
        {
            return "Unknown";
        }

        var facility =
            await _context.Facilities
                .FirstOrDefaultAsync(f =>
                    f.Id == facilityId.Value);

        return facility?.Name ?? "Facility";
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