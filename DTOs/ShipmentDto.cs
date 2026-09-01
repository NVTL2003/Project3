namespace Project3.DTOs
{
    public class CreateShipmentDto
    {
        public Guid ShipmentRequestId { get; set; }
        public Guid ServiceId { get; set; }
        public Guid CustomerId { get; set; }
        public Guid SenderAddressId { get; set; }
        public Guid ReceiverAddressId { get; set; }
        public decimal Weight { get; set; }
        public decimal? Length { get; set; }
        public decimal? Width { get; set; }
        public decimal? Height { get; set; }
        public decimal? DeclaredValue { get; set; }
        public Guid? InsurancePlanId { get; set; }
        public decimal? InsuranceAmount { get; set; }
        public string PackageType { get; set; } = string.Empty;
        public string? SpecialInstructions { get; set; }
        public bool? IsFragile { get; set; }
        public bool? IsLarge { get; set; }
    }

    public class ShipmentDto : CreateShipmentDto
    {
        public Guid Id { get; set; }
        public string TrackingNumber { get; set; } = string.Empty;
        public string CurrentStatus { get; set; } = "created";
        public DateOnly? EstimatedDelivery { get; set; }
        public DateTime? ActualDelivery { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
    }
}