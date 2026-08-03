using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class ProofOfDelivery
{
    public Guid Id { get; set; }

    public Guid ShipmentId { get; set; }

    public Guid DeliveryAttemptId { get; set; }

    public string ReceiverName { get; set; } = null!;

    public string? ReceiverSignature { get; set; }

    public string? ReceiverRelation { get; set; }

    public string? DeliveryPhoto { get; set; }

    public DateTime DeliveryTime { get; set; }

    public decimal? Latitude { get; set; }

    public decimal? Longitude { get; set; }

    public decimal? GpsAccuracy { get; set; }

    public string? Notes { get; set; }

    public DateTime? CreatedAt { get; set; }

    public virtual DeliveryAttempt DeliveryAttempt { get; set; } = null!;

    public virtual Shipment Shipment { get; set; } = null!;
}
