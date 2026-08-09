// InsurancePlanDto.cs
public class InsurancePlanDto
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    public decimal CoverageAmount { get; set; }
    public decimal Premium { get; set; }
    public bool IsActive { get; set; }
}

// CreateInsurancePlanDto.cs
public class CreateInsurancePlanDto
{
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    public decimal CoverageAmount { get; set; }
    public decimal Premium { get; set; }
    public bool IsActive { get; set; } = true;
}