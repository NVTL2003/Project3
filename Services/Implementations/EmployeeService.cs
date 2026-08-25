using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Project3.DTOs;
using Project3.Models;
using Project3.Repositories.Interfaces;
using Project3.Services.Interfaces;

namespace Project3.Services.Implementations;

public class EmployeeService
    : CrudService<Employee, EmployeeDto, CreateEmployeeDto>,
      IEmployeeService
{
    private readonly Pj3Context _context;

    public EmployeeService(
        ICrudRepository<Employee> repository,
        IMapper mapper,
        Pj3Context context)
        : base(repository, mapper)
    {
        _context = context;
    }

    public override async Task<EmployeeDto> CreateAsync(
     CreateEmployeeDto dto)
    {
        // ============================================================
        // 1. VALIDATE BASIC DATA
        // ============================================================

        if (string.IsNullOrWhiteSpace(dto.Username))
            throw new ArgumentException("Username is required.");

        if (string.IsNullOrWhiteSpace(dto.Email))
            throw new ArgumentException("Email is required.");

        if (string.IsNullOrWhiteSpace(dto.Password))
            throw new ArgumentException("Password is required.");

        if (string.IsNullOrWhiteSpace(dto.FirstName))
            throw new ArgumentException("First name is required.");

        if (string.IsNullOrWhiteSpace(dto.LastName))
            throw new ArgumentException("Last name is required.");


        // ============================================================
        // 2. NORMALIZE
        // ============================================================

        var username = dto.Username.Trim();

        var email = dto.Email
            .Trim()
            .ToLowerInvariant();


        // ============================================================
        // 3. CHECK USERNAME
        // ============================================================

        if (await _context.Users
            .AnyAsync(u => u.Username == username))
        {
            throw new InvalidOperationException(
                "Username is already registered.");
        }


        // ============================================================
        // 4. CHECK EMAIL
        // ============================================================

        if (await _context.Users
            .AnyAsync(u => u.Email == email))
        {
            throw new InvalidOperationException(
                "Email is already registered.");
        }


        // ============================================================
        // 5. VALIDATE DEPARTMENT
        // ============================================================

        if (dto.DepartmentId.HasValue)
        {
            var exists = await _context.Departments
                .AnyAsync(d =>
                    d.Id == dto.DepartmentId.Value);

            if (!exists)
                throw new KeyNotFoundException(
                    "Department not found.");
        }


        // ============================================================
        // 6. VALIDATE POSITION
        // ============================================================

        if (dto.PositionId.HasValue)
        {
            var exists = await _context.Positions
                .AnyAsync(p =>
                    p.Id == dto.PositionId.Value);

            if (!exists)
                throw new KeyNotFoundException(
                    "Position not found.");
        }


        // ============================================================
        // 7. VALIDATE BRANCH
        // ============================================================

        if (dto.BranchId.HasValue)
        {
            var exists = await _context.Facilities
                .AnyAsync(f =>
                    f.Id == dto.BranchId.Value);

            if (!exists)
                throw new KeyNotFoundException(
                    "Branch not found.");
        }


        // ============================================================
        // 8. FIND EMPLOYEE ROLE
        // ============================================================

        var employeeRole = await _context.Roles
            .FirstOrDefaultAsync(r =>
                r.Name == "Employee");

        if (employeeRole == null)
        {
            throw new InvalidOperationException(
                "Employee role does not exist.");
        }


        // ============================================================
        // 9. TRANSACTION
        // ============================================================

        await using var transaction =
            await _context.Database.BeginTransactionAsync();

        try
        {
            // ========================================================
            // CREATE USER
            // ========================================================

            var user = new User
            {
                Id = Guid.NewGuid(),

                Username = username,

                Email = email,

                Phone = string.IsNullOrWhiteSpace(dto.Phone)
                    ? null
                    : dto.Phone.Trim(),

                PasswordHash =
                    BCrypt.Net.BCrypt.HashPassword(
                        dto.Password),

                MfaEnabled = false,

                IsActive =
                    dto.IsActive ?? true,

                CreatedAt = DateTime.UtcNow,

                UpdatedAt = DateTime.UtcNow
            };

            _context.Users.Add(user);


            // ========================================================
            // CREATE EMPLOYEE
            // ========================================================

            var employee = new Employee
            {
                Id = Guid.NewGuid(),

                UserId = user.Id,

                FirstName = dto.FirstName.Trim(),

                LastName = dto.LastName.Trim(),

                DepartmentId = dto.DepartmentId,

                PositionId = dto.PositionId,

                BranchId = dto.BranchId,

                HireDate = dto.HireDate,

                EmployeeCode =
                    string.IsNullOrWhiteSpace(dto.EmployeeCode)
                        ? null
                        : dto.EmployeeCode.Trim(),

                IsActive =
                    dto.IsActive ?? true,

                CreatedAt = DateTime.UtcNow,

                UpdatedAt = DateTime.UtcNow
            };

            _context.Employees.Add(employee);


            // ========================================================
            // CREATE USER ROLE
            // ========================================================

            var userRole = new UserRole
            {
                Id = Guid.NewGuid(),

                UserId = user.Id,

                RoleId = employeeRole.Id,

                CreatedAt = DateTime.UtcNow
            };

            _context.UserRoles.Add(userRole);


            // ========================================================
            // SAVE
            // ========================================================

            await _context.SaveChangesAsync();


            // ========================================================
            // COMMIT
            // ========================================================

            await transaction.CommitAsync();


            // ========================================================
            // RETURN
            // ========================================================

            return new EmployeeDto
            {
                Id = employee.Id,

                UserId = user.Id,

                Username = user.Username,

                Email = user.Email,

                Phone = user.Phone,

                FirstName = employee.FirstName,

                LastName = employee.LastName,

                DepartmentId = employee.DepartmentId,

                PositionId = employee.PositionId,

                BranchId = employee.BranchId,

                HireDate = employee.HireDate,

                EmployeeCode = employee.EmployeeCode,

                IsActive = employee.IsActive,

                CreatedAt = employee.CreatedAt,

                UpdatedAt = employee.UpdatedAt
            };
        }
        catch
        {
            await transaction.RollbackAsync();
            throw;
        }
    }
}