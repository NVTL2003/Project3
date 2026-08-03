using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class PricingRule
{
    public Guid Id { get; set; }

    public Guid ServiceId { get; set; }

    public string Name { get; set; } = null!;

    public string RuleType { get; set; } = null!;

    public string CalculationType { get; set; } = null!;

    public decimal? MinValue { get; set; }

    public decimal? MaxValue { get; set; }

    public decimal Rate { get; set; }

    public string? ConditionExpression { get; set; }

    public int? Priority { get; set; }

    public bool? IsActive { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual Service Service { get; set; } = null!;
}
