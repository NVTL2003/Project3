using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Project3.DTOs;
using Project3.Models;
using Project3.Repositories.Interfaces;
using Project3.Services.Implementations;

namespace Project3.Services.Implementations;

public class DeliveryAttemptService
    : CrudService<
        DeliveryAttempt,
        DeliveryAttemptDto,
        CreateDeliveryAttemptDto>
{
    private readonly Pj3Context _context;

    public DeliveryAttemptService(
        ICrudRepository<DeliveryAttempt> repository,
        IMapper mapper,
        Pj3Context context)
        : base(repository, mapper)
    {
        _context = context;
    }

    protected override string[] SearchableProperties => new[]
    {
        "Status",
        "Reason",
        "Notes"
    };


    // =========================================================
    // BUSINESS OPERATION
    // =========================================================

    public async Task<DeliveryAttemptDto> CreateDeliveryAttemptAsync(
        CreateDeliveryAttemptDto dto,
        Guid currentUserId)
    {
        // =====================================================
        // 1. Find Employee from JWT user
        // =====================================================

        var employee = await _context.Employees
            .FirstOrDefaultAsync(e =>
                e.UserId == currentUserId &&
                e.IsActive == true);

        if (employee == null)
        {
            throw new InvalidOperationException(
                "Current user is not an active employee.");
        }


        // =====================================================
        // 2. Validate DeliveryAssignment
        // =====================================================

        var assignment = await _context.DeliveryAssignments
            .Include(a => a.Manifest)
                .ThenInclude(m => m.Route)
            .Include(a => a.RouteStop)
            .FirstOrDefaultAsync(a =>
                a.Id == dto.DeliveryAssignmentId);

        if (assignment == null)
        {
            throw new InvalidOperationException(
                "Delivery assignment not found.");
        }


        // =====================================================
        // 3. JWT employee must be assignment driver
        // =====================================================

        if (assignment.DriverId != employee.Id)
        {
            throw new UnauthorizedAccessException(
                "You are not the driver assigned to this delivery.");
        }


        // =====================================================
        // 4. Validate assignment status
        // =====================================================

        if (string.Equals(
            assignment.Status,
            "Completed",
            StringComparison.OrdinalIgnoreCase))
        {
            throw new InvalidOperationException(
                "This delivery assignment has already been completed.");
        }

        if (string.Equals(
            assignment.Status,
            "Cancelled",
            StringComparison.OrdinalIgnoreCase))
        {
            throw new InvalidOperationException(
                "This delivery assignment has been cancelled.");
        }


        // =====================================================
        // 5. Validate Manifest
        // =====================================================

        var manifest = assignment.Manifest;

        if (manifest == null)
        {
            throw new InvalidOperationException(
                "Manifest not found.");
        }


        if (string.Equals(
            manifest.Status,
            "completed",
            StringComparison.OrdinalIgnoreCase))
        {
            throw new InvalidOperationException(
                "Manifest has already been completed.");
        }

        if (string.Equals(
            manifest.Status,
            "cancelled",
            StringComparison.OrdinalIgnoreCase))
        {
            throw new InvalidOperationException(
                "Manifest has been cancelled.");
        }


        // =====================================================
        // 6. Validate Route
        // =====================================================

        var route = manifest.Route;

        if (route == null)
        {
            throw new InvalidOperationException(
                "Manifest route not found.");
        }


        // =====================================================
        // 7. Validate RouteStop
        // =====================================================

        var routeStop = assignment.RouteStop;

        if (routeStop == null)
        {
            throw new InvalidOperationException(
                "Delivery route stop not found.");
        }


        if (routeStop.RouteId != manifest.RouteId)
        {
            throw new InvalidOperationException(
                "Delivery route stop does not belong to the manifest route.");
        }


        if (routeStop.IsActive != true)
        {
            throw new InvalidOperationException(
                "Delivery route stop is inactive.");
        }


        // =====================================================
        // 8. Find ManifestItem containing Shipment
        // =====================================================

        var manifestItem = await _context.ManifestItems
            .Include(mi => mi.TransportOrder)
                .ThenInclude(to => to.Shipment)
            .FirstOrDefaultAsync(mi =>
                mi.ManifestId == assignment.ManifestId &&
                mi.TransportOrder.ShipmentId == dto.ShipmentId);

        if (manifestItem == null)
        {
            throw new InvalidOperationException(
                "Shipment does not belong to this delivery assignment's manifest.");
        }


        // =====================================================
        // 9. Find Shipment
        // =====================================================

        var shipment = manifestItem.TransportOrder?.Shipment;

        if (shipment == null)
        {
            throw new InvalidOperationException(
                "Shipment not found.");
        }


        // =====================================================
        // 10. Shipment must not already be delivered
        // =====================================================

        if (string.Equals(
            shipment.CurrentStatus,
            "delivered",
            StringComparison.OrdinalIgnoreCase))
        {
            throw new InvalidOperationException(
                "Shipment has already been delivered.");
        }


        // =====================================================
        // 11. Validate shipment has reached delivery facility
        // =====================================================

        var latestScan = await _context.PackageScans
            .Where(ps =>
                ps.ShipmentId == shipment.Id &&
                ps.FacilityId != null)
            .OrderByDescending(ps => ps.ScanTime)
            .FirstOrDefaultAsync();

        if (latestScan == null)
        {
            throw new InvalidOperationException(
                "Shipment has not reached a facility yet.");
        }


        if (latestScan.FacilityId != routeStop.FacilityId)
        {
            throw new InvalidOperationException(
                "Shipment is not currently at the assigned delivery facility.");
        }


        // =====================================================
        // 12. Validate shipment status
        // =====================================================

        var validStatuses = new[]
        {
            "out_for_delivery",
            "in_transit",
            "arrived"
        };

        if (!validStatuses.Contains(
            shipment.CurrentStatus ?? "",
            StringComparer.OrdinalIgnoreCase))
        {
            throw new InvalidOperationException(
                $"Shipment cannot be delivered from status '{shipment.CurrentStatus}'.");
        }


        // =====================================================
        // 13. Normalize delivery status
        // =====================================================

        var status = dto.Status?.Trim().ToLowerInvariant();

        var allowedStatuses = new[]
        {
            "attempted",
            "failed",
            "delivered"
        };

        if (!allowedStatuses.Contains(status))
        {
            throw new InvalidOperationException(
                "Invalid delivery attempt status.");
        }


        // =====================================================
        // 14. Validate POD when delivered
        // =====================================================

        if (status == "delivered" &&
            dto.ProofOfDelivery == null)
        {
            throw new InvalidOperationException(
                "Proof of delivery is required when delivery is successful.");
        }


        if (status != "delivered" &&
            dto.ProofOfDelivery != null)
        {
            throw new InvalidOperationException(
                "Proof of delivery can only be provided for a delivered shipment.");
        }


        // =====================================================
        // 15. Calculate AttemptNumber on server
        // =====================================================

        var previousAttempts = await _context.DeliveryAttempts
            .CountAsync(da =>
                da.DeliveryAssignmentId ==
                assignment.Id &&
                da.ShipmentId ==
                shipment.Id);

        var attemptNumber = previousAttempts + 1;


        // =====================================================
        // 16. Create DeliveryAttempt
        // =====================================================

        var now = DateTime.UtcNow;

        var attempt = new DeliveryAttempt
        {
            Id = Guid.NewGuid(),

            ShipmentId = shipment.Id,

            DeliveryAssignmentId = assignment.Id,

            AttemptNumber = attemptNumber,

            AttemptTime = now,

            Status = status,

            Reason = dto.Reason,

            Notes = dto.Notes,

            Latitude = dto.Latitude,

            Longitude = dto.Longitude,

            // Server controls this.
            IsDelivered = status == "delivered",

            CreatedAt = now,

            UpdatedAt = now
        };


        _context.DeliveryAttempts.Add(attempt);


        // =====================================================
        // 17. Create TrackingEvent
        // =====================================================

        var trackingStatusCode = status switch
        {
            "delivered" => "DELIVERED",
            "failed" => "DELIVERY_FAILED",
            _ => "OUT_FOR_DELIVERY"
        };

        var trackingStatus = await _context.TrackingStatuses
            .FirstOrDefaultAsync(ts =>
                ts.Code == trackingStatusCode);

        if (trackingStatus == null)
        {
            throw new InvalidOperationException(
                $"Tracking status '{trackingStatusCode}' was not found.");
        }


        var trackingEvent = new TrackingEvent
        {
            Id = Guid.NewGuid(),

            ShipmentId = shipment.Id,

            TrackingStatusId = trackingStatus.Id,

            EventLocation = routeStop.StopName,

            EventTime = now,

            IsPublic = trackingStatus.IsPublic ?? true,

            CreatedAt = now
        };

        _context.TrackingEvents.Add(trackingEvent);


        // =====================================================
        // 18. Handle successful delivery
        // =====================================================

        if (status == "delivered")
        {
            var podDto = dto.ProofOfDelivery!;

            var proof = new ProofOfDelivery
            {
                Id = Guid.NewGuid(),

                ShipmentId = shipment.Id,

                DeliveryAttemptId = attempt.Id,

                ReceiverName = podDto.ReceiverName,

                ReceiverSignature = podDto.ReceiverSignature,

                ReceiverRelation = podDto.ReceiverRelation,

                DeliveryPhoto = podDto.DeliveryPhoto,

                DeliveryTime = now,

                Latitude = dto.Latitude,

                Longitude = dto.Longitude,

                GpsAccuracy = podDto.GpsAccuracy,

                Notes = podDto.Notes,

                CreatedAt = now
            };

            _context.ProofOfDeliveries.Add(proof);


            // -------------------------------------------------
            // Shipment becomes delivered
            // -------------------------------------------------

            shipment.CurrentStatus = "delivered";

            shipment.ActualDelivery = now;

            shipment.UpdatedAt = now;


            // -------------------------------------------------
            // Assignment becomes completed
            // -------------------------------------------------

            assignment.Status = "Completed";

            assignment.CompletedAt = now;

            assignment.ActualDeliveryTime = now;

            assignment.UpdatedAt = now;
        }
        else
        {
            // -------------------------------------------------
            // Failed / attempted
            // -------------------------------------------------

            shipment.CurrentStatus = "out_for_delivery";

            shipment.UpdatedAt = now;


            // Assignment remains active
            assignment.UpdatedAt = now;
        }


        // =====================================================
        // 19. Save everything atomically
        // =====================================================

        await _context.SaveChangesAsync();


        // =====================================================
        // 20. Return DTO
        // =====================================================

        return _mapper.Map<DeliveryAttemptDto>(attempt);
    }


    // =========================================================
    // Generic CRUD hooks
    // =========================================================

    protected override Task<DeliveryAttempt> PrepareForCreateAsync(
        DeliveryAttempt entity,
        Guid userId)
    {
        entity.CreatedAt = DateTime.UtcNow;
        entity.UpdatedAt = DateTime.UtcNow;

        entity.AttemptTime ??= DateTime.UtcNow;

        return Task.FromResult(entity);
    }


    protected override Task PrepareForUpdateAsync(
        DeliveryAttempt entity,
        Guid userId)
    {
        entity.UpdatedAt = DateTime.UtcNow;

        return Task.CompletedTask;
    }
}