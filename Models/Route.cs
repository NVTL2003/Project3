using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class Route
{
    public Guid Id { get; set; }

    public string RouteCode { get; set; } = null!;

    public string Name { get; set; } = null!;

    public Guid OriginFacilityId { get; set; }

    public Guid DestinationFacilityId { get; set; }

    public decimal Distance { get; set; }

    public int? EstimatedDuration { get; set; }

    public bool? IsActive { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual Facility DestinationFacility { get; set; } = null!;

    public virtual Facility OriginFacility { get; set; } = null!;

    public virtual ICollection<RouteStop> RouteStops { get; set; } = new List<RouteStop>();

    public virtual ICollection<ShipmentManifest> ShipmentManifests { get; set; } = new List<ShipmentManifest>();
}
