using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class TransportOrder
{
    public Guid Id { get; set; }

    public string OrderNumber { get; set; } = null!;

    public Guid ShipmentId { get; set; }

    public int? Priority { get; set; }

    public decimal Weight { get; set; }

    public decimal? Volume { get; set; }

    public string? SpecialInstructions { get; set; }

    public string? Status { get; set; }

    public Guid? CreatedBy { get; set; }

    public Guid? AssignedVehicleId { get; set; }

    public Guid? AssignedDriverId { get; set; }

    public DateTime? PlannedDeparture { get; set; }

    public DateTime? PlannedArrival { get; set; }

    public DateTime? ActualDeparture { get; set; }

    public DateTime? ActualArrival { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual Employee? AssignedDriver { get; set; }

    public virtual Vehicle? AssignedVehicle { get; set; }

    public virtual Employee? CreatedByNavigation { get; set; }

    public virtual ICollection<ManifestItem> ManifestItems { get; set; } = new List<ManifestItem>();

    public virtual Shipment Shipment { get; set; } = null!;
}
