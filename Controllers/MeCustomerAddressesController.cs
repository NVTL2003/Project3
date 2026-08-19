//using Microsoft.AspNetCore.Authorization;
//using Microsoft.AspNetCore.Mvc;
//using Project3.DTOs;
//using Project3.Services.Interfaces;
//using Project3.Models;

//namespace Project3.Controllers;

//[ApiController]
//[Authorize]
//[Route("api/me/customer-addresses")]
//public class MeCustomerAddressesController
//	: BaseMeCrudController<
//		CustomerAddress,
//		CustomerAddressDto,
//		CreateCustomerAddressDto>
//{
//	public MeCustomerAddressesController(
//		IMeCrudService<
//			CustomerAddress,
//			CustomerAddressDto,
//			CreateCustomerAddressDto> service,
//		IAuthorizationService authorizationService,
//		ICurrentUserService currentUser)
//		: base(
//			service,
//			authorizationService,
//			currentUser)
//	{
//	}
//}

using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Project3.DTOs;
using Project3.Services.Interfaces;
using Project3.Models;

namespace Project3.Controllers;

[ApiController]
[Authorize]
[Route("api/me/customer-addresses")]
public class MeCustomerAddressesController
    : BaseMeCrudController<
        CustomerAddress,
        CustomerAddressDto,
        CreateCustomerAddressDto>
{
    public MeCustomerAddressesController(
        IMeCrudService<
            CustomerAddress,
            CustomerAddressDto,
            CreateCustomerAddressDto> service,
        IAuthorizationService authorizationService,
        ICurrentUserService currentUser)
        : base(
            service,
            authorizationService,
            currentUser)
    {
    }

    protected override string ResourceName =>
        "customer_addresses";
}