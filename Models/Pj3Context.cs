using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Pomelo.EntityFrameworkCore.MySql.Scaffolding.Internal;

namespace Project3.Models;

public partial class Pj3Context : DbContext
{
    public Pj3Context()
    {
    }

    public Pj3Context(DbContextOptions<Pj3Context> options)
        : base(options)
    {
    }

    public virtual DbSet<AuditLog> AuditLogs { get; set; }

    public virtual DbSet<Customer> Customers { get; set; }

    public virtual DbSet<CustomerAddress> CustomerAddresses { get; set; }

    public virtual DbSet<DeliveryAssignment> DeliveryAssignments { get; set; }

    public virtual DbSet<DeliveryAttempt> DeliveryAttempts { get; set; }

    public virtual DbSet<Department> Departments { get; set; }

    public virtual DbSet<Efmigrationshistory> Efmigrationshistories { get; set; }

    public virtual DbSet<Employee> Employees { get; set; }

    public virtual DbSet<EmployeeProfileRequest> EmployeeProfileRequests { get; set; }

    public virtual DbSet<Expense> Expenses { get; set; }

    public virtual DbSet<Facility> Facilities { get; set; }

    public virtual DbSet<InsurancePlan> InsurancePlans { get; set; }

    public virtual DbSet<Invoice> Invoices { get; set; }

    public virtual DbSet<LoginHistory> LoginHistories { get; set; }

    public virtual DbSet<ManifestItem> ManifestItems { get; set; }

    public virtual DbSet<Notification> Notifications { get; set; }

    public virtual DbSet<PackageScan> PackageScans { get; set; }

    public virtual DbSet<Payment> Payments { get; set; }

    public virtual DbSet<Permission> Permissions { get; set; }

    public virtual DbSet<Pincode> Pincodes { get; set; }

    public virtual DbSet<Position> Positions { get; set; }

    public virtual DbSet<PricingRule> PricingRules { get; set; }

    public virtual DbSet<ProofOfDelivery> ProofOfDeliveries { get; set; }

    public virtual DbSet<Role> Roles { get; set; }

    public virtual DbSet<RolePermission> RolePermissions { get; set; }

    public virtual DbSet<Route> Routes { get; set; }

    public virtual DbSet<RouteStop> RouteStops { get; set; }

    public virtual DbSet<Service> Services { get; set; }

    public virtual DbSet<Shipment> Shipments { get; set; }

    public virtual DbSet<ShipmentCharge> ShipmentCharges { get; set; }

    public virtual DbSet<ShipmentContact> ShipmentContacts { get; set; }

    public virtual DbSet<ShipmentManifest> ShipmentManifests { get; set; }

    public virtual DbSet<ShipmentRequest> ShipmentRequests { get; set; }

    public virtual DbSet<ShipmentStatusHistory> ShipmentStatusHistories { get; set; }

    public virtual DbSet<StorageArea> StorageAreas { get; set; }

    public virtual DbSet<TrackingEvent> TrackingEvents { get; set; }

    public virtual DbSet<TrackingStatus> TrackingStatuses { get; set; }

    public virtual DbSet<TransportOrder> TransportOrders { get; set; }

    public virtual DbSet<User> Users { get; set; }

    public virtual DbSet<UserRole> UserRoles { get; set; }

    public virtual DbSet<Vehicle> Vehicles { get; set; }

    public virtual DbSet<VehicleFuelLog> VehicleFuelLogs { get; set; }

    public virtual DbSet<VehicleGp> VehicleGps { get; set; }

    public virtual DbSet<VehicleMaintenance> VehicleMaintenances { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseMySql("server=localhost;database=PJ3;user=root;password=1234", Microsoft.EntityFrameworkCore.ServerVersion.Parse("8.0.43-mysql"));

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder
            .UseCollation("utf8mb4_0900_ai_ci")
            .HasCharSet("utf8mb4");

        modelBuilder.Entity<AuditLog>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("audit_logs");

            entity.HasIndex(e => e.CreatedAt, "idx_audit_logs_created_at");

            entity.HasIndex(e => e.RecordId, "idx_audit_logs_record");

            entity.HasIndex(e => e.TableName, "idx_audit_logs_table");

            entity.HasIndex(e => e.UserId, "idx_audit_logs_user");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Action)
                .HasMaxLength(100)
                .HasColumnName("action");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.Description)
                .HasColumnType("text")
                .HasColumnName("description");
            entity.Property(e => e.IpAddress)
                .HasMaxLength(45)
                .HasColumnName("ip_address");
            entity.Property(e => e.NewData)
                .HasColumnType("json")
                .HasColumnName("new_data");
            entity.Property(e => e.OldData)
                .HasColumnType("json")
                .HasColumnName("old_data");
            entity.Property(e => e.RecordId).HasColumnName("record_id");
            entity.Property(e => e.TableName)
                .HasMaxLength(100)
                .HasColumnName("table_name");
            entity.Property(e => e.UserAgent)
                .HasColumnType("text")
                .HasColumnName("user_agent");
            entity.Property(e => e.UserId).HasColumnName("user_id");

            entity.HasOne(d => d.User).WithMany(p => p.AuditLogs)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("fk_audit_logs_user");
        });

        modelBuilder.Entity<Customer>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("customers");

            entity.HasIndex(e => e.AccountNumber, "account_number").IsUnique();

            entity.HasIndex(e => e.UserId, "idx_customers_user_id").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.AccountNumber)
                .HasMaxLength(50)
                .HasColumnName("account_number");
            entity.Property(e => e.CompanyName)
                .HasMaxLength(200)
                .HasColumnName("company_name");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.CreditLimit)
                .HasPrecision(15, 2)
                .HasColumnName("credit_limit");
            entity.Property(e => e.FirstName)
                .HasMaxLength(100)
                .HasColumnName("first_name");
            entity.Property(e => e.IsActive)
                .HasDefaultValueSql("'1'")
                .HasColumnName("is_active");
            entity.Property(e => e.LastName)
                .HasMaxLength(100)
                .HasColumnName("last_name");
            entity.Property(e => e.TaxId)
                .HasMaxLength(50)
                .HasColumnName("tax_id");
            entity.Property(e => e.UpdatedAt)
                .ValueGeneratedOnAddOrUpdate()
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("updated_at");
            entity.Property(e => e.UserId).HasColumnName("user_id");

            entity.HasOne(d => d.User).WithOne(p => p.Customer)
                .HasForeignKey<Customer>(d => d.UserId)
                .HasConstraintName("fk_customers_user");
        });

        modelBuilder.Entity<CustomerAddress>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("customer_addresses");

            entity.HasIndex(e => e.CustomerId, "idx_customer_addresses_customer");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.AddressLine1)
                .HasMaxLength(255)
                .HasColumnName("address_line1");
            entity.Property(e => e.AddressLine2)
                .HasMaxLength(255)
                .HasColumnName("address_line2");
            entity.Property(e => e.AddressType)
                .HasMaxLength(50)
                .HasColumnName("address_type");
            entity.Property(e => e.City)
                .HasMaxLength(100)
                .HasColumnName("city");
            entity.Property(e => e.Country)
                .HasMaxLength(100)
                .HasDefaultValueSql("'India'")
                .HasColumnName("country");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.CustomerId).HasColumnName("customer_id");
            entity.Property(e => e.IsActive)
                .HasDefaultValueSql("'1'")
                .HasColumnName("is_active");
            entity.Property(e => e.IsDefault)
                .HasDefaultValueSql("'0'")
                .HasColumnName("is_default");
            entity.Property(e => e.Landmark)
                .HasMaxLength(255)
                .HasColumnName("landmark");
            entity.Property(e => e.Phone)
                .HasMaxLength(20)
                .HasColumnName("phone");
            entity.Property(e => e.Pincode)
                .HasMaxLength(20)
                .HasColumnName("pincode");
            entity.Property(e => e.RecipientName)
                .HasMaxLength(200)
                .HasColumnName("recipient_name");
            entity.Property(e => e.State)
                .HasMaxLength(100)
                .HasColumnName("state");
            entity.Property(e => e.UpdatedAt)
                .ValueGeneratedOnAddOrUpdate()
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("updated_at");

            entity.HasOne(d => d.Customer).WithMany(p => p.CustomerAddresses)
                .HasForeignKey(d => d.CustomerId)
                .HasConstraintName("fk_customer_addresses_customer");
        });

        modelBuilder.Entity<DeliveryAssignment>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("delivery_assignments");

            entity.HasIndex(e => e.AssignmentNumber, "assignment_number").IsUnique();

            entity.HasIndex(e => e.VehicleId, "fk_delivery_assignments_vehicle");

            entity.HasIndex(e => e.DriverId, "idx_delivery_assignments_driver");

            entity.HasIndex(e => e.ManifestId, "idx_delivery_assignments_manifest");

            entity.HasIndex(e => e.RouteStopId, "idx_delivery_assignments_route_stop");

            entity.HasIndex(e => e.Status, "idx_delivery_assignments_status");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.ActualDeliveryTime)
                .HasColumnType("timestamp")
                .HasColumnName("actual_delivery_time");
            entity.Property(e => e.AssignedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("assigned_at");
            entity.Property(e => e.AssignmentNumber)
                .HasMaxLength(50)
                .HasColumnName("assignment_number");
            entity.Property(e => e.CompletedAt)
                .HasColumnType("timestamp")
                .HasColumnName("completed_at");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.DriverId).HasColumnName("driver_id");
            entity.Property(e => e.EstimatedDeliveryTime)
                .HasColumnType("timestamp")
                .HasColumnName("estimated_delivery_time");
            entity.Property(e => e.ManifestId).HasColumnName("manifest_id");
            entity.Property(e => e.Notes)
                .HasColumnType("text")
                .HasColumnName("notes");
            entity.Property(e => e.RouteStopId).HasColumnName("route_stop_id");
            entity.Property(e => e.SequenceNumber).HasColumnName("sequence_number");
            entity.Property(e => e.StartedAt)
                .HasColumnType("timestamp")
                .HasColumnName("started_at");
            entity.Property(e => e.Status)
                .HasMaxLength(50)
                .HasDefaultValueSql("'Assigned'")
                .HasColumnName("status");
            entity.Property(e => e.UpdatedAt)
                .ValueGeneratedOnAddOrUpdate()
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("updated_at");
            entity.Property(e => e.VehicleId).HasColumnName("vehicle_id");

            entity.HasOne(d => d.Driver).WithMany(p => p.DeliveryAssignments)
                .HasForeignKey(d => d.DriverId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_delivery_assignments_driver");

            entity.HasOne(d => d.Manifest).WithMany(p => p.DeliveryAssignments)
                .HasForeignKey(d => d.ManifestId)
                .HasConstraintName("fk_delivery_assignments_manifest");

            entity.HasOne(d => d.RouteStop).WithMany(p => p.DeliveryAssignments)
                .HasForeignKey(d => d.RouteStopId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_delivery_assignments_route_stop");

            entity.HasOne(d => d.Vehicle).WithMany(p => p.DeliveryAssignments)
                .HasForeignKey(d => d.VehicleId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_delivery_assignments_vehicle");
        });

        modelBuilder.Entity<DeliveryAttempt>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("delivery_attempts");

            entity.HasIndex(e => e.DeliveryAssignmentId, "idx_delivery_attempts_assignment");

            entity.HasIndex(e => e.ShipmentId, "idx_delivery_attempts_shipment");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.AttemptNumber).HasColumnName("attempt_number");
            entity.Property(e => e.AttemptTime)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("attempt_time");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.DeliveryAssignmentId).HasColumnName("delivery_assignment_id");
            entity.Property(e => e.IsDelivered)
                .HasDefaultValueSql("'0'")
                .HasColumnName("is_delivered");
            entity.Property(e => e.Latitude)
                .HasPrecision(10, 8)
                .HasColumnName("latitude");
            entity.Property(e => e.Longitude)
                .HasPrecision(11, 8)
                .HasColumnName("longitude");
            entity.Property(e => e.Notes)
                .HasColumnType("text")
                .HasColumnName("notes");
            entity.Property(e => e.Reason)
                .HasMaxLength(255)
                .HasColumnName("reason");
            entity.Property(e => e.ShipmentId).HasColumnName("shipment_id");
            entity.Property(e => e.Status)
                .HasColumnType("enum('attempted','delivered','failed')")
                .HasColumnName("status");
            entity.Property(e => e.UpdatedAt)
                .ValueGeneratedOnAddOrUpdate()
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("updated_at");

            entity.HasOne(d => d.DeliveryAssignment).WithMany(p => p.DeliveryAttempts)
                .HasForeignKey(d => d.DeliveryAssignmentId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_delivery_attempts_assignment");

            entity.HasOne(d => d.Shipment).WithMany(p => p.DeliveryAttempts)
                .HasForeignKey(d => d.ShipmentId)
                .HasConstraintName("fk_delivery_attempts_shipment");
        });

        modelBuilder.Entity<Department>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("departments");

            entity.HasIndex(e => e.Name, "name").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.Description)
                .HasMaxLength(255)
                .HasColumnName("description");
            entity.Property(e => e.IsActive)
                .HasDefaultValueSql("'1'")
                .HasColumnName("is_active");
            entity.Property(e => e.Name)
                .HasMaxLength(100)
                .HasColumnName("name");
        });

        modelBuilder.Entity<Efmigrationshistory>(entity =>
        {
            entity.HasKey(e => e.MigrationId).HasName("PRIMARY");

            entity.ToTable("__efmigrationshistory");

            entity.Property(e => e.MigrationId).HasMaxLength(150);
            entity.Property(e => e.ProductVersion).HasMaxLength(32);
        });

        modelBuilder.Entity<Employee>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("employees");

            entity.HasIndex(e => e.EmployeeCode, "employee_code").IsUnique();

            entity.HasIndex(e => e.DepartmentId, "fk_employees_department");

            entity.HasIndex(e => e.PositionId, "fk_employees_position");

            entity.HasIndex(e => e.BranchId, "idx_employees_branch");

            entity.HasIndex(e => e.UserId, "idx_employees_user_id").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.BranchId).HasColumnName("branch_id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.DepartmentId).HasColumnName("department_id");
            entity.Property(e => e.EmployeeCode)
                .HasMaxLength(50)
                .HasColumnName("employee_code");
            entity.Property(e => e.FirstName)
                .HasMaxLength(100)
                .HasColumnName("first_name");
            entity.Property(e => e.HireDate).HasColumnName("hire_date");
            entity.Property(e => e.IsActive)
                .HasDefaultValueSql("'1'")
                .HasColumnName("is_active");
            entity.Property(e => e.LastName)
                .HasMaxLength(100)
                .HasColumnName("last_name");
            entity.Property(e => e.PositionId).HasColumnName("position_id");
            entity.Property(e => e.UpdatedAt)
                .ValueGeneratedOnAddOrUpdate()
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("updated_at");
            entity.Property(e => e.UserId).HasColumnName("user_id");

            entity.HasOne(d => d.Branch).WithMany(p => p.Employees)
                .HasForeignKey(d => d.BranchId)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("fk_employees_branch");

            entity.HasOne(d => d.Department).WithMany(p => p.Employees)
                .HasForeignKey(d => d.DepartmentId)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("fk_employees_department");

            entity.HasOne(d => d.Position).WithMany(p => p.Employees)
                .HasForeignKey(d => d.PositionId)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("fk_employees_position");

            entity.HasOne(d => d.User).WithOne(p => p.Employee)
                .HasForeignKey<Employee>(d => d.UserId)
                .HasConstraintName("fk_employees_user");
        });

        modelBuilder.Entity<EmployeeProfileRequest>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("employee_profile_requests");

            entity.HasIndex(e => e.ApprovedBy, "fk_employee_profile_requests_approved_by");

            entity.HasIndex(e => e.RequestedBy, "fk_employee_profile_requests_requested_by");

            entity.HasIndex(e => e.EmployeeId, "idx_employee_profile_requests_employee");

            entity.HasIndex(e => e.Status, "idx_employee_profile_requests_status");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.ApprovedAt)
                .HasColumnType("timestamp")
                .HasColumnName("approved_at");
            entity.Property(e => e.ApprovedBy).HasColumnName("approved_by");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.EmployeeId).HasColumnName("employee_id");
            entity.Property(e => e.FieldName)
                .HasMaxLength(100)
                .HasColumnName("field_name");
            entity.Property(e => e.NewValue)
                .HasColumnType("text")
                .HasColumnName("new_value");
            entity.Property(e => e.OldValue)
                .HasColumnType("text")
                .HasColumnName("old_value");
            entity.Property(e => e.Reason)
                .HasColumnType("text")
                .HasColumnName("reason");
            entity.Property(e => e.RejectionReason)
                .HasColumnType("text")
                .HasColumnName("rejection_reason");
            entity.Property(e => e.RequestedBy).HasColumnName("requested_by");
            entity.Property(e => e.Status)
                .HasMaxLength(50)
                .HasDefaultValueSql("'Pending'")
                .HasColumnName("status");
            entity.Property(e => e.UpdatedAt)
                .ValueGeneratedOnAddOrUpdate()
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("updated_at");

            entity.HasOne(d => d.ApprovedByNavigation).WithMany(p => p.EmployeeProfileRequestApprovedByNavigations)
                .HasForeignKey(d => d.ApprovedBy)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("fk_employee_profile_requests_approved_by");

            entity.HasOne(d => d.Employee).WithMany(p => p.EmployeeProfileRequests)
                .HasForeignKey(d => d.EmployeeId)
                .HasConstraintName("fk_employee_profile_requests_employee");

            entity.HasOne(d => d.RequestedByNavigation).WithMany(p => p.EmployeeProfileRequestRequestedByNavigations)
                .HasForeignKey(d => d.RequestedBy)
                .HasConstraintName("fk_employee_profile_requests_requested_by");
        });

        modelBuilder.Entity<Expense>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("expenses");

            entity.HasIndex(e => e.ExpenseNumber, "expense_number").IsUnique();

            entity.HasIndex(e => e.ApprovedBy, "fk_expenses_approved_by");

            entity.HasIndex(e => e.EmployeeId, "idx_expenses_employee");

            entity.HasIndex(e => e.ExpenseDate, "idx_expenses_expense_date");

            entity.HasIndex(e => e.FacilityId, "idx_expenses_facility");

            entity.HasIndex(e => e.Status, "idx_expenses_status");

            entity.HasIndex(e => e.VehicleId, "idx_expenses_vehicle");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Amount)
                .HasPrecision(15, 2)
                .HasColumnName("amount");
            entity.Property(e => e.ApprovedAt)
                .HasColumnType("timestamp")
                .HasColumnName("approved_at");
            entity.Property(e => e.ApprovedBy).HasColumnName("approved_by");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.Description)
                .HasColumnType("text")
                .HasColumnName("description");
            entity.Property(e => e.EmployeeId).HasColumnName("employee_id");
            entity.Property(e => e.ExpenseDate).HasColumnName("expense_date");
            entity.Property(e => e.ExpenseNumber)
                .HasMaxLength(50)
                .HasColumnName("expense_number");
            entity.Property(e => e.ExpenseType)
                .HasMaxLength(50)
                .HasColumnName("expense_type");
            entity.Property(e => e.FacilityId).HasColumnName("facility_id");
            entity.Property(e => e.InvoiceNumber)
                .HasMaxLength(100)
                .HasColumnName("invoice_number");
            entity.Property(e => e.Notes)
                .HasColumnType("text")
                .HasColumnName("notes");
            entity.Property(e => e.PaymentDate).HasColumnName("payment_date");
            entity.Property(e => e.PaymentStatus)
                .HasMaxLength(50)
                .HasDefaultValueSql("'Unpaid'")
                .HasColumnName("payment_status");
            entity.Property(e => e.Status)
                .HasDefaultValueSql("'pending'")
                .HasColumnType("enum('pending','approved','rejected','paid')")
                .HasColumnName("status");
            entity.Property(e => e.UpdatedAt)
                .ValueGeneratedOnAddOrUpdate()
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("updated_at");
            entity.Property(e => e.VehicleId).HasColumnName("vehicle_id");

            entity.HasOne(d => d.ApprovedByNavigation).WithMany(p => p.ExpenseApprovedByNavigations)
                .HasForeignKey(d => d.ApprovedBy)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("fk_expenses_approved_by");

            entity.HasOne(d => d.Employee).WithMany(p => p.ExpenseEmployees)
                .HasForeignKey(d => d.EmployeeId)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("fk_expenses_employee");

            entity.HasOne(d => d.Facility).WithMany(p => p.Expenses)
                .HasForeignKey(d => d.FacilityId)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("fk_expenses_facility");

            entity.HasOne(d => d.Vehicle).WithMany(p => p.Expenses)
                .HasForeignKey(d => d.VehicleId)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("fk_expenses_vehicle");
        });

        modelBuilder.Entity<Facility>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("facilities");

            entity.HasIndex(e => e.Code, "code").IsUnique();

            entity.HasIndex(e => e.BranchManagerId, "fk_facilities_branch_manager");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.AddressLine1)
                .HasMaxLength(255)
                .HasColumnName("address_line1");
            entity.Property(e => e.AddressLine2)
                .HasMaxLength(255)
                .HasColumnName("address_line2");
            entity.Property(e => e.BranchManagerId).HasColumnName("branch_manager_id");
            entity.Property(e => e.Capacity)
                .HasPrecision(15, 2)
                .HasColumnName("capacity");
            entity.Property(e => e.City)
                .HasMaxLength(100)
                .HasColumnName("city");
            entity.Property(e => e.Code)
                .HasMaxLength(50)
                .HasColumnName("code");
            entity.Property(e => e.Country)
                .HasMaxLength(100)
                .HasDefaultValueSql("'India'")
                .HasColumnName("country");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.CurrentOccupancy)
                .HasPrecision(15, 2)
                .HasColumnName("current_occupancy");
            entity.Property(e => e.Email)
                .HasMaxLength(255)
                .HasColumnName("email");
            entity.Property(e => e.FacilityType)
                .HasColumnType("enum('Branch','DistributionCenter')")
                .HasColumnName("facility_type");
            entity.Property(e => e.IsActive)
                .HasDefaultValueSql("'1'")
                .HasColumnName("is_active");
            entity.Property(e => e.Name)
                .HasMaxLength(200)
                .HasColumnName("name");
            entity.Property(e => e.Phone)
                .HasMaxLength(20)
                .HasColumnName("phone");
            entity.Property(e => e.Pincode)
                .HasMaxLength(20)
                .HasColumnName("pincode");
            entity.Property(e => e.State)
                .HasMaxLength(100)
                .HasColumnName("state");
            entity.Property(e => e.UpdatedAt)
                .ValueGeneratedOnAddOrUpdate()
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("updated_at");

            entity.HasOne(d => d.BranchManager).WithMany(p => p.Facilities)
                .HasForeignKey(d => d.BranchManagerId)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("fk_facilities_branch_manager");
        });

        modelBuilder.Entity<InsurancePlan>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("insurance_plans");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.Description)
                .HasColumnType("text")
                .HasColumnName("description");
            entity.Property(e => e.FixedCharge)
                .HasPrecision(15, 2)
                .HasDefaultValueSql("'0.00'")
                .HasColumnName("fixed_charge");
            entity.Property(e => e.IsActive)
                .HasDefaultValueSql("'1'")
                .HasColumnName("is_active");
            entity.Property(e => e.MaxCover)
                .HasPrecision(15, 2)
                .HasColumnName("max_cover");
            entity.Property(e => e.MinCover)
                .HasPrecision(15, 2)
                .HasColumnName("min_cover");
            entity.Property(e => e.Name)
                .HasMaxLength(100)
                .HasColumnName("name");
            entity.Property(e => e.RatePercentage)
                .HasPrecision(5, 2)
                .HasColumnName("rate_percentage");
            entity.Property(e => e.UpdatedAt)
                .ValueGeneratedOnAddOrUpdate()
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("updated_at");
        });

        modelBuilder.Entity<Invoice>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("invoices");

            entity.HasIndex(e => e.InvoiceDate, "idx_invoices_invoice_date");

            entity.HasIndex(e => e.ShipmentId, "idx_invoices_shipment");

            entity.HasIndex(e => e.Status, "idx_invoices_status");

            entity.HasIndex(e => e.InvoiceNumber, "invoice_number").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.DiscountAmount)
                .HasPrecision(15, 2)
                .HasDefaultValueSql("'0.00'")
                .HasColumnName("discount_amount");
            entity.Property(e => e.DueDate).HasColumnName("due_date");
            entity.Property(e => e.InvoiceDate).HasColumnName("invoice_date");
            entity.Property(e => e.InvoiceNumber)
                .HasMaxLength(50)
                .HasColumnName("invoice_number");
            entity.Property(e => e.NetAmount)
                .HasPrecision(15, 2)
                .HasColumnName("net_amount");
            entity.Property(e => e.Notes)
                .HasColumnType("text")
                .HasColumnName("notes");
            entity.Property(e => e.ShipmentId).HasColumnName("shipment_id");
            entity.Property(e => e.Status)
                .HasDefaultValueSql("'draft'")
                .HasColumnType("enum('draft','issued','paid','partially_paid','overdue','cancelled')")
                .HasColumnName("status");
            entity.Property(e => e.TotalAmount)
                .HasPrecision(15, 2)
                .HasColumnName("total_amount");
            entity.Property(e => e.UpdatedAt)
                .ValueGeneratedOnAddOrUpdate()
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("updated_at");

            entity.HasOne(d => d.Shipment).WithMany(p => p.Invoices)
                .HasForeignKey(d => d.ShipmentId)
                .HasConstraintName("fk_invoices_shipment");
        });

        modelBuilder.Entity<LoginHistory>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("login_history");

            entity.HasIndex(e => e.LoginTime, "idx_login_history_login_time");

            entity.HasIndex(e => e.UserId, "idx_login_history_user");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.FailureReason)
                .HasColumnType("text")
                .HasColumnName("failure_reason");
            entity.Property(e => e.IpAddress)
                .HasMaxLength(45)
                .HasColumnName("ip_address");
            entity.Property(e => e.LoginStatus)
                .HasMaxLength(50)
                .HasColumnName("login_status");
            entity.Property(e => e.LoginTime)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("login_time");
            entity.Property(e => e.LogoutTime)
                .HasColumnType("timestamp")
                .HasColumnName("logout_time");
            entity.Property(e => e.SessionId)
                .HasMaxLength(100)
                .HasColumnName("session_id");
            entity.Property(e => e.UserAgent)
                .HasColumnType("text")
                .HasColumnName("user_agent");
            entity.Property(e => e.UserId).HasColumnName("user_id");

            entity.HasOne(d => d.User).WithMany(p => p.LoginHistories)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("fk_login_history_user");
        });

        modelBuilder.Entity<ManifestItem>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("manifest_items");

            entity.HasIndex(
                e => e.UnloadedFacilityId,
                "fk_manifest_items_unloaded_facility");

            entity.HasIndex(
                e => e.ManifestId,
                "idx_manifest_items_manifest");

            entity.HasIndex(
                e => e.Status,
                "idx_manifest_items_status");

            entity.HasIndex(
                e => e.TransportOrderId,
                "idx_manifest_items_transport_order");

            entity.HasIndex(
                e => new { e.ManifestId, e.TransportOrderId },
                "unique_manifest_transport_order")
                .IsUnique();

            entity.Property(e => e.Id)
                .HasColumnName("id");

            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");

            entity.Property(e => e.LoadedAt)
                .HasColumnType("timestamp")
                .HasColumnName("loaded_at");

            entity.Property(e => e.LoadingSequence)
                .HasColumnName("loading_sequence");

            entity.Property(e => e.ManifestId)
                .HasColumnName("manifest_id");

            entity.Property(e => e.Notes)
                .HasColumnType("text")
                .HasColumnName("notes");

            entity.Property(e => e.Status)
                .HasMaxLength(50)
                .HasDefaultValueSql("'planned'")
                .HasColumnName("status");

            entity.Property(e => e.TransportOrderId)
                .HasColumnName("transport_order_id");

            entity.Property(e => e.UnloadedAt)
                .HasColumnType("timestamp")
                .HasColumnName("unloaded_at");

            entity.Property(e => e.UnloadedFacilityId)
                .HasColumnName("unloaded_facility_id");

            entity.Property(e => e.UpdatedAt)
                .ValueGeneratedOnAddOrUpdate()
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("updated_at");
            entity.Property(e => e.Weight)
                .HasPrecision(15, 2)
                .HasColumnName("weight");

            entity.HasOne(d => d.Manifest)
                .WithMany(p => p.ManifestItems)
                .HasForeignKey(d => d.ManifestId)
                .HasConstraintName("fk_manifest_items_manifest");

            entity.HasOne(d => d.TransportOrder)
                .WithMany(p => p.ManifestItems)
                .HasForeignKey(d => d.TransportOrderId)
                .HasConstraintName("fk_manifest_items_transport_order");

            entity.HasOne(d => d.UnloadedFacility)
                .WithMany(p => p.ManifestItems)
                .HasForeignKey(d => d.UnloadedFacilityId)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("fk_manifest_items_unloaded_facility");
        });

        modelBuilder.Entity<Notification>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("notifications");

            entity.HasIndex(e => e.CustomerId, "idx_notifications_customer");

            entity.HasIndex(e => e.Status, "idx_notifications_status");

            entity.HasIndex(e => e.TrackingEventId, "idx_notifications_tracking_event");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Content)
                .HasColumnType("text")
                .HasColumnName("content");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.CustomerId).HasColumnName("customer_id");
            entity.Property(e => e.NotificationType)
                .HasMaxLength(50)
                .HasColumnName("notification_type");
            entity.Property(e => e.ReadAt)
                .HasColumnType("timestamp")
                .HasColumnName("read_at");
            entity.Property(e => e.Recipient)
                .HasMaxLength(255)
                .HasColumnName("recipient");
            entity.Property(e => e.SentAt)
                .HasColumnType("timestamp")
                .HasColumnName("sent_at");
            entity.Property(e => e.Status)
                .HasDefaultValueSql("'pending'")
                .HasColumnType("enum('pending','sent','failed','read')")
                .HasColumnName("status");
            entity.Property(e => e.Subject)
                .HasMaxLength(255)
                .HasColumnName("subject");
            entity.Property(e => e.TrackingEventId).HasColumnName("tracking_event_id");
            entity.Property(e => e.UpdatedAt)
                .ValueGeneratedOnAddOrUpdate()
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("updated_at");

            entity.HasOne(d => d.Customer).WithMany(p => p.Notifications)
                .HasForeignKey(d => d.CustomerId)
                .HasConstraintName("fk_notifications_customer");

            entity.HasOne(d => d.TrackingEvent).WithMany(p => p.Notifications)
                .HasForeignKey(d => d.TrackingEventId)
                .HasConstraintName("fk_notifications_tracking_event");
        });

        modelBuilder.Entity<PackageScan>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("package_scans");

            entity.HasIndex(e => e.VehicleId, "fk_package_scans_vehicle");

            entity.HasIndex(e => e.EmployeeId, "idx_package_scans_employee");

            entity.HasIndex(e => e.FacilityId, "idx_package_scans_facility");

            entity.HasIndex(e => e.ScanTime, "idx_package_scans_scan_time");

            entity.HasIndex(e => e.ShipmentId, "idx_package_scans_shipment");

            entity.HasIndex(e => e.ScanNumber, "scan_number").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.EmployeeId).HasColumnName("employee_id");
            entity.Property(e => e.FacilityId).HasColumnName("facility_id");
            entity.Property(e => e.ManifestItemId)
                .HasColumnType("char(36)")
                .HasCharSet("utf8mb4")
                .UseCollation("utf8mb4_0900_ai_ci")
                .HasColumnName("manifest_item_id");
            entity.Property(e => e.IpAddress)
                .HasMaxLength(45)
                .HasColumnName("ip_address");
            entity.Property(e => e.Latitude)
                .HasPrecision(10, 8)
                .HasColumnName("latitude");
            entity.Property(e => e.LocationType)
                .HasColumnType("enum('branch','distribution_center','vehicle')")
                .HasColumnName("location_type");
            entity.Property(e => e.Longitude)
                .HasPrecision(11, 8)
                .HasColumnName("longitude");
            entity.Property(e => e.Notes)
                .HasColumnType("text")
                .HasColumnName("notes");
            entity.Property(e => e.ScanNumber)
                .HasMaxLength(50)
                .HasColumnName("scan_number");
            entity.Property(e => e.ScanTime)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("scan_time");
            entity.Property(e => e.ScanType)
                .HasMaxLength(50)
                .HasColumnName("scan_type");
            entity.Property(e => e.ShipmentId).HasColumnName("shipment_id");
            entity.Property(e => e.VehicleId).HasColumnName("vehicle_id");
            entity.HasOne(d => d.ManifestItem)
            .WithMany()
            .HasForeignKey(d => d.ManifestItemId)
            .OnDelete(DeleteBehavior.SetNull)
            .HasConstraintName("fk_package_scans_manifest_item");
            entity.HasOne(d => d.Employee).WithMany(p => p.PackageScans)
                .HasForeignKey(d => d.EmployeeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_package_scans_employee");

            entity.HasOne(d => d.Facility).WithMany(p => p.PackageScans)
                .HasForeignKey(d => d.FacilityId)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("fk_package_scans_facility");

            entity.HasOne(d => d.Shipment).WithMany(p => p.PackageScans)
                .HasForeignKey(d => d.ShipmentId)
                .HasConstraintName("fk_package_scans_shipment");

            entity.HasOne(d => d.Vehicle).WithMany(p => p.PackageScans)
                .HasForeignKey(d => d.VehicleId)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("fk_package_scans_vehicle");
        });

        modelBuilder.Entity<Payment>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("payments");

            entity.HasIndex(e => e.CustomerId, "idx_payments_customer");

            entity.HasIndex(e => e.InvoiceId, "idx_payments_invoice");

            entity.HasIndex(e => e.PaymentStatus, "idx_payments_status");

            entity.HasIndex(e => e.PaymentNumber, "payment_number").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Amount)
                .HasPrecision(15, 2)
                .HasColumnName("amount");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.CustomerId).HasColumnName("customer_id");
            entity.Property(e => e.InvoiceId).HasColumnName("invoice_id");
            entity.Property(e => e.Notes)
                .HasColumnType("text")
                .HasColumnName("notes");
            entity.Property(e => e.PaymentDate)
                .HasColumnType("timestamp")
                .HasColumnName("payment_date");
            entity.Property(e => e.PaymentMethod)
                .HasColumnType("enum('cash','card','online','vpp')")
                .HasColumnName("payment_method");
            entity.Property(e => e.PaymentNumber)
                .HasMaxLength(50)
                .HasColumnName("payment_number");
            entity.Property(e => e.PaymentStatus)
                .HasDefaultValueSql("'pending'")
                .HasColumnType("enum('pending','completed','failed','refunded')")
                .HasColumnName("payment_status");
            entity.Property(e => e.ReferenceNumber)
                .HasMaxLength(100)
                .HasColumnName("reference_number");
            entity.Property(e => e.TransactionId)
                .HasMaxLength(100)
                .HasColumnName("transaction_id");
            entity.Property(e => e.UpdatedAt)
                .ValueGeneratedOnAddOrUpdate()
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("updated_at");

            entity.HasOne(d => d.Customer).WithMany(p => p.Payments)
                .HasForeignKey(d => d.CustomerId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_payments_customer");

            entity.HasOne(d => d.Invoice).WithMany(p => p.Payments)
                .HasForeignKey(d => d.InvoiceId)
                .HasConstraintName("fk_payments_invoice");
        });

        modelBuilder.Entity<Permission>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("permissions");

            entity.HasIndex(e => e.Name, "name").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Action)
                .HasMaxLength(50)
                .HasColumnName("action");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.Description)
                .HasMaxLength(255)
                .HasColumnName("description");
            entity.Property(e => e.Name)
                .HasMaxLength(100)
                .HasColumnName("name");
            entity.Property(e => e.Resource)
                .HasMaxLength(100)
                .HasColumnName("resource");
        });

        modelBuilder.Entity<Pincode>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("pincodes");

            entity.HasIndex(e => e.FacilityId, "fk_pincodes_facility");

            entity.HasIndex(e => e.Pincode1, "pincode").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.City)
                .HasMaxLength(100)
                .HasColumnName("city");
            entity.Property(e => e.Country)
                .HasMaxLength(100)
                .HasDefaultValueSql("'India'")
                .HasColumnName("country");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.FacilityId).HasColumnName("facility_id");
            entity.Property(e => e.Latitude)
                .HasPrecision(10, 8)
                .HasColumnName("latitude");
            entity.Property(e => e.Longitude)
                .HasPrecision(11, 8)
                .HasColumnName("longitude");
            entity.Property(e => e.Pincode1)
                .HasMaxLength(20)
                .HasColumnName("pincode");
            entity.Property(e => e.Serviceable)
                .HasDefaultValueSql("'1'")
                .HasColumnName("serviceable");
            entity.Property(e => e.State)
                .HasMaxLength(100)
                .HasColumnName("state");
            entity.Property(e => e.UpdatedAt)
                .ValueGeneratedOnAddOrUpdate()
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("updated_at");

            entity.HasOne(d => d.Facility).WithMany(p => p.Pincodes)
                .HasForeignKey(d => d.FacilityId)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("fk_pincodes_facility");
        });

        modelBuilder.Entity<Position>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("positions");

            entity.HasIndex(e => e.Name, "name").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.Description)
                .HasMaxLength(255)
                .HasColumnName("description");
            entity.Property(e => e.IsActive)
                .HasDefaultValueSql("'1'")
                .HasColumnName("is_active");
            entity.Property(e => e.Name)
                .HasMaxLength(100)
                .HasColumnName("name");
        });

        modelBuilder.Entity<PricingRule>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("pricing_rules");

            entity.HasIndex(e => e.ServiceId, "fk_pricing_rules_service");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.CalculationType)
                .HasMaxLength(50)
                .HasColumnName("calculation_type");
            entity.Property(e => e.ConditionExpression)
                .HasColumnType("text")
                .HasColumnName("condition_expression");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.IsActive)
                .HasDefaultValueSql("'1'")
                .HasColumnName("is_active");
            entity.Property(e => e.MaxValue)
                .HasPrecision(15, 2)
                .HasColumnName("max_value");
            entity.Property(e => e.MinValue)
                .HasPrecision(15, 2)
                .HasColumnName("min_value");
            entity.Property(e => e.Name)
                .HasMaxLength(100)
                .HasColumnName("name");
            entity.Property(e => e.Priority)
                .HasDefaultValueSql("'0'")
                .HasColumnName("priority");
            entity.Property(e => e.Rate)
                .HasPrecision(15, 4)
                .HasColumnName("rate");
            entity.Property(e => e.RuleType)
                .HasMaxLength(50)
                .HasColumnName("rule_type");
            entity.Property(e => e.ServiceId).HasColumnName("service_id");
            entity.Property(e => e.UpdatedAt)
                .ValueGeneratedOnAddOrUpdate()
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("updated_at");

            entity.HasOne(d => d.Service).WithMany(p => p.PricingRules)
                .HasForeignKey(d => d.ServiceId)
                .HasConstraintName("fk_pricing_rules_service");
        });

        modelBuilder.Entity<ProofOfDelivery>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("proof_of_delivery");

            entity.HasIndex(e => e.DeliveryAttemptId, "fk_proof_of_delivery_attempt");

            entity.HasIndex(e => e.ShipmentId, "idx_proof_of_delivery_shipment").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.DeliveryAttemptId).HasColumnName("delivery_attempt_id");
            entity.Property(e => e.DeliveryPhoto)
                .HasColumnType("text")
                .HasColumnName("delivery_photo");
            entity.Property(e => e.DeliveryTime)
                .HasColumnType("timestamp")
                .HasColumnName("delivery_time");
            entity.Property(e => e.GpsAccuracy)
                .HasPrecision(5, 2)
                .HasColumnName("gps_accuracy");
            entity.Property(e => e.Latitude)
                .HasPrecision(10, 8)
                .HasColumnName("latitude");
            entity.Property(e => e.Longitude)
                .HasPrecision(11, 8)
                .HasColumnName("longitude");
            entity.Property(e => e.Notes)
                .HasColumnType("text")
                .HasColumnName("notes");
            entity.Property(e => e.ReceiverName)
                .HasMaxLength(200)
                .HasColumnName("receiver_name");
            entity.Property(e => e.ReceiverRelation)
                .HasMaxLength(100)
                .HasColumnName("receiver_relation");
            entity.Property(e => e.ReceiverSignature)
                .HasColumnType("text")
                .HasColumnName("receiver_signature");
            entity.Property(e => e.ShipmentId).HasColumnName("shipment_id");

            entity.HasOne(d => d.DeliveryAttempt).WithMany(p => p.ProofOfDeliveries)
                .HasForeignKey(d => d.DeliveryAttemptId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_proof_of_delivery_attempt");

            entity.HasOne(d => d.Shipment).WithOne(p => p.ProofOfDelivery)
                .HasForeignKey<ProofOfDelivery>(d => d.ShipmentId)
                .HasConstraintName("fk_proof_of_delivery_shipment");
        });

        modelBuilder.Entity<Role>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("roles");

            entity.HasIndex(e => e.Name, "name").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.Description)
                .HasMaxLength(255)
                .HasColumnName("description");
            entity.Property(e => e.IsSystem)
                .HasDefaultValueSql("'0'")
                .HasColumnName("is_system");
            entity.Property(e => e.Name)
                .HasMaxLength(50)
                .HasColumnName("name");
            entity.Property(e => e.UpdatedAt)
                .ValueGeneratedOnAddOrUpdate()
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("updated_at");
        });

        modelBuilder.Entity<RolePermission>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("role_permissions");

            entity.HasIndex(e => e.PermissionId, "fk_role_permissions_permission");

            entity.HasIndex(e => new { e.RoleId, e.PermissionId }, "unique_role_permission").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.PermissionId).HasColumnName("permission_id");
            entity.Property(e => e.RoleId).HasColumnName("role_id");

            entity.HasOne(d => d.Permission).WithMany(p => p.RolePermissions)
                .HasForeignKey(d => d.PermissionId)
                .HasConstraintName("fk_role_permissions_permission");

            entity.HasOne(d => d.Role).WithMany(p => p.RolePermissions)
                .HasForeignKey(d => d.RoleId)
                .HasConstraintName("fk_role_permissions_role");
        });

        modelBuilder.Entity<Route>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("routes");

            entity.HasIndex(e => e.DestinationFacilityId, "idx_routes_destination_facility");

            entity.HasIndex(e => e.OriginFacilityId, "idx_routes_origin_facility");

            entity.HasIndex(e => e.RouteCode, "route_code").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.DestinationFacilityId).HasColumnName("destination_facility_id");
            entity.Property(e => e.Distance)
                .HasPrecision(10, 2)
                .HasColumnName("distance");
            entity.Property(e => e.EstimatedDuration).HasColumnName("estimated_duration");
            entity.Property(e => e.IsActive)
                .HasDefaultValueSql("'1'")
                .HasColumnName("is_active");
            entity.Property(e => e.Name)
                .HasMaxLength(200)
                .HasColumnName("name");
            entity.Property(e => e.OriginFacilityId).HasColumnName("origin_facility_id");
            entity.Property(e => e.RouteCode)
                .HasMaxLength(50)
                .HasColumnName("route_code");
            entity.Property(e => e.UpdatedAt)
                .ValueGeneratedOnAddOrUpdate()
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("updated_at");

            entity.HasOne(d => d.DestinationFacility).WithMany(p => p.RouteDestinationFacilities)
                .HasForeignKey(d => d.DestinationFacilityId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_routes_destination_facility");

            entity.HasOne(d => d.OriginFacility).WithMany(p => p.RouteOriginFacilities)
                .HasForeignKey(d => d.OriginFacilityId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_routes_origin_facility");
        });

        modelBuilder.Entity<RouteStop>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("route_stops");

            entity.HasIndex(e => e.FacilityId, "idx_route_stops_facility");

            entity.HasIndex(e => e.RouteId, "idx_route_stops_route");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.EstimatedArrival).HasColumnName("estimated_arrival");
            entity.Property(e => e.EstimatedDeparture).HasColumnName("estimated_departure");
            entity.Property(e => e.FacilityId).HasColumnName("facility_id");
            entity.Property(e => e.IsActive)
                .HasDefaultValueSql("'1'")
                .HasColumnName("is_active");
            entity.Property(e => e.Latitude)
                .HasPrecision(10, 8)
                .HasColumnName("latitude");
            entity.Property(e => e.Longitude)
                .HasPrecision(11, 8)
                .HasColumnName("longitude");
            entity.Property(e => e.Pincode)
                .HasMaxLength(20)
                .HasColumnName("pincode");
            entity.Property(e => e.RouteId).HasColumnName("route_id");
            entity.Property(e => e.StopName)
                .HasMaxLength(200)
                .HasColumnName("stop_name");
            entity.Property(e => e.StopSequence).HasColumnName("stop_sequence");
            entity.Property(e => e.UpdatedAt)
                .ValueGeneratedOnAddOrUpdate()
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("updated_at");

            entity.HasOne(d => d.Facility).WithMany(p => p.RouteStops)
                .HasForeignKey(d => d.FacilityId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_route_stops_facility");

            entity.HasOne(d => d.Route).WithMany(p => p.RouteStops)
                .HasForeignKey(d => d.RouteId)
                .HasConstraintName("fk_route_stops_route");
        });

        modelBuilder.Entity<Service>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("services");

            entity.HasIndex(e => e.Code, "code").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Code)
                .HasMaxLength(50)
                .HasColumnName("code");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.Description)
                .HasColumnType("text")
                .HasColumnName("description");
            entity.Property(e => e.IsActive)
                .HasDefaultValueSql("'1'")
                .HasColumnName("is_active");
            entity.Property(e => e.Name)
                .HasMaxLength(100)
                .HasColumnName("name");
            entity.Property(e => e.ServiceType)
                .HasMaxLength(50)
                .HasColumnName("service_type");
            entity.Property(e => e.UpdatedAt)
                .ValueGeneratedOnAddOrUpdate()
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("updated_at");
        });

        modelBuilder.Entity<Shipment>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("shipments");

            entity.HasIndex(e => e.InsurancePlanId, "fk_shipments_insurance");

            entity.HasIndex(e => e.ReceiverAddressId, "fk_shipments_receiver_address");

            entity.HasIndex(e => e.ShipmentRequestId, "fk_shipments_request");

            entity.HasIndex(e => e.SenderAddressId, "fk_shipments_sender_address");

            entity.HasIndex(e => e.ServiceId, "fk_shipments_service");

            entity.HasIndex(e => e.CreatedAt, "idx_shipments_created_at");

            entity.HasIndex(e => e.CustomerId, "idx_shipments_customer");

            entity.HasIndex(e => e.EstimatedDelivery, "idx_shipments_estimated_delivery");

            entity.HasIndex(e => e.CurrentStatus, "idx_shipments_status");

            entity.HasIndex(e => e.TrackingNumber, "idx_shipments_tracking").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.ActualDelivery)
                .HasColumnType("timestamp")
                .HasColumnName("actual_delivery");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.CurrentStatus)
                .HasDefaultValueSql("'created'")
                .HasColumnType("enum('created','pickup_scheduled','in_sorting','loaded','in_transit','out_for_delivery','delivered','exception','cancelled')")
                .HasColumnName("current_status");
            entity.Property(e => e.CustomerId).HasColumnName("customer_id");
            entity.Property(e => e.DeclaredValue)
                .HasPrecision(15, 2)
                .HasColumnName("declared_value");
            entity.Property(e => e.EstimatedDelivery).HasColumnName("estimated_delivery");
            entity.Property(e => e.Height)
                .HasPrecision(10, 2)
                .HasColumnName("height");
            entity.Property(e => e.InsuranceAmount)
                .HasPrecision(15, 2)
                .HasColumnName("insurance_amount");
            entity.Property(e => e.InsurancePlanId).HasColumnName("insurance_plan_id");
            entity.Property(e => e.IsActive)
                .HasDefaultValueSql("'1'")
                .HasColumnName("is_active");
            entity.Property(e => e.IsFragile)
                .HasDefaultValueSql("'0'")
                .HasColumnName("is_fragile");
            entity.Property(e => e.IsLarge)
                .HasDefaultValueSql("'0'")
                .HasColumnName("is_large");
            entity.Property(e => e.Length)
                .HasPrecision(10, 2)
                .HasColumnName("length");
            entity.Property(e => e.PackageType)
                .HasMaxLength(50)
                .HasColumnName("package_type");
            entity.Property(e => e.ReceiverAddressId).HasColumnName("receiver_address_id");
            entity.Property(e => e.SenderAddressId).HasColumnName("sender_address_id");
            entity.Property(e => e.ServiceId).HasColumnName("service_id");
            entity.Property(e => e.ShipmentRequestId).HasColumnName("shipment_request_id");
            entity.Property(e => e.SpecialInstructions)
                .HasColumnType("text")
                .HasColumnName("special_instructions");
            entity.Property(e => e.TrackingNumber)
                .HasMaxLength(50)
                .HasColumnName("tracking_number");
            entity.Property(e => e.UpdatedAt)
                .ValueGeneratedOnAddOrUpdate()
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("updated_at");
            entity.Property(e => e.Weight)
                .HasPrecision(10, 3)
                .HasColumnName("weight");
            entity.Property(e => e.Width)
                .HasPrecision(10, 2)
                .HasColumnName("width");

            entity.HasOne(d => d.Customer).WithMany(p => p.Shipments)
                .HasForeignKey(d => d.CustomerId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_shipments_customer");

            entity.HasOne(d => d.InsurancePlan).WithMany(p => p.Shipments)
                .HasForeignKey(d => d.InsurancePlanId)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("fk_shipments_insurance");

            entity.HasOne(d => d.ReceiverAddress).WithMany(p => p.ShipmentReceiverAddresses)
                .HasForeignKey(d => d.ReceiverAddressId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_shipments_receiver_address");

            entity.HasOne(d => d.SenderAddress).WithMany(p => p.ShipmentSenderAddresses)
                .HasForeignKey(d => d.SenderAddressId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_shipments_sender_address");

            entity.HasOne(d => d.Service).WithMany(p => p.Shipments)
                .HasForeignKey(d => d.ServiceId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_shipments_service");

            entity.HasOne(d => d.ShipmentRequest).WithMany(p => p.Shipments)
                .HasForeignKey(d => d.ShipmentRequestId)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("fk_shipments_request");
        });

        modelBuilder.Entity<ShipmentCharge>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("shipment_charges");

            entity.HasIndex(e => e.InvoiceId, "idx_shipment_charges_invoice");

            entity.HasIndex(e => e.ShipmentId, "idx_shipment_charges_shipment");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Amount)
                .HasPrecision(15, 2)
                .HasColumnName("amount");
            entity.Property(e => e.CalculationReference)
                .HasMaxLength(255)
                .HasColumnName("calculation_reference");
            entity.Property(e => e.ChargeType)
                .HasMaxLength(50)
                .HasColumnName("charge_type");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.Description)
                .HasMaxLength(255)
                .HasColumnName("description");
            entity.Property(e => e.InvoiceId).HasColumnName("invoice_id");
            entity.Property(e => e.ShipmentId).HasColumnName("shipment_id");

            entity.HasOne(d => d.Invoice).WithMany(p => p.ShipmentCharges)
                .HasForeignKey(d => d.InvoiceId)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("fk_shipment_charges_invoice");

            entity.HasOne(d => d.Shipment).WithMany(p => p.ShipmentCharges)
                .HasForeignKey(d => d.ShipmentId)
                .HasConstraintName("fk_shipment_charges_shipment");
        });

        modelBuilder.Entity<ShipmentContact>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("shipment_contacts");

            entity.HasIndex(e => e.ShipmentId, "idx_shipment_contacts_shipment");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.AddressLine1)
                .HasMaxLength(255)
                .HasColumnName("address_line1");
            entity.Property(e => e.AddressLine2)
                .HasMaxLength(255)
                .HasColumnName("address_line2");
            entity.Property(e => e.City)
                .HasMaxLength(100)
                .HasColumnName("city");
            entity.Property(e => e.ContactType)
                .HasColumnType("enum('sender','receiver')")
                .HasColumnName("contact_type");
            entity.Property(e => e.Country)
                .HasMaxLength(100)
                .HasDefaultValueSql("'India'")
                .HasColumnName("country");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.Landmark)
                .HasMaxLength(255)
                .HasColumnName("landmark");
            entity.Property(e => e.Name)
                .HasMaxLength(200)
                .HasColumnName("name");
            entity.Property(e => e.Phone)
                .HasMaxLength(20)
                .HasColumnName("phone");
            entity.Property(e => e.Pincode)
                .HasMaxLength(20)
                .HasColumnName("pincode");
            entity.Property(e => e.ShipmentId).HasColumnName("shipment_id");
            entity.Property(e => e.State)
                .HasMaxLength(100)
                .HasColumnName("state");

            entity.HasOne(d => d.Shipment).WithMany(p => p.ShipmentContacts)
                .HasForeignKey(d => d.ShipmentId)
                .HasConstraintName("fk_shipment_contacts_shipment");
        });

        modelBuilder.Entity<ShipmentManifest>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("shipment_manifests");

            entity.HasIndex(e => e.DepartureFacilityId, "fk_shipment_manifests_departure_facility");

            entity.HasIndex(e => e.DepartureTime, "idx_shipment_manifests_departure");

            entity.HasIndex(e => e.DriverId, "idx_shipment_manifests_driver");

            entity.HasIndex(e => e.RouteId, "idx_shipment_manifests_route");

            entity.HasIndex(e => e.Status, "idx_shipment_manifests_status");

            entity.HasIndex(e => e.VehicleId, "idx_shipment_manifests_vehicle");

            entity.HasIndex(e => e.ManifestNumber, "manifest_number").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.ArrivalTime)
                .HasColumnType("timestamp")
                .HasColumnName("arrival_time");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.DepartureFacilityId).HasColumnName("departure_facility_id");
            entity.Property(e => e.DepartureTime)
                .HasColumnType("timestamp")
                .HasColumnName("departure_time");
            entity.Property(e => e.DriverId).HasColumnName("driver_id");
            entity.Property(e => e.ManifestNumber)
                .HasMaxLength(50)
                .HasColumnName("manifest_number");
            entity.Property(e => e.Notes)
                .HasColumnType("text")
                .HasColumnName("notes");
            entity.Property(e => e.RouteId).HasColumnName("route_id");
            entity.Property(e => e.Status)
                .HasDefaultValueSql("'planned'")
                .HasColumnType("enum('planned','in_progress','completed','delayed','cancelled')")
                .HasColumnName("status");
            entity.Property(e => e.TotalPackages)
                .HasDefaultValueSql("'0'")
                .HasColumnName("total_packages");
            entity.Property(e => e.TotalWeight)
                .HasPrecision(15, 2)
                .HasDefaultValueSql("'0.00'")
                .HasColumnName("total_weight");
            entity.Property(e => e.UpdatedAt)
                .ValueGeneratedOnAddOrUpdate()
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("updated_at");
            entity.Property(e => e.VehicleId).HasColumnName("vehicle_id");

            entity.HasOne(d => d.DepartureFacility).WithMany(p => p.ShipmentManifests)
                .HasForeignKey(d => d.DepartureFacilityId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_shipment_manifests_departure_facility");

            entity.HasOne(d => d.Driver).WithMany(p => p.ShipmentManifests)
                .HasForeignKey(d => d.DriverId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_shipment_manifests_driver");

            entity.HasOne(d => d.Route).WithMany(p => p.ShipmentManifests)
                .HasForeignKey(d => d.RouteId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_shipment_manifests_route");

            entity.HasOne(d => d.Vehicle).WithMany(p => p.ShipmentManifests)
                .HasForeignKey(d => d.VehicleId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_shipment_manifests_vehicle");
        });

        modelBuilder.Entity<ShipmentRequest>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("shipment_requests");

            entity.HasIndex(e => e.ApprovedBy, "fk_shipment_requests_approved_by");

            entity.HasIndex(e => e.InsurancePlanId, "fk_shipment_requests_insurance");

            entity.HasIndex(e => e.ReceiverAddressId, "fk_shipment_requests_receiver_address");

            entity.HasIndex(e => e.SenderAddressId, "fk_shipment_requests_sender_address");

            entity.HasIndex(e => e.ServiceId, "fk_shipment_requests_service");

            entity.HasIndex(e => e.CreatedAt, "idx_shipment_requests_created_at");

            entity.HasIndex(e => e.CustomerId, "idx_shipment_requests_customer");

            entity.HasIndex(e => e.Status, "idx_shipment_requests_status");

            entity.HasIndex(e => e.RequestNumber, "request_number").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.ApprovedAt)
                .HasColumnType("timestamp")
                .HasColumnName("approved_at");
            entity.Property(e => e.ApprovedBy).HasColumnName("approved_by");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.CustomerId).HasColumnName("customer_id");
            entity.Property(e => e.DeclaredValue)
                .HasPrecision(15, 2)
                .HasColumnName("declared_value");
            entity.Property(e => e.EstimatedCost)
                .HasPrecision(15, 2)
                .HasColumnName("estimated_cost");
            entity.Property(e => e.Height)
                .HasPrecision(10, 2)
                .HasColumnName("height");
            entity.Property(e => e.InsurancePlanId).HasColumnName("insurance_plan_id");
            entity.Property(e => e.IsFragile)
                .HasDefaultValueSql("'0'")
                .HasColumnName("is_fragile");
            entity.Property(e => e.IsLarge)
                .HasDefaultValueSql("'0'")
                .HasColumnName("is_large");
            entity.Property(e => e.Length)
                .HasPrecision(10, 2)
                .HasColumnName("length");
            entity.Property(e => e.PackageType)
                .HasMaxLength(50)
                .HasColumnName("package_type");
            entity.Property(e => e.ReceiverAddressId).HasColumnName("receiver_address_id");
            entity.Property(e => e.RejectionReason)
                .HasColumnType("text")
                .HasColumnName("rejection_reason");
            entity.Property(e => e.RequestNumber)
                .HasMaxLength(50)
                .HasColumnName("request_number");
            entity.Property(e => e.SenderAddressId).HasColumnName("sender_address_id");
            entity.Property(e => e.ServiceId).HasColumnName("service_id");
            entity.Property(e => e.SpecialInstructions)
                .HasColumnType("text")
                .HasColumnName("special_instructions");
            entity.Property(e => e.Status)
                .HasDefaultValueSql("'pending'")
                .HasColumnType("enum('pending','approved','rejected')")
                .HasColumnName("status");
            entity.Property(e => e.UpdatedAt)
                .ValueGeneratedOnAddOrUpdate()
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("updated_at");
            entity.Property(e => e.Weight)
                .HasPrecision(10, 3)
                .HasColumnName("weight");
            entity.Property(e => e.Width)
                .HasPrecision(10, 2)
                .HasColumnName("width");

            entity.HasOne(d => d.ApprovedByNavigation).WithMany(p => p.ShipmentRequests)
                .HasForeignKey(d => d.ApprovedBy)
                .HasConstraintName("fk_shipment_requests_approved_by");

            entity.HasOne(d => d.Customer).WithMany(p => p.ShipmentRequests)
                .HasForeignKey(d => d.CustomerId)
                .HasConstraintName("fk_shipment_requests_customer");

            entity.HasOne(d => d.InsurancePlan).WithMany(p => p.ShipmentRequests)
                .HasForeignKey(d => d.InsurancePlanId)
                .HasConstraintName("fk_shipment_requests_insurance");

            entity.HasOne(d => d.ReceiverAddress).WithMany(p => p.ShipmentRequestReceiverAddresses)
                .HasForeignKey(d => d.ReceiverAddressId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_shipment_requests_receiver_address");

            entity.HasOne(d => d.SenderAddress).WithMany(p => p.ShipmentRequestSenderAddresses)
                .HasForeignKey(d => d.SenderAddressId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_shipment_requests_sender_address");

            entity.HasOne(d => d.Service).WithMany(p => p.ShipmentRequests)
                .HasForeignKey(d => d.ServiceId)
                .HasConstraintName("fk_shipment_requests_service");
        });

        modelBuilder.Entity<ShipmentStatusHistory>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("shipment_status_history");

            entity.HasIndex(e => e.ChangedBy, "fk_shipment_status_history_changed_by");

            entity.HasIndex(e => e.ChangedAt, "idx_shipment_status_history_changed_at");

            entity.HasIndex(e => e.ShipmentId, "idx_shipment_status_history_shipment");

            entity.HasIndex(e => e.Status, "idx_shipment_status_history_status");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.ChangedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("changed_at");
            entity.Property(e => e.ChangedBy).HasColumnName("changed_by");
            entity.Property(e => e.Notes)
                .HasColumnType("text")
                .HasColumnName("notes");
            entity.Property(e => e.ShipmentId).HasColumnName("shipment_id");
            entity.Property(e => e.Status)
                .HasColumnType("enum('created','pickup_scheduled','in_sorting','loaded','in_transit','out_for_delivery','delivered','exception','cancelled')")
                .HasColumnName("status");

            entity.HasOne(d => d.ChangedByNavigation).WithMany(p => p.ShipmentStatusHistories)
                .HasForeignKey(d => d.ChangedBy)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("fk_shipment_status_history_changed_by");

            entity.HasOne(d => d.Shipment).WithMany(p => p.ShipmentStatusHistories)
                .HasForeignKey(d => d.ShipmentId)
                .HasConstraintName("fk_shipment_status_history_shipment");
        });

        modelBuilder.Entity<StorageArea>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("storage_areas");

            entity.HasIndex(e => e.FacilityId, "fk_storage_areas_facility");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Capacity)
                .HasPrecision(15, 2)
                .HasColumnName("capacity");
            entity.Property(e => e.Container)
                .HasMaxLength(50)
                .HasColumnName("container");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.CurrentOccupancy)
                .HasPrecision(15, 2)
                .HasColumnName("current_occupancy");
            entity.Property(e => e.FacilityId).HasColumnName("facility_id");
            entity.Property(e => e.IsActive)
                .HasDefaultValueSql("'1'")
                .HasColumnName("is_active");
            entity.Property(e => e.Shelf)
                .HasMaxLength(50)
                .HasColumnName("shelf");
            entity.Property(e => e.UpdatedAt)
                .ValueGeneratedOnAddOrUpdate()
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("updated_at");
            entity.Property(e => e.ZoneCode)
                .HasMaxLength(50)
                .HasColumnName("zone_code");

            entity.HasOne(d => d.Facility).WithMany(p => p.StorageAreas)
                .HasForeignKey(d => d.FacilityId)
                .HasConstraintName("fk_storage_areas_facility");
        });

        modelBuilder.Entity<TrackingEvent>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("tracking_events");

            entity.HasIndex(e => e.PackageScanId, "fk_tracking_events_package_scan");

            entity.HasIndex(e => e.ShipmentId, "idx_tracking_events_shipment");

            entity.HasIndex(e => e.TrackingStatusId, "idx_tracking_events_status");

            entity.HasIndex(e => e.EventTime, "idx_tracking_events_time");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.EventLocation)
                .HasMaxLength(255)
                .HasColumnName("event_location");
            entity.Property(e => e.EventTime)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("event_time");
            entity.Property(e => e.IsPublic)
                .HasDefaultValueSql("'1'")
                .HasColumnName("is_public");
            entity.Property(e => e.PackageScanId).HasColumnName("package_scan_id");
            entity.Property(e => e.ShipmentId).HasColumnName("shipment_id");
            entity.Property(e => e.TrackingStatusId).HasColumnName("tracking_status_id");

            entity.HasOne(d => d.PackageScan).WithMany(p => p.TrackingEvents)
                .HasForeignKey(d => d.PackageScanId)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("fk_tracking_events_package_scan");

            entity.HasOne(d => d.Shipment).WithMany(p => p.TrackingEvents)
                .HasForeignKey(d => d.ShipmentId)
                .HasConstraintName("fk_tracking_events_shipment");

            entity.HasOne(d => d.TrackingStatus).WithMany(p => p.TrackingEvents)
                .HasForeignKey(d => d.TrackingStatusId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_tracking_events_status");
        });

        modelBuilder.Entity<TrackingStatus>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("tracking_status");

            entity.HasIndex(e => e.Code, "code").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Code)
                .HasMaxLength(50)
                .HasColumnName("code");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.Description)
                .HasColumnType("text")
                .HasColumnName("description");
            entity.Property(e => e.IsPublic)
                .HasDefaultValueSql("'1'")
                .HasColumnName("is_public");
        });

        modelBuilder.Entity<TransportOrder>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("transport_orders");

            entity.HasIndex(e => e.CreatedBy, "fk_transport_orders_created_by");

            entity.HasIndex(e => e.AssignedDriverId, "idx_transport_orders_assigned_driver");

            entity.HasIndex(e => e.AssignedVehicleId, "idx_transport_orders_assigned_vehicle");

            entity.HasIndex(e => e.PlannedDeparture, "idx_transport_orders_planned_departure");

            entity.HasIndex(e => e.ShipmentId, "idx_transport_orders_shipment");

            entity.HasIndex(e => e.Status, "idx_transport_orders_status");

            entity.HasIndex(e => e.OrderNumber, "order_number").IsUnique();
            entity.Property(e => e.OriginFacilityId)
                .HasColumnName("origin_facility_id");
            entity.HasOne(e => e.OriginFacility)
                .WithMany()
                .HasForeignKey(e => e.OriginFacilityId)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_transport_orders_origin_facility");

            entity.HasOne(e => e.DestinationFacility)
                .WithMany()
                .HasForeignKey(e => e.DestinationFacilityId)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_transport_orders_destination_facility");
            entity.Property(e => e.DestinationFacilityId)
                .HasColumnName("destination_facility_id");
            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.ActualArrival)
                .HasColumnType("timestamp")
                .HasColumnName("actual_arrival");
            entity.Property(e => e.ActualDeparture)
                .HasColumnType("timestamp")
                .HasColumnName("actual_departure");
            entity.Property(e => e.AssignedDriverId).HasColumnName("assigned_driver_id");
            entity.Property(e => e.AssignedVehicleId).HasColumnName("assigned_vehicle_id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.CreatedBy).HasColumnName("created_by");
            entity.Property(e => e.OrderNumber)
                .HasMaxLength(50)
                .HasColumnName("order_number");
            entity.Property(e => e.PlannedArrival)
                .HasColumnType("timestamp")
                .HasColumnName("planned_arrival");
            entity.Property(e => e.PlannedDeparture)
                .HasColumnType("timestamp")
                .HasColumnName("planned_departure");
            entity.Property(e => e.Priority)
                .HasDefaultValueSql("'5'")
                .HasColumnName("priority");
            entity.Property(e => e.ShipmentId).HasColumnName("shipment_id");
            entity.Property(e => e.SpecialInstructions)
                .HasColumnType("text")
                .HasColumnName("special_instructions");
            entity.Property(e => e.Status)
                .HasDefaultValueSql("'created'")
                .HasColumnType("enum('created','planned','assigned','in_transit','delivered','cancelled')")
                .HasColumnName("status");
            entity.Property(e => e.UpdatedAt)
                .ValueGeneratedOnAddOrUpdate()
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("updated_at");
            entity.Property(e => e.Volume)
                .HasPrecision(10, 3)
                .HasColumnName("volume");
            entity.Property(e => e.Weight)
                .HasPrecision(10, 3)
                .HasColumnName("weight");

            entity.HasOne(d => d.AssignedDriver).WithMany(p => p.TransportOrderAssignedDrivers)
                .HasForeignKey(d => d.AssignedDriverId)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("fk_transport_orders_assigned_driver");

            entity.HasOne(d => d.AssignedVehicle).WithMany(p => p.TransportOrders)
                .HasForeignKey(d => d.AssignedVehicleId)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("fk_transport_orders_assigned_vehicle");

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.TransportOrderCreatedByNavigations)
                .HasForeignKey(d => d.CreatedBy)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("fk_transport_orders_created_by");

            entity.HasOne(d => d.Shipment).WithMany(p => p.TransportOrders)
                .HasForeignKey(d => d.ShipmentId)
                .HasConstraintName("fk_transport_orders_shipment");
        });

        modelBuilder.Entity<User>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("users");

            entity.HasIndex(e => e.Email, "email").IsUnique();

            entity.HasIndex(e => e.Username, "idx_users_username").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.Email).HasColumnName("email");
            entity.Property(e => e.IsActive)
                .HasDefaultValueSql("'1'")
                .HasColumnName("is_active");
            entity.Property(e => e.LastLogin)
                .HasColumnType("timestamp")
                .HasColumnName("last_login");
            entity.Property(e => e.MfaEnabled)
                .HasDefaultValueSql("'0'")
                .HasColumnName("mfa_enabled");
            entity.Property(e => e.MfaSecret)
                .HasMaxLength(255)
                .HasColumnName("mfa_secret");
            entity.Property(e => e.PasswordHash)
                .HasMaxLength(255)
                .HasColumnName("password_hash");
            entity.Property(e => e.Phone)
                .HasMaxLength(20)
                .HasColumnName("phone");
            entity.Property(e => e.UpdatedAt)
                .ValueGeneratedOnAddOrUpdate()
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("updated_at");
            entity.Property(e => e.Username)
                .HasMaxLength(50)
                .HasColumnName("username");
        });

        modelBuilder.Entity<UserRole>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("user_roles");

            entity.HasIndex(e => e.RoleId, "fk_user_roles_role");

            entity.HasIndex(e => new { e.UserId, e.RoleId }, "unique_user_role").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.RoleId).HasColumnName("role_id");
            entity.Property(e => e.UserId).HasColumnName("user_id");

            entity.HasOne(d => d.Role).WithMany(p => p.UserRoles)
                .HasForeignKey(d => d.RoleId)
                .HasConstraintName("fk_user_roles_role");

            entity.HasOne(d => d.User).WithMany(p => p.UserRoles)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("fk_user_roles_user");
        });

        modelBuilder.Entity<Vehicle>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("vehicles");

            entity.HasIndex(e => e.AssignedDriverId, "idx_vehicles_assigned_driver");

            entity.HasIndex(e => e.Status, "idx_vehicles_status");

            entity.HasIndex(e => e.RegistrationNumber, "registration_number").IsUnique();

            entity.HasIndex(e => e.VehicleNumber, "vehicle_number").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.AssignedDriverId).HasColumnName("assigned_driver_id");
            entity.Property(e => e.Brand)
                .HasMaxLength(50)
                .HasColumnName("brand");
            entity.Property(e => e.Capacity)
                .HasPrecision(15, 2)
                .HasColumnName("capacity");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.FuelType)
                .HasMaxLength(50)
                .HasColumnName("fuel_type");
            entity.Property(e => e.InsuranceExpiry).HasColumnName("insurance_expiry");
            entity.Property(e => e.MaintenanceDue).HasColumnName("maintenance_due");
            entity.Property(e => e.Model)
                .HasMaxLength(50)
                .HasColumnName("model");
            entity.Property(e => e.RegistrationNumber)
                .HasMaxLength(50)
                .HasColumnName("registration_number");
            entity.Property(e => e.Status)
                .HasMaxLength(50)
                .HasDefaultValueSql("'Available'")
                .HasColumnName("status");
            entity.Property(e => e.UpdatedAt)
                .ValueGeneratedOnAddOrUpdate()
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("updated_at");
            entity.Property(e => e.VehicleNumber)
                .HasMaxLength(50)
                .HasColumnName("vehicle_number");
            entity.Property(e => e.VehicleType)
                .HasMaxLength(50)
                .HasColumnName("vehicle_type");
            entity.Property(e => e.Year).HasColumnName("year");

            entity.HasOne(d => d.AssignedDriver).WithMany(p => p.Vehicles)
                .HasForeignKey(d => d.AssignedDriverId)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("fk_vehicles_assigned_driver");
        });

        modelBuilder.Entity<VehicleFuelLog>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("vehicle_fuel_logs");

            entity.HasIndex(e => e.VehicleId, "idx_vehicle_fuel_logs_vehicle");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Cost)
                .HasPrecision(15, 2)
                .HasColumnName("cost");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.FuelDate).HasColumnName("fuel_date");
            entity.Property(e => e.FuelType)
                .HasMaxLength(50)
                .HasColumnName("fuel_type");
            entity.Property(e => e.OdometerReading)
                .HasPrecision(10, 2)
                .HasColumnName("odometer_reading");
            entity.Property(e => e.Quantity)
                .HasPrecision(10, 2)
                .HasColumnName("quantity");
            entity.Property(e => e.VehicleId).HasColumnName("vehicle_id");

            entity.HasOne(d => d.Vehicle).WithMany(p => p.VehicleFuelLogs)
                .HasForeignKey(d => d.VehicleId)
                .HasConstraintName("fk_vehicle_fuel_logs_vehicle");
        });

        modelBuilder.Entity<VehicleGp>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("vehicle_gps");

            entity.HasIndex(e => e.RecordedAt, "idx_vehicle_gps_recorded_at");

            entity.HasIndex(e => e.VehicleId, "idx_vehicle_gps_vehicle");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Heading)
                .HasPrecision(5, 2)
                .HasColumnName("heading");
            entity.Property(e => e.Latitude)
                .HasPrecision(10, 8)
                .HasColumnName("latitude");
            entity.Property(e => e.Longitude)
                .HasPrecision(11, 8)
                .HasColumnName("longitude");
            entity.Property(e => e.RecordedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("recorded_at");
            entity.Property(e => e.Speed)
                .HasPrecision(8, 2)
                .HasColumnName("speed");
            entity.Property(e => e.VehicleId).HasColumnName("vehicle_id");

            entity.HasOne(d => d.Vehicle).WithMany(p => p.VehicleGps)
                .HasForeignKey(d => d.VehicleId)
                .HasConstraintName("fk_vehicle_gps_vehicle");
        });

        modelBuilder.Entity<VehicleMaintenance>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("vehicle_maintenance");

            entity.HasIndex(e => e.VehicleId, "idx_vehicle_maintenance_vehicle");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Cost)
                .HasPrecision(15, 2)
                .HasColumnName("cost");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp")
                .HasColumnName("created_at");
            entity.Property(e => e.Description)
                .HasColumnType("text")
                .HasColumnName("description");
            entity.Property(e => e.MaintenanceDate).HasColumnName("maintenance_date");
            entity.Property(e => e.NextMaintenanceDate).HasColumnName("next_maintenance_date");
            entity.Property(e => e.PerformedBy).HasColumnName("performed_by");
            entity.Property(e => e.VehicleId).HasColumnName("vehicle_id");

            entity.HasOne(d => d.Vehicle).WithMany(p => p.VehicleMaintenances)
                .HasForeignKey(d => d.VehicleId)
                .HasConstraintName("fk_vehicle_maintenance_vehicle");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
