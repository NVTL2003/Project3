//Repositories\Implementations\CrudRepository.cs

//using Microsoft.EntityFrameworkCore;
//using System.Linq.Expressions;
//using Project3.Repositories.Interfaces;
//using Project3.Models;

//namespace Project3.Repositories.Implementations;

//public class CrudRepository<TEntity> : ICrudRepository<TEntity>
//    where TEntity : class
//{
//    protected readonly Pj3Context _context;
//    protected readonly DbSet<TEntity> _dbSet;

//    public CrudRepository(Pj3Context context)
//    {
//        _context = context;
//        _dbSet = context.Set<TEntity>();
//    }

//    public async Task<IEnumerable<TEntity>> GetAllAsync()
//    {
//        return await _dbSet.ToListAsync();
//    }
//    public async Task<TEntity?> GetByIdAsync(Guid id)
//    {
//        return await _dbSet.FindAsync(id);
//    }

//    public async Task<TEntity?> FirstOrDefaultAsync(
//        Expression<Func<TEntity, bool>> predicate)
//    {
//        return await _dbSet.FirstOrDefaultAsync(predicate);
//    }

//    public async Task AddAsync(TEntity entity)
//    {
//        await _dbSet.AddAsync(entity);
//    }

//    public void Update(TEntity entity)
//    {
//        _dbSet.Update(entity);
//    }

//    public void Delete(TEntity entity)
//    {
//        _dbSet.Remove(entity);
//    }

//    public async Task<bool> SaveChangesAsync()
//    {
//        return await _context.SaveChangesAsync() > 0;
//    }
//}

using Microsoft.EntityFrameworkCore;
using System.Linq.Expressions;
using Project3.Repositories.Interfaces;
using Project3.Models;

namespace Project3.Repositories.Implementations;

public class CrudRepository<TEntity> : ICrudRepository<TEntity> where TEntity : class
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

    public async Task<TEntity?> FirstOrDefaultAsync(Expression<Func<TEntity, bool>> predicate)
    {
        return await _dbSet.FirstOrDefaultAsync(predicate);
    }

    public async Task<IEnumerable<TEntity>> FindAsync(Expression<Func<TEntity, bool>> predicate)
    {
        return await _dbSet.Where(predicate).ToListAsync();
    }

    public async Task<(IEnumerable<TEntity> Items, int TotalCount)> GetPagedAsync(
        Expression<Func<TEntity, bool>>? filter = null,
        Func<IQueryable<TEntity>, IOrderedQueryable<TEntity>>? orderBy = null,
        int page = 1,
        int pageSize = 10,
        params string[] includes)
    {
        IQueryable<TEntity> query = _dbSet;

        // Apply includes
        foreach (var include in includes)
        {
            query = query.Include(include);
        }

        // Apply filter - THIS IS THE KEY PART
        if (filter != null)
        {
            query = query.Where(filter);
            Console.WriteLine($"Filter applied to query");
        }

        // Get total count BEFORE pagination
        var totalCount = await query.CountAsync();
        Console.WriteLine($"Total count: {totalCount}");

        // Apply ordering
        if (orderBy != null)
        {
            query = orderBy(query);
        }
        else
        {
            // Default ordering by Id
            var entityType = typeof(TEntity);
            var idProperty = entityType.GetProperty("Id") ?? entityType.GetProperties().FirstOrDefault();
            if (idProperty != null)
            {
                query = query.OrderBy(e => EF.Property<object>(e, idProperty.Name));
            }
        }

        // Apply pagination
        query = query.Skip((page - 1) * pageSize).Take(pageSize);

        var items = await query.ToListAsync();
        Console.WriteLine($"Returning {items.Count} items");

        return (items, totalCount);
    }

    public async Task<int> CountAsync(Expression<Func<TEntity, bool>>? filter = null)
    {
        if (filter == null)
            return await _dbSet.CountAsync();
        return await _dbSet.CountAsync(filter);
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