using System;
using System.Collections.Generic;

namespace Project3.DTOs
{
    /// <summary>
    /// DTO for returning user data (read-only)
    /// </summary>
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

        // Navigation properties (minimal info)
        //public CustomerSummaryDto? Customer { get; set; }
        //public EmployeeSummaryDto? Employee { get; set; }
        //public List<RoleSummaryDto> Roles { get; set; } = new();
    }

    /// <summary>
    /// DTO for creating a new user
    /// </summary>
    public class CreateUserDto
    {
        public string Username { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string? Phone { get; set; }
        public string Password { get; set; } = string.Empty;
        public bool? MfaEnabled { get; set; } = false;
        public bool? IsActive { get; set; } = true;
    }

    /// <summary>
    /// DTO for updating an existing user
    /// </summary>
    public class UpdateUserDto
    {
        public string? Username { get; set; }
        public string? Email { get; set; }
        public string? Phone { get; set; }
        public bool? MfaEnabled { get; set; }
        public bool? IsActive { get; set; }
    }

    /// <summary>
    /// DTO for changing user password
    /// </summary>
    public class ChangePasswordDto
    {
        public string CurrentPassword { get; set; } = string.Empty;
        public string NewPassword { get; set; } = string.Empty;
        public string ConfirmNewPassword { get; set; } = string.Empty;
    }

    /// <summary>
    /// DTO for user login
    /// </summary>
    public class LoginDto
    {
        public string UsernameOrEmail { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty;
        public bool RememberMe { get; set; } = false;
    }

    /// <summary>
    /// DTO for login response (JWT token)
    /// </summary>
    public class LoginResponseDto
    {
        public string Token { get; set; } = string.Empty;
        public DateTime ExpiresAt { get; set; }
        public UserDto User { get; set; } = new();
        public List<string> Roles { get; set; } = new();
        public List<string> Permissions { get; set; } = new();
    }

    /// <summary>
    /// DTO for user registration (self-registration)
    /// </summary>
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

    /// <summary>
    /// DTO for user search/filtering
    /// </summary>
    public class UserFilterDto
    {
        public string? SearchTerm { get; set; }
        public bool? IsActive { get; set; }
        public string? Role { get; set; }
        public DateTime? FromDate { get; set; }
        public DateTime? ToDate { get; set; }
        public int PageNumber { get; set; } = 1;
        public int PageSize { get; set; } = 10;
        public string? SortBy { get; set; } = "CreatedAt";
        public bool SortDescending { get; set; } = true;
    }

    /// <summary>
    /// DTO for paginated user list
    /// </summary>
    public class PaginatedUserListDto
    {
        public List<UserDto> Items { get; set; } = new();
        public int TotalCount { get; set; }
        public int PageNumber { get; set; }
        public int PageSize { get; set; }
        public int TotalPages { get; set; }
        public bool HasPreviousPage => PageNumber > 1;
        public bool HasNextPage => PageNumber < TotalPages;
    }
}
