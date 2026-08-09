// ServiceDto.cs
public class ServiceDto
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    public decimal BasePrice { get; set; }
    public string? Unit { get; set; }
    public bool IsActive { get; set; }
}

// CreateServiceDto.cs
public class CreateServiceDto
{
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    public decimal BasePrice { get; set; }
    public string? Unit { get; set; }
    public bool IsActive { get; set; } = true;
}