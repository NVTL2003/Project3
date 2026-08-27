using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Project3.DTOs;
using Project3.Repositories.Interfaces;
using Project3.Services.Interfaces;
using Project3.Models;

namespace Project3.Services.Implementations;

public class RouteService
    : CrudService<
        Project3.Models.Route,
        RouteDto,
        CreateRouteDto>,
      IRouteService
{
    private readonly Pj3Context _context;

    public RouteService(
        ICrudRepository<Project3.Models.Route> repository,
        IMapper mapper,
        Pj3Context context)
        : base(repository, mapper)
    {
        _context = context;
    }

    // ============================================================
    // GET ALL
    // ============================================================

    public override async Task<IEnumerable<RouteDto>> GetAllAsync()
    {
        var routes = await _context.Routes
            .Include(r => r.OriginFacility)
            .Include(r => r.DestinationFacility)
            .Include(r => r.RouteStops)
                .ThenInclude(rs => rs.Facility)
            .ToListAsync();

        return _mapper.Map<IEnumerable<RouteDto>>(routes);
    }

    // ============================================================
    // GET BY ID
    // ============================================================

    public override async Task<RouteDto?> GetByIdAsync(Guid id)
    {
        var route = await _context.Routes
            .Include(r => r.OriginFacility)
            .Include(r => r.DestinationFacility)
            .Include(r => r.RouteStops)
                .ThenInclude(rs => rs.Facility)
            .FirstOrDefaultAsync(r => r.Id == id);

        if (route == null)
            return null;

        return _mapper.Map<RouteDto>(route);
    }

    // ============================================================
    // CREATE
    // ============================================================

    public override async Task<RouteDto> CreateAsync(
        CreateRouteDto dto)
    {
        // --------------------------------------------------------
        // Validate origin facility
        // --------------------------------------------------------

        var originExists = await _context.Facilities
            .AnyAsync(f => f.Id == dto.OriginFacilityId);

        if (!originExists)
        {
            throw new KeyNotFoundException(
                "Origin facility not found.");
        }

        // --------------------------------------------------------
        // Validate destination facility
        // --------------------------------------------------------

        var destinationExists = await _context.Facilities
            .AnyAsync(f => f.Id == dto.DestinationFacilityId);

        if (!destinationExists)
        {
            throw new KeyNotFoundException(
                "Destination facility not found.");
        }

        // --------------------------------------------------------
        // Origin != Destination
        // --------------------------------------------------------

        if (dto.OriginFacilityId ==
            dto.DestinationFacilityId)
        {
            throw new InvalidOperationException(
                "Origin and destination facilities cannot be the same.");
        }

        // --------------------------------------------------------
        // Route code uniqueness
        // --------------------------------------------------------

        var codeExists = await _context.Routes
            .AnyAsync(r =>
                r.RouteCode == dto.RouteCode);

        if (codeExists)
        {
            throw new InvalidOperationException(
                $"Route code '{dto.RouteCode}' already exists.");
        }

        // --------------------------------------------------------
        // Create
        // --------------------------------------------------------

        var route = _mapper.Map<Project3.Models.Route>(dto);

        route.Id = Guid.NewGuid();

        route.CreatedAt = DateTime.UtcNow;
        route.UpdatedAt = DateTime.UtcNow;

        if (route.IsActive == null)
            route.IsActive = true;

        await _context.Routes.AddAsync(route);

        await _context.SaveChangesAsync();

        return _mapper.Map<RouteDto>(route);
    }

    // ============================================================
    // UPDATE
    // ============================================================

    public override async Task<bool> UpdateAsync(
        Guid id,
        CreateRouteDto dto)
    {
        var route = await _context.Routes
            .FirstOrDefaultAsync(r => r.Id == id);

        if (route == null)
            return false;

        // --------------------------------------------------------
        // Validate origin
        // --------------------------------------------------------

        var originExists = await _context.Facilities
            .AnyAsync(f => f.Id == dto.OriginFacilityId);

        if (!originExists)
        {
            throw new KeyNotFoundException(
                "Origin facility not found.");
        }

        // --------------------------------------------------------
        // Validate destination
        // --------------------------------------------------------

        var destinationExists = await _context.Facilities
            .AnyAsync(f => f.Id == dto.DestinationFacilityId);

        if (!destinationExists)
        {
            throw new KeyNotFoundException(
                "Destination facility not found.");
        }

        // --------------------------------------------------------
        // Origin != Destination
        // --------------------------------------------------------

        if (dto.OriginFacilityId ==
            dto.DestinationFacilityId)
        {
            throw new InvalidOperationException(
                "Origin and destination facilities cannot be the same.");
        }

        // --------------------------------------------------------
        // Route code uniqueness
        // --------------------------------------------------------

        var codeExists = await _context.Routes
            .AnyAsync(r =>
                r.RouteCode == dto.RouteCode &&
                r.Id != id);

        if (codeExists)
        {
            throw new InvalidOperationException(
                $"Route code '{dto.RouteCode}' already exists.");
        }

        // --------------------------------------------------------
        // Update
        // --------------------------------------------------------

        _mapper.Map(dto, route);

        route.UpdatedAt = DateTime.UtcNow;

        _context.Routes.Update(route);

        return await _context.SaveChangesAsync() > 0;
    }
}