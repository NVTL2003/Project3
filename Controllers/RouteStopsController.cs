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
public class RouteStopsController
    : BaseCrudController<
        RouteStop,
        RouteStopDto,
        CreateRouteStopDto>
{
    private readonly IRouteStopService _routeStopService;

    public RouteStopsController(
        IRouteStopService service,
        IAuthorizationService authorizationService,
        ICurrentUserService currentUser)
        : base(
            service,
            authorizationService,
            currentUser)
    {
        _routeStopService = service;
    }

    // ============================================================
    // GET STOPS BY ROUTE
    // ============================================================

    [HttpGet("route/{routeId:guid}")]
    public async Task<ActionResult<IEnumerable<RouteStopDto>>>
        GetByRoute(Guid routeId)
    {
        var stops =
            await _routeStopService.GetByRouteAsync(routeId);

        return Ok(stops);
    }
}