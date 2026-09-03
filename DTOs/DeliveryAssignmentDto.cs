namespace Project3.DTOs
{
    public class DeliveryAssignmentDto
    {
        public Guid Id { get; set; }

        public string AssignmentNumber { get; set; } = string.Empty;

        public Guid ManifestId { get; set; }

        public Guid DriverId { get; set; }

        public Guid VehicleId { get; set; }

        public Guid RouteStopId { get; set; }

        public DateTime? AssignedAt { get; set; }

        public DateTime? StartedAt { get; set; }

        public DateTime? CompletedAt { get; set; }

        public string Status { get; set; } = "assigned";

        public int? SequenceNumber { get; set; }

        public DateTime? EstimatedDeliveryTime { get; set; }

        public DateTime? ActualDeliveryTime { get; set; }

        public string? Notes { get; set; }

        public DateTime? CreatedAt { get; set; }

        public DateTime? UpdatedAt { get; set; }
    }
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
}