using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class ManifestItem
{
    public Guid Id { get; set; }

    public Guid ManifestId { get; set; }

    public Guid TransportOrderId { get; set; }

    public int? LoadingSequence { get; set; }

    public string? Status { get; set; }

    public DateTime? LoadedAt { get; set; }

    public DateTime? UnloadedAt { get; set; }

    public Guid? UnloadedFacilityId { get; set; }

    public string? Notes { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual ShipmentManifest Manifest { get; set; } = null!;

    public virtual TransportOrder TransportOrder { get; set; } = null!;

    public virtual Facility? UnloadedFacility { get; set; }
}
