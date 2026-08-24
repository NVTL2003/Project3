using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Project3.DTOs;
using Project3.Models;
using Project3.Services.Interfaces;

namespace Project3.Controllers;

[ApiController]
[Authorize]
[Route("api/[controller]")]
public class VehiclesController
    : BaseCrudController<
        Vehicle,
        VehicleDto,
        CreateVehicleDto>
{
    public VehiclesController(
        IVehicleService service,
        IAuthorizationService authorizationService,
        ICurrentUserService currentUser)
        : base(
            service,
            authorizationService,
            currentUser)
    {
    }

    protected override string ResourceName => "vehicles";
}