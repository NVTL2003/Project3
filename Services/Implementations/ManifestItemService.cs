using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Project3.DTOs;
using Project3.Models;
using Project3.Repositories.Interfaces;

namespace Project3.Services.Implementations
{
    public class ManifestItemService
        : CrudService<
            ManifestItem,
            ManifestItemDto,
            CreateManifestItemDto>
    {
        private readonly Pj3Context _context;

        public ManifestItemService(
            ICrudRepository<ManifestItem> repository,
            IMapper mapper,
            Pj3Context context)
            : base(repository, mapper)
        {
            _context = context;
        }

        protected override string[] SearchableProperties => new[]
        {
            "Notes",
            "Status"
        };

        // ============================================================
        // CREATE MANIFEST ITEM
        // ============================================================

        public override async Task<ManifestItemDto> CreateAsync(
            CreateManifestItemDto dto)
        {
            // --------------------------------------------------------
            // 1. Validate requested weight
            // --------------------------------------------------------

            if (dto.Weight <= 0)
            {
                throw new InvalidOperationException(
                    "Manifest item weight must be greater than zero.");
            }

            // --------------------------------------------------------
            // 2. Find manifest + vehicle
            // --------------------------------------------------------

            var manifest = await _context.ShipmentManifests
                .Include(m => m.Vehicle)
                .FirstOrDefaultAsync(m =>
                    m.Id == dto.ManifestId);

            if (manifest == null)
            {
                throw new KeyNotFoundException(
                    "Shipment manifest not found.");
            }

            // --------------------------------------------------------
            // 3. Manifest must still accept assignments
            // --------------------------------------------------------

            if (manifest.Status != "planned")
            {
                throw new InvalidOperationException(
                    $"Cannot add a transport order to a manifest " +
                    $"with status '{manifest.Status}'.");
            }

            // --------------------------------------------------------
            // 4. Validate vehicle
            // --------------------------------------------------------

            if (manifest.Vehicle == null)
            {
                throw new InvalidOperationException(
                    "Manifest vehicle not found.");
            }

            if (manifest.Vehicle.Capacity <= 0)
            {
                throw new InvalidOperationException(
                    "Manifest vehicle has no valid weight capacity.");
            }

            // --------------------------------------------------------
            // 5. Find Transport Order
            // --------------------------------------------------------

            var transportOrder = await _context.TransportOrders
                .FirstOrDefaultAsync(o =>
                    o.Id == dto.TransportOrderId);

            if (transportOrder == null)
            {
                throw new KeyNotFoundException(
                    "Transport order not found.");
            }

            // --------------------------------------------------------
            // 6. Validate Transport Order status
            // --------------------------------------------------------

            if (transportOrder.Status == "cancelled")
            {
                throw new InvalidOperationException(
                    "Cannot assign a cancelled transport order.");
            }

            if (transportOrder.Status == "delivered")
            {
                throw new InvalidOperationException(
                    "Cannot assign a delivered transport order.");
            }

            // --------------------------------------------------------
            // 7. Check duplicate on SAME manifest
            // --------------------------------------------------------

            var existingItem = await _context.ManifestItems
                .FirstOrDefaultAsync(mi =>
                    mi.ManifestId == dto.ManifestId &&
                    mi.TransportOrderId == dto.TransportOrderId);

            if (existingItem != null)
            {
                throw new InvalidOperationException(
                    "This transport order is already assigned to this manifest.");
            }

            // ========================================================
            // 8. CALCULATE ALREADY ALLOCATED TO WEIGHT
            // ========================================================

            var allocatedTransportOrderWeight =
                await _context.ManifestItems
                    .Where(mi =>
                        mi.TransportOrderId == dto.TransportOrderId)
                    .SumAsync(mi => (decimal?)mi.Weight)
                ?? 0m;

            // ========================================================
            // 9. CALCULATE REMAINING TO WEIGHT
            // ========================================================

            var remainingTransportOrderWeight =
                transportOrder.Weight -
                allocatedTransportOrderWeight;

            // Prevent weird negative values caused by bad old data.
            if (remainingTransportOrderWeight < 0)
            {
                remainingTransportOrderWeight = 0;
            }

            // ========================================================
            // 10. REQUESTED WEIGHT CANNOT EXCEED TO REMAINING WEIGHT
            // ========================================================

            if (dto.Weight > remainingTransportOrderWeight)
            {
                throw new InvalidOperationException(
                    $"Cannot assign {dto.Weight:0.##} kg. " +
                    $"Only {remainingTransportOrderWeight:0.##} kg " +
                    $"of the transport order's weight remains available.");
            }

            // ========================================================
            // 11. CALCULATE CURRENT MANIFEST WEIGHT
            // ========================================================

            var currentManifestWeight =
                await _context.ManifestItems
                    .Where(mi =>
                        mi.ManifestId == dto.ManifestId)
                    .SumAsync(mi => (decimal?)mi.Weight)
                ?? 0m;

            // ========================================================
            // 12. CALCULATE REMAINING VEHICLE CAPACITY
            // ========================================================

            var vehicleCapacity =
                manifest.Vehicle.Capacity;

            var remainingVehicleCapacity =
                vehicleCapacity -
                currentManifestWeight;

            if (remainingVehicleCapacity < 0)
            {
                remainingVehicleCapacity = 0;
            }

            // ========================================================
            // 13. CHECK VEHICLE CAPACITY
            // ========================================================

            if (dto.Weight > remainingVehicleCapacity)
            {
                throw new InvalidOperationException(
                    $"Cannot assign {dto.Weight:0.##} kg. " +
                    $"The vehicle has only " +
                    $"{remainingVehicleCapacity:0.##} kg " +
                    $"of remaining capacity.");
            }

            // ========================================================
            // 14. CREATE MANIFEST ITEM
            // ========================================================

            var now = DateTime.UtcNow;

            var entity = new ManifestItem
            {
                Id = Guid.NewGuid(),

                ManifestId = dto.ManifestId,

                TransportOrderId = dto.TransportOrderId,

                Weight = dto.Weight,

                LoadingSequence = dto.LoadingSequence,

                Status = "planned",

                LoadedAt = null,

                UnloadedAt = null,

                UnloadedFacilityId = null,

                Notes = dto.Notes,

                CreatedAt = now,

                UpdatedAt = now
            };

            _context.ManifestItems.Add(entity);

            // ========================================================
            // 15. UPDATE MANIFEST TOTALS
            // ========================================================

            manifest.TotalWeight =
                currentManifestWeight + dto.Weight;

            manifest.TotalPackages =
                await _context.ManifestItems
                    .CountAsync(mi =>
                        mi.ManifestId == dto.ManifestId)
                + 1;

            manifest.UpdatedAt = now;

            // ========================================================
            // 16. SAVE
            // ========================================================

            await _context.SaveChangesAsync();

            return _mapper.Map<ManifestItemDto>(entity);
        }

        // ============================================================
        // PREPARE FOR CREATE
        // ============================================================

        protected override Task<ManifestItem> PrepareForCreateAsync(
            ManifestItem entity,
            Guid userId)
        {
            var now = DateTime.UtcNow;

            entity.CreatedAt = now;
            entity.UpdatedAt = now;

            entity.Status = "planned";

            entity.LoadedAt = null;
            entity.UnloadedAt = null;
            entity.UnloadedFacilityId = null;

            return Task.FromResult(entity);
        }

        // ============================================================
        // PREPARE FOR UPDATE
        // ============================================================

        protected override Task PrepareForUpdateAsync(
            ManifestItem entity,
            Guid userId)
        {
            entity.UpdatedAt = DateTime.UtcNow;

            return Task.CompletedTask;
        }
    }
}