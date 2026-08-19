using Project3.DTOs;

public interface IMeCrudService<TEntity, TDto, TCreateDto>
	where TEntity : class
{
	Task<IEnumerable<TDto>> GetMineAsync(Guid userId);

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