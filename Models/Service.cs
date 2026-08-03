using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class Service
{
    public Guid Id { get; set; }

    public string Code { get; set; } = null!;

    public string Name { get; set; } = null!;

    public string? Description { get; set; }

    public string ServiceType { get; set; } = null!;

    public bool? IsActive { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual ICollection<PricingRule> PricingRules { get; set; } = new List<PricingRule>();

    public virtual ICollection<ShipmentRequest> ShipmentRequests { get; set; } = new List<ShipmentRequest>();

    public virtual ICollection<Shipment> Shipments { get; set; } = new List<Shipment>();
}
