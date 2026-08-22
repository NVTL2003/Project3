using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Project3.Authentication;
using Project3.DTOs;
using Project3.Services.Interfaces;

[ApiController]
[Authorize]
[Route("api/[controller]")]
public abstract class BaseCrudController<TEntity, TDto, TCreateDto>
    : ControllerBase
    where TEntity : class
{
    protected readonly ICrudService<TEntity, TDto, TCreateDto> _service;

    private readonly IAuthorizationService _authorizationService;
    private readonly ICurrentUserService _currentUser;

    protected BaseCrudController(
        ICrudService<TEntity, TDto, TCreateDto> service,
        IAuthorizationService authorizationService,
        ICurrentUserService currentUser)
    {
        _service = service;
        _authorizationService = authorizationService;
        _currentUser = currentUser;
    }

    protected virtual string ResourceName =>
        typeof(TEntity).Name.ToLowerInvariant();

    // ============================================================
    // PERMISSION
    // ============================================================

    protected async Task<bool> HasPermission(
        string action,
        string scope)
    {
        var permission =
            Permission.Build(
                ResourceName,
                action,
                scope);

        Console.WriteLine("========================================");
        Console.WriteLine("🔐 PERMISSION CHECK");
        Console.WriteLine($"Resource: {ResourceName}");
        Console.WriteLine($"Action: {action}");
        Console.WriteLine($"Scope: {scope}");
        Console.WriteLine($"Permission: {permission}");
        Console.WriteLine($"User: {User.Identity?.Name}");

        var result =
            await _authorizationService.AuthorizeAsync(
                User,
                resource: null,
                requirements: new[]
                {
                    new PermissionRequirement(permission)
                });

        Console.WriteLine(
            $"Permission result: {result.Succeeded}");

        Console.WriteLine("========================================");

        return result.Succeeded;
    }

    // ============================================================
    // CURRENT USER
    // ============================================================

    protected bool TryGetCurrentUserId(out Guid userId)
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
    // ALL - GET
    // ============================================================

    [HttpGet]
    public virtual async Task<IActionResult> GetAll()
    {
        if (!await HasPermission(
            PermissionActions.Read,
            PermissionScopes.All))
        {
            return Forbid();
        }

        var result =
            await _service.GetAllAsync();

        return Ok(result);
    }

    // ============================================================
    // ALL - GET PAGED
    // ============================================================

    [HttpGet("paged")]
    public virtual async Task<IActionResult> GetPaged(
        [FromQuery] QueryParamsDto queryParams)
    {
        if (!await HasPermission(
            PermissionActions.Read,
            PermissionScopes.All))
        {
            return Forbid();
        }

        var result =
            await _service.GetPagedAsync(queryParams);

        return Ok(result);
    }

    // ============================================================
    // ALL - GET BY ID
    // ============================================================

    [HttpGet("{id:guid}")]
    public virtual async Task<IActionResult> GetById(
        Guid id)
    {
        if (!await HasPermission(
            PermissionActions.Read,
            PermissionScopes.All))
        {
            return Forbid();
        }

        var result =
            await _service.GetByIdAsync(id);

        if (result == null)
            return NotFound();

        return Ok(result);
    }

    // ============================================================
    // ALL - CREATE
    // ============================================================

    [HttpPost]
    public virtual async Task<IActionResult> Create(
        [FromBody] TCreateDto dto)
    {
        if (!await HasPermission(
            PermissionActions.Create,
            PermissionScopes.All))
        {
            return Forbid();
        }

        if (!ModelState.IsValid)
            return BadRequest(ModelState);

        var created =
            await _service.CreateAsync(dto);

        return Ok(created);
    }

    // ============================================================
    // ALL - UPDATE
    // ============================================================

    [HttpPut("{id:guid}")]
    public virtual async Task<IActionResult> Update(
        Guid id,
        [FromBody] TCreateDto dto)
    {
        if (!await HasPermission(
            PermissionActions.Update,
            PermissionScopes.All))
        {
            return Forbid();
        }

        if (!ModelState.IsValid)
            return BadRequest(ModelState);

        var success =
            await _service.UpdateAsync(id, dto);

        if (!success)
            return NotFound();

        return NoContent();
    }

    // ============================================================
    // ALL - DELETE
    // ============================================================

    [HttpDelete("{id:guid}")]
    public virtual async Task<IActionResult> Delete(
        Guid id)
    {
        if (!await HasPermission(
            PermissionActions.Delete,
            PermissionScopes.All))
        {
            return Forbid();
        }

        var success =
            await _service.DeleteAsync(id);

        if (!success)
            return NotFound();

        return NoContent();
    }

    // ============================================================
    // OWN - GET
    // ============================================================

    [HttpGet("me")]
    public virtual async Task<IActionResult> GetMine()
    {
        if (!await HasPermission(
            PermissionActions.Read,
            PermissionScopes.Own))
        {
            return Forbid();
        }

        if (!TryGetCurrentUserId(out var userId))
            return Unauthorized();

        var result =
            await _service.GetMineAsync(userId);

        return Ok(result);
    }

    // ============================================================
    // OWN - GET PAGED
    // ============================================================

    [HttpGet("me/paged")]
    public virtual async Task<IActionResult> GetMinePaged(
        [FromQuery] QueryParamsDto queryParams)
    {
        if (!await HasPermission(
            PermissionActions.Read,
            PermissionScopes.Own))
        {
            return Forbid();
        }

        if (!TryGetCurrentUserId(out var userId))
            return Unauthorized();

        var result =
            await _service.GetMinePagedAsync(
                userId,
                queryParams);

        return Ok(result);
    }

    // ============================================================
    // OWN - GET BY ID
    // ============================================================

    [HttpGet("me/{id:guid}")]
    public virtual async Task<IActionResult> GetMineById(
        Guid id)
    {
        if (!await HasPermission(
            PermissionActions.Read,
            PermissionScopes.Own))
        {
            return Forbid();
        }

        if (!TryGetCurrentUserId(out var userId))
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
    // OWN - CREATE
    // ============================================================

    [HttpPost("me")]
    public virtual async Task<IActionResult> CreateMine(
        [FromBody] TCreateDto dto)
    {
        if (!await HasPermission(
            PermissionActions.Create,
            PermissionScopes.Own))
        {
            return Forbid();
        }

        if (!TryGetCurrentUserId(out var userId))
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
    // OWN - UPDATE
    // ============================================================

    [HttpPut("me/{id:guid}")]
    public virtual async Task<IActionResult> UpdateMine(
        Guid id,
        [FromBody] TCreateDto dto)
    {
        if (!await HasPermission(
            PermissionActions.Update,
            PermissionScopes.Own))
        {
            return Forbid();
        }

        if (!TryGetCurrentUserId(out var userId))
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
    // OWN - DELETE
    // ============================================================

    [HttpDelete("me/{id:guid}")]
    public virtual async Task<IActionResult> DeleteMine(
        Guid id)
    {
        if (!await HasPermission(
            PermissionActions.Delete,
            PermissionScopes.Own))
        {
            return Forbid();
        }

        if (!TryGetCurrentUserId(out var userId))
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