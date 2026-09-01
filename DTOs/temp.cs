namespace Project3.DTOs
{
    // ----- Shipment Request -----
    public class CreateShipmentRequestDto
    {
        public Guid CustomerId { get; set; }
        public Guid SenderAddressId { get; set; }
        public Guid ReceiverAddressId { get; set; }
        public Guid? ServiceId { get; set; }
        public string PackageType { get; set; } = string.Empty;
        public decimal Weight { get; set; }
        public decimal? Length { get; set; }
        public decimal? Width { get; set; }
        public decimal? Height { get; set; }
        public decimal? DeclaredValue { get; set; }
        public Guid? InsurancePlanId { get; set; }
        public string? SpecialInstructions { get; set; }
        public bool? IsFragile { get; set; }
        public bool? IsLarge { get; set; }
    }

    public class CreateMyShipmentRequestDto
    {
        public Guid SenderAddressId { get; set; }
        public Guid ReceiverAddressId { get; set; }
        public Guid? ServiceId { get; set; }
        public string PackageType { get; set; } = string.Empty;
        public decimal Weight { get; set; }
        public decimal? Length { get; set; }
        public decimal? Width { get; set; }
        public decimal? Height { get; set; }
        public decimal? DeclaredValue { get; set; }
        public Guid? InsurancePlanId { get; set; }
        public string? SpecialInstructions { get; set; }
        public bool? IsFragile { get; set; }
        public bool? IsLarge { get; set; }
    }
    public class ShipmentRequestDto : CreateShipmentRequestDto
    {
        public Guid Id { get; set; }
        public string RequestNumber { get; set; } = string.Empty;
        public string Status { get; set; } = "pending";
        public decimal? EstimatedCost { get; set; }
        public Guid? ApprovedBy { get; set; }
        public DateTime? ApprovedAt { get; set; }
        public string? RejectionReason { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        // Optionally include navigation properties if needed for display
    }

    // ----- Tracking Event -----
    public class CreateTrackingEventDto
    {
        public Guid ShipmentId { get; set; }
        public Guid? PackageScanId { get; set; }
        public Guid TrackingStatusId { get; set; }
        public string? EventLocation { get; set; }
        public DateTime? EventTime { get; set; }
        public bool? IsPublic { get; set; }
    }

    public class TrackingEventDto : CreateTrackingEventDto
    {
        public Guid Id { get; set; }
        public DateTime CreatedAt { get; set; }
    }

    // ----- Delivery Attempt -----
    public class CreateDeliveryAttemptDto
    {
        public Guid ShipmentId { get; set; }
        public Guid? DeliveryAssignmentId { get; set; }  // Make nullable
        public int AttemptNumber { get; set; }
        public DateTime? AttemptTime { get; set; }
        public string Status { get; set; } = "attempted";
        public string? Reason { get; set; }
        public string? Notes { get; set; }
        public decimal? Latitude { get; set; }
        public decimal? Longitude { get; set; }
        public bool? IsDelivered { get; set; }
    }

    public class DeliveryAttemptDto : CreateDeliveryAttemptDto
    {
        public Guid Id { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
    }

    // ----- Proof of Delivery -----
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

    public class ProofOfDeliveryDto : CreateProofOfDeliveryDto
    {
        public Guid Id { get; set; }
        public DateTime CreatedAt { get; set; }
    }
    // ----- Delivery Assignment -----
    public class CreateDeliveryAssignmentDto
    {
        public Guid ManifestId { get; set; }
        public Guid DriverId { get; set; }
        public Guid VehicleId { get; set; }
        public Guid RouteStopId { get; set; }
        public int? SequenceNumber { get; set; }
        public DateTime? EstimatedDeliveryTime { get; set; }
        public string? Notes { get; set; }
    }

    public class DeliveryAssignmentDto : CreateDeliveryAssignmentDto
    {
        public Guid Id { get; set; }
        public string AssignmentNumber { get; set; } = string.Empty;
        public DateTime? AssignedAt { get; set; }
        public DateTime? StartedAt { get; set; }
        public DateTime? CompletedAt { get; set; }
        public string Status { get; set; } = "Assigned";
        public DateTime? ActualDeliveryTime { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
    }

    public class ApproveShipmentRequestDto
    {
        public Guid ShipmentId { get; set; }

        public string TrackingNumber { get; set; } = string.Empty;

        public string Message { get; set; } = string.Empty;
    }
    public class ApproveShipmentRequestResult
    {
        public Guid ShipmentId { get; set; }

        public string TrackingNumber { get; set; } = string.Empty;

        public string Message { get; set; } = string.Empty;
    }
}
