using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;

namespace Project3.Authentication;

public static class PermissionAuthorizationExtensions
{
    public static async Task<bool> HasPermissionAsync(
        this IAuthorizationService authorizationService,
        ClaimsPrincipal user,
        string permission)
    {
        var result =
            await authorizationService.AuthorizeAsync(
                user,
                null,
                new PermissionRequirement(permission));

        return result.Succeeded;
    }
}