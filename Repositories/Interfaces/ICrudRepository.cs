using System.Linq.Expressions;

namespace Project3.Repositories.Interfaces;

public interface ICrudRepository<TEntity>
    where TEntity : class
{
    Task<IEnumerable<TEntity>> GetAllAsync();

    Task<TEntity?> GetByIdAsync(
        Guid id);

    Task<TEntity?>
        FirstOrDefaultAsync(
            Expression<Func<TEntity, bool>> predicate);

    Task<IEnumerable<TEntity>>
        FindAsync(
            Expression<Func<TEntity, bool>> predicate);

    Task<(
        IEnumerable<TEntity> Items,
        int TotalCount
    )> GetPagedAsync(
        Expression<Func<TEntity, bool>>? filter = null,
        Func<
            IQueryable<TEntity>,
            IOrderedQueryable<TEntity>
        >? orderBy = null,
        int page = 1,
        int pageSize = 10,
        params string[] includes);

    Task<int> CountAsync(
        Expression<Func<TEntity, bool>>? filter = null);

    Task AddAsync(
        TEntity entity);

    void Update(
        TEntity entity);

    void Delete(
        TEntity entity);

    Task<bool> SaveChangesAsync();
}