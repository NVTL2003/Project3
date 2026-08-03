using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class Payment
{
    public Guid Id { get; set; }

    public string PaymentNumber { get; set; } = null!;

    public Guid InvoiceId { get; set; }

    public Guid CustomerId { get; set; }

    public decimal Amount { get; set; }

    public string PaymentMethod { get; set; } = null!;

    public string? PaymentStatus { get; set; }

    public string? TransactionId { get; set; }

    public DateTime? PaymentDate { get; set; }

    public string? ReferenceNumber { get; set; }

    public string? Notes { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual Customer Customer { get; set; } = null!;

    public virtual Invoice Invoice { get; set; } = null!;
}
