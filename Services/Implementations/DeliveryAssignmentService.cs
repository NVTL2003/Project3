using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Project3.DTOs;
using Project3.Models;
using Project3.Repositories.Interfaces;
using Project3.Services.Implementations;

namespace Project3.Services.Implementations;

public class DeliveryAssignmentService
    : CrudService<
        DeliveryAssignment,
        DeliveryAssignmentDto,
        CreateDeliveryAssignmentDto>
{
    private readonly Pj3Context _context;

    public DeliveryAssignmentService(
        ICrudRepository<DeliveryAssignment> repository,
        IMapper mapper,
        Pj3Context context)
        : base(repository, mapper)
    {
        _context = context;
    }

    protected override string[] SearchableProperties => new[]
    {
        "AssignmentNumber",
        "Status",
        "Notes"
    };

    protected override async Task<DeliveryAssignment> PrepareForCreateAsync(
        DeliveryAssignment entity,
        Guid userId)
    {
        // -------------------------------------------------
        // 1. Validate Manifest
        // -------------------------------------------------

        var manifest = await _context.ShipmentManifests
            .Include(m => m.Route)
            .FirstOrDefaultAsync(m => m.Id == entity.ManifestId);

        if (manifest == null)
            throw new InvalidOperationException(
                "Manifest not found.");

        if (string.Equals(
            manifest.Status,
            "completed",
            StringComparison.OrdinalIgnoreCase))
        {
            throw new InvalidOperationException(
                "Cannot create a delivery assignment for a completed manifest.");
        }

        if (string.Equals(
            manifest.Status,
            "cancelled",
            StringComparison.OrdinalIgnoreCase))
        {
            throw new InvalidOperationException(
                "Cannot create a delivery assignment for a cancelled manifest.");
        }


        // -------------------------------------------------
        // 2. Validate Driver
        // -------------------------------------------------

        var driver = await _context.Employees
            .FirstOrDefaultAsync(e =>
                e.Id == entity.DriverId &&
                e.IsActive == true);

        if (driver == null)
            throw new InvalidOperationException(
                "Driver not found or inactive.");


        // -------------------------------------------------
        // 3. Validate Vehicle
        // -------------------------------------------------

        var vehicle = await _context.Vehicles
            .FirstOrDefaultAsync(v =>
                v.Id == entity.VehicleId);

        if (vehicle == null)
            throw new InvalidOperationException(
                "Vehicle not found.");


        // -------------------------------------------------
        // 4. Manifest Driver must match assignment Driver
        // -------------------------------------------------

        if (manifest.DriverId != entity.DriverId)
        {
            throw new InvalidOperationException(
                "The selected driver is not assigned to this manifest.");
        }


        // -------------------------------------------------
        // 5. Manifest Vehicle must match assignment Vehicle
        // -------------------------------------------------

        if (manifest.VehicleId != entity.VehicleId)
        {
            throw new InvalidOperationException(
                "The selected vehicle is not assigned to this manifest.");
        }


        // -------------------------------------------------
        // 6. Validate Route
        // -------------------------------------------------

        if (manifest.Route == null)
        {
            throw new InvalidOperationException(
                "Manifest route not found.");
        }


        // -------------------------------------------------
        // 7. Validate RouteStop
        // -------------------------------------------------

        var routeStop = await _context.RouteStops
            .FirstOrDefaultAsync(rs =>
                rs.Id == entity.RouteStopId &&
                rs.IsActive == true);

        if (routeStop == null)
            throw new InvalidOperationException(
                "Route stop not found or inactive.");


        // -------------------------------------------------
        // 8. RouteStop must belong to Manifest.Route
        // -------------------------------------------------

        if (routeStop.RouteId != manifest.RouteId)
        {
            throw new InvalidOperationException(
                "The selected route stop does not belong to the manifest route.");
        }


        // -------------------------------------------------
        // 9. Prevent duplicate assignment
        // -------------------------------------------------

        var duplicate = await _context.DeliveryAssignments
            .AnyAsync(a =>
                a.ManifestId == entity.ManifestId &&
                a.RouteStopId == entity.RouteStopId &&
                a.DriverId == entity.DriverId &&
                a.Status != "Cancelled");

        if (duplicate)
        {
            throw new InvalidOperationException(
                "A delivery assignment already exists for this driver and route stop.");
        }


        // -------------------------------------------------
        // 10. Server-controlled fields
        // -------------------------------------------------

        entity.Id = Guid.NewGuid();

        entity.AssignmentNumber =
            $"ASN-{DateTime.UtcNow:yyyyMMdd}-" +
            $"{Guid.NewGuid().ToString()[..8].ToUpper()}";

        entity.Status = "Assigned";

        entity.AssignedAt = DateTime.UtcNow;

        entity.CreatedAt = DateTime.UtcNow;

        entity.UpdatedAt = DateTime.UtcNow;


        // If SequenceNumber isn't supplied,
        // use RouteStop.StopSequence.
        if (!entity.SequenceNumber.HasValue)
        {
            entity.SequenceNumber = routeStop.StopSequence;
        }


        return entity;
    }

    protected override Task PrepareForUpdateAsync(
        DeliveryAssignment entity,
        Guid userId)
    {
        entity.UpdatedAt = DateTime.UtcNow;

        return Task.CompletedTask;
    }
}