using AutoMapper;
using Project3.DTOs;
using Project3.Exceptions;
using Project3.Models;
using Project3.Repositories.Interfaces;

namespace Project3.Services.Implementations;

public class RolePermissionService
    : CrudService<RolePermission, RolePermissionDto, CreateRolePermissionDto>
{
    private readonly ILogger<RolePermissionService> _logger;

    // ============================================================
    // SEARCHABLE PROPERTIES (if needed, maybe by RoleId or PermissionId)
    // ============================================================

    protected override string[] SearchableProperties => Array.Empty<string>(); // Not searchable by text

    // ============================================================
    // CONSTRUCTOR
    // ============================================================

    public RolePermissionService(
        ICrudRepository<RolePermission> repository,
        IMapper mapper,
        ILogger<RolePermissionService> logger)
        : base(repository, mapper)
    {
        _logger = logger;
    }

    // ============================================================
    // CREATE
    // ============================================================

    public override async Task<RolePermissionDto> CreateAsync(CreateRolePermissionDto dto)
    {
        // Validate foreign keys exist (optional, but recommended)
        // We assume repositories for Role and Permission are available,
        // but to keep it simple, we'll just check for duplicate role-permission pair.

        // Check duplicate
        var existing = await _repository.FirstOrDefaultAsync(
            rp => rp.RoleId == dto.RoleId && rp.PermissionId == dto.PermissionId
        );
        if (existing != null)
        {
            _logger.LogWarning(
                "Attempted to create duplicate RolePermission: RoleId={RoleId}, PermissionId={PermissionId}",
                dto.RoleId, dto.PermissionId);
            throw new DuplicateResourceException(
                $"RolePermission with RoleId '{dto.RoleId}' and PermissionId '{dto.PermissionId}' already exists.");
        }

        return await base.CreateAsync(dto);
    }
}