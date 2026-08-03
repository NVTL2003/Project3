using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class Notification
{
    public Guid Id { get; set; }

    public Guid TrackingEventId { get; set; }

    public Guid CustomerId { get; set; }

    public string NotificationType { get; set; } = null!;

    public string? Subject { get; set; }

    public string Content { get; set; } = null!;

    public string Recipient { get; set; } = null!;

    public string? Status { get; set; }

    public DateTime? SentAt { get; set; }

    public DateTime? ReadAt { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual Customer Customer { get; set; } = null!;

    public virtual TrackingEvent TrackingEvent { get; set; } = null!;
}
