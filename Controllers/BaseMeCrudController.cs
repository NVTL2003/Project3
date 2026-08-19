using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Project3.Authentication;
using Project3.DTOs;
using Project3.Services.Interfaces;

[ApiController]
[Authorize]
public abstract class BaseMeCrudController<TEntity, TDto, TCreateDto>
	: ControllerBase
	where TEntity : class
{
	protected readonly IMeCrudService<
		TEntity,
		TDto,
		TCreateDto> _service;

	protected readonly IAuthorizationService
		_authorizationService;

	protected readonly ICurrentUserService
		_currentUser;

	protected BaseMeCrudController(
		IMeCrudService<TEntity, TDto, TCreateDto> service,
		IAuthorizationService authorizationService,
		ICurrentUserService currentUser)
	{
		_service = service;
		_authorizationService = authorizationService;
		_currentUser = currentUser;
	}

	protected virtual string ResourceName =>
		typeof(TEntity).Name
			.ToLowerInvariant();

	protected async Task<bool> HasPermission(
		string action)
	{
		var permission =
			$"{ResourceName}.{action.ToLowerInvariant()}";

		var result =
			await _authorizationService.AuthorizeAsync(
				User,
				resource: null,
				requirements: new[]
				{
					new PermissionRequirement(permission)
				});

		return result.Succeeded;
	}

	protected bool TryGetUserId(
		out Guid userId)
	{
		if (_currentUser.UserId is Guid id)
		{
			userId = id;
			return true;
		}

		userId = Guid.Empty;
		return false;
	}

	// ============================================================
	// GET MINE
	// ============================================================

	[HttpGet]
	public virtual async Task<IActionResult> GetMine()
	{
		if (!await HasPermission("read"))
			return Forbid();

		if (!TryGetUserId(out var userId))
			return Unauthorized();

		var result =
			await _service.GetMineAsync(userId);

		return Ok(result);
	}

	// ============================================================
	// GET MINE PAGED
	// ============================================================

	[HttpGet("paged")]
	public virtual async Task<IActionResult> GetMinePaged(
		[FromQuery] QueryParamsDto queryParams)
	{
		if (!await HasPermission("read"))
			return Forbid();

		if (!TryGetUserId(out var userId))
			return Unauthorized();

		var result =
			await _service.GetMinePagedAsync(
				userId,
				queryParams);

		return Ok(result);
	}

	// ============================================================
	// GET MINE BY ID
	// ============================================================

	[HttpGet("{id:guid}")]
	public virtual async Task<IActionResult> GetMineById(
		Guid id)
	{
		if (!await HasPermission("read"))
			return Forbid();

		if (!TryGetUserId(out var userId))
			return Unauthorized();

		var result =
			await _service.GetMineByIdAsync(
				userId,
				id);

		if (result == null)
			return NotFound();

		return Ok(result);
	}

	// ============================================================
	// CREATE MINE
	// ============================================================

	[HttpPost]
	public virtual async Task<IActionResult> CreateMine(
		[FromBody] TCreateDto dto)
	{
		if (!await HasPermission("create"))
			return Forbid();

		if (!TryGetUserId(out var userId))
			return Unauthorized();

		if (!ModelState.IsValid)
			return BadRequest(ModelState);

		var result =
			await _service.CreateMineAsync(
				userId,
				dto);

		return Ok(result);
	}

	// ============================================================
	// UPDATE MINE
	// ============================================================

	[HttpPut("{id:guid}")]
	public virtual async Task<IActionResult> UpdateMine(
		Guid id,
		[FromBody] TCreateDto dto)
	{
		if (!await HasPermission("update"))
			return Forbid();

		if (!TryGetUserId(out var userId))
			return Unauthorized();

		if (!ModelState.IsValid)
			return BadRequest(ModelState);

		var success =
			await _service.UpdateMineAsync(
				userId,
				id,
				dto);

		if (!success)
			return NotFound();

		return NoContent();
	}

	// ============================================================
	// DELETE MINE
	// ============================================================

	[HttpDelete("{id:guid}")]
	public virtual async Task<IActionResult> DeleteMine(
		Guid id)
	{
		if (!await HasPermission("delete"))
			return Forbid();

		if (!TryGetUserId(out var userId))
			return Unauthorized();

		var success =
			await _service.DeleteMineAsync(
				userId,
				id);

		if (!success)
			return NotFound();

		return NoContent();
	}
}