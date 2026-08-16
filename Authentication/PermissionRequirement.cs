using Microsoft.AspNetCore.Authorization;

namespace Project3.Authentication;

public class PermissionRequirement
    : IAuthorizationRequirement
{
    public string Permission { get; }

    public PermissionRequirement(string permission)
    {
        Permission = permission;
    }
}