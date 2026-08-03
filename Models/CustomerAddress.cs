using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class CustomerAddress
{
    public Guid Id { get; set; }

    public Guid CustomerId { get; set; }

    public string AddressType { get; set; } = null!;

    public string RecipientName { get; set; } = null!;

    public string? Phone { get; set; }

    public string AddressLine1 { get; set; } = null!;

    public string? AddressLine2 { get; set; }

    public string City { get; set; } = null!;

    public string? State { get; set; }

    public string Pincode { get; set; } = null!;

    public string? Country { get; set; }

    public string? Landmark { get; set; }

    public bool? IsDefault { get; set; }

    public bool? IsActive { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual Customer Customer { get; set; } = null!;

    public virtual ICollection<Shipment> ShipmentReceiverAddresses { get; set; } = new List<Shipment>();

    public virtual ICollection<ShipmentRequest> ShipmentRequestReceiverAddresses { get; set; } = new List<ShipmentRequest>();

    public virtual ICollection<ShipmentRequest> ShipmentRequestSenderAddresses { get; set; } = new List<ShipmentRequest>();

    public virtual ICollection<Shipment> ShipmentSenderAddresses { get; set; } = new List<Shipment>();
}
