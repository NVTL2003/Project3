using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class Invoice
{
    public Guid Id { get; set; }

    public string InvoiceNumber { get; set; } = null!;

    public Guid ShipmentId { get; set; }

    public DateOnly InvoiceDate { get; set; }

    public DateOnly? DueDate { get; set; }

    public decimal TotalAmount { get; set; }

    public decimal? DiscountAmount { get; set; }

    public decimal NetAmount { get; set; }

    public string? Status { get; set; }

    public string? Notes { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual ICollection<Payment> Payments { get; set; } = new List<Payment>();

    public virtual Shipment Shipment { get; set; } = null!;

    public virtual ICollection<ShipmentCharge> ShipmentCharges { get; set; } = new List<ShipmentCharge>();
}
