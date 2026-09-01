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

    protected override string[] SearchableProperties =>
    [
        "RouteCode",
        "Name"
    ];

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
            .AsNoTracking()
            .Include(r => r.OriginFacility)
            .Include(r => r.DestinationFacility)
            .Include(r => r.RouteStops)
                .ThenInclude(rs => rs.Facility)
            .OrderBy(r => r.RouteCode)
            .ToListAsync();

        return _mapper.Map<IEnumerable<RouteDto>>(routes);
    }

    // ============================================================
    // GET BY ID
    // ============================================================

    public override async Task<RouteDto?> GetByIdAsync(Guid id)
    {
        var route = await _context.Routes
            .AsNoTracking()
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
        var routeCode = dto.RouteCode.Trim();
        var routeName = dto.Name.Trim();

        if (string.IsNullOrWhiteSpace(routeCode))
            throw new InvalidOperationException(
                "Route code is required.");

        if (string.IsNullOrWhiteSpace(routeName))
            throw new InvalidOperationException(
                "Route name is required.");

        if (dto.Distance <= 0)
            throw new InvalidOperationException(
                "Route distance must be greater than zero.");

        if (dto.EstimatedDuration.HasValue &&
            dto.EstimatedDuration.Value <= 0)
        {
            throw new InvalidOperationException(
                "Estimated duration must be greater than zero.");
        }

        // --------------------------------------------------------
        // Origin
        // --------------------------------------------------------

        var origin = await _context.Facilities
            .FirstOrDefaultAsync(f =>
                f.Id == dto.OriginFacilityId);

        if (origin == null)
            throw new KeyNotFoundException(
                "Origin facility not found.");

        if (origin.IsActive != true)
            throw new InvalidOperationException(
                "Origin facility is inactive.");

        // --------------------------------------------------------
        // Destination
        // --------------------------------------------------------

        var destination = await _context.Facilities
            .FirstOrDefaultAsync(f =>
                f.Id == dto.DestinationFacilityId);

        if (destination == null)
            throw new KeyNotFoundException(
                "Destination facility not found.");

        if (destination.IsActive != true)
            throw new InvalidOperationException(
                "Destination facility is inactive.");

        // --------------------------------------------------------
        // Origin != Destination
        // --------------------------------------------------------

        if (dto.OriginFacilityId ==
            dto.DestinationFacilityId)
        {
            throw new InvalidOperationException(
                "Origin and destination cannot be the same facility.");
        }

        // --------------------------------------------------------
        // Route code uniqueness
        // --------------------------------------------------------

        var codeExists = await _context.Routes
            .AnyAsync(r =>
                r.RouteCode == routeCode);

        if (codeExists)
        {
            throw new InvalidOperationException(
                $"Route code '{routeCode}' already exists.");
        }

        // --------------------------------------------------------
        // Create
        // --------------------------------------------------------

        var now = DateTime.UtcNow;

        var route =
            _mapper.Map<Project3.Models.Route>(dto);

        route.Id = Guid.NewGuid();

        route.RouteCode = routeCode;
        route.Name = routeName;

        route.IsActive = dto.IsActive ?? true;

        route.CreatedAt = now;
        route.UpdatedAt = now;

        await _context.Routes.AddAsync(route);

        await _context.SaveChangesAsync();

        return await GetByIdAsync(route.Id)
            ?? throw new InvalidOperationException(
                "Route could not be loaded after creation.");
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

        var routeCode = dto.RouteCode.Trim();
        var routeName = dto.Name.Trim();

        if (string.IsNullOrWhiteSpace(routeCode))
            throw new InvalidOperationException(
                "Route code is required.");

        if (string.IsNullOrWhiteSpace(routeName))
            throw new InvalidOperationException(
                "Route name is required.");

        if (dto.Distance <= 0)
            throw new InvalidOperationException(
                "Route distance must be greater than zero.");

        if (dto.EstimatedDuration.HasValue &&
            dto.EstimatedDuration.Value <= 0)
        {
            throw new InvalidOperationException(
                "Estimated duration must be greater than zero.");
        }

        // --------------------------------------------------------
        // Validate origin
        // --------------------------------------------------------

        var origin = await _context.Facilities
            .FirstOrDefaultAsync(f =>
                f.Id == dto.OriginFacilityId);

        if (origin == null)
            throw new KeyNotFoundException(
                "Origin facility not found.");

        if (origin.IsActive != true)
            throw new InvalidOperationException(
                "Origin facility is inactive.");

        // --------------------------------------------------------
        // Validate destination
        // --------------------------------------------------------

        var destination = await _context.Facilities
            .FirstOrDefaultAsync(f =>
                f.Id == dto.DestinationFacilityId);

        if (destination == null)
            throw new KeyNotFoundException(
                "Destination facility not found.");

        if (destination.IsActive != true)
            throw new InvalidOperationException(
                "Destination facility is inactive.");

        // --------------------------------------------------------
        // Origin != Destination
        // --------------------------------------------------------

        if (dto.OriginFacilityId ==
            dto.DestinationFacilityId)
        {
            throw new InvalidOperationException(
                "Origin and destination cannot be the same facility.");
        }

        // --------------------------------------------------------
        // Route code uniqueness
        // --------------------------------------------------------

        var codeExists = await _context.Routes
            .AnyAsync(r =>
                r.RouteCode == routeCode &&
                r.Id != id);

        if (codeExists)
        {
            throw new InvalidOperationException(
                $"Route code '{routeCode}' already exists.");
        }

        // --------------------------------------------------------
        // Protect operational routes
        // --------------------------------------------------------

        var hasManifest = await _context.ShipmentManifests
            .AnyAsync(m =>
                m.RouteId == route.Id);

        if (hasManifest &&
            (route.OriginFacilityId != dto.OriginFacilityId ||
             route.DestinationFacilityId != dto.DestinationFacilityId))
        {
            throw new InvalidOperationException(
                "Origin or destination cannot be changed because this route has already been used by shipment manifests.");
        }

        // --------------------------------------------------------
        // Update
        // --------------------------------------------------------

        route.RouteCode = routeCode;
        route.Name = routeName;
        route.OriginFacilityId = dto.OriginFacilityId;
        route.DestinationFacilityId = dto.DestinationFacilityId;
        route.Distance = dto.Distance;
        route.EstimatedDuration = dto.EstimatedDuration;

        if (dto.IsActive.HasValue)
            route.IsActive = dto.IsActive;

        route.UpdatedAt = DateTime.UtcNow;

        return await _context.SaveChangesAsync() > 0;
    }

    // ============================================================
    // ACTIVATE / DEACTIVATE (Single method pair)
    // ============================================================

    public async Task<bool> ActivateAsync(Guid routeId)
    {
        var route = await _context.Routes
            .Include(r => r.RouteStops)
            .FirstOrDefaultAsync(r => r.Id == routeId);

        if (route == null)
            throw new KeyNotFoundException(
                "Route not found.");

        if (route.IsActive == true)
            return true;

        // Validate before activating
        await ValidateRouteAsync(route);

        route.IsActive = true;
        route.UpdatedAt = DateTime.UtcNow;

        return await _context.SaveChangesAsync() > 0;
    }

    public async Task<bool> DeactivateAsync(Guid routeId)
    {
        var route = await _context.Routes
            .FirstOrDefaultAsync(r => r.Id == routeId);

        if (route == null)
            throw new KeyNotFoundException(
                "Route not found.");

        // Don't deactivate route if it is currently being used
        var hasActiveManifest =
            await _context.ShipmentManifests
                .AnyAsync(m =>
                    m.RouteId == routeId &&
                    (m.Status == "planned" ||
                     m.Status == "loading" ||
                     m.Status == "in_transit"));

        if (hasActiveManifest)
        {
            throw new InvalidOperationException(
                "Route cannot be deactivated because it has an active shipment manifest.");
        }

        route.IsActive = false;
        route.UpdatedAt = DateTime.UtcNow;

        return await _context.SaveChangesAsync() > 0;
    }

    // ============================================================
    // GET ROUTE STOPS
    // ============================================================

    public async Task<IEnumerable<RouteStopDto>> GetStopsAsync(
        Guid routeId)
    {
        // --------------------------------------------------------
        // Validate route
        // --------------------------------------------------------

        var routeExists = await _context.Routes
            .AnyAsync(r => r.Id == routeId);

        if (!routeExists)
        {
            throw new KeyNotFoundException(
                "Route not found.");
        }

        // --------------------------------------------------------
        // Get stops
        // --------------------------------------------------------

        var stops = await _context.RouteStops
            .Include(rs => rs.Facility)
            .Where(rs => rs.RouteId == routeId)
            .OrderBy(rs => rs.StopSequence)
            .ToListAsync();

        return _mapper.Map<IEnumerable<RouteStopDto>>(stops);
    }

    // ============================================================
    // VALIDATE ROUTE
    // ============================================================

    public async Task ValidateRouteAsync(
        Project3.Models.Route route)
    {
        if (route.OriginFacilityId ==
            route.DestinationFacilityId)
        {
            throw new InvalidOperationException(
                "Origin and destination cannot be the same.");
        }

        if (route.Distance <= 0)
        {
            throw new InvalidOperationException(
                "Route distance must be greater than zero.");
        }

        if (route.EstimatedDuration.HasValue &&
            route.EstimatedDuration.Value <= 0)
        {
            throw new InvalidOperationException(
                "Estimated duration must be greater than zero.");
        }

        // Load stops if not already loaded
        if (route.RouteStops == null || !route.RouteStops.Any())
        {
            await _context.Entry(route)
                .Collection(r => r.RouteStops)
                .LoadAsync();
        }

        var activeStops = route.RouteStops
            .Where(s => s.IsActive != false)
            .OrderBy(s => s.StopSequence)
            .ToList();

        // Sequence must be continuous: 1, 2, 3, 4...
        for (int i = 0; i < activeStops.Count; i++)
        {
            var expected = i + 1;

            if (activeStops[i].StopSequence != expected)
            {
                throw new InvalidOperationException(
                    $"Route stop sequence is invalid. Expected {expected}.");
            }
        }
    }
}