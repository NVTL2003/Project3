using Project3.DTOs;
using Project3.Models;

namespace Project3.Services.Interfaces;

public interface IRouteService
    : ICrudService<
        Project3.Models.Route,
        RouteDto,
        CreateRouteDto>
{
}