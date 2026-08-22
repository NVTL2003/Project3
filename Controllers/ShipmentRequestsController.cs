using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Project3.DTOs;
using Project3.Models;
using Project3.Services.Interfaces;

namespace Project3.Controllers;

[ApiController]
[Authorize]
[Route("api/shipment-requests")]
public class ShipmentRequestsController
	: BaseCrudController<ShipmentRequest, ShipmentRequestDto, CreateShipmentRequestDto>
{
	private readonly Pj3Context _context;
	private readonly ICurrentUserService _currentUser;

	public ShipmentRequestsController(
		ICrudService<ShipmentRequest, ShipmentRequestDto, CreateShipmentRequestDto> service,
		IAuthorizationService authorizationService,
		Pj3Context context,
		ICurrentUserService currentUser)
		: base(service, authorizationService,currentUser)
	{
		_context = context;
		_currentUser = currentUser;
	}

	protected override string ResourceName => "shipment_requests";

	[HttpPost("{id}/approve")]
	public async Task<IActionResult> Approve(Guid id)
	{
		var request = await _context.ShipmentRequests
			.FirstOrDefaultAsync(r => r.Id == id);

		if (request == null)
			return NotFound(new { message = "Shipment request not found." });

		if (request.Status != "pending")
			return BadRequest(new { message = $"Request already {request.Status}." });

		var userId = _currentUser.UserId;
		if (userId == null)
			return Unauthorized();

		var employee = await _context.Employees
			.FirstOrDefaultAsync(e => e.UserId == userId.Value);

		if (employee == null)
			return BadRequest(new { message = "Current user is not an employee." });

		var trackingNumber = GenerateTrackingNumber();

		var shipment = new Shipment
		{
			Id = Guid.NewGuid(),
			TrackingNumber = trackingNumber,
			ShipmentRequestId = request.Id,
			ServiceId = request.ServiceId ?? throw new InvalidOperationException("Service is required"),
			CustomerId = request.CustomerId,
			SenderAddressId = request.SenderAddressId,
			ReceiverAddressId = request.ReceiverAddressId,
			Weight = request.Weight,
			Length = request.Length,
			Width = request.Width,
			Height = request.Height,
			DeclaredValue = request.DeclaredValue,
			InsurancePlanId = request.InsurancePlanId,
			PackageType = request.PackageType,
			SpecialInstructions = request.SpecialInstructions,
			IsFragile = request.IsFragile ?? false,
			IsLarge = request.IsLarge ?? false,
			CurrentStatus = "created",
			IsActive = true,
			CreatedAt = DateTime.UtcNow,
			UpdatedAt = DateTime.UtcNow
		};

		request.Status = "approved";
		request.ApprovedBy = employee.Id;
		request.ApprovedAt = DateTime.UtcNow;

		_context.Shipments.Add(shipment);

		var trackingStatus = await _context.TrackingStatuses
			.FirstOrDefaultAsync(ts => ts.Code == "CREATED");

		if (trackingStatus == null)
		{
			trackingStatus = new TrackingStatus
			{
				Id = Guid.NewGuid(),
				Code = "CREATED",
				Description = "Shipment Created",
				IsPublic = true,
				CreatedAt = DateTime.UtcNow
			};
			_context.TrackingStatuses.Add(trackingStatus);
		}

		var trackingEvent = new TrackingEvent
		{
			Id = Guid.NewGuid(),
			ShipmentId = shipment.Id,
			TrackingStatusId = trackingStatus.Id,
			EventLocation = "System",
			EventTime = DateTime.UtcNow,
			IsPublic = true,
			CreatedAt = DateTime.UtcNow
		};

		_context.TrackingEvents.Add(trackingEvent);

		await _context.SaveChangesAsync();

		return Ok(new
		{
			shipmentId = shipment.Id,
			trackingNumber = shipment.TrackingNumber,
			message = "Shipment created successfully."
		});
	}

	private string GenerateTrackingNumber()
	{
		return "TRK-" + DateTime.UtcNow.ToString("yyyyMMddHHmmss") + "-" +
			   Guid.NewGuid().ToString("N").Substring(0, 4).ToUpper();
	}
}