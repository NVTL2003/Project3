using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class TrackingStatus
{
    public Guid Id { get; set; }

    public string Code { get; set; } = null!;

    public string? Description { get; set; }

    public bool? IsPublic { get; set; }

    public DateTime? CreatedAt { get; set; }

    public virtual ICollection<TrackingEvent> TrackingEvents { get; set; } = new List<TrackingEvent>();
}
