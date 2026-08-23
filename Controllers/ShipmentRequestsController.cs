using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Project3.DTOs;
using Project3.Models;
using Project3.Services.Interfaces;
using Project3.Authentication;

[ApiController]
[Authorize]
[Route("api/[controller]")]
public class ShipmentRequestsController
    : BaseCrudController<
        ShipmentRequest,
        ShipmentRequestDto,
        CreateShipmentRequestDto>
{
    private readonly IShipmentRequestService _shipmentRequestService;

    public ShipmentRequestsController(
        IShipmentRequestService shipmentRequestService,
        IAuthorizationService authorizationService,
        ICurrentUserService currentUser)
        : base(
            shipmentRequestService,
            authorizationService,
            currentUser)
    {
        _shipmentRequestService = shipmentRequestService;
    }

    [HttpPost("{id:guid}/approve")]
    public async Task<IActionResult> Approve(Guid id)
    {
        if (!await HasPermission(
            PermissionActions.Update,
            PermissionScopes.All))
        {
            return Forbid();
        }

        if (!TryGetCurrentUserId(out var userId))
            return Unauthorized();

        var result =
            await _shipmentRequestService
                .ApproveAsync(id, userId);

        return Ok(result);
    }
}