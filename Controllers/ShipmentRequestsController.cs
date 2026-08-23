using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Project3.Authentication;
using Project3.DTOs;
using Project3.Models;
using Project3.Services.Interfaces;

namespace Project3.Controllers;

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
        IShipmentRequestService service,
        IAuthorizationService authorizationService,
        ICurrentUserService currentUser)
        : base(
            service,
            authorizationService,
            currentUser)
    {
        _shipmentRequestService = service;
    }

    // ============================================================
    // APPROVE
    // ============================================================

    [HttpPost("{id}/approve")]
    public async Task<IActionResult> Approve(Guid id)
    {
        var userId = _currentUser.UserId;

        if (userId == null)
            return Unauthorized();

        var result = await _authorizationService.AuthorizeAsync(
            User,
            null,
            new PermissionRequirement(
                "shipment_requests.update.all"));

        if (!result.Succeeded)
            return Forbid();

        try
        {
            var response =
                await _shipmentRequestService.ApproveAsync(
                    id,
                    userId.Value);

            return Ok(response);
        }
        catch (KeyNotFoundException ex)
        {
            return NotFound(new
            {
                message = ex.Message
            });
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new
            {
                message = ex.Message
            });
        }
    }
}