namespace Project3.DTOs
{
    public class ProofOfDeliveryDto
    {
        public Guid Id { get; set; }

        public Guid ShipmentId { get; set; }

        public Guid DeliveryAttemptId { get; set; }

        public string ReceiverName { get; set; } = string.Empty;

        public string? ReceiverSignature { get; set; }

        public string? ReceiverRelation { get; set; }

        public string? DeliveryPhoto { get; set; }

        public DateTime DeliveryTime { get; set; }

        public decimal? Latitude { get; set; }

        public decimal? Longitude { get; set; }

        public decimal? GpsAccuracy { get; set; }

        public string? Notes { get; set; }

        public DateTime? CreatedAt { get; set; }
    }

    public class CreateProofOfDeliveryDto
    {
        public Guid ShipmentId { get; set; }

        public Guid DeliveryAttemptId { get; set; }

        public string ReceiverName { get; set; } = string.Empty;

        public string? ReceiverSignature { get; set; }

        public string? ReceiverRelation { get; set; }

        public string? DeliveryPhoto { get; set; }

        public DateTime DeliveryTime { get; set; }

        public decimal? Latitude { get; set; }

        public decimal? Longitude { get; set; }

        public decimal? GpsAccuracy { get; set; }

        public string? Notes { get; set; }
    }
}