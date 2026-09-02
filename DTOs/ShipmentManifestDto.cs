using System;
using System.Collections.Generic;

namespace Project3.DTOs
{
	public class ShipmentManifestDto
	{
		public Guid Id { get; set; }
		public string ManifestNumber { get; set; } = string.Empty;
		public Guid VehicleId { get; set; }
		public Guid DriverId { get; set; }
		public Guid RouteId { get; set; }
		public Guid DepartureFacilityId { get; set; }
		public DateTime DepartureTime { get; set; }
		public DateTime? ArrivalTime { get; set; }
		public string? Status { get; set; }
		public int? TotalPackages { get; set; }
		public decimal? TotalWeight { get; set; }
		public string? Notes { get; set; }
		public DateTime CreatedAt { get; set; }
		public DateTime UpdatedAt { get; set; }
		public List<ManifestItemDto>? ManifestItems { get; set; }
	}

	public class CreateShipmentManifestDto
	{
		public Guid VehicleId { get; set; }

		public Guid DriverId { get; set; }

		public Guid RouteId { get; set; }

		public Guid DepartureFacilityId { get; set; }

		public DateTime DepartureTime { get; set; }

		public string? Notes { get; set; }
	}
}