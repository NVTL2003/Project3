//using AutoMapper;
//using Project3.DTOs;
//using Project3.Exceptions;
//using Project3.Models;
//using Project3.Repositories.Interfaces;

//namespace Project3.Services.Implementations;

//public class ShipmentMeService
//    : MeCrudService<
//        Shipment,
//        ShipmentDto,
//        CreateShipmentDto>
//{
//    protected override async Task<
//        Expression<Func<Shipment, bool>>?>
//        BuildOwnershipFilterAsync(Guid userId)
//    {
//        return shipment =>
//            shipment.Customer.UserId == userId;
//    }

//    // CreateMineAsync(...)
//}