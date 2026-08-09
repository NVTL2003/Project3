// PincodeDto.cs
public class PincodeDto
{
    public Guid Id { get; set; }
    public string Code { get; set; } = string.Empty;
    public string City { get; set; } = string.Empty;
    public string State { get; set; } = string.Empty;
    public string Country { get; set; } = string.Empty;
    public double Latitude { get; set; }
    public double Longitude { get; set; }
}

// CreatePincodeDto.cs
public class CreatePincodeDto
{
    public string Code { get; set; } = string.Empty;
    public string City { get; set; } = string.Empty;
    public string State { get; set; } = string.Empty;
    public string Country { get; set; } = "USA";
    public double Latitude { get; set; }
    public double Longitude { get; set; }
}