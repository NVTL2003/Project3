using AutoMapper;
using Project3.DTOs;
using Project3.Models;
using Project3.Repositories.Interfaces;

namespace Project3.Services.Implementations;

public class ShipmentService
    : CrudService<
        Shipment,
        ShipmentDto,
        CreateShipmentDto>
{
    public ShipmentService(
        ICrudRepository<Shipment> repository,
        IMapper mapper)
        : base(repository, mapper)
    {
    }

    protected override IQueryable<Shipment> ApplyOwnerFilter(
        IQueryable<Shipment> query,
        Guid userId)
    {
        return query.Where(shipment =>
            shipment.Customer.UserId == userId);
    }
}