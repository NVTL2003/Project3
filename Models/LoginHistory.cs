using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class LoginHistory
{
    public Guid Id { get; set; }

    public Guid UserId { get; set; }

    public DateTime? LoginTime { get; set; }

    public DateTime? LogoutTime { get; set; }

    public string? IpAddress { get; set; }

    public string? UserAgent { get; set; }

    public string LoginStatus { get; set; } = null!;

    public string? FailureReason { get; set; }

    public string? SessionId { get; set; }

    public DateTime? CreatedAt { get; set; }

    public virtual User User { get; set; } = null!;
}
