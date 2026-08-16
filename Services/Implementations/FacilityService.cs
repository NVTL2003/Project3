//using AutoMapper;
//using Project3.DTOs;
//using Project3.Exceptions;
//using Project3.Models;
//using Project3.Repositories.Interfaces;
//using System.Linq.Expressions;

//namespace Project3.Services.Implementations;

//public class FacilityService
//    : CrudService<
//        Facility,
//        FacilityDto,
//        CreateFacilityDto
//      >
//{
//    private readonly ILogger<FacilityService> _logger;

//    protected override string[] SearchableProperties =>
//    [
//        nameof(Facility.Name),
//        nameof(Facility.Code),
//        nameof(Facility.City),
//        nameof(Facility.State),
//        nameof(Facility.AddressLine1),
//        nameof(Facility.Email),
//        nameof(Facility.Phone)
//    ];

//    public FacilityService(
//        ICrudRepository<Facility> repository,
//        IMapper mapper,
//        ILogger<FacilityService> logger)
//        : base(repository, mapper)
//    {
//        _logger = logger;
//    }

//    protected override Expression<Func<Facility, bool>>? BuildFilter(
//    QueryParamsDto queryParams)
//    {
//        var baseFilter = base.BuildFilter(queryParams);

//        Expression<Func<Facility, bool>> activeFilter =
//            f => f.IsActive == true;

//        if (baseFilter == null)
//            return activeFilter;

//        return CombineExpressions(
//            activeFilter,
//            baseFilter
//        );
//    }

//    public override async Task<FacilityDto> CreateAsync(
//        CreateFacilityDto dto)
//    {
//        dto.Code =
//            dto.Code?
//                .Trim()
//                .ToUpperInvariant()
//            ?? string.Empty;

//        if (string.IsNullOrWhiteSpace(dto.Code))
//        {
//            throw new ArgumentException(
//                "Facility code is required."
//            );
//        }

//        var existingFacility =
//            await _repository.FirstOrDefaultAsync(
//                f =>
//                    f.Code != null &&
//                    f.Code.ToUpper() == dto.Code
//            );

//        if (existingFacility != null)
//        {
//            _logger.LogWarning(
//                "Attempted to create duplicate facility code: {Code}",
//                dto.Code
//            );

//            throw new DuplicateResourceException(
//                $"A facility with code '{dto.Code}' already exists."
//            );
//        }

//        if (string.IsNullOrWhiteSpace(
//            dto.FacilityType))
//        {
//            dto.FacilityType = "Branch";
//        }

//        return await base.CreateAsync(dto);
//    }

//    // ============================================================
//    // DELETE / SOFT DELETE
//    // ============================================================

//    public override async Task<bool> DeleteAsync(Guid id)
//    {
//    );
//        var facility =
//            await _repository.GetByIdAsync(id);

//        if (facility == null)
//            return false;

//        // Soft delete
//        facility.IsActive = false;

//        _repository.Update(facility);

//        _logger.LogInformation(
//            "Facility {FacilityId} marked as inactive.",
//            id
//        );

//        return await _repository.SaveChangesAsync();
//    }
//}
using AutoMapper;
using Project3.DTOs;
using Project3.Exceptions;
using Project3.Models;
using Project3.Repositories.Interfaces;
using Project3.Common;

namespace Project3.Services.Implementations;

public class FacilityService
    : SoftDeleteCrudService<
        Facility,
        FacilityDto,
        CreateFacilityDto>
{
    private readonly ILogger<FacilityService> _logger;

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

    public FacilityService(
        ICrudRepository<Facility> repository,
        IMapper mapper,
        ILogger<FacilityService> logger)
        : base(repository, mapper)
    {
        _logger = logger;
    }

    public override async Task<FacilityDto> CreateAsync(
        CreateFacilityDto dto)
    {
        dto.Code =
            dto.Code?
                .Trim()
                .ToUpperInvariant()
            ?? string.Empty;

        if (string.IsNullOrWhiteSpace(dto.Code))
        {
            throw new ArgumentException(
                "Facility code is required.");
        }

        var existingFacility =
            await _repository.FirstOrDefaultAsync(
                f =>
                    f.Code != null &&
                    f.Code.ToUpper() == dto.Code);

        if (existingFacility != null)
        {
            throw new DuplicateResourceException(
                $"A facility with code '{dto.Code}' already exists.");
        }

        if (string.IsNullOrWhiteSpace(dto.FacilityType))
        {
            dto.FacilityType = "Branch";
        }

        return await base.CreateAsync(dto);
    }
}