using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Project3.Authentication;
using Project3.DTOs;
using Project3.Services.Interfaces;

namespace Project3.Controllers;

[ApiController]
[Authorize]
[Route("api/[controller]")]
public class RoutesController
    : BaseCrudController<
        Project3.Models.Route,
        RouteDto,
        CreateRouteDto>
{
    private readonly IRouteService _routeService;

    public RoutesController(
        IRouteService service,
        IAuthorizationService authorizationService,
        ICurrentUserService currentUser)
        : base(
            service,
            authorizationService,
            currentUser)
    {
        _routeService = service;
    }

    // ============================================================
    // GET ROUTE STOPS
    // ============================================================

    [HttpGet("{id:guid}/stops")]
    public async Task<IActionResult> GetStops(Guid id)
    {
        if (!await HasPermission(
            PermissionActions.Read,
            PermissionScopes.All))
        {
            return Forbid();
        }

        try
        {
            var stops =
                await _routeService.GetStopsAsync(id);

            return Ok(stops);
        }
        catch (KeyNotFoundException ex)
        {
            return NotFound(new
            {
                message = ex.Message
            });
        }
    }

    // ============================================================
    // ACTIVATE
    // ============================================================

    [HttpPost("{id:guid}/activate")]
    public async Task<IActionResult> Activate(Guid id)
    {
        if (!await HasPermission(
            PermissionActions.Update,
            PermissionScopes.All))
        {
            return Forbid();
        }

        var success =
            await _routeService.ActivateAsync(id);

        if (!success)
        {
            return NotFound(new
            {
                message = "Route not found."
            });
        }

        return Ok(new
        {
            message = "Route activated successfully."
        });
    }

    // ============================================================
    // DEACTIVATE
    // ============================================================

    [HttpPost("{id:guid}/deactivate")]
    public async Task<IActionResult> Deactivate(Guid id)
    {
        if (!await HasPermission(
            PermissionActions.Update,
            PermissionScopes.All))
        {
            return Forbid();
        }

        var success =
            await _routeService.DeactivateAsync(id);

        if (!success)
        {
            return NotFound(new
            {
                message = "Route not found."
            });
        }

        return Ok(new
        {
            message = "Route deactivated successfully."
        });
    }
}