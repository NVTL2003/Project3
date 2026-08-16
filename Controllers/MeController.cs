using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using Project3.Models;
using Project3.DTOs;

[ApiController]
[Route("api/me")]
[Authorize]
public class MeController : ControllerBase
{
    private readonly Pj3Context _context;

    public MeController(Pj3Context context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<IActionResult> GetCurrentUser()
    {
        var userIdClaim =
            User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

        if (!Guid.TryParse(userIdClaim, out var userId))
        {
            return Unauthorized();
        }

        var user = await _context.Users
            .Where(u => u.Id == userId)
            .Select(u => new CurrentUserDto
            {
                Id = u.Id,
                Username = u.Username,
                Email = u.Email,
                Phone = u.Phone,

                Roles = u.UserRoles
                    .Select(ur => ur.Role.Name)
                    .ToList(),

                Permissions = u.UserRoles
                    .SelectMany(ur => ur.Role.RolePermissions)
                    .Select(rp => rp.Permission.Name)
                    .Distinct()
                    .ToList()
            })
            .FirstOrDefaultAsync();

        if (user == null)
        {
            return NotFound();
        }

        return Ok(user);
    }
}