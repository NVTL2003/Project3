//using Microsoft.AspNetCore.Authorization;
//using Microsoft.EntityFrameworkCore;
//using Project3.Models;

//namespace Project3.Authentication;

//public class PermissionAuthorizationHandler
//    : AuthorizationHandler<PermissionRequirement>
//{
//    private readonly Pj3Context _context;

//    public PermissionAuthorizationHandler(
//        Pj3Context context)
//    {
//        _context = context;
//    }

//    protected override async Task HandleRequirementAsync(
//        AuthorizationHandlerContext context,
//        PermissionRequirement requirement)
//    {
//        // User must be authenticated
//        if (context.User?.Identity?.IsAuthenticated != true)
//            return;

//        // Get user ID from JWT
//        var userIdClaim =
//            context.User.FindFirst(
//                System.Security.Claims.ClaimTypes.NameIdentifier);

//        if (userIdClaim == null)
//            return;

//        if (!Guid.TryParse(
//            userIdClaim.Value,
//            out var userId))
//        {
//            return;
//        }

//        // Check database permissions
//        var hasPermission =
//            await _context.UserRoles
//                .Where(ur => ur.UserId == userId)
//                .SelectMany(
//                    ur => ur.Role.RolePermissions)
//                .AnyAsync(
//                    rp => rp.Permission.Name ==
//                          requirement.Permission);

//        if (hasPermission)
//        {
//            context.Succeed(requirement);
//        }
//    }
//}
using Microsoft.AspNetCore.Authorization;

namespace Project3.Authentication;

public class PermissionAuthorizationHandler
    : AuthorizationHandler<PermissionRequirement>
{
    protected override Task HandleRequirementAsync(
        AuthorizationHandlerContext context,
        PermissionRequirement requirement)
    {
        var hasPermission =
            context.User
                .FindAll("permission")
                .Any(c =>
                    string.Equals(
                        c.Value,
                        requirement.Permission,
                        StringComparison.OrdinalIgnoreCase));

        if (hasPermission)
        {
            context.Succeed(requirement);
        }

        return Task.CompletedTask;
    }
}