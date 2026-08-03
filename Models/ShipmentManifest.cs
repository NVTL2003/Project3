using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class ShipmentManifest
{
    public Guid Id { get; set; }

    public string ManifestNumber { get; set; } = null!;

    public Guid VehicleId { get; set; }

    public Guid DriverId { get; set; }

    public Guid RouteId { get; set; }

    public Guid DepartureFacilityId { get; set; }

    public DateTime DepartureTime { get; set; }

    public DateTime? ArrivalTime { get; set; }

    public string? Status { get; set; }

    public int? TotalPackages { get; set; }

    public decimal? TotalWeight { get; set; }

    public string? Notes { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual ICollection<DeliveryAssignment> DeliveryAssignments { get; set; } = new List<DeliveryAssignment>();

    public virtual Facility DepartureFacility { get; set; } = null!;

    public virtual Employee Driver { get; set; } = null!;

    public virtual ICollection<ManifestItem> ManifestItems { get; set; } = new List<ManifestItem>();

    public virtual Route Route { get; set; } = null!;

    public virtual Vehicle Vehicle { get; set; } = null!;
}
