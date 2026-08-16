using AutoMapper;
using Project3.Common;
using Project3.DTOs;
using Project3.Repositories.Interfaces;
using System.Linq.Expressions;

namespace Project3.Services.Implementations;

public class SoftDeleteCrudService<TEntity, TDto, TCreateDto>
    : CrudService<TEntity, TDto, TCreateDto>
    where TEntity : class, ISoftDeletable
{
    public SoftDeleteCrudService(
        ICrudRepository<TEntity> repository,
        IMapper mapper)
        : base(repository, mapper)
    {
    }

    // ============================================================
    // DEFAULT FILTER
    // ============================================================

    protected override Expression<Func<TEntity, bool>>? BuildFilter(
        QueryParamsDto queryParams)
    {
        var baseFilter =
            base.BuildFilter(queryParams);

        Expression<Func<TEntity, bool>> activeFilter =
            entity => entity.IsActive == true;

        if (baseFilter == null)
            return activeFilter;

        return CombineExpressions(
            activeFilter,
            baseFilter);
    }

    // ============================================================
    // SOFT DELETE
    // ============================================================

    public override async Task<bool> DeleteAsync(Guid id)
    {
        var entity =
            await _repository.GetByIdAsync(id);

        if (entity == null)
            return false;

        entity.IsActive = false;

        _repository.Update(entity);

        return await _repository.SaveChangesAsync();
    }
}