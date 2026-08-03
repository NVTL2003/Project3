using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class TrackingEvent
{
    public Guid Id { get; set; }

    public Guid ShipmentId { get; set; }

    public Guid? PackageScanId { get; set; }

    public Guid TrackingStatusId { get; set; }

    public string? EventLocation { get; set; }

    public DateTime? EventTime { get; set; }

    public bool? IsPublic { get; set; }

    public DateTime? CreatedAt { get; set; }

    public virtual ICollection<Notification> Notifications { get; set; } = new List<Notification>();

    public virtual PackageScan? PackageScan { get; set; }

    public virtual Shipment Shipment { get; set; } = null!;

    public virtual TrackingStatus TrackingStatus { get; set; } = null!;
}
