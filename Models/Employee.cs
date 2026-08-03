using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class Employee
{
    public Guid Id { get; set; }

    public Guid UserId { get; set; }

    public string FirstName { get; set; } = null!;

    public string LastName { get; set; } = null!;

    public Guid? DepartmentId { get; set; }

    public Guid? PositionId { get; set; }

    public Guid? BranchId { get; set; }

    public DateOnly? HireDate { get; set; }

    public string? EmployeeCode { get; set; }

    public bool? IsActive { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual Facility? Branch { get; set; }

    public virtual ICollection<DeliveryAssignment> DeliveryAssignments { get; set; } = new List<DeliveryAssignment>();

    public virtual Department? Department { get; set; }

    public virtual ICollection<EmployeeProfileRequest> EmployeeProfileRequests { get; set; } = new List<EmployeeProfileRequest>();

    public virtual ICollection<Expense> ExpenseApprovedByNavigations { get; set; } = new List<Expense>();

    public virtual ICollection<Expense> ExpenseEmployees { get; set; } = new List<Expense>();

    public virtual ICollection<Facility> Facilities { get; set; } = new List<Facility>();

    public virtual ICollection<PackageScan> PackageScans { get; set; } = new List<PackageScan>();

    public virtual Position? Position { get; set; }

    public virtual ICollection<ShipmentManifest> ShipmentManifests { get; set; } = new List<ShipmentManifest>();

    public virtual ICollection<ShipmentRequest> ShipmentRequests { get; set; } = new List<ShipmentRequest>();

    public virtual ICollection<ShipmentStatusHistory> ShipmentStatusHistories { get; set; } = new List<ShipmentStatusHistory>();

    public virtual ICollection<TransportOrder> TransportOrderAssignedDrivers { get; set; } = new List<TransportOrder>();

    public virtual ICollection<TransportOrder> TransportOrderCreatedByNavigations { get; set; } = new List<TransportOrder>();

    public virtual User User { get; set; } = null!;

    public virtual ICollection<Vehicle> Vehicles { get; set; } = new List<Vehicle>();
}
