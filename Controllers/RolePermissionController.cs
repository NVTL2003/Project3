using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Project3.DTOs;
using Project3.Models;
using Project3.Services.Interfaces;

[Route("api/[controller]")]
[ApiController]
public class RolePermissionController
    : BaseCrudController<RolePermission, RolePermissionDto, CreateRolePermissionDto>
{
    public RolePermissionController(
        ICrudService<RolePermission, RolePermissionDto, CreateRolePermissionDto> service,
        IAuthorizationService authorizationService)
        : base(service, authorizationService)
    {
    }
}