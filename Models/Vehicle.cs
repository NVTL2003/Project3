using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class Vehicle
{
    public Guid Id { get; set; }

    public string VehicleNumber { get; set; } = null!;

    public string VehicleType { get; set; } = null!;

    public string? Brand { get; set; }

    public string? Model { get; set; }

    public int? Year { get; set; }

    public decimal Capacity { get; set; }

    public string? Status { get; set; }

    public string? RegistrationNumber { get; set; }

    public DateOnly? InsuranceExpiry { get; set; }

    public DateOnly? MaintenanceDue { get; set; }

    public Guid? AssignedDriverId { get; set; }

    public string? FuelType { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual Employee? AssignedDriver { get; set; }

    public virtual ICollection<DeliveryAssignment> DeliveryAssignments { get; set; } = new List<DeliveryAssignment>();

    public virtual ICollection<Expense> Expenses { get; set; } = new List<Expense>();

    public virtual ICollection<PackageScan> PackageScans { get; set; } = new List<PackageScan>();

    public virtual ICollection<ShipmentManifest> ShipmentManifests { get; set; } = new List<ShipmentManifest>();

    public virtual ICollection<TransportOrder> TransportOrders { get; set; } = new List<TransportOrder>();

    public virtual ICollection<VehicleFuelLog> VehicleFuelLogs { get; set; } = new List<VehicleFuelLog>();

    public virtual ICollection<VehicleGp> VehicleGps { get; set; } = new List<VehicleGp>();

    public virtual ICollection<VehicleMaintenance> VehicleMaintenances { get; set; } = new List<VehicleMaintenance>();
}
