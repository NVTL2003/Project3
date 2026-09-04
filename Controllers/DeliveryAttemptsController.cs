using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Project3.Authentication;
using Project3.DTOs;
using Project3.Models;
using Project3.Services;
using Project3.Services.Implementations;
using Project3.Services.Interfaces;

namespace Project3.Controllers;

[ApiController]
[Authorize]
[Route("api/[controller]")]
public class DeliveryAttemptsController
    : BaseCrudController<
        DeliveryAttempt,
        DeliveryAttemptDto,
        CreateDeliveryAttemptDto>
{
    private readonly DeliveryAttemptService _deliveryAttemptService;

    public DeliveryAttemptsController(
        DeliveryAttemptService deliveryAttemptService,
        IAuthorizationService authorizationService,
        ICurrentUserService currentUser)
        : base(
            deliveryAttemptService,
            authorizationService,
            currentUser)
    {
        _deliveryAttemptService = deliveryAttemptService;
    }

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
        {
            return BadRequest(ModelState);
        }

        var userId = _currentUser.UserId;

        if (!userId.HasValue)
        {
            return Unauthorized();
        }

        var result =
            await _deliveryAttemptService
                .CreateDeliveryAttemptAsync(
                    dto,
                    userId.Value);

        return Ok(result);
    }

    [HttpPut("{id}")]
    public override async Task<IActionResult> Update(
        Guid id,
        [FromBody] CreateDeliveryAttemptDto dto)
    {
        return BadRequest(new
        {
            message = "Delivery attempts cannot be updated."
        });
    }

    [HttpDelete("{id}")]
    public override async Task<IActionResult> Delete(
        Guid id)
    {
        return BadRequest(new
        {
            message = "Delivery attempts cannot be deleted."
        });
    }
}