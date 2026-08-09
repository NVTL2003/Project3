// PricingRuleDto.cs
public class PricingRuleDto
{
    public Guid Id { get; set; }
    public Guid ServiceId { get; set; }
    public decimal MinWeight { get; set; }
    public decimal MaxWeight { get; set; }
    public decimal PricePerKg { get; set; }
    public decimal? DiscountPercentage { get; set; }
    public string? ServiceName { get; set; } // optional
}

// CreatePricingRuleDto.cs
public class CreatePricingRuleDto
{
    public Guid ServiceId { get; set; }
    public decimal MinWeight { get; set; }
    public decimal MaxWeight { get; set; }
    public decimal PricePerKg { get; set; }
    public decimal? DiscountPercentage { get; set; }
}