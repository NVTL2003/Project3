//using Microsoft.AspNetCore.Authorization;
//using Microsoft.AspNetCore.Mvc;
//using Project3.DTOs;
//using Project3.Models;
//using Project3.Services.Interfaces;

//[Authorize]
//[Route("api/me/shipments")]
//public class MeShipmentsController
//    : BaseMeCrudController<
//        Shipment,
//        ShipmentDto,
//        CreateShipmentDto>
//{
//    public MeShipmentsController(
//        IMeCrudService<
//            Shipment,
//            ShipmentDto,
//            CreateShipmentDto> service,
//        IAuthorizationService authorizationService)
//        : base(service, authorizationService)
//    {
//    }
//}