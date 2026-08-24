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

    public override async Task<TransportOrderDto> CreateAsync(
        CreateTransportOrderDto dto)
    {
        // --------------------------------------------------------
        // 1. Validate shipment
        // --------------------------------------------------------

        var shipment = await _context.Shipments
            .FirstOrDefaultAsync(s => s.Id == dto.ShipmentId);

        if (shipment == null)
        {
            throw new KeyNotFoundException(
                "Shipment not found.");
        }

        // --------------------------------------------------------
        // 2. Validate vehicle if supplied
        // --------------------------------------------------------

        Guid? vehicleId = null;

        if (dto.AssignedVehicleId.HasValue &&
            dto.AssignedVehicleId.Value != Guid.Empty)
        {
            var vehicleExists = await _context.Vehicles
                .AnyAsync(v => v.Id == dto.AssignedVehicleId.Value);

            if (!vehicleExists)
            {
                throw new KeyNotFoundException(
                    "Assigned vehicle not found.");
            }

            vehicleId = dto.AssignedVehicleId.Value;
        }

        // --------------------------------------------------------
        // 3. Validate driver if supplied
        // --------------------------------------------------------

        Guid? driverId = null;

        if (dto.AssignedDriverId.HasValue &&
            dto.AssignedDriverId.Value != Guid.Empty)
        {
            var driverExists = await _context.Employees
                .AnyAsync(e => e.Id == dto.AssignedDriverId.Value);

            if (!driverExists)
            {
                throw new KeyNotFoundException(
                    "Assigned driver not found.");
            }

            driverId = dto.AssignedDriverId.Value;
        }

        // --------------------------------------------------------
        // 4. Find current employee from JWT
        // --------------------------------------------------------

        var userId = _currentUser.UserId;

        if (userId == null)
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
        // 5. Create transport order
        // --------------------------------------------------------

        var now = DateTime.UtcNow;

        var order = new TransportOrder
        {
            Id = Guid.NewGuid(),

            OrderNumber = GenerateOrderNumber(),

            ShipmentId = dto.ShipmentId,

            Priority = dto.Priority ?? 5,

            Weight = dto.Weight,

            Volume = dto.Volume,

            SpecialInstructions = dto.SpecialInstructions,

            Status = "planned",

            // Server determines creator
            CreatedBy = employee.Id,

            AssignedVehicleId = vehicleId,

            AssignedDriverId = driverId,

            PlannedDeparture = dto.PlannedDeparture,

            PlannedArrival = dto.PlannedArrival,

            CreatedAt = now,

            UpdatedAt = now
        };

        _context.TransportOrders.Add(order);

        // --------------------------------------------------------
        // 6. Update shipment
        // --------------------------------------------------------

        shipment.CurrentStatus = "in_transit";
        shipment.UpdatedAt = now;

        // --------------------------------------------------------
        // 7. Save
        // --------------------------------------------------------

        await _context.SaveChangesAsync();

        // --------------------------------------------------------
        // 8. Return DTO
        // --------------------------------------------------------

        return _mapper.Map<TransportOrderDto>(order);
    }

    private string GenerateOrderNumber()
    {
        return
            "TO-" +
            DateTime.UtcNow.ToString("yyyyMMddHHmmss") +
            "-" +
            Guid.NewGuid()
                .ToString("N")
                .Substring(0, 4)
                .ToUpper();
    }
}