using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class RouteStop
{
    public Guid Id { get; set; }

    public Guid RouteId { get; set; }

    public int StopSequence { get; set; }

    public Guid FacilityId { get; set; }

    public string StopName { get; set; } = null!;

    public string? Pincode { get; set; }

    public decimal? Latitude { get; set; }

    public decimal? Longitude { get; set; }

    public int? EstimatedArrival { get; set; }

    public int? EstimatedDeparture { get; set; }

    public bool? IsActive { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual ICollection<DeliveryAssignment> DeliveryAssignments { get; set; } = new List<DeliveryAssignment>();

    public virtual Facility Facility { get; set; } = null!;

    public virtual Route Route { get; set; } = null!;
}
