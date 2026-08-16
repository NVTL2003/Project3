using AutoMapper;
using Project3.DTOs;
using Project3.Exceptions;
using Project3.Models;
using Project3.Repositories.Interfaces;

namespace Project3.Services.Implementations;

public class PermissionService
    : CrudService<Permission, PermissionDto, CreatePermissionDto>
{
    private readonly ILogger<PermissionService> _logger;

    // ============================================================
    // SEARCHABLE PROPERTIES
    // ============================================================

    protected override string[] SearchableProperties =>
    [
        nameof(Permission.Name),
        nameof(Permission.Resource),
        nameof(Permission.Action),
        nameof(Permission.Description)
    ];

    // ============================================================
    // CONSTRUCTOR
    // ============================================================

    public PermissionService(
        ICrudRepository<Permission> repository,
        IMapper mapper,
        ILogger<PermissionService> logger)
        : base(repository, mapper)
    {
        _logger = logger;
    }

    // ============================================================
    // CREATE
    // ============================================================

    public override async Task<PermissionDto> CreateAsync(CreatePermissionDto dto)
    {
        // Normalize strings
        dto.Name = dto.Name?.Trim() ?? string.Empty;
        dto.Resource = dto.Resource?.Trim() ?? string.Empty;
        dto.Action = dto.Action?.Trim() ?? string.Empty;

        // Validate required fields
        if (string.IsNullOrWhiteSpace(dto.Name))
            throw new ArgumentException("Permission name is required.");
        if (string.IsNullOrWhiteSpace(dto.Resource))
            throw new ArgumentException("Resource is required.");
        if (string.IsNullOrWhiteSpace(dto.Action))
            throw new ArgumentException("Action is required.");

        // Check for duplicate (same Resource + Action)
        var existing = await _repository.FirstOrDefaultAsync(
            p => p.Resource == dto.Resource && p.Action == dto.Action
        );
        if (existing != null)
        {
            _logger.LogWarning(
                "Attempted to create duplicate permission: Resource={Resource}, Action={Action}",
                dto.Resource, dto.Action);
            throw new DuplicateResourceException(
                $"Permission with Resource '{dto.Resource}' and Action '{dto.Action}' already exists.");
        }

        return await base.CreateAsync(dto);
    }
}