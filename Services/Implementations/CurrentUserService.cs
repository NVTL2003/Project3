using System.Security.Claims;
using Project3.Services.Interfaces;

namespace Project3.Services.Implementations;

public class CurrentUserService : ICurrentUserService
{
    private readonly IHttpContextAccessor _httpContextAccessor;

    public CurrentUserService(
        IHttpContextAccessor httpContextAccessor)
    {
        _httpContextAccessor = httpContextAccessor;
    }

    private ClaimsPrincipal? User =>
        _httpContextAccessor.HttpContext?.User;

    public bool IsAuthenticated =>
        User?.Identity?.IsAuthenticated == true;

    public Guid? UserId
    {
        get
        {
            var value =
                User?.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            return Guid.TryParse(value, out var id)
                ? id
                : null;
        }
    }

    public string? Username =>
        User?.FindFirst(ClaimTypes.Name)?.Value;

    public bool IsInRole(string role)
    {
        return User?.IsInRole(role) == true;
    }

    public bool HasPermission(string permission)
    {
        return User?
            .Claims
            .Where(c => c.Type == "permission")
            .Any(c => c.Value == permission)
            == true;
    }
}