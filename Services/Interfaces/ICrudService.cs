using Project3.DTOs;

public interface ICrudService<TEntity, TDto, TCreateDto>
{
    Task<IEnumerable<TDto>> GetAllAsync();
    Task<TDto?> GetByIdAsync(Guid id);
    Task<TDto> CreateAsync(TCreateDto dto);
    Task<bool> UpdateAsync(Guid id, TCreateDto dto);
    Task<bool> DeleteAsync(Guid id);
    Task<PagedResult<TDto>> GetPagedAsync(QueryParamsDto queryParams);
}