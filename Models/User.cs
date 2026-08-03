using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class User
{
    public Guid Id { get; set; }

    public string Username { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string? Phone { get; set; }

    public string PasswordHash { get; set; } = null!;

    public bool? MfaEnabled { get; set; }

    public string? MfaSecret { get; set; }

    public bool? IsActive { get; set; }

    public DateTime? LastLogin { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual ICollection<AuditLog> AuditLogs { get; set; } = new List<AuditLog>();

    public virtual Customer? Customer { get; set; }

    public virtual Employee? Employee { get; set; }

    public virtual ICollection<EmployeeProfileRequest> EmployeeProfileRequestApprovedByNavigations { get; set; } = new List<EmployeeProfileRequest>();

    public virtual ICollection<EmployeeProfileRequest> EmployeeProfileRequestRequestedByNavigations { get; set; } = new List<EmployeeProfileRequest>();

    public virtual ICollection<LoginHistory> LoginHistories { get; set; } = new List<LoginHistory>();

    public virtual ICollection<UserRole> UserRoles { get; set; } = new List<UserRole>();
}
