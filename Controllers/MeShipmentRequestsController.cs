using AutoMapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Project3.Authentication;
using Project3.DTOs;
using Project3.Models;
using Project3.Services.Interfaces;

namespace Project3.Controllers;

[ApiController]
[Authorize]
[Route("api/me/shipment-requests")]
public class MeShipmentRequestsController : ControllerBase
{
	private readonly Pj3Context _context;
	private readonly ICurrentUserService _currentUser;
	private readonly IMapper _mapper;
	private readonly IAuthorizationService _authorizationService;

	public MeShipmentRequestsController(
		Pj3Context context,
		ICurrentUserService currentUser,
		IMapper mapper,
		IAuthorizationService authorizationService)
	{
		_context = context;
		_currentUser = currentUser;
		_mapper = mapper;
		_authorizationService = authorizationService;
	}

	private async Task<bool> HasPermission(string action)
	{
		var permission = $"shipment_requests.{action}";
		var result = await _authorizationService.AuthorizeAsync(
			User,
			resource: null,
			requirements: new[]
			{
				new PermissionRequirement(permission)
			});

		return result.Succeeded;
	}

	[HttpGet]
	public async Task<IActionResult> GetMyRequests()
	{
		if (!await HasPermission("read"))
			return Forbid();

		var userId = _currentUser.UserId;
		if (userId == null) return Unauthorized();

		var customer = await _context.Customers
			.FirstOrDefaultAsync(c => c.UserId == userId.Value);

		if (customer == null) return NotFound("Customer not found");

		var requests = await _context.ShipmentRequests
			.Where(r => r.CustomerId == customer.Id)
			.OrderByDescending(r => r.CreatedAt)
			.ToListAsync();

		return Ok(_mapper.Map<List<ShipmentRequestDto>>(requests));
	}

	[HttpGet("paged")]
	public async Task<IActionResult> GetMyRequestsPaged([FromQuery] QueryParamsDto queryParams)
	{
		if (!await HasPermission("read"))
			return Forbid();

		var userId = _currentUser.UserId;
		if (userId == null) return Unauthorized();

		var customer = await _context.Customers
			.FirstOrDefaultAsync(c => c.UserId == userId.Value);

		if (customer == null) return NotFound("Customer not found");

		var page = queryParams.Page <= 0 ? 1 : queryParams.Page;
		var pageSize = queryParams.PageSize <= 0 ? 10 : Math.Min(queryParams.PageSize, 100);

		var query = _context.ShipmentRequests
			.Where(r => r.CustomerId == customer.Id);

		if (!string.IsNullOrWhiteSpace(queryParams.Search))
		{
			var search = queryParams.Search.Trim().ToLowerInvariant();
			query = query.Where(r =>
				r.RequestNumber.ToLower().Contains(search) ||
				r.PackageType.ToLower().Contains(search) ||
				(r.Status != null && r.Status.ToLower().Contains(search)));
		}

		var totalCount = await query.CountAsync();

		var requests = await query
			.OrderByDescending(r => r.CreatedAt)
			.Skip((page - 1) * pageSize)
			.Take(pageSize)
			.ToListAsync();

		var items = _mapper.Map<List<ShipmentRequestDto>>(requests);

		return Ok(new PagedResult<ShipmentRequestDto>
		{
			Items = items,
			TotalCount = totalCount,
			Page = page,
			PageSize = pageSize
		});
	}

	[HttpPost]
	public async Task<IActionResult> CreateMyRequest([FromBody] CreateMyShipmentRequestDto dto)
	{
		if (!await HasPermission("create"))
			return Forbid();

		if (!ModelState.IsValid)
			return BadRequest(ModelState);

		var userId = _currentUser.UserId;
		if (userId == null) return Unauthorized();

		var customer = await _context.Customers
			.FirstOrDefaultAsync(c => c.UserId == userId.Value);

		if (customer == null) return NotFound("Customer not found");

		// Validate required fields
		if (dto.SenderAddressId == Guid.Empty)
			return BadRequest(new { message = "Sender address is required." });

		if (dto.ReceiverAddressId == Guid.Empty)
			return BadRequest(new { message = "Receiver address is required." });

		if (string.IsNullOrWhiteSpace(dto.PackageType))
			return BadRequest(new { message = "Package type is required." });

		if (dto.Weight <= 0)
			return BadRequest(new { message = "Weight must be greater than 0." });

		var request = new ShipmentRequest
		{
			Id = Guid.NewGuid(),
			RequestNumber = GenerateRequestNumber(),
			CustomerId = customer.Id,
			SenderAddressId = dto.SenderAddressId,
			ReceiverAddressId = dto.ReceiverAddressId,
			ServiceId = dto.ServiceId,
			PackageType = dto.PackageType,
			Weight = dto.Weight,
			Length = dto.Length,
			Width = dto.Width,
			Height = dto.Height,
			DeclaredValue = dto.DeclaredValue,
			InsurancePlanId = dto.InsurancePlanId,
			SpecialInstructions = dto.SpecialInstructions,
			IsFragile = dto.IsFragile ?? false,
			IsLarge = dto.IsLarge ?? false,
			Status = "pending",
			CreatedAt = DateTime.UtcNow,
			UpdatedAt = DateTime.UtcNow
		};

		_context.ShipmentRequests.Add(request);
		await _context.SaveChangesAsync();

		var result = _mapper.Map<ShipmentRequestDto>(request);
		return Ok(result);
	}

	private string GenerateRequestNumber()
	{
		return "REQ-" + DateTime.UtcNow.ToString("yyyyMMddHHmmss") + "-" +
			   Guid.NewGuid().ToString("N").Substring(0, 4).ToUpper();
	}
}