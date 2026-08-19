//using AutoMapper;
//using Microsoft.EntityFrameworkCore;
//using Project3.DTOs;
//using Project3.Models;
//using Project3.Repositories.Interfaces;

//namespace Project3.Services.Implementations;

//public class CustomerAddressMeService
//    : MeCrudService<
//        CustomerAddress,
//        CustomerAddressDto,
//        CreateCustomerAddressDto>
//{
//    private readonly Pj3Context _context;

//    public CustomerAddressMeService(
//        ICrudRepository<CustomerAddress> repository,
//        IMapper mapper,
//        Pj3Context context)
//        : base(repository, mapper)
//    {
//        _context = context;
//    }

//    protected override IQueryable<CustomerAddress>
//        ApplyOwnerFilter(
//            IQueryable<CustomerAddress> query,
//            Guid userId)
//    {
//        return query.Where(address =>
//            _context.Customers.Any(customer =>
//                customer.Id == address.CustomerId &&
//                customer.UserId == userId));
//    }

//    protected override async Task<CustomerAddress>
//        PrepareForCreateAsync(
//            CustomerAddress entity,
//            Guid userId)
//    {
//        var customerId =
//            await _context.Customers
//                .Where(c => c.UserId == userId)
//                .Select(c => (Guid?)c.Id)
//                .FirstOrDefaultAsync();

//        if (customerId == null)
//        {
//            throw new InvalidOperationException(
//                "Customer profile not found.");
//        }

//        entity.Id = Guid.NewGuid();

//        entity.CustomerId =
//            customerId.Value;

//        entity.IsActive = true;

//        entity.CreatedAt =
//            DateTime.UtcNow;

//        entity.UpdatedAt =
//            DateTime.UtcNow;

//        return entity;
//    }

//    protected override Task PrepareForUpdateAsync(
//        CustomerAddress entity,
//        Guid userId)
//    {
//        entity.UpdatedAt =
//            DateTime.UtcNow;

//        return Task.CompletedTask;
//    }
//}
using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Project3.DTOs;
using Project3.Models;
using Project3.Repositories.Interfaces;

namespace Project3.Services.Implementations;

public class CustomerAddressMeService
    : MeCrudService<CustomerAddress, CustomerAddressDto, CreateCustomerAddressDto>
{
    private readonly Pj3Context _context;

    public CustomerAddressMeService(
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
        // Filter addresses by the customer's UserId
        return query
            .Include(a => a.Customer)
            .Where(a => a.Customer.UserId == userId);
    }

    protected override async Task<CustomerAddress> PrepareForCreateAsync(
        CustomerAddress entity,
        Guid userId)
    {
        // Find the customer record for this user
        var customer = await _context.Customers
            .FirstOrDefaultAsync(c => c.UserId == userId);

        if (customer == null)
        {
            throw new InvalidOperationException("Customer record not found for current user.");
        }

        // Set the customer ID
        entity.CustomerId = customer.Id;
        entity.Id = Guid.NewGuid();
        entity.CreatedAt = DateTime.UtcNow;
        entity.UpdatedAt = DateTime.UtcNow;

        return entity;
    }
}