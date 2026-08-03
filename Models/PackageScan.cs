using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class PackageScan
{
    public Guid Id { get; set; }

    public string ScanNumber { get; set; } = null!;

    public Guid ShipmentId { get; set; }

    public Guid EmployeeId { get; set; }

    public Guid? FacilityId { get; set; }

    public Guid? VehicleId { get; set; }

    public string LocationType { get; set; } = null!;

    public string ScanType { get; set; } = null!;

    public DateTime? ScanTime { get; set; }

    public decimal? Latitude { get; set; }

    public decimal? Longitude { get; set; }

    public string? IpAddress { get; set; }

    public string? Notes { get; set; }

    public DateTime? CreatedAt { get; set; }

    public virtual Employee Employee { get; set; } = null!;

    public virtual Facility? Facility { get; set; }

    public virtual Shipment Shipment { get; set; } = null!;

    public virtual ICollection<TrackingEvent> TrackingEvents { get; set; } = new List<TrackingEvent>();

    public virtual Vehicle? Vehicle { get; set; }
}
