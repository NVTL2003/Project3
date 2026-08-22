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
[Route("api/delivery-attempts")]
public class DeliveryAttemptsController
    : BaseCrudController<DeliveryAttempt, DeliveryAttemptDto, CreateDeliveryAttemptDto>
{
    private readonly Pj3Context _context;
    private readonly ICurrentUserService _currentUser;

    public DeliveryAttemptsController(
        ICrudService<DeliveryAttempt, DeliveryAttemptDto, CreateDeliveryAttemptDto> service,
        IAuthorizationService authorizationService,
        Pj3Context context,
        ICurrentUserService currentUser)
        : base(service, authorizationService,currentUser)
    {
        _context = context;
        _currentUser = currentUser;
    }

    protected override string ResourceName => "delivery_attempts";

    [HttpPost]
    public override async Task<IActionResult> Create(
    [FromBody] CreateDeliveryAttemptDto dto)
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

        // Handle DeliveryAssignmentId - set to null if empty GUID
        Guid? deliveryAssignmentId = null;
        if (dto.DeliveryAssignmentId != Guid.Empty)
        {
            // Check if it exists
            var assignmentExists = await _context.DeliveryAssignments
                .AnyAsync(da => da.Id == dto.DeliveryAssignmentId);

            if (assignmentExists)
            {
                deliveryAssignmentId = dto.DeliveryAssignmentId;
            }
        }

        var attempt = new DeliveryAttempt
        {
            Id = Guid.NewGuid(),
            ShipmentId = dto.ShipmentId,
            DeliveryAssignmentId = deliveryAssignmentId ?? Guid.Empty, // Will be null if no valid assignment
            AttemptNumber = dto.AttemptNumber,
            AttemptTime = dto.AttemptTime ?? DateTime.UtcNow,
            Status = dto.Status ?? "attempted",
            Reason = dto.Reason,
            Notes = dto.Notes,
            Latitude = dto.Latitude,
            Longitude = dto.Longitude,
            IsDelivered = dto.IsDelivered ?? (dto.Status == "delivered"),
            CreatedAt = DateTime.UtcNow,
            UpdatedAt = DateTime.UtcNow
        };

        _context.DeliveryAttempts.Add(attempt);

        if (dto.Status == "delivered")
        {
            var proof = new ProofOfDelivery
            {
                Id = Guid.NewGuid(),
                ShipmentId = dto.ShipmentId,
                DeliveryAttemptId = attempt.Id,
                ReceiverName = "Receiver",
                DeliveryTime = dto.AttemptTime ?? DateTime.UtcNow,
                Latitude = dto.Latitude,
                Longitude = dto.Longitude,
                Notes = dto.Notes,
                CreatedAt = DateTime.UtcNow
            };

            _context.ProofOfDeliveries.Add(proof);

            shipment.CurrentStatus = "delivered";
            shipment.ActualDelivery = dto.AttemptTime ?? DateTime.UtcNow;
            shipment.UpdatedAt = DateTime.UtcNow;
        }
        else if (dto.Status == "failed")
        {
            shipment.CurrentStatus = "exception";
            shipment.UpdatedAt = DateTime.UtcNow;
        }
        else
        {
            shipment.CurrentStatus = "out_for_delivery";
            shipment.UpdatedAt = DateTime.UtcNow;
        }

        await _context.SaveChangesAsync();

        return Ok(new
        {
            attemptId = attempt.Id,
            status = attempt.Status,
            message = dto.Status == "delivered"
                ? "Delivery completed successfully. Proof of delivery created."
                : "Delivery attempt recorded."
        });
    }

    [HttpPut("{id}")]
    public override async Task<IActionResult> Update(Guid id, [FromBody] CreateDeliveryAttemptDto dto)
    {
        return BadRequest(new { message = "Delivery attempts cannot be updated." });
    }

    [HttpDelete("{id}")]
    public override async Task<IActionResult> Delete(Guid id)
    {
        return BadRequest(new { message = "Delivery attempts cannot be deleted." });
    }
}