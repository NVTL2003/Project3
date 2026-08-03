using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class Customer
{
    public Guid Id { get; set; }

    public Guid UserId { get; set; }

    public string? CompanyName { get; set; }

    public string FirstName { get; set; } = null!;

    public string LastName { get; set; } = null!;

    public string? TaxId { get; set; }

    public string? AccountNumber { get; set; }

    public decimal? CreditLimit { get; set; }

    public bool? IsActive { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual ICollection<CustomerAddress> CustomerAddresses { get; set; } = new List<CustomerAddress>();

    public virtual ICollection<Notification> Notifications { get; set; } = new List<Notification>();

    public virtual ICollection<Payment> Payments { get; set; } = new List<Payment>();

    public virtual ICollection<ShipmentRequest> ShipmentRequests { get; set; } = new List<ShipmentRequest>();

    public virtual ICollection<Shipment> Shipments { get; set; } = new List<Shipment>();

    public virtual User User { get; set; } = null!;
}
