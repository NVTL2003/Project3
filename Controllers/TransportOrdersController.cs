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
[Route("api/[controller]")]
public class TransportOrdersController
    : BaseCrudController<TransportOrder, TransportOrderDto, CreateTransportOrderDto>
{
    private readonly Pj3Context _context;
    private readonly ICurrentUserService _currentUser;

    public TransportOrdersController(
        ICrudService<TransportOrder, TransportOrderDto, CreateTransportOrderDto> service,
        IAuthorizationService authorizationService,
        Pj3Context context,
        ICurrentUserService currentUser)
        : base(service, authorizationService, currentUser)
    {
        _context = context;
        _currentUser = currentUser;
    }

    protected override string ResourceName => "transport_orders";

    [HttpPost]
    public override async Task<IActionResult> Create([FromBody] CreateTransportOrderDto dto)
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

        // Force null for empty GUIDs
        Guid? assignedVehicleId = null;
        if (dto.AssignedVehicleId.HasValue && dto.AssignedVehicleId.Value != Guid.Empty)
        {
            assignedVehicleId = dto.AssignedVehicleId;
        }

        Guid? assignedDriverId = null;
        if (dto.AssignedDriverId.HasValue && dto.AssignedDriverId.Value != Guid.Empty)
        {
            assignedDriverId = dto.AssignedDriverId;
        }

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
            CreatedBy = employee.Id,
            AssignedVehicleId = assignedVehicleId,
            AssignedDriverId = assignedDriverId,
            PlannedDeparture = dto.PlannedDeparture,
            PlannedArrival = dto.PlannedArrival,
            CreatedAt = DateTime.UtcNow,
            UpdatedAt = DateTime.UtcNow
        };

        _context.TransportOrders.Add(order);

        shipment.CurrentStatus = "in_transit";
        shipment.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync();

        return Ok(new
        {
            transportOrderId = order.Id,
            orderNumber = order.OrderNumber,
            status = order.Status,
            message = "Transport order created successfully."
        });
    }

    private string GenerateOrderNumber()
    {
        return "TO-" + DateTime.UtcNow.ToString("yyyyMMddHHmmss") + "-" +
               Guid.NewGuid().ToString("N").Substring(0, 4).ToUpper();
    }
}