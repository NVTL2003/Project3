using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Project3.DTOs;
using Project3.Repositories.Interfaces;
using Project3.Services.Interfaces;
using System.Globalization;
using System.Linq.Expressions;

namespace Project3.Services.Implementations;

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

    // ============================================================
    // GET ALL
    // ============================================================

    public virtual async Task<IEnumerable<TDto>> GetAllAsync()
    {
        var entities =
            await _repository.GetAllAsync();

        return _mapper.Map<IEnumerable<TDto>>(
            entities
        );
    }

    // ============================================================
    // GET BY ID
    // ============================================================

    public virtual async Task<TDto?> GetByIdAsync(Guid id)
    {
        var entity =
            await _repository.GetByIdAsync(id);

        if (entity == null)
            return default;

        return _mapper.Map<TDto>(entity);
    }

    // ============================================================
    // OWNERSHIP
    // ============================================================

    protected virtual IQueryable<TEntity> ApplyOwnerFilter(
        IQueryable<TEntity> query,
        Guid userId)
    {
        // By default, no ownership filter.
        // Services that support "own" access override this.
        return query;
    }

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
        var query =
            ApplyOwnerFilter(
                _repository.Query(),
                userId);

        var entity =
            await query.FirstOrDefaultAsync(
                e => EF.Property<Guid>(e, "Id") == id);

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
        var query =
            ApplyOwnerFilter(
                _repository.Query(),
                userId);

        // Reuse your existing generic search/filter/sort logic
        var filter =
            BuildFilter(queryParams);

        if (filter != null)
            query = query.Where(filter);

        var orderBy =
            BuildSort(queryParams);

        if (orderBy != null)
            query = orderBy(query);

        var page =
            queryParams.Page < 1
                ? 1
                : queryParams.Page;

        var pageSize =
            queryParams.PageSize < 1
                ? 10
                : Math.Min(
                    queryParams.PageSize,
                    100);

        var totalCount =
            await query.CountAsync();

        var entities =
            await query
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

        return new PagedResult<TDto>
        {
            Items =
                _mapper.Map<List<TDto>>(
                    entities),

            TotalCount =
                totalCount,

            Page =
                page,

            PageSize =
                pageSize
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

        Console.WriteLine("========================================");
        Console.WriteLine("CRUD MAPPING DEBUG");
        Console.WriteLine($"DTO Type: {dto?.GetType().FullName}");
        Console.WriteLine($"Entity Type: {entity?.GetType().FullName}");
        Console.WriteLine("========================================");

        if (entity == null)
            return default;

        entity = await PrepareForCreateAsync(
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
        var query =
            ApplyOwnerFilter(
                _repository.Query(),
                userId);

        var entity =
            await query.FirstOrDefaultAsync(
                e => EF.Property<Guid>(e, "Id") == id);

        if (entity == null)
            return false;

        _mapper.Map(dto, entity);

        await PrepareForUpdateAsync(
            entity,
            userId);

        _repository.Update(entity);

        return await _repository.SaveChangesAsync();
    }

    // ============================================================
    // DELETE MINE
    // ============================================================

    public virtual async Task<bool> DeleteMineAsync(
        Guid userId,
        Guid id)
    {
        var query =
            ApplyOwnerFilter(
                _repository.Query(),
                userId);

        var entity =
            await query.FirstOrDefaultAsync(
                e => EF.Property<Guid>(e, "Id") == id);

        if (entity == null)
            return false;

        await PrepareForDeleteAsync(
            entity,
            userId);

        _repository.Delete(entity);

        return await _repository.SaveChangesAsync();
    }

    // ============================================================
    // CREATE
    // ============================================================

    public virtual async Task<TDto> CreateAsync(
        TCreateDto dto)
    {
        var entity =
            _mapper.Map<TEntity>(dto);

        await _repository.AddAsync(entity);

        await _repository.SaveChangesAsync();

        return _mapper.Map<TDto>(entity);
    }

    // ============================================================
    // UPDATE
    // ============================================================

    public virtual async Task<bool> UpdateAsync(
        Guid id,
        TCreateDto dto)
    {
        var entity =
            await _repository.GetByIdAsync(id);

        if (entity == null)
            return false;

        _mapper.Map(dto, entity);

        _repository.Update(entity);

        return await _repository.SaveChangesAsync();
    }

    // ============================================================
    // DELETE
    // ============================================================

    public virtual async Task<bool> DeleteAsync(
        Guid id)
    {
        var entity =
            await _repository.GetByIdAsync(id);

        if (entity == null)
            return false;

        _repository.Delete(entity);

        return await _repository.SaveChangesAsync();
    }

    // ============================================================
    // PAGED QUERY
    // ============================================================

    public virtual async Task<PagedResult<TDto>>
        GetPagedAsync(
            QueryParamsDto queryParams)
    {
        Console.WriteLine(
            "========================================"
        );

        Console.WriteLine(
            "📊 CrudService.GetPagedAsync"
        );

        // --------------------------------------------------------
        // Normalize pagination
        // --------------------------------------------------------

        var page =
            queryParams.Page < 1
                ? 1
                : queryParams.Page;

        var pageSize =
            queryParams.PageSize < 1
                ? 10
                : Math.Min(
                    queryParams.PageSize,
                    100
                );

        // --------------------------------------------------------
        // Normalize sort
        // --------------------------------------------------------

        var sortOrder =
            string.Equals(
                queryParams.SortOrder,
                "desc",
                StringComparison.OrdinalIgnoreCase
            )
                ? "desc"
                : "asc";

        Console.WriteLine(
            $"Search: [{queryParams.Search}]"
        );

        Console.WriteLine(
            $"SortBy: [{queryParams.SortBy}]"
        );

        Console.WriteLine(
            $"SortOrder: [{sortOrder}]"
        );

        Console.WriteLine(
            $"Page: {page}"
        );

        Console.WriteLine(
            $"PageSize: {pageSize}"
        );

        // --------------------------------------------------------
        // BUILD FILTER
        // --------------------------------------------------------

        var filter =
            BuildFilter(queryParams);

        // --------------------------------------------------------
        // BUILD SORT
        // --------------------------------------------------------

        var orderBy =
            BuildSort(queryParams);

        Console.WriteLine(
            $"Filter generated: {filter != null}"
        );

        Console.WriteLine(
            $"Sort generated: {orderBy != null}"
        );

        // --------------------------------------------------------
        // REPOSITORY
        // --------------------------------------------------------

        var (items, totalCount) =
            await _repository.GetPagedAsync(
                filter,
                orderBy,
                page,
                pageSize
            );

        Console.WriteLine(
            $"Repository returned {items.Count()} items"
        );

        Console.WriteLine(
            $"Repository totalCount = {totalCount}"
        );

        Console.WriteLine(
            "========================================"
        );

        // --------------------------------------------------------
        // RESULT
        // --------------------------------------------------------

        return new PagedResult<TDto>
        {
            Items =
                _mapper.Map<List<TDto>>(items),

            TotalCount =
                totalCount,

            Page =
                page,

            PageSize =
                pageSize
        };
    }

    // ============================================================
    // BUILD FILTER
    // ============================================================

    protected virtual Expression<Func<TEntity, bool>>?
        BuildFilter(
            QueryParamsDto queryParams)
    {
        Expression<Func<TEntity, bool>>? result =
            null;

        // --------------------------------------------------------
        // SEARCH
        // --------------------------------------------------------

        if (!string.IsNullOrWhiteSpace(
            queryParams.Search))
        {
            var search =
                queryParams.Search
                    .Trim()
                    .ToLowerInvariant();

            var searchFilter =
                BuildSearchFilter(search);

            if (searchFilter != null)
            {
                result = searchFilter;
            }
        }

        // --------------------------------------------------------
        // FILTERS
        // --------------------------------------------------------

        if (queryParams.Filters != null)
        {
            foreach (var filter in queryParams.Filters)
            {
                if (string.IsNullOrWhiteSpace(
                    filter.Value))
                {
                    continue;
                }

                var current =
                    BuildPropertyFilter(
                        filter.Key,
                        filter.Value
                    );

                if (current == null)
                    continue;

                result =
                    result == null
                        ? current
                        : CombineExpressions(
                            result,
                            current
                        );
            }
        }

        return result;
    }

    // ============================================================
    // SEARCHABLE PROPERTIES
    // ============================================================
    //
    // Derived services override this.
    //
    // Example:
    //
    // protected override string[] SearchableProperties =>
    // [
    //     "Name",
    //     "Code",
    //     "City"
    // ];
    //
    // ============================================================

    protected virtual string[] SearchableProperties =>
        Array.Empty<string>();

    // ============================================================
    // BUILD SEARCH FILTER
    // ============================================================

    protected virtual Expression<Func<TEntity, bool>>?
        BuildSearchFilter(
            string search)
    {
        if (SearchableProperties.Length == 0)
            return null;

        var parameter =
            Expression.Parameter(
                typeof(TEntity),
                "x"
            );

        Expression? combinedBody =
            null;

        foreach (var propertyName
                 in SearchableProperties)
        {
            var property =
                typeof(TEntity)
                    .GetProperty(
                        propertyName,
                        System.Reflection.BindingFlags.Public |
                        System.Reflection.BindingFlags.Instance |
                        System.Reflection.BindingFlags.IgnoreCase
                    );

            if (property == null)
                continue;

            // Only search string properties.
            if (property.PropertyType != typeof(string))
                continue;

            var propertyExpression =
                Expression.Property(
                    parameter,
                    property
                );

            // x.Property != null
            var notNull =
                Expression.NotEqual(
                    propertyExpression,
                    Expression.Constant(
                        null,
                        typeof(string)
                    )
                );

            // x.Property.ToLower()
            var toLowerMethod =
                typeof(string).GetMethod(
                    nameof(string.ToLower),
                    Type.EmptyTypes
                )!;

            var loweredProperty =
                Expression.Call(
                    propertyExpression,
                    toLowerMethod
                );

            // x.Property.ToLower().Contains(search)
            var containsMethod =
                typeof(string).GetMethod(
                    nameof(string.Contains),
                    new[] { typeof(string) }
                )!;

            var contains =
                Expression.Call(
                    loweredProperty,
                    containsMethod,
                    Expression.Constant(search)
                );

            var propertyCondition =
                Expression.AndAlso(
                    notNull,
                    contains
                );

            combinedBody =
                combinedBody == null
                    ? propertyCondition
                    : Expression.OrElse(
                        combinedBody,
                        propertyCondition
                    );
        }

        if (combinedBody == null)
            return null;

        return Expression.Lambda<Func<TEntity, bool>>(
            combinedBody,
            parameter
        );
    }

    // ============================================================
    // BUILD PROPERTY FILTER
    // ============================================================

    protected virtual Expression<Func<TEntity, bool>>?
        BuildPropertyFilter(
            string propertyName,
            string value)
    {
        var property =
            typeof(TEntity)
                .GetProperty(
                    propertyName,
                    System.Reflection.BindingFlags.Public |
                    System.Reflection.BindingFlags.Instance |
                    System.Reflection.BindingFlags.IgnoreCase
                );

        if (property == null)
        {
            Console.WriteLine(
                $"⚠️ Unknown filter property: {propertyName}"
            );

            return null;
        }

        var parameter =
            Expression.Parameter(
                typeof(TEntity),
                "x"
            );

        var propertyExpression =
            Expression.Property(
                parameter,
                property
            );

        var propertyType =
            Nullable.GetUnderlyingType(
                property.PropertyType
            )
            ?? property.PropertyType;

        // ========================================================
        // STRING
        // ========================================================

        if (propertyType == typeof(string))
        {
            var toLowerMethod =
                typeof(string).GetMethod(
                    nameof(string.ToLower),
                    Type.EmptyTypes
                )!;

            var containsMethod =
                typeof(string).GetMethod(
                    nameof(string.Contains),
                    new[] { typeof(string) }
                )!;

            var lowered =
                Expression.Call(
                    propertyExpression,
                    toLowerMethod
                );

            var contains =
                Expression.Call(
                    lowered,
                    containsMethod,
                    Expression.Constant(
                        value.Trim().ToLowerInvariant()
                    )
                );

            var body =
                Expression.AndAlso(
                    Expression.NotEqual(
                        propertyExpression,
                        Expression.Constant(
                            null,
                            property.PropertyType
                        )
                    ),
                    contains
                );

            return Expression.Lambda<Func<TEntity, bool>>(
                body,
                parameter
            );
        }

        // ========================================================
        // BOOLEAN
        // ========================================================

        if (propertyType == typeof(bool))
        {
            if (!bool.TryParse(
                value,
                out var boolValue))
            {
                if (value.Equals(
                    "1",
                    StringComparison.OrdinalIgnoreCase) ||
                    value.Equals(
                        "active",
                        StringComparison.OrdinalIgnoreCase))
                {
                    boolValue = true;
                }
                else if (
                    value.Equals(
                        "0",
                        StringComparison.OrdinalIgnoreCase) ||
                    value.Equals(
                        "inactive",
                        StringComparison.OrdinalIgnoreCase))
                {
                    boolValue = false;
                }
                else
                {
                    Console.WriteLine(
                        $"⚠️ Invalid boolean filter: {value}"
                    );

                    return null;
                }
            }

            var constant =
                Expression.Constant(
                    boolValue,
                    propertyType
                );

            Expression body =
                Expression.Equal(
                    propertyExpression,
                    constant
                );

            // Nullable<bool>
            if (Nullable.GetUnderlyingType(
                property.PropertyType) != null)
            {
                body =
                    Expression.Equal(
                        propertyExpression,
                        Expression.Convert(
                            constant,
                            property.PropertyType
                        )
                    );
            }

            return Expression.Lambda<Func<TEntity, bool>>(
                body,
                parameter
            );
        }

        // ========================================================
        // ENUM
        // ========================================================

        if (propertyType.IsEnum)
        {
            try
            {
                var enumValue =
                    Enum.Parse(
                        propertyType,
                        value,
                        ignoreCase: true
                    );

                var constant =
                    Expression.Constant(
                        enumValue,
                        propertyType
                    );

                var body =
                    Expression.Equal(
                        propertyExpression,
                        constant
                    );

                return Expression.Lambda<Func<TEntity, bool>>(
                    body,
                    parameter
                );
            }
            catch
            {
                Console.WriteLine(
                    $"⚠️ Invalid enum value '{value}' for {property.Name}"
                );

                return null;
            }
        }

        // ========================================================
        // NUMERIC / GUID / DATE / ETC.
        // ========================================================

        try
        {
            var converted =
                Convert.ChangeType(
                    value,
                    propertyType,
                    CultureInfo.InvariantCulture
                );

            var constant =
                Expression.Constant(
                    converted,
                    propertyType
                );

            var body =
                Expression.Equal(
                    propertyExpression,
                    constant
                );

            return Expression.Lambda<Func<TEntity, bool>>(
                body,
                parameter
            );
        }
        catch
        {
            Console.WriteLine(
                $"⚠️ Could not convert filter value '{value}' " +
                $"to {propertyType.Name}"
            );

            return null;
        }
    }

    // ============================================================
    // BUILD SORT
    // ============================================================

    protected virtual Func<
        IQueryable<TEntity>,
        IOrderedQueryable<TEntity>
    >? BuildSort(
        QueryParamsDto queryParams)
    {
        if (string.IsNullOrWhiteSpace(
            queryParams.SortBy))
        {
            return null;
        }

        var property =
            typeof(TEntity)
                .GetProperty(
                    queryParams.SortBy,
                    System.Reflection.BindingFlags.Public |
                    System.Reflection.BindingFlags.Instance |
                    System.Reflection.BindingFlags.IgnoreCase
                );

        if (property == null)
        {
            Console.WriteLine(
                $"⚠️ Unknown sort property: {queryParams.SortBy}"
            );

            return null;
        }

        var descending =
            string.Equals(
                queryParams.SortOrder,
                "desc",
                StringComparison.OrdinalIgnoreCase
            );

        return query =>
        {
            var parameter =
                Expression.Parameter(
                    typeof(TEntity),
                    "x"
                );

            var propertyExpression =
                Expression.Property(
                    parameter,
                    property
                );

            var lambda =
                Expression.Lambda(
                    propertyExpression,
                    parameter
                );

            var methodName =
                descending
                    ? nameof(Queryable.OrderByDescending)
                    : nameof(Queryable.OrderBy);

            var method =
                typeof(Queryable)
                    .GetMethods()
                    .First(m =>
                        m.Name == methodName &&
                        m.IsGenericMethodDefinition &&
                        m.GetParameters().Length == 2
                    );

            var genericMethod =
                method.MakeGenericMethod(
                    typeof(TEntity),
                    property.PropertyType
                );

            var ordered =
                genericMethod.Invoke(
                    null,
                    new object[]
                    {
                        query,
                        lambda
                    }
                );

            return (IOrderedQueryable<TEntity>)
                ordered!;
        };
    }

    // ============================================================
    // COMBINE EXPRESSIONS
    // ============================================================

    protected virtual Expression<Func<TEntity, bool>>
        CombineExpressions(
            Expression<Func<TEntity, bool>> first,
            Expression<Func<TEntity, bool>> second)
    {
        var parameter =
            Expression.Parameter(
                typeof(TEntity),
                "x"
            );

        var firstBody =
            new ReplaceParameterVisitor(
                first.Parameters[0],
                parameter
            ).Visit(first.Body);

        var secondBody =
            new ReplaceParameterVisitor(
                second.Parameters[0],
                parameter
            ).Visit(second.Body);

        var body =
            Expression.AndAlso(
                firstBody!,
                secondBody!
            );

        return Expression.Lambda<Func<TEntity, bool>>(
            body,
            parameter
        );
    }

    // ============================================================
    // PARAMETER REPLACEMENT
    // ============================================================

    private sealed class ReplaceParameterVisitor
        : ExpressionVisitor
    {
        private readonly ParameterExpression
            _oldParameter;

        private readonly ParameterExpression
            _newParameter;

        public ReplaceParameterVisitor(
            ParameterExpression oldParameter,
            ParameterExpression newParameter)
        {
            _oldParameter =
                oldParameter;

            _newParameter =
                newParameter;
        }

        protected override Expression VisitParameter(
            ParameterExpression node)
        {
            return node == _oldParameter
                ? _newParameter
                : base.VisitParameter(node);
        }
    }

    // ============================================================
    // OWNERSHIP / LIFECYCLE HOOKS
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