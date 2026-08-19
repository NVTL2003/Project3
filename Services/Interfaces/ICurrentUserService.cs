namespace Project3.Services.Interfaces;

public interface ICurrentUserService
{
    Guid? UserId { get; }

    string? Username { get; }

    bool IsAuthenticated { get; }

    bool IsInRole(string role);

    bool HasPermission(string permission);
}