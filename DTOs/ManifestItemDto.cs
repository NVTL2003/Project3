using System;

namespace Project3.DTOs
{
    public class ManifestItemDto
    {
        public Guid Id { get; set; }

        public Guid ManifestId { get; set; }

        public Guid TransportOrderId { get; set; }

        // Weight assigned from this Transport Order
        // to this particular Manifest, in KG.
        public decimal Weight { get; set; }

        public int? LoadingSequence { get; set; }

        public string? Status { get; set; }

        public DateTime? LoadedAt { get; set; }

        public DateTime? UnloadedAt { get; set; }

        public Guid? UnloadedFacilityId { get; set; }

        public string? Notes { get; set; }

        public DateTime? CreatedAt { get; set; }

        public DateTime? UpdatedAt { get; set; }
    }

    public class CreateManifestItemDto
    {
        public Guid ManifestId { get; set; }

        public Guid TransportOrderId { get; set; }

        // Amount of the Transport Order's weight
        // assigned to this Manifest, in KG.
        public decimal Weight { get; set; }

        public int? LoadingSequence { get; set; }

        public string? Notes { get; set; }
    }
}