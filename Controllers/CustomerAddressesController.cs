using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Project3.DTOs;
using Project3.Models;
using Project3.Services.Interfaces;

[ApiController]
[Authorize]
[Route("api/customer-addresses")]
public class CustomerAddressesController
    : BaseCrudController<CustomerAddress, CustomerAddressDto, CreateCustomerAddressDto>
{
    public CustomerAddressesController(
        ICrudService<CustomerAddress, CustomerAddressDto, CreateCustomerAddressDto> service,
        IAuthorizationService authorizationService,
        ICurrentUserService currentUser)
        : base(service, authorizationService, currentUser)
    {
    }

    protected override string ResourceName => "customer-addresses";
}