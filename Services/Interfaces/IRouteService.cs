using Project3.DTOs;

namespace Project3.Services.Interfaces;

public interface IRouteService
    : ICrudService<
        Project3.Models.Route,
        RouteDto,
        CreateRouteDto>
{
    Task<IEnumerable<RouteStopDto>> GetStopsAsync(
        Guid routeId);

    Task<bool> ActivateAsync(
        Guid routeId);

    Task<bool> DeactivateAsync(
        Guid routeId);
}