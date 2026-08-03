using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class ShipmentRequest
{
    public Guid Id { get; set; }

    public string RequestNumber { get; set; } = null!;

    public Guid CustomerId { get; set; }

    public Guid SenderAddressId { get; set; }

    public Guid ReceiverAddressId { get; set; }

    public Guid? ServiceId { get; set; }

    public string PackageType { get; set; } = null!;

    public decimal Weight { get; set; }

    public decimal? Length { get; set; }

    public decimal? Width { get; set; }

    public decimal? Height { get; set; }

    public decimal? DeclaredValue { get; set; }

    public Guid? InsurancePlanId { get; set; }

    public string? SpecialInstructions { get; set; }

    public bool? IsFragile { get; set; }

    public bool? IsLarge { get; set; }

    public string? Status { get; set; }

    public decimal? EstimatedCost { get; set; }

    public Guid? ApprovedBy { get; set; }

    public DateTime? ApprovedAt { get; set; }

    public string? RejectionReason { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual Employee? ApprovedByNavigation { get; set; }

    public virtual Customer Customer { get; set; } = null!;

    public virtual InsurancePlan? InsurancePlan { get; set; }

    public virtual CustomerAddress ReceiverAddress { get; set; } = null!;

    public virtual CustomerAddress SenderAddress { get; set; } = null!;

    public virtual Service? Service { get; set; }

    public virtual ICollection<Shipment> Shipments { get; set; } = new List<Shipment>();
}
