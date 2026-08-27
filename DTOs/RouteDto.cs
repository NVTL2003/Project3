namespace Project3.DTOs;

public class CreateRouteDto
{
    public string RouteCode { get; set; } = string.Empty;

    public string Name { get; set; } = string.Empty;

    public Guid OriginFacilityId { get; set; }

    public Guid DestinationFacilityId { get; set; }

    public decimal Distance { get; set; }

    public int? EstimatedDuration { get; set; }

    public bool? IsActive { get; set; }
}

public class RouteDto : CreateRouteDto
{
    public Guid Id { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public List<RouteStopDto> Stops { get; set; } = new();
}