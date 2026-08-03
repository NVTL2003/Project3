using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class VehicleMaintenance
{
    public Guid Id { get; set; }

    public Guid VehicleId { get; set; }

    public DateOnly MaintenanceDate { get; set; }

    public string? Description { get; set; }

    public decimal? Cost { get; set; }

    public Guid? PerformedBy { get; set; }

    public DateOnly? NextMaintenanceDate { get; set; }

    public DateTime? CreatedAt { get; set; }

    public virtual Vehicle Vehicle { get; set; } = null!;
}
