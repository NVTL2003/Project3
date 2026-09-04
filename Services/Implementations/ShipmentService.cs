using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Project3.DTOs;
using Project3.Models;
using Project3.Repositories.Interfaces;

namespace Project3.Services.Implementations;

public class ShipmentService
    : CrudService<
        Shipment,
        ShipmentDto,
        CreateShipmentDto>
{
    public ShipmentService(
        ICrudRepository<Shipment> repository,
        IMapper mapper)
        : base(repository, mapper)
    {
    }

    // ============================================================
    // OWNERSHIP
    // ============================================================

    protected override IQueryable<Shipment> ApplyOwnerFilter(
        IQueryable<Shipment> query,
        Guid userId)
    {
        return query.Where(shipment =>
            shipment.Customer.UserId == userId);
    }

    // ============================================================
    // LEGACY STATUS NORMALIZATION
    // ============================================================
    //
    // "picked_up" was previously used as Shipment.CurrentStatus.
    //
    // It is no longer a valid Shipment status.
    //
    // Pickup should produce:
    //
    //     picked_up tracking event
    //              +
    //     in_sorting shipment status
    //
    // This method automatically repairs old records when they
    // are read through ShipmentService.
    //
    // No manual SQL is required.
    // ============================================================

    private async Task NormalizeLegacyStatusAsync(
        Shipment shipment)
    {
        if (!string.Equals(
                shipment.CurrentStatus,
                "picked_up",
                StringComparison.OrdinalIgnoreCase))
        {
            return;
        }

        shipment.CurrentStatus = "in_sorting";
        shipment.UpdatedAt = DateTime.UtcNow;

        _repository.Update(shipment);

        await _repository.SaveChangesAsync();
    }

    // ============================================================
    // NORMALIZE COLLECTION
    // ============================================================

    private async Task NormalizeLegacyStatusesAsync(
        IEnumerable<Shipment> shipments)
    {
        var changed = false;

        foreach (var shipment in shipments)
        {
            if (!string.Equals(
                    shipment.CurrentStatus,
                    "picked_up",
                    StringComparison.OrdinalIgnoreCase))
            {
                continue;
            }

            shipment.CurrentStatus = "in_sorting";
            shipment.UpdatedAt = DateTime.UtcNow;

            _repository.Update(shipment);

            changed = true;
        }

        if (changed)
        {
            await _repository.SaveChangesAsync();
        }
    }

    // ============================================================
    // GET ALL
    // ============================================================

    public override async Task<IEnumerable<ShipmentDto>>
        GetAllAsync()
    {
        var entities =
            await _repository.GetAllAsync();

        await NormalizeLegacyStatusesAsync(entities);

        return _mapper.Map<IEnumerable<ShipmentDto>>(
            entities);
    }

    // ============================================================
    // GET BY ID
    // ============================================================

    public override async Task<ShipmentDto?> GetByIdAsync(Guid id)
    {
        Console.WriteLine("");
        Console.WriteLine("##################################################");
        Console.WriteLine("SHIPMENT SERVICE - GET BY ID");
        Console.WriteLine($"Requested ID: {id}");
        Console.WriteLine("##################################################");

        var entity =
            await _repository.GetByIdAsync(id);

        if (entity == null)
        {
            Console.WriteLine("SHIPMENT NOT FOUND");
            Console.WriteLine("##################################################");
            return default;
        }

        DebugShipment("BEFORE NORMALIZATION", entity);

        await NormalizeLegacyStatusAsync(entity);

        DebugShipment("AFTER NORMALIZATION", entity);

        var dto =
            _mapper.Map<ShipmentDto>(entity);

        Console.WriteLine("SHIPMENT DTO");
        Console.WriteLine($"DTO ID            : {dto.Id}");
        Console.WriteLine($"DTO Tracking      : {dto.TrackingNumber}");
        Console.WriteLine($"DTO CurrentStatus : [{dto.CurrentStatus}]");
        Console.WriteLine("##################################################");
        Console.WriteLine("");

        return dto;
    }

    // ============================================================
    // GET MINE
    // ============================================================

    public override async Task<IEnumerable<ShipmentDto>>
        GetMineAsync(Guid userId)
    {
        var query =
            ApplyOwnerFilter(
                _repository.Query(),
                userId);

        var entities =
            await query.ToListAsync();

        await NormalizeLegacyStatusesAsync(entities);

        return _mapper.Map<IEnumerable<ShipmentDto>>(
            entities);
    }

    // ============================================================
    // GET MINE BY ID
    // ============================================================

    public override async Task<ShipmentDto?>
        GetMineByIdAsync(
            Guid userId,
            Guid id)
    {
        var query =
            ApplyOwnerFilter(
                _repository.Query(),
                userId);

        var entity =
            await query.FirstOrDefaultAsync(
                shipment => shipment.Id == id);

        if (entity == null)
            return default;

        await NormalizeLegacyStatusAsync(entity);

        return _mapper.Map<ShipmentDto>(entity);
    }

    // ============================================================
    // GET MINE PAGED
    // ============================================================

    public override async Task<PagedResult<ShipmentDto>>
        GetMinePagedAsync(
            Guid userId,
            QueryParamsDto queryParams)
    {
        var query =
            ApplyOwnerFilter(
                _repository.Query(),
                userId);

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

        await NormalizeLegacyStatusesAsync(entities);

        return new PagedResult<ShipmentDto>
        {
            Items =
                _mapper.Map<List<ShipmentDto>>(
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
    // GET PAGED
    // ============================================================

    public override async Task<PagedResult<ShipmentDto>>
        GetPagedAsync(
            QueryParamsDto queryParams)
    {
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

        var filter =
            BuildFilter(queryParams);

        var orderBy =
            BuildSort(queryParams);

        var (items, totalCount) =
            await _repository.GetPagedAsync(
                filter,
                orderBy,
                page,
                pageSize);

        await NormalizeLegacyStatusesAsync(items);

        return new PagedResult<ShipmentDto>
        {
            Items =
                _mapper.Map<List<ShipmentDto>>(
                    items),

            TotalCount =
                totalCount,

            Page =
                page,

            PageSize =
                pageSize
        };
    }

    // ============================================================
    // DEBUG METHODS
    // ============================================================

    private void DebugShipment(string source, Shipment shipment)
    {
        Console.WriteLine("");
        Console.WriteLine("==================================================");
        Console.WriteLine($"SHIPMENT DEBUG [{source}]");
        Console.WriteLine("==================================================");
        Console.WriteLine($"ID            : {shipment.Id}");
        Console.WriteLine($"Tracking      : {shipment.TrackingNumber}");
        Console.WriteLine($"CurrentStatus : [{shipment.CurrentStatus}]");
        Console.WriteLine($"UpdatedAt     : {shipment.UpdatedAt}");
        Console.WriteLine("==================================================");
        Console.WriteLine("");
    }
}