using Project3.DTOs;

public interface ICrudService<TEntity, TDto, TCreateDto>
    where TEntity : class
{
    // ============================================================
    // ALL
    // ============================================================

    Task<IEnumerable<TDto>> GetAllAsync();

    Task<TDto?> GetByIdAsync(
        Guid id);

    Task<TDto> CreateAsync(
        TCreateDto dto);

    Task<bool> UpdateAsync(
        Guid id,
        TCreateDto dto);

    Task<bool> DeleteAsync(
        Guid id);

    Task<PagedResult<TDto>> GetPagedAsync(
        QueryParamsDto queryParams);

    // ============================================================
    // OWN
    // ============================================================

    Task<IEnumerable<TDto>> GetMineAsync(
        Guid userId);

    Task<TDto?> GetMineByIdAsync(
        Guid userId,
        Guid id);

    Task<PagedResult<TDto>> GetMinePagedAsync(
        Guid userId,
        QueryParamsDto queryParams);

    Task<TDto?> CreateMineAsync(
        Guid userId,
        TCreateDto dto);

    Task<bool> UpdateMineAsync(
        Guid userId,
        Guid id,
        TCreateDto dto);

    Task<bool> DeleteMineAsync(
        Guid userId,
        Guid id);
}