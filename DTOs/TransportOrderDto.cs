namespace Project3.DTOs
{
    public class CreateTransportOrderDto
    {
        public Guid ShipmentId { get; set; }

        public Guid OriginFacilityId { get; set; }

        public Guid DestinationFacilityId { get; set; }

        public int? Priority { get; set; }

        public decimal Weight { get; set; }

        public decimal? Volume { get; set; }

        public string? SpecialInstructions { get; set; }

        public DateTime? PlannedDeparture { get; set; }

        public DateTime? PlannedArrival { get; set; }
    }

    public class TransportOrderDto : CreateTransportOrderDto
    {
        public Guid Id { get; set; }

        public string OrderNumber { get; set; } = string.Empty;

        public string Status { get; set; } = "planned";

        public Guid CreatedBy { get; set; }

        public DateTime? ActualDeparture { get; set; }

        public DateTime? ActualArrival { get; set; }

        public DateTime CreatedAt { get; set; }

        public DateTime UpdatedAt { get; set; }
    }
}