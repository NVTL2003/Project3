using AutoMapper;
using Project3.DTOs;
using Project3.Models;
using Project3.Repositories.Interfaces;
using Project3.Services.Interfaces;

namespace Project3.Services.Implementations
{
    public class ShipmentManifestService
        : CrudService<
            ShipmentManifest,
            ShipmentManifestDto,
            CreateShipmentManifestDto>
    {
        private readonly ICurrentUserService _currentUser;

        public ShipmentManifestService(
            ICrudRepository<ShipmentManifest> repository,
            IMapper mapper,
            ICurrentUserService currentUser)
            : base(repository, mapper)
        {
            _currentUser = currentUser;
        }

        protected override string[] SearchableProperties => new[]
        {
            "ManifestNumber",
            "Notes"
        };

        public override async Task<ShipmentManifestDto> CreateAsync(
            CreateShipmentManifestDto dto)
        {
            var entity = _mapper.Map<ShipmentManifest>(dto);

            if (entity == null)
                throw new InvalidOperationException(
                    "Failed to create ShipmentManifest entity.");

            var userId = _currentUser.UserId ?? Guid.Empty;

            entity = await PrepareForCreateAsync(
                entity,
                userId);

            await _repository.AddAsync(entity);
            await _repository.SaveChangesAsync();

            return _mapper.Map<ShipmentManifestDto>(entity);
        }

        protected override Task<ShipmentManifest> PrepareForCreateAsync(
            ShipmentManifest entity,
            Guid userId)
        {
            var now = DateTime.UtcNow;

            entity.Id = Guid.NewGuid();

            entity.ManifestNumber =
                "MAN-" +
                now.ToString("yyyyMMddHHmmss") +
                "-" +
                Guid.NewGuid()
                    .ToString("N")
                    .Substring(0, 4)
                    .ToUpperInvariant();

            entity.Status = "planned";

            entity.TotalPackages = 0;
            entity.TotalWeight = 0;

            entity.CreatedAt = now;
            entity.UpdatedAt = now;

            entity.ArrivalTime = null;

            return Task.FromResult(entity);
        }

        protected override Task PrepareForUpdateAsync(
            ShipmentManifest entity,
            Guid userId)
        {
            entity.UpdatedAt = DateTime.UtcNow;

            return Task.CompletedTask;
        }
    }
}