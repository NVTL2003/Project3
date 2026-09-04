using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Project3.DTOs;
using Project3.Models;
using Project3.Repositories.Interfaces;
using Project3.Services.Interfaces;

namespace Project3.Services.Implementations
{
    public class ShipmentManifestService
        : CrudService<ShipmentManifest, ShipmentManifestDto, CreateShipmentManifestDto>,
          IShipmentManifestService
    {
        private readonly Pj3Context _context;

        public ShipmentManifestService(
            ICrudRepository<ShipmentManifest> repository,
            IMapper mapper,
            Pj3Context context)
            : base(repository, mapper)
        {
            _context = context;
        }

        protected override string[] SearchableProperties => new[]
        {
            "ManifestNumber",
            "Status",
            "Notes"
        };

        // ============================================================
        // CREATE MANIFEST
        // ============================================================

        public override async Task<ShipmentManifestDto> CreateAsync(
            CreateShipmentManifestDto dto)
        {
            // --------------------------------------------------------
            // 1. Validate route
            // --------------------------------------------------------

            var route = await _context.Routes
                .Include(r => r.RouteStops)
                .FirstOrDefaultAsync(r =>
                    r.Id == dto.RouteId);

            if (route == null)
            {
                throw new KeyNotFoundException(
                    "Route not found.");
            }

            // --------------------------------------------------------
            // 2. Validate vehicle
            // --------------------------------------------------------

            var vehicle = await _context.Vehicles
                .FirstOrDefaultAsync(v =>
                    v.Id == dto.VehicleId);

            if (vehicle == null)
            {
                throw new KeyNotFoundException(
                    "Vehicle not found.");
            }

            if (vehicle.Status != "Available")
            {
                throw new InvalidOperationException(
                    $"Vehicle is not available. Current status: {vehicle.Status}");
            }

            // --------------------------------------------------------
            // 3. Validate driver
            // --------------------------------------------------------

            var driver = await _context.Employees
                .Include(e => e.User)
                .FirstOrDefaultAsync(e =>
                    e.Id == dto.DriverId);

            if (driver == null)
            {
                throw new KeyNotFoundException(
                    "Driver not found.");
            }

            // --------------------------------------------------------
            // 4. Validate departure facility
            // --------------------------------------------------------

            if (dto.DepartureFacilityId != route.OriginFacilityId)
            {
                throw new InvalidOperationException(
                    "Departure facility must match the route origin facility.");
            }

            // --------------------------------------------------------
            // 6. Create manifest
            // --------------------------------------------------------

            var now = DateTime.UtcNow;

            var entity = new ShipmentManifest
            {
                Id = Guid.NewGuid(),

                ManifestNumber = GenerateManifestNumber(),

                RouteId = dto.RouteId,

                VehicleId = dto.VehicleId,

                DriverId = dto.DriverId,

                DepartureFacilityId = dto.DepartureFacilityId,

                DepartureTime = dto.DepartureTime.ToUniversalTime(),

                // Actual arrival is unknown when the manifest is created.
                // It will be set when the truck actually arrives.
                ArrivalTime = null,

                Status = "planned",

                TotalWeight = 0,

                TotalPackages = 0,

                Notes = dto.Notes,

                CreatedAt = now,

                UpdatedAt = now
            };

            _context.ShipmentManifests.Add(entity);

            await _context.SaveChangesAsync();

            return _mapper.Map<ShipmentManifestDto>(entity);


        }

        // ============================================================
        // START MANIFEST
        // ============================================================

        public async Task<ShipmentManifestDto> StartManifestAsync(
            Guid manifestId,
            Guid userId)
        {
            var manifest = await _context.ShipmentManifests
                .Include(m => m.Driver)
                .Include(m => m.Vehicle)
                .FirstOrDefaultAsync(m =>
                    m.Id == manifestId);

            if (manifest == null)
            {
                throw new KeyNotFoundException(
                    "Manifest not found.");
            }

            if (manifest.Status != "planned")
            {
                throw new InvalidOperationException(
                    $"Cannot start manifest with status '{manifest.Status}'.");
            }

            // Verify driver
            if (manifest.DriverId != userId)
            {
                throw new UnauthorizedAccessException(
                    "Only the assigned driver can start this manifest.");
            }

            // Update vehicle status
            if (manifest.Vehicle != null)
            {
                manifest.Vehicle.Status = "In Route";
            }

            manifest.Status = "in_progress";
            manifest.UpdatedAt = DateTime.UtcNow;

            await _context.SaveChangesAsync();

            return _mapper.Map<ShipmentManifestDto>(manifest);
        }

        // ============================================================
        // COMPLETE MANIFEST
        // ============================================================

        public async Task<ShipmentManifestDto> CompleteManifestAsync(
            Guid manifestId,
            Guid userId)
        {
            var manifest = await _context.ShipmentManifests
                .Include(m => m.Driver)
                .Include(m => m.Vehicle)
                .Include(m => m.ManifestItems)
                .FirstOrDefaultAsync(m =>
                    m.Id == manifestId);

            if (manifest == null)
            {
                throw new KeyNotFoundException(
                    "Manifest not found.");
            }

            if (manifest.Status != "in_progress")
            {
                throw new InvalidOperationException(
                    $"Cannot complete manifest with status '{manifest.Status}'.");
            }

            // Verify driver
            if (manifest.DriverId != userId)
            {
                throw new UnauthorizedAccessException(
                    "Only the assigned driver can complete this manifest.");
            }

            // Check if all items are unloaded
            var hasLoadedItems = manifest.ManifestItems
                .Any(mi => mi.Status != "unloaded");

            if (hasLoadedItems)
            {
                throw new InvalidOperationException(
                    "Cannot complete manifest with items still loaded.");
            }

            // Update vehicle status
            if (manifest.Vehicle != null)
            {
                manifest.Vehicle.Status = "Available";
            }

            manifest.Status = "completed";
            manifest.UpdatedAt = DateTime.UtcNow;

            await _context.SaveChangesAsync();

            return _mapper.Map<ShipmentManifestDto>(manifest);
        }

        // ============================================================
        // CANCEL MANIFEST
        // ============================================================

        public async Task<ShipmentManifestDto> CancelManifestAsync(
            Guid manifestId,
            Guid userId)
        {
            var manifest = await _context.ShipmentManifests
                .Include(m => m.Vehicle)
                .Include(m => m.ManifestItems)
                .FirstOrDefaultAsync(m =>
                    m.Id == manifestId);

            if (manifest == null)
            {
                throw new KeyNotFoundException(
                    "Manifest not found.");
            }

            if (manifest.Status == "completed")
            {
                throw new InvalidOperationException(
                    "Cannot cancel a completed manifest.");
            }

            if (manifest.Status == "cancelled")
            {
                throw new InvalidOperationException(
                    "Manifest is already cancelled.");
            }

            // Update vehicle status if it was in use
            if (manifest.Vehicle != null && manifest.Vehicle.Status == "In Route")
            {
                manifest.Vehicle.Status = "Available";
            }

            manifest.Status = "cancelled";
            manifest.UpdatedAt = DateTime.UtcNow;

            await _context.SaveChangesAsync();

            return _mapper.Map<ShipmentManifestDto>(manifest);
        }

        // ============================================================
        // GET MANIFEST WITH ITEMS
        // ============================================================

        public async Task<ShipmentManifestDto> GetManifestWithItemsAsync(
            Guid manifestId)
        {
            var manifest = await _context.ShipmentManifests
                .Include(m => m.ManifestItems)
                    .ThenInclude(mi => mi.TransportOrder)
                        .ThenInclude(to => to.Shipment)
                .Include(m => m.Route)
                    .ThenInclude(r => r.RouteStops)
                .Include(m => m.Vehicle)
                .Include(m => m.Driver)
                    .ThenInclude(e => e.User)
                .FirstOrDefaultAsync(m =>
                    m.Id == manifestId);

            if (manifest == null)
            {
                throw new KeyNotFoundException(
                    "Manifest not found.");
            }

            return _mapper.Map<ShipmentManifestDto>(manifest);
        }

        // ============================================================
        // GET MANIFEST BY VEHICLE
        // ============================================================

        public async Task<IEnumerable<ShipmentManifestDto>> GetManifestsByVehicleAsync(
            Guid vehicleId)
        {
            var manifests = await _context.ShipmentManifests
                .Where(m =>
                    m.VehicleId == vehicleId &&
                    m.Status != "completed" &&
                    m.Status != "cancelled")
                .OrderByDescending(m => m.DepartureTime)
                .ToListAsync();

            return _mapper.Map<IEnumerable<ShipmentManifestDto>>(manifests);
        }

        // ============================================================
        // GET MANIFEST BY DRIVER
        // ============================================================

        public async Task<IEnumerable<ShipmentManifestDto>> GetManifestsByDriverAsync(
            Guid driverId)
        {
            var manifests = await _context.ShipmentManifests
                .Where(m =>
                    m.DriverId == driverId &&
                    m.Status != "completed" &&
                    m.Status != "cancelled")
                .OrderByDescending(m => m.DepartureTime)
                .ToListAsync();

            return _mapper.Map<IEnumerable<ShipmentManifestDto>>(manifests);
        }

        // ============================================================
        // PREPARE FOR CREATE
        // ============================================================

        protected override Task<ShipmentManifest> PrepareForCreateAsync(
            ShipmentManifest entity,
            Guid userId)
        {
            var now = DateTime.UtcNow;

            entity.ManifestNumber = GenerateManifestNumber();
            entity.CreatedAt = now;
            entity.UpdatedAt = now;
            entity.Status = "planned";
            entity.TotalWeight = 0;
            entity.TotalPackages = 0;

            return Task.FromResult(entity);
        }

        // ============================================================
        // PREPARE FOR UPDATE
        // ============================================================

        protected override Task PrepareForUpdateAsync(
            ShipmentManifest entity,
            Guid userId)
        {
            entity.UpdatedAt = DateTime.UtcNow;

            return Task.CompletedTask;
        }

        // ============================================================
        // GENERATE MANIFEST NUMBER
        // ============================================================

        private string GenerateManifestNumber()
        {
            return
                "MAN-" +
                DateTime.UtcNow.ToString("yyyyMMddHHmmss") +
                "-" +
                Guid.NewGuid()
                    .ToString("N")
                    .Substring(0, 4)
                    .ToUpperInvariant();
        }
    }
}