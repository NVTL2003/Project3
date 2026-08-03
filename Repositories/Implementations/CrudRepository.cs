//Repositories\Implementations\CrudRepository.cs

using Microsoft.EntityFrameworkCore;
using System.Linq.Expressions;
using Project3.Repositories.Interfaces;
using Project3.Models;

namespace Project3.Repositories.Implementations;

public class CrudRepository<TEntity> : ICrudRepository<TEntity>
    where TEntity : class
{
    protected readonly Pj3Context _context;
    protected readonly DbSet<TEntity> _dbSet;

    public CrudRepository(Pj3Context context)
    {
        _context = context;
        _dbSet = context.Set<TEntity>();
    }

    public async Task<IEnumerable<TEntity>> GetAllAsync()
    {
        return await _dbSet.ToListAsync();
    }
    public async Task<TEntity?> GetByIdAsync(Guid id)
    {
        return await _dbSet.FindAsync(id);
    }

    public async Task<TEntity?> FirstOrDefaultAsync(
        Expression<Func<TEntity, bool>> predicate)
    {
        return await _dbSet.FirstOrDefaultAsync(predicate);
    }

    public async Task AddAsync(TEntity entity)
    {
        await _dbSet.AddAsync(entity);
    }

    public void Update(TEntity entity)
    {
        _dbSet.Update(entity);
    }

    public void Delete(TEntity entity)
    {
        _dbSet.Remove(entity);
    }

    public async Task<bool> SaveChangesAsync()
    {
        return await _context.SaveChangesAsync() > 0;
    }
}