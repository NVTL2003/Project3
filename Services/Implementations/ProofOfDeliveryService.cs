using AutoMapper;
using Project3.DTOs;
using Project3.Models;
using Project3.Repositories.Interfaces;
using Project3.Services.Implementations;

namespace Project3.Services.Implementations
{
    public class ProofOfDeliveryService
        : CrudService<ProofOfDelivery, ProofOfDeliveryDto, CreateProofOfDeliveryDto>
    {
        public ProofOfDeliveryService(
            ICrudRepository<ProofOfDelivery> repository,
            IMapper mapper)
            : base(repository, mapper)
        {
        }

        protected override string[] SearchableProperties => new[]
        {
            "ReceiverName",
            "ReceiverRelation",
            "Notes"
        };

        protected override Task<ProofOfDelivery> PrepareForCreateAsync(
            ProofOfDelivery entity,
            Guid userId)
        {
            entity.CreatedAt = DateTime.UtcNow;

            // Set delivery time if not provided
            if (entity.DeliveryTime == default)
            {
                entity.DeliveryTime = DateTime.UtcNow;
            }

            return Task.FromResult(entity);
        }
    }
}