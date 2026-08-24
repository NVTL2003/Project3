using AutoMapper;
using Project3.DTOs;
using Project3.Models;
using Project3.Repositories.Interfaces;
using Project3.Services.Interfaces;

namespace Project3.Services.Implementations;

public class VehicleService
    : CrudService<
        Vehicle,
        VehicleDto,
        CreateVehicleDto>,
      IVehicleService
{
    public VehicleService(
        ICrudRepository<Vehicle> repository,
        IMapper mapper)
        : base(repository, mapper)
    {
    }
}