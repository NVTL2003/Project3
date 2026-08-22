using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Project3.DTOs;
using Project3.Models;
using Project3.Services.Interfaces;

[Route("api/[controller]")]
[ApiController]
public class PermissionController
    : BaseCrudController<Permission, PermissionDto, CreatePermissionDto>
{
    public PermissionController(
        ICrudService<Permission, PermissionDto, CreatePermissionDto> service,
        IAuthorizationService authorizationService,
        ICurrentUserService currentUser)
        : base(service, authorizationService,currentUser)
    {
    }
}