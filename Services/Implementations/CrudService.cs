//Services\Implementations\CrudService.cs

using AutoMapper;
using AutoMapper.QueryableExtensions;
using Microsoft.EntityFrameworkCore;
using Project3.Repositories.Interfaces;

public class CrudService<TEntity, TDto, TCreateDto>
    : ICrudService<TEntity, TDto, TCreateDto>
    where TEntity : class
{
    protected readonly ICrudRepository<TEntity> _repository;
    protected readonly IMapper _mapper;

    public CrudService(
        ICrudRepository<TEntity> repository,
        IMapper mapper)
    {
        _repository = repository;
        _mapper = mapper;
    }

    public virtual async Task<IEnumerable<TDto>> GetAllAsync()
    {
        var entities = await _repository.GetAllAsync();

        return _mapper.Map<IEnumerable<TDto>>(entities);
    }

    public virtual async Task<TDto?> GetByIdAsync(Guid id)
    {
        var entity = await _repository.GetByIdAsync(id);

        if (entity == null)
            return default;

        return _mapper.Map<TDto>(entity);
    }

    public virtual async Task<TDto> CreateAsync(TCreateDto dto)
    {
        var entity = _mapper.Map<TEntity>(dto);

        await _repository.AddAsync(entity);
        await _repository.SaveChangesAsync();

        return _mapper.Map<TDto>(entity);
    }

    public virtual async Task<bool> UpdateAsync(
        Guid id,
        TCreateDto dto)
    {
        var entity = await _repository.GetByIdAsync(id);

        if (entity == null)
            return false;

        _mapper.Map(dto, entity);

        _repository.Update(entity);

        return await _repository.SaveChangesAsync();
    }

    public virtual async Task<bool> DeleteAsync(Guid id)
    {
        var entity = await _repository.GetByIdAsync(id);

        if (entity == null)
            return false;

        _repository.Delete(entity);

        return await _repository.SaveChangesAsync();
    }
}