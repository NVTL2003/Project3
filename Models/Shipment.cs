using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class Shipment
{
    public Guid Id { get; set; }

    public string TrackingNumber { get; set; } = null!;

    public Guid? ShipmentRequestId { get; set; }

    public Guid ServiceId { get; set; }

    public Guid CustomerId { get; set; }

    public Guid SenderAddressId { get; set; }

    public Guid ReceiverAddressId { get; set; }

    public decimal Weight { get; set; }

    public decimal? Length { get; set; }

    public decimal? Width { get; set; }

    public decimal? Height { get; set; }

    public decimal? DeclaredValue { get; set; }

    public Guid? InsurancePlanId { get; set; }

    public decimal? InsuranceAmount { get; set; }

    public string PackageType { get; set; } = null!;

    public string? SpecialInstructions { get; set; }

    public bool? IsFragile { get; set; }

    public bool? IsLarge { get; set; }

    public string? CurrentStatus { get; set; }

    public DateOnly? EstimatedDelivery { get; set; }

    public DateTime? ActualDelivery { get; set; }

    public bool? IsActive { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual Customer Customer { get; set; } = null!;

    public virtual ICollection<DeliveryAttempt> DeliveryAttempts { get; set; } = new List<DeliveryAttempt>();

    public virtual InsurancePlan? InsurancePlan { get; set; }

    public virtual ICollection<Invoice> Invoices { get; set; } = new List<Invoice>();

    public virtual ICollection<PackageScan> PackageScans { get; set; } = new List<PackageScan>();

    public virtual ProofOfDelivery? ProofOfDelivery { get; set; }

    public virtual CustomerAddress ReceiverAddress { get; set; } = null!;

    public virtual CustomerAddress SenderAddress { get; set; } = null!;

    public virtual Service Service { get; set; } = null!;

    public virtual ICollection<ShipmentCharge> ShipmentCharges { get; set; } = new List<ShipmentCharge>();

    public virtual ICollection<ShipmentContact> ShipmentContacts { get; set; } = new List<ShipmentContact>();

    public virtual ShipmentRequest? ShipmentRequest { get; set; }

    public virtual ICollection<ShipmentStatusHistory> ShipmentStatusHistories { get; set; } = new List<ShipmentStatusHistory>();

    public virtual ICollection<TrackingEvent> TrackingEvents { get; set; } = new List<TrackingEvent>();

    public virtual ICollection<TransportOrder> TransportOrders { get; set; } = new List<TransportOrder>();
}
