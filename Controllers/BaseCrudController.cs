//using Microsoft.AspNetCore.Mvc;
//using Project3.DTOs;


//[ApiController]
//[Route("api/[controller]")]
//public abstract class BaseCrudController<TEntity, TDto, TCreateDto> : ControllerBase
//    where TEntity : class
//{
//    protected readonly ICrudService<TEntity, TDto, TCreateDto> _service;

//    protected BaseCrudController(ICrudService<TEntity, TDto, TCreateDto> service)
//    {
//        _service = service;
//    }

//    [HttpGet]
//    public virtual async Task<IActionResult> GetAll()
//    {
//        var result = await _service.GetAllAsync();
//        return Ok(result);
//    }

//    [HttpGet("paged")]
//    public virtual async Task<IActionResult> GetPaged([FromQuery] QueryParamsDto queryParams)
//    {
//        Console.WriteLine($"=== GetPaged called ===");
//        Console.WriteLine($"Page: {queryParams.Page}, PageSize: {queryParams.PageSize}");
//        Console.WriteLine($"Search: {queryParams.Search ?? "null"}");
//        Console.WriteLine($"SortBy: {queryParams.SortBy ?? "null"}, SortOrder: {queryParams.SortOrder ?? "null"}");
//        Console.WriteLine($"Filters: {System.Text.Json.JsonSerializer.Serialize(queryParams.Filters)}");

//        var result = await _service.GetPagedAsync(queryParams);
//        return Ok(result);
//    }

//    [HttpGet("{id}")]
//    public virtual async Task<IActionResult> GetById(Guid id)
//    {
//        var result = await _service.GetByIdAsync(id);
//        if (result == null) return NotFound();
//        return Ok(result);
//    }

//    [HttpPost]
//    public virtual async Task<IActionResult> Create([FromBody] TCreateDto dto)
//    {
//        if (!ModelState.IsValid)
//            return BadRequest(ModelState);

//        var created = await _service.CreateAsync(dto);
//        return Ok(created);
//    }

//    [HttpPut("{id}")]
//    public virtual async Task<IActionResult> Update(Guid id, [FromBody] TCreateDto dto)
//    {
//        if (!ModelState.IsValid)
//            return BadRequest(ModelState);

//        var success = await _service.UpdateAsync(id, dto);
//        if (!success) return NotFound();
//        return NoContent();
//    }

//    [HttpDelete("{id}")]
//    public virtual async Task<IActionResult> Delete(Guid id)
//    {
//        var success = await _service.DeleteAsync(id);
//        if (!success) return NotFound();
//        return NoContent();
//    }
//}
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Project3.DTOs;
using Project3.Authentication;

[ApiController]
[Authorize]
[Route("api/[controller]")]
public abstract class BaseCrudController<TEntity, TDto, TCreateDto>
    : ControllerBase
    where TEntity : class
{
    protected readonly ICrudService<TEntity, TDto, TCreateDto> _service;

    private readonly IAuthorizationService _authorizationService;

    protected BaseCrudController(
        ICrudService<TEntity, TDto, TCreateDto> service,
        IAuthorizationService authorizationService)
    {
        _service = service;
        _authorizationService = authorizationService;
    }

    private string ResourceName =>
        typeof(TEntity).Name;

    // ============================================================
    // PERMISSION CHECK
    // ============================================================

    private async Task<bool> HasPermission(string action)
    {
        var permission =
            $"{ResourceName}.{action}";

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

    // ============================================================
    // GET ALL
    // ============================================================

    [HttpGet]
    public virtual async Task<IActionResult> GetAll()
    {
        if (!await HasPermission("Read"))
            return Forbid();

        var result =
            await _service.GetAllAsync();

        return Ok(result);
    }

    // ============================================================
    // GET BY ID
    // ============================================================

    [HttpGet("{id}")]
    public virtual async Task<IActionResult> GetById(Guid id)
    {
        if (!await HasPermission("Read"))
            return Forbid();

        var result =
            await _service.GetByIdAsync(id);

        if (result == null)
            return NotFound();

        return Ok(result);
    }

    // ============================================================
    // CREATE
    // ============================================================

    [HttpPost]
    public virtual async Task<IActionResult> Create(
        [FromBody] TCreateDto dto)
    {
        if (!await HasPermission("Create"))
            return Forbid();

        if (!ModelState.IsValid)
            return BadRequest(ModelState);

        var created =
            await _service.CreateAsync(dto);

        return Ok(created);
    }

    // ============================================================
    // UPDATE
    // ============================================================

    [HttpPut("{id}")]
    public virtual async Task<IActionResult> Update(
        Guid id,
        [FromBody] TCreateDto dto)
    {
        if (!await HasPermission("Update"))
            return Forbid();

        if (!ModelState.IsValid)
            return BadRequest(ModelState);

        var success =
            await _service.UpdateAsync(id, dto);

        if (!success)
            return NotFound();

        return NoContent();
    }

    // ============================================================
    // DELETE
    // ============================================================

    [HttpDelete("{id}")]
    public virtual async Task<IActionResult> Delete(Guid id)
    {
        if (!await HasPermission("Delete"))
            return Forbid();

        var success =
            await _service.DeleteAsync(id);

        if (!success)
            return NotFound();

        return NoContent();
    }
}