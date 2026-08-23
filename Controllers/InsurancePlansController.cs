using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Project3.DTOs;
using Project3.Models;
using Project3.Services.Interfaces;

[ApiController]
[Authorize]
[Route("api/[controller]")]
public class InsurancePlansController
    : BaseCrudController<
        InsurancePlan,
        InsurancePlanDto,
        CreateInsurancePlanDto>
{
    public InsurancePlansController(
        ICrudService<
            InsurancePlan,
            InsurancePlanDto,
            CreateInsurancePlanDto> service,
        IAuthorizationService authorizationService,
        ICurrentUserService currentUser)
        : base(
            service,
            authorizationService,
            currentUser)
    {
    }
}