using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class AuditLog
{
    public Guid Id { get; set; }

    public Guid UserId { get; set; }

    public string Action { get; set; } = null!;

    public string TableName { get; set; } = null!;

    public Guid RecordId { get; set; }

    public string? OldData { get; set; }

    public string? NewData { get; set; }

    public string? IpAddress { get; set; }

    public string? UserAgent { get; set; }

    public string? Description { get; set; }

    public DateTime? CreatedAt { get; set; }

    public virtual User User { get; set; } = null!;
}
