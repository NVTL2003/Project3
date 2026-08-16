using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Project3.DTOs;
using Project3.Models;
using Project3.Services.Interfaces;

[Route("api/[controller]")]
[ApiController]
public class RoleController
    : BaseCrudController<Role, RoleDto, CreateRoleDto>
{
    public RoleController(
        ICrudService<Role, RoleDto, CreateRoleDto> service,
        IAuthorizationService authorizationService)
        : base(service, authorizationService)
    {
    }
}