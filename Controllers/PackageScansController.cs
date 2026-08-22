using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Project3.DTOs;
using Project3.Models;
using Project3.Services.Interfaces;
using Project3.Authentication;

namespace Project3.Controllers;

[ApiController]
[Authorize]
[Route("api/package-scans")]
public class PackageScansController
    : BaseCrudController<PackageScan, PackageScanDto, CreatePackageScanDto>
{
    private readonly Pj3Context _context;
    private readonly ICurrentUserService _currentUser;

    public PackageScansController(
        ICrudService<PackageScan, PackageScanDto, CreatePackageScanDto> service,
        IAuthorizationService authorizationService,
        Pj3Context context,
        ICurrentUserService currentUser)
        : base(service, authorizationService, currentUser)
    {
        _context = context;
        _currentUser = currentUser;
    }

    protected override string ResourceName => "package_scans";

    // Override the generic Create to use scan logic
    [HttpPost]
    public override async Task<IActionResult> Create([FromBody] CreatePackageScanDto dto)
    {
        if (!await HasPermission(
            PermissionActions.Create,
            PermissionScopes.All))
        {
            return Forbid();
        }

        if (!ModelState.IsValid)
            return BadRequest(ModelState);
        var shipment = await _context.Shipments.FindAsync(dto.ShipmentId);
        if (shipment == null)
            return NotFound(new { message = "Shipment not found." });

        var userId = _currentUser.UserId;
        if (userId == null) return Unauthorized();

        var employee = await _context.Employees
            .FirstOrDefaultAsync(e => e.UserId == userId.Value);

        if (employee == null)
            return BadRequest(new { message = "Current user is not an employee." });

        var scan = new PackageScan
        {
            Id = Guid.NewGuid(),
            ScanNumber = GenerateScanNumber(),
            ShipmentId = dto.ShipmentId,
            EmployeeId = employee.Id,
            FacilityId = dto.FacilityId,
            VehicleId = dto.VehicleId,
            LocationType = dto.LocationType ?? "branch",
            ScanType = dto.ScanType ?? "pickup",
            ScanTime = DateTime.UtcNow,
            Latitude = dto.Latitude,
            Longitude = dto.Longitude,
            IpAddress = HttpContext.Connection.RemoteIpAddress?.ToString(),
            Notes = dto.Notes,
            CreatedAt = DateTime.UtcNow
        };

        _context.PackageScans.Add(scan);

        var statusCode = dto.ScanType?.ToLowerInvariant() switch
        {
            "pickup" => "PICKED_UP",
            "sorting" => "IN_SORTING",
            "loaded" => "LOADED",
            "out_for_delivery" => "OUT_FOR_DELIVERY",
            "delivered" => "DELIVERED",
            _ => "IN_TRANSIT"
        };

        var trackingStatus = await _context.TrackingStatuses
            .FirstOrDefaultAsync(ts => ts.Code == statusCode);

        if (trackingStatus == null)
        {
            trackingStatus = new TrackingStatus
            {
                Id = Guid.NewGuid(),
                Code = statusCode,
                Description = statusCode.Replace("_", " "),
                IsPublic = true,
                CreatedAt = DateTime.UtcNow
            };
            _context.TrackingStatuses.Add(trackingStatus);
        }

        var trackingEvent = new TrackingEvent
        {
            Id = Guid.NewGuid(),
            ShipmentId = dto.ShipmentId,
            PackageScanId = scan.Id,
            TrackingStatusId = trackingStatus.Id,
            EventLocation = dto.FacilityId != null ? "Facility" : (dto.VehicleId != null ? "Vehicle" : "Unknown"),
            EventTime = DateTime.UtcNow,
            IsPublic = true,
            CreatedAt = DateTime.UtcNow
        };

        _context.TrackingEvents.Add(trackingEvent);

        if (dto.ScanType?.ToLowerInvariant() == "delivered")
        {
            shipment.CurrentStatus = "delivered";
            shipment.ActualDelivery = DateTime.UtcNow;
        }
        else
        {
            shipment.CurrentStatus = statusCode.ToLowerInvariant();
        }

        shipment.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync();

        return Ok(new
        {
            scanId = scan.Id,
            scanNumber = scan.ScanNumber,
            trackingEventId = trackingEvent.Id,
            message = "Package scanned successfully."
        });
    }

    // Keep the separate scan endpoint too
    [HttpPost("scan")]
    public async Task<IActionResult> ScanShipment([FromBody] CreatePackageScanDto dto)
    {
        // Same logic as Create
        return await Create(dto);
    }

    private string GenerateScanNumber()
    {
        return "SCN-" + DateTime.UtcNow.ToString("yyyyMMddHHmmss") + "-" +
               Guid.NewGuid().ToString("N").Substring(0, 4).ToUpper();
    }
}