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
public class EmployeesController
    : BaseCrudController<Employee, EmployeeDto, CreateEmployeeDto>
{
    public EmployeesController(
        ICrudService<Employee, EmployeeDto, CreateEmployeeDto> service,
        IAuthorizationService authorizationService,
        ICurrentUserService currentUser)
        : base(service, authorizationService, currentUser)
    {
    }

    protected override string ResourceName => "employees";
}