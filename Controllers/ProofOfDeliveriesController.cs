using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Project3.DTOs;
using Project3.Models;
using Project3.Services.Interfaces;

namespace Project3.Controllers;

[ApiController]
[Authorize]
[Route("api/proof-of-deliveries")]
public class ProofOfDeliveriesController
    : BaseCrudController<ProofOfDelivery, ProofOfDeliveryDto, CreateProofOfDeliveryDto>
{
    public ProofOfDeliveriesController(
        ICrudService<ProofOfDelivery, ProofOfDeliveryDto, CreateProofOfDeliveryDto> service,
        IAuthorizationService authorizationService)
        : base(service, authorizationService)
    {
    }

    protected override string ResourceName => "proof_of_delivery";
}