using System;

namespace Project3.DTOs;

// ============================================================
// CREATE / UPDATE
// ============================================================

public class CreateVehicleDto
{
    public string VehicleNumber { get; set; } = string.Empty;

    public string VehicleType { get; set; } = string.Empty;

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
}


// ============================================================
// RESPONSE
// ============================================================

public class VehicleDto : CreateVehicleDto
{
    public Guid Id { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }
}