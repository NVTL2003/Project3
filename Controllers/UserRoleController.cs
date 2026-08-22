using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Project3.DTOs;
using Project3.Models;
using Project3.Services.Interfaces;

[Route("api/[controller]")]
[ApiController]
public class UserRoleController
    : BaseCrudController<UserRole, UserRoleDto, CreateUserRoleDto>
{
    public UserRoleController(
        ICrudService<UserRole, UserRoleDto, CreateUserRoleDto> service,
        IAuthorizationService authorizationService,
        ICurrentUserService currentUser)
        : base(service, authorizationService, currentUser)
    {
    }
}