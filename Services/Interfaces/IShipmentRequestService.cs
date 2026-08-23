using Project3.DTOs;
using Project3.Models;

namespace Project3.Services.Interfaces;

public interface IShipmentRequestService
    : ICrudService<
        ShipmentRequest,
        ShipmentRequestDto,
        CreateShipmentRequestDto>
{
    Task<ApproveShipmentRequestResult> ApproveAsync(
        Guid id,
        Guid userId);
}