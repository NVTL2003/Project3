using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class VehicleFuelLog
{
    public Guid Id { get; set; }

    public Guid VehicleId { get; set; }

    public DateOnly FuelDate { get; set; }

    public string? FuelType { get; set; }

    public decimal? Quantity { get; set; }

    public decimal? Cost { get; set; }

    public decimal? OdometerReading { get; set; }

    public DateTime? CreatedAt { get; set; }

    public virtual Vehicle Vehicle { get; set; } = null!;
}
