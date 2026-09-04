using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Project3.DTOs;
using Project3.Exceptions;
using Project3.Models;
using Project3.Repositories.Interfaces;

namespace Project3.Services.Implementations;

public class UserRoleService
    : CrudService<UserRole, UserRoleDto, CreateUserRoleDto>
{
    private readonly ILogger<UserRoleService> _logger;
    private readonly Pj3Context _context;
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
        ILogger<UserRoleService> logger,
        Pj3Context context)
        : base(repository, mapper)
    {
        _logger = logger;
        _context = context;
    }

    // ============================================================
    // CREATE
    // ============================================================

    public override async Task<UserRoleDto> CreateAsync(
    CreateUserRoleDto dto)
    {
        // ============================================================
        // 1. CHECK DUPLICATE
        // ============================================================

        var existing = await _repository.FirstOrDefaultAsync(
            ur => ur.UserId == dto.UserId &&
                  ur.RoleId == dto.RoleId);

        if (existing != null)
        {
            _logger.LogWarning(
                "Attempted to create duplicate UserRole: UserId={UserId}, RoleId={RoleId}",
                dto.UserId,
                dto.RoleId);

            throw new DuplicateResourceException(
                $"UserRole with UserId '{dto.UserId}' and RoleId '{dto.RoleId}' already exists.");
        }


        // ============================================================
        // 2. FIND ROLE
        // ============================================================

        var role = await _context.Roles
            .FirstOrDefaultAsync(r => r.Id == dto.RoleId);

        if (role == null)
        {
            throw new InvalidOperationException(
                "Role not found.");
        }


        // ============================================================
        // 3. CUSTOMER ROLE REQUIRES CUSTOMER ENTITY
        // ============================================================

        if (role.Name == "Customer")
        {
            var customerExists = await _context.Customers
                .AnyAsync(c => c.UserId == dto.UserId);

            if (!customerExists)
            {
                throw new InvalidOperationException(
                    "Cannot assign the Customer role because this user does not have a Customer account.");
            }
        }


        // ============================================================
        // 4. CREATE USER ROLE
        // ============================================================

        return await base.CreateAsync(dto);
    }
    public override async Task<bool> DeleteAsync(Guid id)
    {
        var userRole = await _repository.GetByIdAsync(id);

        if (userRole == null)
            return false;

        var role = await _context.Roles
            .FirstOrDefaultAsync(r => r.Id == userRole.RoleId);

        if (role?.Name == "Customer")
        {
            throw new InvalidOperationException(
                "The Customer role cannot be removed.");
        }

        return await base.DeleteAsync(id);
    }
}