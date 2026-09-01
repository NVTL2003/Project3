using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Project3.DTOs;
using Project3.Models;
using Project3.Repositories.Interfaces;
using Project3.Services.Interfaces;

namespace Project3.Services.Implementations;

public class RouteStopService
    : CrudService<
        RouteStop,
        RouteStopDto,
        CreateRouteStopDto>,
      IRouteStopService
{
    private readonly Pj3Context _context;

    public RouteStopService(
        ICrudRepository<RouteStop> repository,
        IMapper mapper,
        Pj3Context context)
        : base(repository, mapper)
    {
        _context = context;
    }

    // ============================================================
    // GET ALL
    // ============================================================

    public override async Task<IEnumerable<RouteStopDto>> GetAllAsync()
    {
        var stops = await _context.RouteStops
            .AsNoTracking()
            .Include(rs => rs.Route)
            .Include(rs => rs.Facility)
            .OrderBy(rs => rs.RouteId)
            .ThenBy(rs => rs.StopSequence)
            .ToListAsync();

        return _mapper.Map<IEnumerable<RouteStopDto>>(stops);
    }

    // ============================================================
    // GET BY ID
    // ============================================================

    public override async Task<RouteStopDto?> GetByIdAsync(Guid id)
    {
        var stop = await _context.RouteStops
            .AsNoTracking()
            .Include(rs => rs.Route)
            .Include(rs => rs.Facility)
            .FirstOrDefaultAsync(rs => rs.Id == id);

        if (stop == null)
            return null;

        return _mapper.Map<RouteStopDto>(stop);
    }

    // ============================================================
    // GET STOPS FOR ROUTE
    // ============================================================

    public async Task<IEnumerable<RouteStopDto>> GetByRouteAsync(
        Guid routeId)
    {
        var routeExists = await _context.Routes
            .AnyAsync(r => r.Id == routeId);

        if (!routeExists)
        {
            throw new KeyNotFoundException(
                "Route not found.");
        }

        var stops = await _context.RouteStops
            .AsNoTracking()
            .Include(rs => rs.Facility)
            .Where(rs =>
                rs.RouteId == routeId &&
                rs.IsActive != false)
            .OrderBy(rs => rs.StopSequence)
            .ToListAsync();

        return _mapper.Map<IEnumerable<RouteStopDto>>(stops);
    }

    // ============================================================
    // CREATE
    // ============================================================

    public override async Task<RouteStopDto> CreateAsync(
        CreateRouteStopDto dto)
    {
        var route = await _context.Routes
            .FirstOrDefaultAsync(r =>
                r.Id == dto.RouteId);

        if (route == null)
        {
            throw new KeyNotFoundException(
                "Route not found.");
        }

        if (route.IsActive != true)
        {
            throw new InvalidOperationException(
                "Cannot add a stop to an inactive route.");
        }

        // --------------------------------------------------------
        // Validate sequence
        // --------------------------------------------------------

        if (dto.StopSequence < 1)
        {
            throw new InvalidOperationException(
                "Stop sequence must be greater than zero.");
        }

        // --------------------------------------------------------
        // Facility
        // --------------------------------------------------------

        var facility = await _context.Facilities
            .FirstOrDefaultAsync(f =>
                f.Id == dto.FacilityId);

        if (facility == null)
        {
            throw new KeyNotFoundException(
                "Facility not found.");
        }

        if (facility.IsActive != true)
        {
            throw new InvalidOperationException(
                "Facility is inactive.");
        }

        // --------------------------------------------------------
        // Don't allow origin as intermediate stop
        // --------------------------------------------------------

        if (facility.Id == route.OriginFacilityId)
        {
            throw new InvalidOperationException(
                "Origin facility cannot be added as an intermediate route stop.");
        }

        // --------------------------------------------------------
        // Don't allow destination as intermediate stop
        // --------------------------------------------------------

        if (facility.Id == route.DestinationFacilityId)
        {
            throw new InvalidOperationException(
                "Destination facility cannot be added as an intermediate route stop.");
        }

        // --------------------------------------------------------
        // Duplicate facility
        // --------------------------------------------------------

        var facilityAlreadyUsed =
            await _context.RouteStops
                .AnyAsync(rs =>
                    rs.RouteId == dto.RouteId &&
                    rs.FacilityId == dto.FacilityId &&
                    rs.IsActive != false);

        if (facilityAlreadyUsed)
        {
            throw new InvalidOperationException(
                "This facility already exists as a stop on this route.");
        }

        // --------------------------------------------------------
        // Sequence
        // --------------------------------------------------------

        var sequenceExists =
            await _context.RouteStops
                .AnyAsync(rs =>
                    rs.RouteId == dto.RouteId &&
                    rs.StopSequence == dto.StopSequence &&
                    rs.IsActive != false);

        if (sequenceExists)
        {
            throw new InvalidOperationException(
                $"Stop sequence {dto.StopSequence} already exists.");
        }

        // --------------------------------------------------------
        // Time validation
        // --------------------------------------------------------

        ValidateStopTimes(dto);

        // --------------------------------------------------------
        // Create
        // --------------------------------------------------------

        var now = DateTime.UtcNow;

        var stop = new RouteStop
        {
            Id = Guid.NewGuid(),

            RouteId = route.Id,

            StopSequence = dto.StopSequence,

            FacilityId = facility.Id,

            // Server derives these from facility
            StopName = facility.Name,

            Pincode = facility.Pincode,

            Latitude = dto.Latitude,

            Longitude = dto.Longitude,

            EstimatedArrival = dto.EstimatedArrival,

            EstimatedDeparture = dto.EstimatedDeparture,

            IsActive = dto.IsActive ?? true,

            CreatedAt = now,

            UpdatedAt = now
        };

        // If coordinates weren't provided, use facility coordinates
        // if your Facility model eventually contains them.

        await _context.RouteStops.AddAsync(stop);

        await _context.SaveChangesAsync();

        return await GetByIdAsync(stop.Id)
            ?? throw new InvalidOperationException(
                "Route stop could not be loaded after creation.");
    }

    // ============================================================
    // UPDATE
    // ============================================================

    public override async Task<bool> UpdateAsync(
        Guid id,
        CreateRouteStopDto dto)
    {
        var stop = await _context.RouteStops
            .FirstOrDefaultAsync(rs =>
                rs.Id == id);

        if (stop == null)
            return false;

        var route = await _context.Routes
            .FirstOrDefaultAsync(r =>
                r.Id == dto.RouteId);

        if (route == null)
        {
            throw new KeyNotFoundException(
                "Route not found.");
        }

        if (route.IsActive != true)
        {
            throw new InvalidOperationException(
                "Cannot modify stops on an inactive route.");
        }

        if (dto.StopSequence < 1)
        {
            throw new InvalidOperationException(
                "Stop sequence must be greater than zero.");
        }

        // --------------------------------------------------------
        // Facility
        // --------------------------------------------------------

        var facility = await _context.Facilities
            .FirstOrDefaultAsync(f =>
                f.Id == dto.FacilityId);

        if (facility == null)
        {
            throw new KeyNotFoundException(
                "Facility not found.");
        }

        if (facility.IsActive != true)
        {
            throw new InvalidOperationException(
                "Facility is inactive.");
        }

        // --------------------------------------------------------
        // Origin / destination protection
        // --------------------------------------------------------

        if (facility.Id == route.OriginFacilityId)
        {
            throw new InvalidOperationException(
                "Origin facility cannot be an intermediate route stop.");
        }

        if (facility.Id == route.DestinationFacilityId)
        {
            throw new InvalidOperationException(
                "Destination facility cannot be an intermediate route stop.");
        }

        // --------------------------------------------------------
        // Duplicate facility
        // --------------------------------------------------------

        var duplicateFacility =
            await _context.RouteStops
                .AnyAsync(rs =>
                    rs.RouteId == route.Id &&
                    rs.FacilityId == facility.Id &&
                    rs.Id != id &&
                    rs.IsActive != false);

        if (duplicateFacility)
        {
            throw new InvalidOperationException(
                "This facility already exists as another stop on this route.");
        }

        // --------------------------------------------------------
        // Duplicate sequence
        // --------------------------------------------------------

        var sequenceExists =
            await _context.RouteStops
                .AnyAsync(rs =>
                    rs.RouteId == route.Id &&
                    rs.StopSequence == dto.StopSequence &&
                    rs.Id != id &&
                    rs.IsActive != false);

        if (sequenceExists)
        {
            throw new InvalidOperationException(
                $"Stop sequence {dto.StopSequence} already exists.");
        }

        ValidateStopTimes(dto);

        // --------------------------------------------------------
        // Update
        // --------------------------------------------------------

        stop.RouteId = route.Id;
        stop.StopSequence = dto.StopSequence;
        stop.FacilityId = facility.Id;

        stop.StopName = facility.Name;
        stop.Pincode = facility.Pincode;

        stop.Latitude = dto.Latitude;
        stop.Longitude = dto.Longitude;

        stop.EstimatedArrival = dto.EstimatedArrival;
        stop.EstimatedDeparture = dto.EstimatedDeparture;

        if (dto.IsActive.HasValue)
            stop.IsActive = dto.IsActive;

        stop.UpdatedAt = DateTime.UtcNow;

        return await _context.SaveChangesAsync() > 0;
    }

    // ============================================================
    // DELETE / REMOVE STOP
    // ============================================================

    public override async Task<bool> DeleteAsync(Guid id)
    {
        var stop = await _context.RouteStops
            .FirstOrDefaultAsync(rs =>
                rs.Id == id);

        if (stop == null)
            return false;

        // --------------------------------------------------------
        // Don't physically remove a stop that was operationally used
        // --------------------------------------------------------

        var hasAssignments =
            await _context.DeliveryAssignments
                .AnyAsync(da =>
                    da.RouteStopId == id);

        if (hasAssignments)
        {
            // Soft deactivate instead
            stop.IsActive = false;
            stop.UpdatedAt = DateTime.UtcNow;

            return await _context.SaveChangesAsync() > 0;
        }

        _context.RouteStops.Remove(stop);

        return await _context.SaveChangesAsync() > 0;
    }

    // ============================================================
    // VALIDATE STOP TIMES
    // ============================================================
    // ============================================================
    // GET ROUTE STOPS
    // ============================================================

    public async Task<IEnumerable<RouteStopDto>> GetStopsAsync(
        Guid routeId)
    {
        var routeExists = await _context.Routes
            .AnyAsync(r => r.Id == routeId);

        if (!routeExists)
        {
            throw new KeyNotFoundException(
                "Route not found.");
        }

        var stops = await _context.RouteStops
            .Include(rs => rs.Facility)
            .Where(rs => rs.RouteId == routeId)
            .OrderBy(rs => rs.StopSequence)
            .ToListAsync();

        return _mapper.Map<IEnumerable<RouteStopDto>>(stops);
    }


    // ============================================================
    // DEACTIVATE ROUTE
    // ============================================================

    public async Task<bool> DeactivateAsync(Guid routeId)
    {
        var route = await _context.Routes
            .FirstOrDefaultAsync(r => r.Id == routeId);

        if (route == null)
        {
            throw new KeyNotFoundException(
                "Route not found.");
        }

        if (route.IsActive == false)
        {
            throw new InvalidOperationException(
                "Route is already inactive.");
        }

        route.IsActive = false;
        route.UpdatedAt = DateTime.UtcNow;

        return await _context.SaveChangesAsync() > 0;
    }


    // ============================================================
    // ACTIVATE ROUTE
    // ============================================================

    public async Task<bool> ActivateAsync(Guid routeId)
    {
        var route = await _context.Routes
            .FirstOrDefaultAsync(r => r.Id == routeId);

        if (route == null)
        {
            throw new KeyNotFoundException(
                "Route not found.");
        }

        if (route.IsActive == true)
        {
            throw new InvalidOperationException(
                "Route is already active.");
        }

        route.IsActive = true;
        route.UpdatedAt = DateTime.UtcNow;

        return await _context.SaveChangesAsync() > 0;
    }

    private static void ValidateStopTimes(
        CreateRouteStopDto dto)
    {
        if (dto.EstimatedArrival.HasValue &&
            dto.EstimatedArrival.Value < 0)
        {
            throw new InvalidOperationException(
                "Estimated arrival cannot be negative.");
        }

        if (dto.EstimatedDeparture.HasValue &&
            dto.EstimatedDeparture.Value < 0)
        {
            throw new InvalidOperationException(
                "Estimated departure cannot be negative.");
        }

        if (dto.EstimatedArrival.HasValue &&
            dto.EstimatedDeparture.HasValue &&
            dto.EstimatedDeparture.Value <
            dto.EstimatedArrival.Value)
        {
            throw new InvalidOperationException(
                "Estimated departure cannot be earlier than estimated arrival.");
        }
    }
}