using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class Pincode
{
    public Guid Id { get; set; }

    public string Pincode1 { get; set; } = null!;

    public string City { get; set; } = null!;

    public string State { get; set; } = null!;

    public string? Country { get; set; }

    public decimal? Latitude { get; set; }

    public decimal? Longitude { get; set; }

    public Guid? FacilityId { get; set; }

    public bool? Serviceable { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual Facility? Facility { get; set; }
}
