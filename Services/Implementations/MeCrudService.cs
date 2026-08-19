using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Project3.DTOs;
using Project3.Repositories.Interfaces;
using Project3.Services.Interfaces;

namespace Project3.Services.Implementations;

public abstract class MeCrudService<TEntity, TDto, TCreateDto>
    : IMeCrudService<TEntity, TDto, TCreateDto>
    where TEntity : class
{
    protected readonly ICrudRepository<TEntity> _repository;
    protected readonly IMapper _mapper;

    protected MeCrudService(
        ICrudRepository<TEntity> repository,
        IMapper mapper)
    {
        _repository = repository;
        _mapper = mapper;
    }

    // ============================================================
    // OWNERSHIP
    // ============================================================

    protected abstract IQueryable<TEntity> ApplyOwnerFilter(
        IQueryable<TEntity> query,
        Guid userId);

    // ============================================================
    // GET MINE
    // ============================================================

    public virtual async Task<IEnumerable<TDto>> GetMineAsync(
        Guid userId)
    {
        var query = ApplyOwnerFilter(
            _repository.Query(),
            userId);

        var entities = await query.ToListAsync();

        return _mapper.Map<IEnumerable<TDto>>(entities);
    }

    // ============================================================
    // GET MINE BY ID
    // ============================================================

    public virtual async Task<TDto?> GetMineByIdAsync(
        Guid userId,
        Guid id)
    {
        var query = ApplyOwnerFilter(
            _repository.Query(),
            userId);

        var entity = await query
            .FirstOrDefaultAsync(e =>
                EF.Property<Guid>(e, "Id") == id);

        if (entity == null)
            return default;

        return _mapper.Map<TDto>(entity);
    }

    // ============================================================
    // GET MINE PAGED
    // ============================================================

    public virtual async Task<PagedResult<TDto>> GetMinePagedAsync(
        Guid userId,
        QueryParamsDto queryParams)
    {
        var query = ApplyOwnerFilter(
            _repository.Query(),
            userId);

        var totalCount = await query.CountAsync();

        var page =
            queryParams.Page <= 0
                ? 1
                : queryParams.Page;

        var pageSize =
            queryParams.PageSize <= 0
                ? 10
                : queryParams.PageSize;

        var entities = await query
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();

        var items =
            _mapper.Map<List<TDto>>(entities);

        return new PagedResult<TDto>
        {
            Items = items,
            TotalCount = totalCount,
            Page = page,
            PageSize = pageSize
        };
    }

    // ============================================================
    // CREATE MINE
    // ============================================================

    public virtual async Task<TDto?> CreateMineAsync(
        Guid userId,
        TCreateDto dto)
    {
        var entity = _mapper.Map<TEntity>(dto);

        if (entity == null)
            return default;

        entity =
            await PrepareForCreateAsync(
                entity,
                userId);

        await _repository.AddAsync(entity);

        await _repository.SaveChangesAsync();

        return _mapper.Map<TDto>(entity);
    }

    // ============================================================
    // UPDATE MINE
    // ============================================================

    public virtual async Task<bool> UpdateMineAsync(
        Guid userId,
        Guid id,
        TCreateDto dto)
    {
        var query = ApplyOwnerFilter(
            _repository.Query(),
            userId);

        var entity = await query
            .FirstOrDefaultAsync(e =>
                EF.Property<Guid>(e, "Id") == id);

        if (entity == null)
            return false;

        _mapper.Map(dto, entity);

        await PrepareForUpdateAsync(
            entity,
            userId);

        _repository.Update(entity);

        await _repository.SaveChangesAsync();

        return true;
    }

    // ============================================================
    // DELETE MINE
    // ============================================================

    public virtual async Task<bool> DeleteMineAsync(
        Guid userId,
        Guid id)
    {
        var query = ApplyOwnerFilter(
            _repository.Query(),
            userId);

        var entity = await query
            .FirstOrDefaultAsync(e =>
                EF.Property<Guid>(e, "Id") == id);

        if (entity == null)
            return false;

        await PrepareForDeleteAsync(
            entity,
            userId);

        _repository.Delete(entity);

        await _repository.SaveChangesAsync();

        return true;
    }

    // ============================================================
    // HOOKS
    // ============================================================

    protected virtual Task<TEntity> PrepareForCreateAsync(
        TEntity entity,
        Guid userId)
    {
        return Task.FromResult(entity);
    }

    protected virtual Task PrepareForUpdateAsync(
        TEntity entity,
        Guid userId)
    {
        return Task.CompletedTask;
    }

    protected virtual Task PrepareForDeleteAsync(
        TEntity entity,
        Guid userId)
    {
        return Task.CompletedTask;
    }
}