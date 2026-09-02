using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Project3.DTOs;
using Project3.Models;
using Project3.Services.Interfaces;

[Route("api/[controller]")]
[ApiController]
public class FacilityController
    : BaseCrudController<
        Facility,
        FacilityDto,
        CreateFacilityDto>
{

    public FacilityController(
        ICrudService<
            Facility,
            FacilityDto,
            CreateFacilityDto> service,
        IAuthorizationService authorizationService,
        ICurrentUserService currentUser)
        : base(
            service,
            authorizationService, currentUser)
    {
    }
}