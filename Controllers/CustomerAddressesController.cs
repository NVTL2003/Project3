using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Project3.DTOs;
using Project3.Models;
using Project3.Services.Interfaces;

[ApiController]
[Authorize]
[Route("api/[controller]")]
public class CustomerAddressesController
    : BaseCrudController<CustomerAddress, CustomerAddressDto, CreateCustomerAddressDto>
{
    public CustomerAddressesController(
        ICrudService<CustomerAddress, CustomerAddressDto, CreateCustomerAddressDto> service,
        IAuthorizationService authorizationService)
        : base(service, authorizationService)
    {
    }

    protected override string ResourceName => "customer_addresses";
}