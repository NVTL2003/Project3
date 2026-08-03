using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class StorageArea
{
    public Guid Id { get; set; }

    public Guid FacilityId { get; set; }

    public string ZoneCode { get; set; } = null!;

    public string? Shelf { get; set; }

    public string? Container { get; set; }

    public decimal? Capacity { get; set; }

    public decimal? CurrentOccupancy { get; set; }

    public bool? IsActive { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual Facility Facility { get; set; } = null!;
}
