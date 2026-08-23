using Project3.Models;

namespace Project3.Authentication;

public static class PermissionResourceMap
{
    private static readonly Dictionary<Type, string> Map = new()
    {
        // ============================================================
        // Core
        // ============================================================

        [typeof(User)] = "users",
        [typeof(Role)] = "roles",
        [typeof(Permission)] = "permissions",
        [typeof(UserRole)] = "user_roles",
        [typeof(RolePermission)] = "role_permissions",

        // ============================================================
        // Organization
        // ============================================================

        [typeof(Employee)] = "employees",
        [typeof(Department)] = "departments",
        [typeof(Position)] = "positions",

        // ============================================================
        // Customer
        // ============================================================

        [typeof(Customer)] = "customers",
        [typeof(CustomerAddress)] = "customer_addresses",

        // ============================================================
        // Facilities
        // ============================================================

        [typeof(Facility)] = "facilities",
        [typeof(Pincode)] = "pincodes",
        [typeof(StorageArea)] = "storage_areas",
        [typeof(Service)] = "services",
        [typeof(PricingRule)] = "pricing_rules",
        [typeof(InsurancePlan)] = "insurance_plans",

        // ============================================================
        // Shipment
        // ============================================================

        [typeof(Shipment)] = "shipments",
        [typeof(ShipmentContact)] = "shipment_contacts",
        [typeof(ShipmentCharge)] = "shipment_charges",
        [typeof(ShipmentManifest)] = "shipment_manifests",
        [typeof(ShipmentRequest)] = "shipment_requests",
        [typeof(ShipmentStatusHistory)] = "shipment_status_history",

        // ============================================================
        // Tracking
        // ============================================================

        [typeof(TrackingEvent)] = "tracking_events",
        [typeof(TrackingStatus)] = "tracking_status",

        // ============================================================
        // Routing
        // ============================================================

        [typeof(Project3.Models.Route)] = "routes",
        [typeof(RouteStop)] = "route_stops",

        // ============================================================
        // Delivery
        // ============================================================

        [typeof(DeliveryAssignment)] = "delivery_assignments",
        [typeof(DeliveryAttempt)] = "delivery_attempts",

        // ============================================================
        // Vehicles
        // ============================================================

        [typeof(Vehicle)] = "vehicles",
        [typeof(VehicleGp)] = "vehicle_gps",
        [typeof(VehicleMaintenance)] = "vehicle_maintenance",
        [typeof(VehicleFuelLog)] = "vehicle_fuel_logs",

        // ============================================================
        // Transport
        // ============================================================

        [typeof(TransportOrder)] = "transport_orders",
        [typeof(ManifestItem)] = "manifest_items",

        // ============================================================
        // Finance
        // ============================================================

        [typeof(Invoice)] = "invoices",
        [typeof(Payment)] = "payments",
        [typeof(Expense)] = "expenses",

        // ============================================================
        // System
        // ============================================================

        [typeof(Notification)] = "notifications",
        [typeof(LoginHistory)] = "login_history",
        [typeof(AuditLog)] = "audit_logs",

        // ============================================================
        // Proof / Scanning
        // ============================================================

        [typeof(ProofOfDelivery)] = "proof_of_delivery",
        [typeof(EmployeeProfileRequest)] = "employee_profile_requests",
        [typeof(PackageScan)] = "package_scans",
    };

    public static string GetResource(Type entityType)
    {
        if (Map.TryGetValue(entityType, out var resource))
        {
            return resource;
        }

        throw new InvalidOperationException(
            $"No permission resource mapping exists for entity '{entityType.FullName}'. " +
            $"Add '{entityType.Name}' to PermissionResourceMap before using it with BaseCrudController."
        );
    }

    public static string GetResource<TEntity>()
        where TEntity : class
    {
        return GetResource(typeof(TEntity));
    }
}