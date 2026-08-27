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
    public RoutesController(
        IRouteService service,
        IAuthorizationService authorizationService,
        ICurrentUserService currentUser)
        : base(
            service,
            authorizationService,
            currentUser)
    {
    }
}