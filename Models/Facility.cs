using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class Facility
{
    public Guid Id { get; set; }

    public string Code { get; set; } = null!;

    public string Name { get; set; } = null!;

    public string FacilityType { get; set; } = null!;

    public string AddressLine1 { get; set; } = null!;

    public string? AddressLine2 { get; set; }

    public string City { get; set; } = null!;

    public string? State { get; set; }

    public string Pincode { get; set; } = null!;

    public string? Country { get; set; }

    public string? Phone { get; set; }

    public string? Email { get; set; }

    public Guid? BranchManagerId { get; set; }

    public decimal? Capacity { get; set; }

    public decimal? CurrentOccupancy { get; set; }

    public bool? IsActive { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual Employee? BranchManager { get; set; }

    public virtual ICollection<Employee> Employees { get; set; } = new List<Employee>();

    public virtual ICollection<Expense> Expenses { get; set; } = new List<Expense>();

    public virtual ICollection<ManifestItem> ManifestItems { get; set; } = new List<ManifestItem>();

    public virtual ICollection<PackageScan> PackageScans { get; set; } = new List<PackageScan>();

    public virtual ICollection<Pincode> Pincodes { get; set; } = new List<Pincode>();

    public virtual ICollection<Route> RouteDestinationFacilities { get; set; } = new List<Route>();

    public virtual ICollection<Route> RouteOriginFacilities { get; set; } = new List<Route>();

    public virtual ICollection<RouteStop> RouteStops { get; set; } = new List<RouteStop>();

    public virtual ICollection<ShipmentManifest> ShipmentManifests { get; set; } = new List<ShipmentManifest>();

    public virtual ICollection<StorageArea> StorageAreas { get; set; } = new List<StorageArea>();
}
