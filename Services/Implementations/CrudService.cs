//Services\Implementations\CrudService.cs

//using AutoMapper;
//using AutoMapper.QueryableExtensions;
//using Microsoft.EntityFrameworkCore;
//using Project3.Repositories.Interfaces;

//public class CrudService<TEntity, TDto, TCreateDto>
//    : ICrudService<TEntity, TDto, TCreateDto>
//    where TEntity : class
//{
//    protected readonly ICrudRepository<TEntity> _repository;
//    protected readonly IMapper _mapper;

//    public CrudService(
//        ICrudRepository<TEntity> repository,
//        IMapper mapper)
//    {
//        _repository = repository;
//        _mapper = mapper;
//    }

//    public virtual async Task<IEnumerable<TDto>> GetAllAsync()
//    {
//        var entities = await _repository.GetAllAsync();

//        return _mapper.Map<IEnumerable<TDto>>(entities);
//    }

//    public virtual async Task<TDto?> GetByIdAsync(Guid id)
//    {
//        var entity = await _repository.GetByIdAsync(id);

//        if (entity == null)
//            return default;

//        return _mapper.Map<TDto>(entity);
//    }

//    public virtual async Task<TDto> CreateAsync(TCreateDto dto)
//    {
//        var entity = _mapper.Map<TEntity>(dto);

//        await _repository.AddAsync(entity);
//        await _repository.SaveChangesAsync();

//        return _mapper.Map<TDto>(entity);
//    }

//    ////

//    //public virtual async Task<TDto> CreateAsync(TCreateDto dto)
//    //{
//    //    try
//    //    {
//    //        Console.WriteLine($"Creating entity with DTO: {System.Text.Json.JsonSerializer.Serialize(dto)}");

//    //        var entity = _mapper.Map<TEntity>(dto);

//    //        Console.WriteLine($"Mapped entity: {System.Text.Json.JsonSerializer.Serialize(entity)}");

//    //        await _repository.AddAsync(entity);
//    //        await _repository.SaveChangesAsync();

//    //        return _mapper.Map<TDto>(entity);
//    //    }
//    //    catch (Exception ex)
//    //    {
//    //        Console.WriteLine($"Error in CreateAsync: {ex.Message}");
//    //        Console.WriteLine($"Stack trace: {ex.StackTrace}");
//    //        throw;
//    //    }
//    //}

//    ////


//    public virtual async Task<bool> UpdateAsync(
//        Guid id,
//        TCreateDto dto)
//    {
//        var entity = await _repository.GetByIdAsync(id);

//        if (entity == null)
//            return false;

//        _mapper.Map(dto, entity);

//        _repository.Update(entity);

//        return await _repository.SaveChangesAsync();
//    }

//    public virtual async Task<bool> DeleteAsync(Guid id)
//    {
//        var entity = await _repository.GetByIdAsync(id);

//        if (entity == null)
//            return false;

//        _repository.Delete(entity);

//        return await _repository.SaveChangesAsync();
//    }
//}

using AutoMapper;
using AutoMapper.QueryableExtensions;
using Microsoft.EntityFrameworkCore;
using Project3.Repositories.Interfaces;
using Project3.DTOs;
using System.Linq.Expressions;

public class CrudService<TEntity, TDto, TCreateDto> : ICrudService<TEntity, TDto, TCreateDto>
    where TEntity : class
{
    protected readonly ICrudRepository<TEntity> _repository;
    protected readonly IMapper _mapper;

    public CrudService(ICrudRepository<TEntity> repository, IMapper mapper)
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
        if (entity == null) return default;
        return _mapper.Map<TDto>(entity);
    }

    public virtual async Task<TDto> CreateAsync(TCreateDto dto)
    {
        var entity = _mapper.Map<TEntity>(dto);
        await _repository.AddAsync(entity);
        await _repository.SaveChangesAsync();
        return _mapper.Map<TDto>(entity);
    }

    public virtual async Task<bool> UpdateAsync(Guid id, TCreateDto dto)
    {
        var entity = await _repository.GetByIdAsync(id);
        if (entity == null) return false;
        _mapper.Map(dto, entity);
        _repository.Update(entity);
        return await _repository.SaveChangesAsync();
    }

    public virtual async Task<bool> DeleteAsync(Guid id)
    {
        var entity = await _repository.GetByIdAsync(id);
        if (entity == null) return false;
        _repository.Delete(entity);
        return await _repository.SaveChangesAsync();
    }

    // ONLY ONE GetPagedAsync method
    public virtual async Task<PagedResult<TDto>> GetPagedAsync(QueryParamsDto queryParams)
    {
        var filter = BuildFilter(queryParams);
        var orderBy = BuildSort(queryParams);

        var (items, totalCount) = await _repository.GetPagedAsync(
            filter,
            orderBy,
            queryParams.Page,
            queryParams.PageSize
        );

        return new PagedResult<TDto>
        {
            Items = _mapper.Map<List<TDto>>(items),
            TotalCount = totalCount,
            Page = queryParams.Page,
            PageSize = queryParams.PageSize
        };
    }

    protected virtual Expression<Func<TEntity, bool>>? BuildFilter(QueryParamsDto queryParams)
    {
        return null;
    }

    protected virtual Func<IQueryable<TEntity>, IOrderedQueryable<TEntity>>? BuildSort(QueryParamsDto queryParams)
    {
        if (string.IsNullOrEmpty(queryParams.SortBy))
            return null;

        // Use a simpler approach for sorting
        return query => {
            // Get the property info
            var propertyInfo = typeof(TEntity).GetProperty(queryParams.SortBy);
            if (propertyInfo == null)
            {
                // Try to find property case-insensitively
                propertyInfo = typeof(TEntity).GetProperties()
                    .FirstOrDefault(p => string.Equals(p.Name, queryParams.SortBy, StringComparison.OrdinalIgnoreCase));

                if (propertyInfo == null)
                    return (IOrderedQueryable<TEntity>)query;
            }

            var parameter = Expression.Parameter(typeof(TEntity), "x");
            var property = Expression.Property(parameter, propertyInfo);
            var lambda = Expression.Lambda(property, parameter);

            var methodName = queryParams.SortOrder?.ToLower() == "desc"
                ? "OrderByDescending"
                : "OrderBy";

            var methodCall = Expression.Call(
                typeof(Queryable),
                methodName,
                new[] { typeof(TEntity), property.Type },
                query.Expression,
                Expression.Quote(lambda)
            );

            return (IOrderedQueryable<TEntity>)query.Provider.CreateQuery<TEntity>(methodCall);
        };
    }
}