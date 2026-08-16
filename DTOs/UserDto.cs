using System;
using System.Collections.Generic;

namespace Project3.DTOs;

public class UserDto
{
    public Guid Id { get; set; }

    public string Username { get; set; } = string.Empty;

    public string Email { get; set; } = string.Empty;

    public string? Phone { get; set; }

    public bool? MfaEnabled { get; set; }

    public bool? IsActive { get; set; }

    public DateTime? LastLogin { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public List<string> Roles { get; set; } = new();

    public List<string> Permissions { get; set; } = new();
}


// ============================================================
// CREATE USER
// ============================================================

public class CreateUserDto
{
    public string Username { get; set; } = string.Empty;

    public string Email { get; set; } = string.Empty;

    public string? Phone { get; set; }

    public string Password { get; set; } = string.Empty;

    public bool? MfaEnabled { get; set; } = false;

    public bool? IsActive { get; set; } = true;
}


// ============================================================
// UPDATE USER
// ============================================================

public class UpdateUserDto
{
    public string? Username { get; set; }

    public string? Email { get; set; }

    public string? Phone { get; set; }

    public bool? MfaEnabled { get; set; }

    public bool? IsActive { get; set; }
}


// ============================================================
// LOGIN
// ============================================================

public class LoginDto
{
    public string UsernameOrEmail { get; set; } = string.Empty;

    public string Password { get; set; } = string.Empty;

    public bool RememberMe { get; set; }
}


// ============================================================
// AUTH RESPONSE
// ============================================================

public class AuthResponseDto
{
    public string Token { get; set; } = string.Empty;

    public DateTime ExpiresAt { get; set; }

    public UserDto User { get; set; } = new();
}


// ============================================================
// CHANGE PASSWORD
// ============================================================

public class ChangePasswordDto
{
    public string CurrentPassword { get; set; } = string.Empty;

    public string NewPassword { get; set; } = string.Empty;

    public string ConfirmNewPassword { get; set; } = string.Empty;
}


// ============================================================
// REGISTER
// ============================================================

public class RegisterUserDto
{
    public string Username { get; set; } = string.Empty;

    public string Email { get; set; } = string.Empty;

    public string Phone { get; set; } = string.Empty;

    public string Password { get; set; } = string.Empty;

    public string ConfirmPassword { get; set; } = string.Empty;

    public string FirstName { get; set; } = string.Empty;

    public string LastName { get; set; } = string.Empty;

    public string? CompanyName { get; set; }

    public string? TaxId { get; set; }
}

public class CurrentUserDto
{
    public Guid Id { get; set; }

    public string Username { get; set; } = string.Empty;

    public string? Email { get; set; }

    public string? Phone { get; set; }

    public List<string> Roles { get; set; } = new();

    public List<string> Permissions { get; set; } = new();
}