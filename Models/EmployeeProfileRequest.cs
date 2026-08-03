using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class EmployeeProfileRequest
{
    public Guid Id { get; set; }

    public Guid EmployeeId { get; set; }

    public Guid RequestedBy { get; set; }

    public string FieldName { get; set; } = null!;

    public string? OldValue { get; set; }

    public string NewValue { get; set; } = null!;

    public string? Reason { get; set; }

    public string? Status { get; set; }

    public Guid? ApprovedBy { get; set; }

    public DateTime? ApprovedAt { get; set; }

    public string? RejectionReason { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual User? ApprovedByNavigation { get; set; }

    public virtual Employee Employee { get; set; } = null!;

    public virtual User RequestedByNavigation { get; set; } = null!;
}
