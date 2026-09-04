using Project3.DTOs;
using Project3.Models;

namespace Project3.Services.Interfaces
{
    public interface IShipmentManifestService
        : ICrudService<
            ShipmentManifest,
            ShipmentManifestDto,
            CreateShipmentManifestDto>
    {
        Task<ShipmentManifestDto> StartManifestAsync(
            Guid manifestId,
            Guid userId);

        Task<ShipmentManifestDto> CompleteManifestAsync(
            Guid manifestId,
            Guid userId);

        Task<ShipmentManifestDto> CancelManifestAsync(
            Guid manifestId,
            Guid userId);

        Task<ShipmentManifestDto> GetManifestWithItemsAsync(
            Guid manifestId);

        Task<IEnumerable<ShipmentManifestDto>> GetManifestsByVehicleAsync(
            Guid vehicleId);

        Task<IEnumerable<ShipmentManifestDto>> GetManifestsByDriverAsync(
            Guid driverId);
    }
}