using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Project3.Authentication;
using Project3.DTOs;
using Project3.Models;
using Project3.Services.Interfaces;
using Project3.Services.Implementations;

namespace Project3.Controllers;

[ApiController]
[Authorize]
[Route("api/[controller]")]
public class ProofOfDeliveriesController
    : BaseCrudController<
        ProofOfDelivery,
        ProofOfDeliveryDto,
        CreateProofOfDeliveryDto>
{
    public ProofOfDeliveriesController(
        ICrudService<
            ProofOfDelivery,
            ProofOfDeliveryDto,
            CreateProofOfDeliveryDto> service,
        IAuthorizationService authorizationService,
        ICurrentUserService currentUser)
        : base(
            service,
            authorizationService,
            currentUser)
    {
    }

    [HttpPost]
    public override async Task<IActionResult> Create(
        [FromBody] CreateProofOfDeliveryDto dto)
    {
        return BadRequest(new
        {
            message =
                "Proof of delivery is created automatically when a delivery attempt is completed."
        });
    }

    [HttpPut("{id}")]
    public override async Task<IActionResult> Update(
        Guid id,
        [FromBody] CreateProofOfDeliveryDto dto)
    {
        return BadRequest(new
        {
            message =
                "Proof of delivery cannot be updated."
        });
    }

    [HttpDelete("{id}")]
    public override async Task<IActionResult> Delete(Guid id)
    {
        return BadRequest(new
        {
            message =
                "Proof of delivery cannot be deleted."
        });
    }
}