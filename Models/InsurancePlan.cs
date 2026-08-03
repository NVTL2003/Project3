using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class InsurancePlan
{
    public Guid Id { get; set; }

    public string Name { get; set; } = null!;

    public string? Description { get; set; }

    public decimal MinCover { get; set; }

    public decimal MaxCover { get; set; }

    public decimal RatePercentage { get; set; }

    public decimal? FixedCharge { get; set; }

    public bool? IsActive { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual ICollection<ShipmentRequest> ShipmentRequests { get; set; } = new List<ShipmentRequest>();

    public virtual ICollection<Shipment> Shipments { get; set; } = new List<Shipment>();
}
