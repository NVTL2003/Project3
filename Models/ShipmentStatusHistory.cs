using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class ShipmentStatusHistory
{
    public Guid Id { get; set; }

    public Guid ShipmentId { get; set; }

    public string Status { get; set; } = null!;

    public Guid? ChangedBy { get; set; }

    public DateTime? ChangedAt { get; set; }

    public string? Notes { get; set; }

    public virtual Employee? ChangedByNavigation { get; set; }

    public virtual Shipment Shipment { get; set; } = null!;
}
