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

    public async Task<bool> RegisterAsync(RegisterRequestDto request)
    {
        // ============================================================
        // 1. BASIC VALIDATION
        // ============================================================

        if (string.IsNullOrWhiteSpace(request.Username))
            throw new ArgumentException("Username is required.");

        if (string.IsNullOrWhiteSpace(request.Email))
            throw new ArgumentException("Email is required.");

        if (string.IsNullOrWhiteSpace(request.Password))
            throw new ArgumentException("Password is required.");

        if (string.IsNullOrWhiteSpace(request.FirstName))
            throw new ArgumentException("First name is required.");

        if (string.IsNullOrWhiteSpace(request.LastName))
            throw new ArgumentException("Last name is required.");


        // ============================================================
        // 2. NORMALIZE INPUT
        // ============================================================

        var username = request.Username.Trim();
        var email = request.Email.Trim().ToLowerInvariant();


        // ============================================================
        // 3. CHECK USERNAME / EMAIL DUPLICATES
        // ============================================================

        var usernameExists = await _context.Users
            .AnyAsync(u => u.Username == username);

        if (usernameExists)
        {
            throw new InvalidOperationException(
                "Username is already registered.");
        }


        var emailExists = await _context.Users
            .AnyAsync(u => u.Email == email);

        if (emailExists)
        {
            throw new InvalidOperationException(
                "Email is already registered.");
        }


        // ============================================================
        // 4. FIND CUSTOMER ROLE
        // ============================================================

        var customerRole = await _context.Roles
            .FirstOrDefaultAsync(r => r.Name == "Customer");

        if (customerRole == null)
        {
            throw new InvalidOperationException(
                "Customer role does not exist in the database.");
        }


        // ============================================================
        // 5. START TRANSACTION
        // ============================================================

        await using var transaction =
            await _context.Database.BeginTransactionAsync();

        try
        {
            // ========================================================
            // 6. CREATE USER
            // ========================================================

            var user = new User
            {
                Id = Guid.NewGuid(),

                Username = username,

                Email = email,

                Phone = string.IsNullOrWhiteSpace(request.Phone)
                    ? null
                    : request.Phone.Trim(),

                PasswordHash =
                    BCryptHasher.HashPassword(request.Password),

                MfaEnabled = false,

                IsActive = true,

                CreatedAt = DateTime.UtcNow,

                UpdatedAt = DateTime.UtcNow
            };

            _context.Users.Add(user);


            // ========================================================
            // 7. CREATE CUSTOMER
            // ========================================================

            var customer = new Customer
            {
                Id = Guid.NewGuid(),

                UserId = user.Id,

                FirstName = request.FirstName.Trim(),

                LastName = request.LastName.Trim(),

                CompanyName = string.IsNullOrWhiteSpace(request.CompanyName)
                    ? null
                    : request.CompanyName.Trim(),

                TaxId = string.IsNullOrWhiteSpace(request.TaxId)
                    ? null
                    : request.TaxId.Trim(),

                IsActive = true,

                CreatedAt = DateTime.UtcNow,

                UpdatedAt = DateTime.UtcNow
            };

            _context.Customers.Add(customer);


            // ========================================================
            // 8. ASSIGN CUSTOMER ROLE
            // ========================================================

            var userRole = new UserRole
            {
                Id = Guid.NewGuid(),

                UserId = user.Id,

                RoleId = customerRole.Id,

                CreatedAt = DateTime.UtcNow
            };

            _context.UserRoles.Add(userRole);


            // ========================================================
            // 9. SAVE EVERYTHING
            // ========================================================

            await _context.SaveChangesAsync();


            // ========================================================
            // 10. COMMIT
            // ========================================================

            await transaction.CommitAsync();

            return true;
        }
        catch
        {
            await transaction.RollbackAsync();

            throw;
        }
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