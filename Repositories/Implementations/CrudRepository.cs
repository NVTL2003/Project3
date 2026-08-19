using Microsoft.EntityFrameworkCore;
using System.Linq.Expressions;
using Project3.Repositories.Interfaces;
using Project3.Models;

namespace Project3.Repositories.Implementations;

public class CrudRepository<TEntity>
    : ICrudRepository<TEntity>
    where TEntity : class
{
    protected readonly Pj3Context _context;

    protected readonly DbSet<TEntity> _dbSet;

    public CrudRepository(Pj3Context context)
    {
        _context = context;

        _dbSet =
            context.Set<TEntity>();
    }

    public IQueryable<TEntity> Query()
    {
        return _dbSet.AsQueryable();
    }

    // ============================================================
    // GET ALL
    // ============================================================

    public async Task<IEnumerable<TEntity>>
        GetAllAsync()
    {
        return await _dbSet.ToListAsync();
    }

    // ============================================================
    // GET BY ID
    // ============================================================

    public async Task<TEntity?> GetByIdAsync(
        Guid id)
    {
        return await _dbSet.FindAsync(id);
    }

    // ============================================================
    // FIRST OR DEFAULT
    // ============================================================

    public async Task<TEntity?>
        FirstOrDefaultAsync(
            Expression<Func<TEntity, bool>> predicate)
    {
        return await _dbSet
            .FirstOrDefaultAsync(predicate);
    }

    // ============================================================
    // FIND
    // ============================================================

    public async Task<IEnumerable<TEntity>>
        FindAsync(
            Expression<Func<TEntity, bool>> predicate)
    {
        return await _dbSet
            .Where(predicate)
            .ToListAsync();
    }

    // ============================================================
    // PAGED QUERY
    // ============================================================

    public async Task<(
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
        params string[] includes)
    {
        IQueryable<TEntity> query =
            _dbSet;

        // --------------------------------------------------------
        // Includes
        // --------------------------------------------------------

        foreach (var include in includes)
        {
            query =
                query.Include(include);
        }

        // --------------------------------------------------------
        // Filter
        // --------------------------------------------------------

        if (filter != null)
        {
            Console.WriteLine(
                "🔎 Repository: APPLYING FILTER"
            );

            query =
                query.Where(filter);
        }
        else
        {
            Console.WriteLine(
                "⚠️ Repository: NO FILTER"
            );
        }

        // --------------------------------------------------------
        // Total count
        // --------------------------------------------------------

        var totalCount =
            await query.CountAsync();

        Console.WriteLine(
            $"📊 FILTERED TOTAL: {totalCount}"
        );

        // --------------------------------------------------------
        // Default sorting
        // --------------------------------------------------------

        if (orderBy != null)
        {
            query =
                orderBy(query);
        }
        else
        {
            var idProperty =
                typeof(TEntity)
                    .GetProperty("Id");

            if (idProperty != null)
            {
                query =
                    query.OrderBy(
                        e =>
                            EF.Property<object>(
                                e,
                                idProperty.Name
                            )
                    );
            }
        }

        // --------------------------------------------------------
        // Pagination protection
        // --------------------------------------------------------

        page =
            page < 1
                ? 1
                : page;

        pageSize =
            pageSize < 1
                ? 10
                : Math.Min(pageSize, 100);

        // --------------------------------------------------------
        // Pagination
        // --------------------------------------------------------

        query =
            query
                .Skip(
                    (page - 1) *
                    pageSize
                )
                .Take(pageSize);

        // --------------------------------------------------------
        // Execute
        // --------------------------------------------------------

        var items =
            await query.ToListAsync();

        Console.WriteLine(
            $"Returning {items.Count} items"
        );

        return (
            items,
            totalCount
        );
    }

    // ============================================================
    // COUNT
    // ============================================================

    public async Task<int> CountAsync(
        Expression<Func<TEntity, bool>>? filter = null)
    {
        if (filter == null)
        {
            return await _dbSet.CountAsync();
        }

        return await _dbSet.CountAsync(filter);
    }

    // ============================================================
    // ADD
    // ============================================================

    public async Task AddAsync(
        TEntity entity)
    {
        await _dbSet.AddAsync(entity);
    }

    // ============================================================
    // UPDATE
    // ============================================================

    public void Update(
        TEntity entity)
    {
        _dbSet.Update(entity);
    }

    // ============================================================
    // DELETE
    // ============================================================

    public void Delete(
        TEntity entity)
    {
        _dbSet.Remove(entity);
    }

    // ============================================================
    // SAVE
    // ============================================================

    public async Task<bool>
        SaveChangesAsync()
    {
        return
            await _context.SaveChangesAsync()
            > 0;
    }
}