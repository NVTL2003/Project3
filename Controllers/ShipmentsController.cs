using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Project3.DTOs;
using Project3.Models;
using Project3.Services.Interfaces;
using QRCoder;

namespace Project3.Controllers
{
    [ApiController]
    [Authorize]
    [Route("api/[controller]")]
    public class ShipmentsController
        : BaseCrudController<
            Shipment,
            ShipmentDto,
            CreateShipmentDto>
    {
        public ShipmentsController(
            ICrudService<Shipment, ShipmentDto, CreateShipmentDto> service,
            IAuthorizationService authorizationService,
            ICurrentUserService currentUser)
            : base(service, authorizationService, currentUser)
        {
        }

        [HttpPost("me")]
        public override Task<IActionResult> CreateMine(
            [FromBody] CreateShipmentDto dto)
        {
            return Task.FromResult<IActionResult>(
                Forbid());
        }

        [HttpPut("me/{id:guid}")]
        public override Task<IActionResult> UpdateMine(
            Guid id,
            [FromBody] CreateShipmentDto dto)
        {
            return Task.FromResult<IActionResult>(
                Forbid());
        }

        [HttpDelete("me/{id:guid}")]
        public override Task<IActionResult> DeleteMine(
            Guid id)
        {
            return Task.FromResult<IActionResult>(
                Forbid());
        }

        // ============================================================
        // QR CODE
        // ============================================================

        [HttpGet("{id:guid}/qr")]
        public async Task<IActionResult> GetQrCode(Guid id)
        {
            var shipment = await _service.GetByIdAsync(id);

            if (shipment == null)
                return NotFound();

            using var qrGenerator = new QRCodeGenerator();

            using var qrData = qrGenerator.CreateQrCode(
                shipment.TrackingNumber,
                QRCodeGenerator.ECCLevel.Q);

            var qrCode = new PngByteQRCode(qrData);

            byte[] qrBytes = qrCode.GetGraphic(20);

            return File(
                qrBytes,
                "image/png",
                $"{shipment.TrackingNumber}.png");
        }
    }
}