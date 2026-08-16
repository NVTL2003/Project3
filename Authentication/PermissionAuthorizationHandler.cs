using Microsoft.AspNetCore.Authorization;

namespace Project3.Authentication;

public class PermissionAuthorizationHandler
    : AuthorizationHandler<PermissionRequirement>
{
    protected override Task HandleRequirementAsync(
    AuthorizationHandlerContext context,
    PermissionRequirement requirement)
    {
        Console.WriteLine("========================================");
        Console.WriteLine("🔐 AUTHORIZATION HANDLER");

        Console.WriteLine(
            $"Required permission: {requirement.Permission}"
        );

        Console.WriteLine(
            $"Authenticated: {context.User.Identity?.IsAuthenticated}"
        );

        Console.WriteLine(
            $"User: {context.User.Identity?.Name}"
        );

        var permissions =
            context.User
                .FindAll("permission")
                .Select(c => c.Value)
                .ToList();

        Console.WriteLine(
            $"JWT permissions: {string.Join(", ", permissions)}"
        );

        var hasPermission =
            permissions.Any(p =>
                string.Equals(
                    p,
                    requirement.Permission,
                    StringComparison.OrdinalIgnoreCase
                )
            );

        Console.WriteLine(
            $"HAS PERMISSION: {hasPermission}"
        );

        Console.WriteLine("========================================");

        if (hasPermission)
        {
            context.Succeed(requirement);
        }

        return Task.CompletedTask;
    }
}