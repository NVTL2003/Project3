using AutoMapper;
using Project3.DTOs;
using Project3.Models;
using Project3.Repositories.Interfaces;

namespace Project3.Services.Implementations
{
    public class ManifestItemService
        : CrudService<ManifestItem, ManifestItemDto, CreateManifestItemDto>
    {
        public ManifestItemService(
            ICrudRepository<ManifestItem> repository,
            IMapper mapper)
            : base(repository, mapper)
        {
        }

        protected override string[] SearchableProperties => new[]
        {
            "Notes",
            "Status"
        };

        protected override Task<ManifestItem> PrepareForCreateAsync(
            ManifestItem entity,
            Guid userId)
        {
            entity.CreatedAt = DateTime.UtcNow;
            entity.UpdatedAt = DateTime.UtcNow;

            // A manifest item is only an assignment.
            // It has NOT been physically loaded yet.
            if (string.IsNullOrEmpty(entity.Status))
            {
                entity.Status = "planned";
            }

            entity.LoadedAt = null;
            entity.UnloadedAt = null;
            entity.UnloadedFacilityId = null;

            return Task.FromResult(entity);
        }

        protected override Task PrepareForUpdateAsync(
            ManifestItem entity,
            Guid userId)
        {
            entity.UpdatedAt = DateTime.UtcNow;

            return Task.CompletedTask;
        }
    }
}
