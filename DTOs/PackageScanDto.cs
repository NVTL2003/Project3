namespace Project3.DTOs
{
    public class CreatePackageScanDto
    {
        public Guid ShipmentId { get; set; }

        public Guid? FacilityId { get; set; }

        public Guid? VehicleId { get; set; }

        public string LocationType { get; set; } = string.Empty;

        public string ScanType { get; set; } = string.Empty;

        public decimal? Latitude { get; set; }

        public decimal? Longitude { get; set; }

        public string? Notes { get; set; }
    }

    public class PackageScanDto : CreatePackageScanDto
    {
        public Guid Id { get; set; }
        public string ScanNumber { get; set; } = string.Empty;
        public DateTime? ScanTime { get; set; }
        public DateTime CreatedAt { get; set; }
    }

    public class PackageScanResultDto
    {
        public Guid ScanId { get; set; }
        public string ScanNumber { get; set; } = string.Empty;
        public Guid TrackingEventId { get; set; }
        public string TrackingStatus { get; set; } = string.Empty;
        public string Message { get; set; } = string.Empty;
    }
}