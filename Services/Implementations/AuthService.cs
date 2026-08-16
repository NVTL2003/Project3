using Microsoft.EntityFrameworkCore;
using Project3.DTOs;
using Project3.Models;
using Project3.Authentication;
using Project3.Services.Interfaces;

using BCryptHasher = BCrypt.Net.BCrypt;

namespace Project3.Services.Implementations;

public class AuthService : IAuthService
{
    private readonly Pj3Context _context;
    private readonly IJwtService _jwtService;

    public AuthService(
        Pj3Context context,
        IJwtService jwtService)
    {
        _context = context;
        _jwtService = jwtService;
    }

    public async Task<AuthResponseDto?> LoginAsync(
    LoginDto request)
    {
        Console.WriteLine("========== LOGIN DEBUG ==========");
        Console.WriteLine($"UsernameOrEmail: [{request.UsernameOrEmail}]");
        Console.WriteLine($"Password received: {!string.IsNullOrEmpty(request.Password)}");

        var user = await _context.Users
            .Include(u => u.UserRoles)
                .ThenInclude(ur => ur.Role)
                    .ThenInclude(r => r.RolePermissions)
                        .ThenInclude(rp => rp.Permission)
            .FirstOrDefaultAsync(u =>
                u.Username == request.UsernameOrEmail ||
                u.Email == request.UsernameOrEmail);

        if (user == null)
        {
            Console.WriteLine("LOGIN RESULT: USER NOT FOUND");
            Console.WriteLine("=================================");
            return null;
        }

        Console.WriteLine($"USER FOUND: {user.Username}");
        Console.WriteLine($"USER ACTIVE: {user.IsActive}");

        if (user.IsActive != true)
        {
            Console.WriteLine("LOGIN RESULT: USER INACTIVE");
            Console.WriteLine("=================================");
            return null;
        }

        var passwordValid =
            BCryptHasher.Verify(
                request.Password,
                user.PasswordHash);

        Console.WriteLine($"PASSWORD VALID: {passwordValid}");

        if (!passwordValid)
        {
            Console.WriteLine("LOGIN RESULT: INVALID PASSWORD");
            Console.WriteLine("=================================");
            return null;
        }

        var roles = user.UserRoles
            .Select(ur => ur.Role.Name)
            .Distinct()
            .ToList();

        var permissions = user.UserRoles
            .SelectMany(ur => ur.Role.RolePermissions)
            .Select(rp => rp.Permission.Name)
            .Distinct()
            .ToList();

        Console.WriteLine($"ROLES: {string.Join(", ", roles)}");
        Console.WriteLine($"PERMISSIONS: {permissions.Count}");

        var token = _jwtService.GenerateToken(
            user,
            roles,
            permissions);

        user.LastLogin = DateTime.UtcNow;

        await _context.SaveChangesAsync();

        var userDto = new UserDto
        {
            Id = user.Id,
            Username = user.Username,
            Email = user.Email,
            Phone = user.Phone,
            MfaEnabled = user.MfaEnabled,
            IsActive = user.IsActive,
            LastLogin = user.LastLogin,
            CreatedAt = user.CreatedAt,
            UpdatedAt = user.UpdatedAt,
            Roles = roles,
            Permissions = permissions
        };

        Console.WriteLine("LOGIN RESULT: SUCCESS");
        Console.WriteLine("=================================");

        return new AuthResponseDto
        {
            Token = token,
            ExpiresAt = DateTime.UtcNow.AddHours(1),
            User = userDto
        };
    }
}