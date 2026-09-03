namespace Project3.DTOs
{
    public class DeliveryAttemptDto
    {
        public Guid Id { get; set; }

        public Guid ShipmentId { get; set; }

        public Guid DeliveryAssignmentId { get; set; }

        public int AttemptNumber { get; set; }

        public DateTime? AttemptTime { get; set; }

        public string Status { get; set; } = string.Empty;

        public string? Reason { get; set; }

        public string? Notes { get; set; }

        public decimal? Latitude { get; set; }

        public decimal? Longitude { get; set; }

        public bool? IsDelivered { get; set; }

        public DateTime? CreatedAt { get; set; }

        public DateTime? UpdatedAt { get; set; }

        public ProofOfDeliveryDto? ProofOfDelivery { get; set; }
    }

    public class CreateDeliveryAttemptDto
    {
        public Guid ShipmentId { get; set; }

        public Guid DeliveryAssignmentId { get; set; }

        // attempted / failed / delivered
        public string Status { get; set; } = "attempted";

        public string? Reason { get; set; }

        public string? Notes { get; set; }

        public decimal? Latitude { get; set; }

        public decimal? Longitude { get; set; }

        // Used only when Status = "delivered".
        public DeliveryProofInputDto? ProofOfDelivery { get; set; }
    }

    public class DeliveryProofInputDto
    {
        public string ReceiverName { get; set; } = string.Empty;

        public string? ReceiverSignature { get; set; }

        public string? ReceiverRelation { get; set; }

        public string? DeliveryPhoto { get; set; }

        public decimal? GpsAccuracy { get; set; }

        public string? Notes { get; set; }
    }
}