using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Project3.DTOs;
using Project3.Models;
using Project3.Repositories.Interfaces;

namespace Project3.Services.Implementations;

public class CustomerAddressService
    : CrudService<
        CustomerAddress,
        CustomerAddressDto,
        CreateCustomerAddressDto>
{
    private readonly Pj3Context _context;

    public CustomerAddressService(
        ICrudRepository<CustomerAddress> repository,
        IMapper mapper,
        Pj3Context context)
        : base(repository, mapper)
    {
        _context = context;
    }

    protected override IQueryable<CustomerAddress> ApplyOwnerFilter(
        IQueryable<CustomerAddress> query,
        Guid userId)
    {
        return query
            .Include(a => a.Customer)
            .Where(a => a.Customer.UserId == userId);
    }

    protected override async Task<CustomerAddress> PrepareForCreateAsync(
        CustomerAddress entity,
        Guid userId)
    {
        var customer = await _context.Customers
            .FirstOrDefaultAsync(c => c.UserId == userId);

        if (customer == null)
        {
            throw new InvalidOperationException(
                "Customer record not found for current user.");
        }

        entity.CustomerId = customer.Id;
        entity.Id = Guid.NewGuid();
        entity.CreatedAt = DateTime.UtcNow;
        entity.UpdatedAt = DateTime.UtcNow;

        return entity;
    }

    protected override Task PrepareForUpdateAsync(
        CustomerAddress entity,
        Guid userId)
    {
        entity.UpdatedAt = DateTime.UtcNow;

        return Task.CompletedTask;
    }
}