using AutoMapper;
using Project3.DTOs;
using Project3.Exceptions;
using Project3.Models;
using Project3.Repositories.Interfaces;

namespace Project3.Services.Implementations;

public class RoleService
    : CrudService<Role, RoleDto, CreateRoleDto>
{
    private readonly ILogger<RoleService> _logger;

    // ============================================================
    // SEARCHABLE PROPERTIES
    // ============================================================

    protected override string[] SearchableProperties =>
    [
        nameof(Role.Name),
        nameof(Role.Description)
    ];

    // ============================================================
    // CONSTRUCTOR
    // ============================================================

    public RoleService(
        ICrudRepository<Role> repository,
        IMapper mapper,
        ILogger<RoleService> logger)
        : base(repository, mapper)
    {
        _logger = logger;
    }

    // ============================================================
    // CREATE
    // ============================================================

    public override async Task<RoleDto> CreateAsync(CreateRoleDto dto)
    {
        // --------------------------------------------------------
        // Normalize name
        // --------------------------------------------------------

        dto.Name = dto.Name?.Trim() ?? string.Empty;

        // --------------------------------------------------------
        // Validate name
        // --------------------------------------------------------

        if (string.IsNullOrWhiteSpace(dto.Name))
        {
            throw new ArgumentException("Role name is required.");
        }

        // --------------------------------------------------------
        // Check duplicate name
        // --------------------------------------------------------

        var existingRole = await _repository.FirstOrDefaultAsync(
            r => r.Name != null && r.Name.ToUpper() == dto.Name.ToUpper()
        );

        if (existingRole != null)
        {
            _logger.LogWarning(
                "Attempted to create duplicate role name: {Name}",
                dto.Name
            );

            throw new DuplicateResourceException(
                $"A role with name '{dto.Name}' already exists."
            );
        }

        // --------------------------------------------------------
        // Default IsSystem to false if not provided
        // --------------------------------------------------------

        dto.IsSystem ??= false;

        return await base.CreateAsync(dto);
    }

    // ============================================================
    // UPDATE (Optional override if needed)
    // ============================================================

    public override async Task<bool> UpdateAsync(
    Guid id,
    CreateRoleDto dto)
    {
        // Normalize name
        dto.Name = dto.Name?.Trim() ?? string.Empty;

        if (string.IsNullOrWhiteSpace(dto.Name))
        {
            throw new ArgumentException(
                "Role name is required.");
        }

        // Check duplicate name
        var existingRole =
            await _repository.FirstOrDefaultAsync(
                r =>
                    r.Name != null &&
                    r.Name.ToUpper() == dto.Name.ToUpper() &&
                    r.Id != id
            );

        if (existingRole != null)
        {
            _logger.LogWarning(
                "Attempted to update role with duplicate name: {Name}",
                dto.Name
            );

            throw new DuplicateResourceException(
                $"A role with name '{dto.Name}' already exists."
            );
        }

        return await base.UpdateAsync(id, dto);
    }
}