using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class ShipmentCharge
{
    public Guid Id { get; set; }

    public Guid ShipmentId { get; set; }

    public Guid? InvoiceId { get; set; }

    public string ChargeType { get; set; } = null!;

    public string? Description { get; set; }

    public decimal Amount { get; set; }

    public string? CalculationReference { get; set; }

    public DateTime? CreatedAt { get; set; }

    public virtual Invoice? Invoice { get; set; }

    public virtual Shipment Shipment { get; set; } = null!;
}
