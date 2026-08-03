//Repositories\Interfaces\ICrudRepository.cs

using System.Linq.Expressions;

namespace Project3.Repositories.Interfaces;

public interface ICrudRepository<TEntity>
    where TEntity : class
{
    Task<IEnumerable<TEntity>> GetAllAsync();

    Task<TEntity?> GetByIdAsync(Guid id);

    Task<TEntity?> FirstOrDefaultAsync(
        Expression<Func<TEntity, bool>> predicate);

    Task AddAsync(TEntity entity);

    void Update(TEntity entity);

    void Delete(TEntity entity);

    Task<bool> SaveChangesAsync();
}