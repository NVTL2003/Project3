namespace Project3.DTOs;

public class CreateRouteStopDto
{
    public Guid RouteId { get; set; }

    public int StopSequence { get; set; }

    public Guid FacilityId { get; set; }

    public string StopName { get; set; } = string.Empty;

    public string? Pincode { get; set; }

    public decimal? Latitude { get; set; }

    public decimal? Longitude { get; set; }

    public int? EstimatedArrival { get; set; }

    public int? EstimatedDeparture { get; set; }

    public bool? IsActive { get; set; }
}

public class RouteStopDto : CreateRouteStopDto
{
    public Guid Id { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }
}