namespace Project3.DTOs
{
    public class CreateEmployeeDto
    {
        // ============================
        // ACCOUNT
        // ============================

        public string Username { get; set; } = string.Empty;

        public string Email { get; set; } = string.Empty;

        public string? Phone { get; set; }

        public string Password { get; set; } = string.Empty;


        // ============================
        // EMPLOYEE
        // ============================

        public string FirstName { get; set; } = string.Empty;

        public string LastName { get; set; } = string.Empty;

        public Guid? DepartmentId { get; set; }

        public Guid? PositionId { get; set; }

        public Guid? BranchId { get; set; }

        public DateOnly? HireDate { get; set; }

        public string? EmployeeCode { get; set; }

        public bool? IsActive { get; set; }
    }

    public class EmployeeDto
    {
        public Guid Id { get; set; }

        // ============================
        // USER
        // ============================

        public Guid UserId { get; set; }

        public string Username { get; set; } = string.Empty;

        public string Email { get; set; } = string.Empty;

        public string? Phone { get; set; }


        // ============================
        // EMPLOYEE
        // ============================

        public string FirstName { get; set; } = string.Empty;

        public string LastName { get; set; } = string.Empty;

        public Guid? DepartmentId { get; set; }

        public Guid? PositionId { get; set; }

        public Guid? BranchId { get; set; }

        public DateOnly? HireDate { get; set; }

        public string? EmployeeCode { get; set; }

        public bool? IsActive { get; set; }

        public DateTime? CreatedAt { get; set; }

        public DateTime? UpdatedAt { get; set; }
    }
}