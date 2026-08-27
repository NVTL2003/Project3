using Project3.DTOs;
using Project3.Models;

namespace Project3.Services.Interfaces;

public interface IRouteStopService
    : ICrudService<
        RouteStop,
        RouteStopDto,
        CreateRouteStopDto>
{
}