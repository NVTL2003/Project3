using AutoMapper;
using Project3.DTOs;
using Project3.Exceptions;
using Project3.Models;
using Project3.Repositories.Interfaces;

namespace Project3.Services.Implementations;

public class FacilityService
    : CrudService<
        Facility,
        FacilityDto,
        CreateFacilityDto
      >
{
    private readonly ILogger<FacilityService> _logger;

    // ============================================================
    // SEARCHABLE PROPERTIES
    // ============================================================

    protected override string[] SearchableProperties =>
    [
        nameof(Facility.Name),
        nameof(Facility.Code),
        nameof(Facility.City),
        nameof(Facility.State),
        nameof(Facility.AddressLine1),
        nameof(Facility.Email),
        nameof(Facility.Phone)
    ];

    // ============================================================
    // CONSTRUCTOR
    // ============================================================

    public FacilityService(
        ICrudRepository<Facility> repository,
        IMapper mapper,
        ILogger<FacilityService> logger)
        : base(repository, mapper)
    {
        _logger = logger;
    }

    // ============================================================
    // CREATE
    // ============================================================

    public override async Task<FacilityDto> CreateAsync(
        CreateFacilityDto dto)
    {
        // --------------------------------------------------------
        // Normalize code
        // --------------------------------------------------------

        dto.Code =
            dto.Code?
                .Trim()
                .ToUpperInvariant()
            ?? string.Empty;

        // --------------------------------------------------------
        // Validate code
        // --------------------------------------------------------

        if (string.IsNullOrWhiteSpace(dto.Code))
        {
            throw new ArgumentException(
                "Facility code is required."
            );
        }

        // --------------------------------------------------------
        // Check duplicate code
        // --------------------------------------------------------

        var existingFacility =
            await _repository.FirstOrDefaultAsync(
                f =>
                    f.Code != null &&
                    f.Code.ToUpper() == dto.Code
            );

        if (existingFacility != null)
        {
            _logger.LogWarning(
                "Attempted to create duplicate facility code: {Code}",
                dto.Code
            );

            throw new DuplicateResourceException(
                $"A facility with code '{dto.Code}' already exists."
            );
        }

        // --------------------------------------------------------
        // Default facility type
        // --------------------------------------------------------

        if (string.IsNullOrWhiteSpace(
            dto.FacilityType))
        {
            dto.FacilityType = "Branch";
        }

        return await base.CreateAsync(dto);
    }
}