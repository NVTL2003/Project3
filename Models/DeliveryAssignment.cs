using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class DeliveryAssignment
{
    public Guid Id { get; set; }

    public string AssignmentNumber { get; set; } = null!;

    public Guid ManifestId { get; set; }

    public Guid DriverId { get; set; }

    public Guid VehicleId { get; set; }

    public Guid RouteStopId { get; set; }

    public DateTime? AssignedAt { get; set; }

    public DateTime? StartedAt { get; set; }

    public DateTime? CompletedAt { get; set; }

    public string? Status { get; set; }

    public int? SequenceNumber { get; set; }

    public DateTime? EstimatedDeliveryTime { get; set; }

    public DateTime? ActualDeliveryTime { get; set; }

    public string? Notes { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual ICollection<DeliveryAttempt> DeliveryAttempts { get; set; } = new List<DeliveryAttempt>();

    public virtual Employee Driver { get; set; } = null!;

    public virtual ShipmentManifest Manifest { get; set; } = null!;

    public virtual RouteStop RouteStop { get; set; } = null!;

    public virtual Vehicle Vehicle { get; set; } = null!;
}
