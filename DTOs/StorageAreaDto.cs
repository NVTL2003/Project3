// StorageAreaDto.cs
public class StorageAreaDto
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public Guid FacilityId { get; set; }
    public string? Description { get; set; }
    public int CapacityInKg { get; set; }
    public bool IsActive { get; set; }
    // optionally include facility name
    public string? FacilityName { get; set; }
}

// CreateStorageAreaDto.cs
public class CreateStorageAreaDto
{
    public string Name { get; set; } = string.Empty;
    public Guid FacilityId { get; set; }
    public string? Description { get; set; }
    public int CapacityInKg { get; set; }
    public bool IsActive { get; set; } = true;
}