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

    // ============================================================
    // SCAN PACKAGE
    // ============================================================

    public async Task<PackageScanResultDto> ScanAsync(
        CreatePackageScanDto dto,
        Guid userId)
    {
        // --------------------------------------------------------
        // 1. Validate shipment
        // --------------------------------------------------------

        var shipment = await _context.Shipments
            .FirstOrDefaultAsync(s =>
                s.Id == dto.ShipmentId);

        if (shipment == null)
        {
            throw new KeyNotFoundException(
                "Shipment not found.");
        }

        // --------------------------------------------------------
        // 2. Find employee
        // --------------------------------------------------------

        var employee = await _context.Employees
            .FirstOrDefaultAsync(e =>
                e.UserId == userId);

        if (employee == null)
        {
            throw new InvalidOperationException(
                "Current user is not an employee.");
        }

        // --------------------------------------------------------
        // 3. Normalize and validate scan/location type
        // --------------------------------------------------------

        var scanType =
            string.IsNullOrWhiteSpace(dto.ScanType)
                ? "pickup"
                : dto.ScanType.Trim().ToLowerInvariant();

        var locationType =
            string.IsNullOrWhiteSpace(dto.LocationType)
                ? "branch"
                : dto.LocationType.Trim().ToLowerInvariant();

        var validLocationTypes = new[]
        {
    "branch",
    "distribution_center",
    "vehicle"
};

        if (!validLocationTypes.Contains(locationType))
        {
            throw new InvalidOperationException(
                $"Invalid location type '{dto.LocationType}'. " +
                "Allowed values: branch, distribution_center, vehicle.");
        }

        // Validate location reference
        switch (locationType)
        {
            case "branch":
            case "distribution_center":

                if (dto.FacilityId == null)
                {
                    throw new InvalidOperationException(
                        $"FacilityId is required when location type is '{locationType}'.");
                }

                break;

            case "vehicle":

                if (dto.VehicleId == null)
                {
                    throw new InvalidOperationException(
                        "VehicleId is required when location type is 'vehicle'.");
                }

                break;
        }

        // --------------------------------------------------------
        // 4. Generate scan number
        // --------------------------------------------------------

        var scanNumber =
            GenerateScanNumber();

        var now = DateTime.UtcNow;

        // --------------------------------------------------------
        // 5. Create Package Scan
        // --------------------------------------------------------

        var scan = new PackageScan
        {
            Id = Guid.NewGuid(),

            ScanNumber = scanNumber,

            ShipmentId = dto.ShipmentId,

            EmployeeId = employee.Id,

            FacilityId = dto.FacilityId,

            VehicleId = dto.VehicleId,

            LocationType = locationType,

            ScanType = scanType,

            ScanTime = now,

            Latitude = dto.Latitude,

            Longitude = dto.Longitude,

            IpAddress =
                null,

            Notes = dto.Notes,

            CreatedAt = now
        };

        _context.PackageScans.Add(scan);

        // --------------------------------------------------------
        // 6. Determine tracking status
        // --------------------------------------------------------

        var statusCode = scanType switch
        {
            "pickup" => "PICKED_UP",
            "sorting" => "IN_SORTING",
            "loaded" => "LOADED",
            "out_for_delivery" => "OUT_FOR_DELIVERY",
            "delivered" => "DELIVERED",
            _ => "IN_TRANSIT"
        };

        var shipmentStatus = scanType switch
        {
            "pickup" => "in_transit",
            "sorting" => "in_sorting",
            "loaded" => "loaded",
            "out_for_delivery" => "out_for_delivery",
            "delivered" => "delivered",
            _ => "in_transit"
        };

        // --------------------------------------------------------
        // 7. Find / create Tracking Status
        // --------------------------------------------------------

        var trackingStatus =
            await _context.TrackingStatuses
                .FirstOrDefaultAsync(ts =>
                    ts.Code == statusCode);

        if (trackingStatus == null)
        {
            trackingStatus = new TrackingStatus
            {
                Id = Guid.NewGuid(),

                Code = statusCode,

                Description =
                    statusCode
                        .Replace("_", " "),

                IsPublic = true,

                CreatedAt = now
            };

            _context.TrackingStatuses.Add(
                trackingStatus);
        }

        // --------------------------------------------------------
        // 8. Create Tracking Event
        // --------------------------------------------------------

        var eventLocation =
            dto.FacilityId != null
                ? "Facility"
                : dto.VehicleId != null
                    ? "Vehicle"
                    : "Unknown";

        var trackingEvent = new TrackingEvent
        {
            Id = Guid.NewGuid(),

            ShipmentId = shipment.Id,

            PackageScanId = scan.Id,

            TrackingStatusId =
                trackingStatus.Id,

            EventLocation =
                eventLocation,

            EventTime = now,

            IsPublic = true,

            CreatedAt = now
        };

        _context.TrackingEvents.Add(
            trackingEvent);

        // --------------------------------------------------------
        // 9. Update shipment status
        // --------------------------------------------------------

        shipment.CurrentStatus = shipmentStatus;

        if (scanType == "delivered")
        {
            shipment.ActualDelivery = now;
        }

        shipment.UpdatedAt = now;

        shipment.UpdatedAt = now;

        // --------------------------------------------------------
        // 10. Save everything
        // --------------------------------------------------------

        await _context.SaveChangesAsync();

        // --------------------------------------------------------
        // 11. Return result
        // --------------------------------------------------------

        return new PackageScanResultDto
        {
            ScanId = scan.Id,

            ScanNumber =
                scan.ScanNumber,

            TrackingEventId =
                trackingEvent.Id,

            TrackingStatus =
                trackingStatus.Code,

            Message =
                "Package scanned successfully."
        };
    }

    // ============================================================
    // GENERATE SCAN NUMBER
    // ============================================================

    private string GenerateScanNumber()
    {
        return
            "SCN-" +
            DateTime.UtcNow
                .ToString("yyyyMMddHHmmss") +
            "-" +
            Guid.NewGuid()
                .ToString("N")
                .Substring(0, 4)
                .ToUpper();
    }
}