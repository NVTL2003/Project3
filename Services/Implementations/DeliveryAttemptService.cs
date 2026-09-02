using AutoMapper;
using Project3.DTOs;
using Project3.Models;
using Project3.Repositories.Interfaces;
using Project3.Services.Implementations;

namespace Project3.Services.Implementations
{
    public class DeliveryAttemptService
        : CrudService<DeliveryAttempt, DeliveryAttemptDto, CreateDeliveryAttemptDto>
    {
        public DeliveryAttemptService(
            ICrudRepository<DeliveryAttempt> repository,
            IMapper mapper)
            : base(repository, mapper)
        {
        }

        protected override string[] SearchableProperties => new[]
        {
            "Status",
            "Reason",
            "Notes"
        };

        protected override Task<DeliveryAttempt> PrepareForCreateAsync(
            DeliveryAttempt entity,
            Guid userId)
        {
            entity.CreatedAt = DateTime.UtcNow;
            entity.UpdatedAt = DateTime.UtcNow;
            entity.AttemptTime = entity.AttemptTime ?? DateTime.UtcNow;

            if (string.IsNullOrEmpty(entity.Status))
            {
                entity.Status = "attempted";
            }

            return Task.FromResult(entity);
        }

        protected override Task PrepareForUpdateAsync(
            DeliveryAttempt entity,
            Guid userId)
        {
            entity.UpdatedAt = DateTime.UtcNow;
            return Task.CompletedTask;
        }
    }
}