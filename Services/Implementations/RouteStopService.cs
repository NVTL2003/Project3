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

    public override async Task<RouteStopDto?> GetByIdAsync(
        Guid id)
    {
        var stop = await _context.RouteStops
            .Include(rs => rs.Route)
            .Include(rs => rs.Facility)
            .FirstOrDefaultAsync(rs => rs.Id == id);

        if (stop == null)
            return null;

        return _mapper.Map<RouteStopDto>(stop);
    }

    // ============================================================
    // CREATE
    // ============================================================

    public override async Task<RouteStopDto> CreateAsync(
        CreateRouteStopDto dto)
    {
        // --------------------------------------------------------
        // Validate route
        // --------------------------------------------------------

        var route = await _context.Routes
            .FirstOrDefaultAsync(r =>
                r.Id == dto.RouteId);

        if (route == null)
        {
            throw new KeyNotFoundException(
                "Route not found.");
        }

        // --------------------------------------------------------
        // Validate facility
        // --------------------------------------------------------

        var facilityExists = await _context.Facilities
            .AnyAsync(f =>
                f.Id == dto.FacilityId);

        if (!facilityExists)
        {
            throw new KeyNotFoundException(
                "Facility not found.");
        }

        // --------------------------------------------------------
        // Validate stop sequence
        // --------------------------------------------------------

        if (dto.StopSequence < 1)
        {
            throw new InvalidOperationException(
                "Stop sequence must be greater than zero.");
        }

        // --------------------------------------------------------
        // Prevent duplicate sequence
        // --------------------------------------------------------

        var sequenceExists =
            await _context.RouteStops
                .AnyAsync(rs =>
                    rs.RouteId == dto.RouteId &&
                    rs.StopSequence == dto.StopSequence);

        if (sequenceExists)
        {
            throw new InvalidOperationException(
                $"Stop sequence {dto.StopSequence} already exists for this route.");
        }

        // --------------------------------------------------------
        // Create
        // --------------------------------------------------------

        var stop =
            _mapper.Map<RouteStop>(dto);

        stop.Id = Guid.NewGuid();

        stop.CreatedAt = DateTime.UtcNow;
        stop.UpdatedAt = DateTime.UtcNow;

        if (stop.IsActive == null)
            stop.IsActive = true;

        await _context.RouteStops.AddAsync(stop);

        await _context.SaveChangesAsync();

        return _mapper.Map<RouteStopDto>(stop);
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

        // --------------------------------------------------------
        // Validate route
        // --------------------------------------------------------

        var routeExists = await _context.Routes
            .AnyAsync(r =>
                r.Id == dto.RouteId);

        if (!routeExists)
        {
            throw new KeyNotFoundException(
                "Route not found.");
        }

        // --------------------------------------------------------
        // Validate facility
        // --------------------------------------------------------

        var facilityExists = await _context.Facilities
            .AnyAsync(f =>
                f.Id == dto.FacilityId);

        if (!facilityExists)
        {
            throw new KeyNotFoundException(
                "Facility not found.");
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
        // Prevent duplicate sequence
        // --------------------------------------------------------

        var sequenceExists =
            await _context.RouteStops
                .AnyAsync(rs =>
                    rs.RouteId == dto.RouteId &&
                    rs.StopSequence == dto.StopSequence &&
                    rs.Id != id);

        if (sequenceExists)
        {
            throw new InvalidOperationException(
                $"Stop sequence {dto.StopSequence} already exists for this route.");
        }

        // --------------------------------------------------------
        // Update
        // --------------------------------------------------------

        _mapper.Map(dto, stop);

        stop.UpdatedAt = DateTime.UtcNow;

        _context.RouteStops.Update(stop);

        return await _context.SaveChangesAsync() > 0;
    }
}