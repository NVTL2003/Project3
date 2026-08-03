using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class Expense
{
    public Guid Id { get; set; }

    public string ExpenseNumber { get; set; } = null!;

    public string ExpenseType { get; set; } = null!;

    public Guid? FacilityId { get; set; }

    public Guid? VehicleId { get; set; }

    public Guid? EmployeeId { get; set; }

    public decimal Amount { get; set; }

    public DateOnly ExpenseDate { get; set; }

    public string? Description { get; set; }

    public string? InvoiceNumber { get; set; }

    public Guid? ApprovedBy { get; set; }

    public DateTime? ApprovedAt { get; set; }

    public string? Status { get; set; }

    public string? PaymentStatus { get; set; }

    public DateOnly? PaymentDate { get; set; }

    public string? Notes { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual Employee? ApprovedByNavigation { get; set; }

    public virtual Employee? Employee { get; set; }

    public virtual Facility? Facility { get; set; }

    public virtual Vehicle? Vehicle { get; set; }
}
