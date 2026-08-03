using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class ShipmentContact
{
    public Guid Id { get; set; }

    public Guid ShipmentId { get; set; }

    public string ContactType { get; set; } = null!;

    public string Name { get; set; } = null!;

    public string? Phone { get; set; }

    public string AddressLine1 { get; set; } = null!;

    public string? AddressLine2 { get; set; }

    public string City { get; set; } = null!;

    public string? State { get; set; }

    public string Pincode { get; set; } = null!;

    public string? Country { get; set; }

    public string? Landmark { get; set; }

    public DateTime? CreatedAt { get; set; }

    public virtual Shipment Shipment { get; set; } = null!;
}
