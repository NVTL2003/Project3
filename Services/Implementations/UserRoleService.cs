using AutoMapper;
using Project3.DTOs;
using Project3.Exceptions;
using Project3.Models;
using Project3.Repositories.Interfaces;

namespace Project3.Services.Implementations;

public class UserRoleService
    : CrudService<UserRole, UserRoleDto, CreateUserRoleDto>
{
    private readonly ILogger<UserRoleService> _logger;

    // ============================================================
    // SEARCHABLE PROPERTIES
    // ============================================================

    protected override string[] SearchableProperties => Array.Empty<string>(); // Not searchable by text

    // ============================================================
    // CONSTRUCTOR
    // ============================================================

    public UserRoleService(
        ICrudRepository<UserRole> repository,
        IMapper mapper,
        ILogger<UserRoleService> logger)
        : base(repository, mapper)
    {
        _logger = logger;
    }

    // ============================================================
    // CREATE
    // ============================================================

    public override async Task<UserRoleDto> CreateAsync(CreateUserRoleDto dto)
    {
        // Check duplicate (UserId + RoleId)
        var existing = await _repository.FirstOrDefaultAsync(
            ur => ur.UserId == dto.UserId && ur.RoleId == dto.RoleId
        );
        if (existing != null)
        {
            _logger.LogWarning(
                "Attempted to create duplicate UserRole: UserId={UserId}, RoleId={RoleId}",
                dto.UserId, dto.RoleId);
            throw new DuplicateResourceException(
                $"UserRole with UserId '{dto.UserId}' and RoleId '{dto.RoleId}' already exists.");
        }

        return await base.CreateAsync(dto);
    }
}