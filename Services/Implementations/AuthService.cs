//using Microsoft.EntityFrameworkCore;
//using Project3.DTOs.Auth;
//using Project3.Models;
//using Project3.Authentication;
//using Project3.Services.Interfaces;

//using BCryptHasher = BCrypt.Net.BCrypt;

//namespace Project3.Services.Implementations;

//public class AuthService : IAuthService
//{
//    private readonly Pj3Context _context;
//    private readonly IJwtService _jwtService;

//    public AuthService(
//        Pj3Context context,
//        IJwtService jwtService)
//    {
//        _context = context;
//        _jwtService = jwtService;
//    }

//    public async Task<LoginResponseDto?> LoginAsync(
//        LoginRequestDto request)
//    {
//        var user = await _context.Set<User>()
//            .Include(u => u.UserRoles)
//                .ThenInclude(ur => ur.Role)
//            .FirstOrDefaultAsync(
//                u => u.Username == request.Username);

//        if (user == null)
//            return null;

//        if (user.IsActive == false)
//            return null;

//        var passwordValid =
//            BCryptHasher.Verify(
//                request.Password,
//                user.PasswordHash);

//        if (!passwordValid)
//            return null;

//        var roles = user.UserRoles
//            .Select(ur => ur.Role.Name)
//            .ToList();

//        var token = _jwtService.GenerateToken(
//            user,
//            roles);

//        user.LastLogin = DateTime.UtcNow;

//        await _context.SaveChangesAsync();

//        return new LoginResponseDto
//        {
//            Token = token,
//            UserId = user.Id,
//            Username = user.Username,
//            Roles = roles
//        };
//    }
//}
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
        var user = await _context.Users
            .Include(u => u.UserRoles)
                .ThenInclude(ur => ur.Role)
                    .ThenInclude(r => r.RolePermissions)
                        .ThenInclude(rp => rp.Permission)
            .FirstOrDefaultAsync(u =>
                u.Username == request.UsernameOrEmail ||
                u.Email == request.UsernameOrEmail);

        if (user == null)
            return null;

        if (user.IsActive != true)
            return null;

        var passwordValid =
            BCryptHasher.Verify(
                request.Password,
                user.PasswordHash);

        if (!passwordValid)
            return null;

        // ============================================
        // ROLES
        // ============================================

        var roles = user.UserRoles
            .Select(ur => ur.Role.Name)
            .Distinct()
            .ToList();

        // ============================================
        // PERMISSIONS
        // ============================================

        var permissions = user.UserRoles
            .SelectMany(ur => ur.Role.RolePermissions)
            .Select(rp => rp.Permission.Name)
            .Distinct()
            .ToList();

        // ============================================
        // JWT
        // ============================================

        var token = _jwtService.GenerateToken(
            user,
            roles,
            permissions);

        // ============================================
        // LOGIN TIME
        // ============================================

        user.LastLogin = DateTime.UtcNow;

        await _context.SaveChangesAsync();

        // ============================================
        // USER DTO
        // ============================================

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

        // ============================================
        // RESPONSE
        // ============================================

        return new AuthResponseDto
        {
            Token = token,

            ExpiresAt =
                DateTime.UtcNow.AddHours(1),

            User = userDto
        };
    }
}