using AutoMapper;
using Project3.DTOs;
using Project3.Models;
using Project3.Repositories.Interfaces;
using Project3.Services.Implementations;

namespace Project3.Services.Implementations
{
    public class DeliveryAssignmentService
        : CrudService<DeliveryAssignment, DeliveryAssignmentDto, CreateDeliveryAssignmentDto>
    {
        public DeliveryAssignmentService(
            ICrudRepository<DeliveryAssignment> repository,
            IMapper mapper)
            : base(repository, mapper)
        {
        }

        protected override string[] SearchableProperties => new[]
        {
            "AssignmentNumber",
            "Notes",
            "Status"
        };

        protected override Task<DeliveryAssignment> PrepareForCreateAsync(
            DeliveryAssignment entity,
            Guid userId)
        {
            entity.CreatedAt = DateTime.UtcNow;
            entity.UpdatedAt = DateTime.UtcNow;
            entity.AssignedAt = DateTime.UtcNow;

            if (string.IsNullOrEmpty(entity.Status))
            {
                entity.Status = "Assigned";
            }

            // Generate assignment number if not provided
            if (string.IsNullOrEmpty(entity.AssignmentNumber))
            {
                entity.AssignmentNumber = $"ASN-{DateTime.UtcNow:yyyyMMdd}-{Guid.NewGuid().ToString().Substring(0, 8).ToUpper()}";
            }

            return Task.FromResult(entity);
        }

        protected override Task PrepareForUpdateAsync(
            DeliveryAssignment entity,
            Guid userId)
        {
            entity.UpdatedAt = DateTime.UtcNow;
            return Task.CompletedTask;
        }
    }
}