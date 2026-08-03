using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class DeliveryAttempt
{
    public Guid Id { get; set; }

    public Guid ShipmentId { get; set; }

    public Guid DeliveryAssignmentId { get; set; }

    public int AttemptNumber { get; set; }

    public DateTime? AttemptTime { get; set; }

    public string Status { get; set; } = null!;

    public string? Reason { get; set; }

    public string? Notes { get; set; }

    public decimal? Latitude { get; set; }

    public decimal? Longitude { get; set; }

    public bool? IsDelivered { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual DeliveryAssignment DeliveryAssignment { get; set; } = null!;

    public virtual ICollection<ProofOfDelivery> ProofOfDeliveries { get; set; } = new List<ProofOfDelivery>();

    public virtual Shipment Shipment { get; set; } = null!;
}
