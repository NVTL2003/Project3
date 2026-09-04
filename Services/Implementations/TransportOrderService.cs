using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Project3.DTOs;
using Project3.Models;
using Project3.Repositories.Interfaces;
using Project3.Services.Interfaces;

namespace Project3.Services.Implementations;

public class TransportOrderService
    : CrudService<
        TransportOrder,
        TransportOrderDto,
        CreateTransportOrderDto>,
      ITransportOrderService
{
    private readonly Pj3Context _context;
    private readonly ICurrentUserService _currentUser;

    public TransportOrderService(
        ICrudRepository<TransportOrder> repository,
        IMapper mapper,
        Pj3Context context,
        ICurrentUserService currentUser)
        : base(repository, mapper)
    {
        _context = context;
        _currentUser = currentUser;
    }

    // ============================================================
    // CREATE TRANSPORT ORDER
    // ============================================================

    public override async Task<TransportOrderDto> CreateAsync(
        CreateTransportOrderDto dto)
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
        // 2. Validate origin and destination
        // --------------------------------------------------------

        if (dto.OriginFacilityId == Guid.Empty)
        {
            throw new InvalidOperationException(
                "Origin facility is required.");
        }

        if (dto.DestinationFacilityId == Guid.Empty)
        {
            throw new InvalidOperationException(
                "Destination facility is required.");
        }

        if (dto.OriginFacilityId == dto.DestinationFacilityId)
        {
            throw new InvalidOperationException(
                "Origin and destination facilities cannot be the same.");
        }

        // --------------------------------------------------------
        // 3. Validate origin facility
        // --------------------------------------------------------

        var originFacility = await _context.Facilities
            .FirstOrDefaultAsync(f =>
                f.Id == dto.OriginFacilityId);

        if (originFacility == null)
        {
            throw new KeyNotFoundException(
                "Origin facility not found.");
        }

        // --------------------------------------------------------
        // 4. Validate destination facility
        // --------------------------------------------------------

        var destinationFacility = await _context.Facilities
            .FirstOrDefaultAsync(f =>
                f.Id == dto.DestinationFacilityId);

        if (destinationFacility == null)
        {
            throw new KeyNotFoundException(
                "Destination facility not found.");
        }

        // --------------------------------------------------------
        // 5. Validate weight
        // --------------------------------------------------------

        if (dto.Weight <= 0)
        {
            throw new InvalidOperationException(
                "Transport order weight must be greater than zero.");
        }

        // --------------------------------------------------------
        // 6. Prevent duplicate active transport orders
        // --------------------------------------------------------

        var existingOrder = await _context.TransportOrders
            .AnyAsync(o =>
                o.ShipmentId == dto.ShipmentId &&
                o.Status != "completed" &&
                o.Status != "cancelled");

        if (existingOrder)
        {
            throw new InvalidOperationException(
                "This shipment already has an active transport order.");
        }

        // --------------------------------------------------------
        // 7. Find current employee from JWT
        // --------------------------------------------------------

        var userId = _currentUser.UserId;

        if (!userId.HasValue)
        {
            throw new UnauthorizedAccessException(
                "Authenticated user not found.");
        }

        var employee = await _context.Employees
            .FirstOrDefaultAsync(e =>
                e.UserId == userId.Value);

        if (employee == null)
        {
            throw new InvalidOperationException(
                "Current user is not an employee.");
        }

        // --------------------------------------------------------
        // 8. Validate planned dates
        // --------------------------------------------------------

        if (dto.PlannedDeparture.HasValue &&
            dto.PlannedArrival.HasValue &&
            dto.PlannedArrival.Value < dto.PlannedDeparture.Value)
        {
            throw new InvalidOperationException(
                "Planned arrival cannot be earlier than planned departure.");
        }

        // --------------------------------------------------------
        // 9. Create transport order
        // --------------------------------------------------------

        var now = DateTime.UtcNow;

        var order = new TransportOrder
        {
            Id = Guid.NewGuid(),

            OrderNumber = GenerateOrderNumber(),

            ShipmentId = shipment.Id,

            OriginFacilityId = dto.OriginFacilityId,

            DestinationFacilityId = dto.DestinationFacilityId,

            Priority = dto.Priority ?? 5,

            Weight = dto.Weight,

            Volume = dto.Volume,

            SpecialInstructions = dto.SpecialInstructions,

            Status = "planned",

            CreatedBy = employee.Id,

            AssignedVehicleId = null,

            AssignedDriverId = null,

            PlannedDeparture = dto.PlannedDeparture,

            PlannedArrival = dto.PlannedArrival,

            CreatedAt = now,

            UpdatedAt = now
        };

        _context.TransportOrders.Add(order);

        await _context.SaveChangesAsync();

        return _mapper.Map<TransportOrderDto>(order);
    }

    // ============================================================
    // GENERATE ORDER NUMBER
    // ============================================================

    private string GenerateOrderNumber()
    {
        return
            "TO-" +
            DateTime.UtcNow.ToString("yyyyMMddHHmmss") +
            "-" +
            Guid.NewGuid()
                .ToString("N")
                .Substring(0, 4)
                .ToUpperInvariant();
    }
}