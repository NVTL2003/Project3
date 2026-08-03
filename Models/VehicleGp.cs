using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class VehicleGp
{
    public Guid Id { get; set; }

    public Guid VehicleId { get; set; }

    public DateTime? RecordedAt { get; set; }

    public decimal? Latitude { get; set; }

    public decimal? Longitude { get; set; }

    public decimal? Speed { get; set; }

    public decimal? Heading { get; set; }

    public virtual Vehicle Vehicle { get; set; } = null!;
}
