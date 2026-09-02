const MENU_GROUPS = [
    // =========================================================
    // USER & ACCESS
    // =========================================================
    {
        key: "user",
        label: "User & Access",
        entities: [
            {
                label: "Users",
                permission: "users",
                path: "/users"
            },
            {
                label: "Roles",
                permission: "roles",
                path: "/roles"
            },
            {
                label: "Permissions",
                permission: "permissions",
                path: "/permissions"
            },
            {
                label: "User Roles",
                permission: "user_roles",
                path: "/user-roles"
            }
        ]
    },

    // =========================================================
    // EMPLOYEE
    // =========================================================
    {
        key: "employee",
        label: "Employee",
        entities: [
            {
                label: "Employees",
                permission: "employees",
                path: "/employees"
            },
            {
                label: "Departments",
                permission: "departments",
                path: "/departments"
            },
            {
                label: "Positions",
                permission: "positions",
                path: "/positions"
            }
        ]
    },

    // =========================================================
    // COMPANY / MASTER DATA
    // =========================================================
    {
        key: "company",
        label: "Company",
        entities: [
            {
                label: "Facilities",
                permission: "facilities",
                path: "/facilities"
            },
            {
                label: "Pincodes",
                permission: "pincodes",
                path: "/pincodes"
            },
            {
                label: "Storage Areas",
                permission: "storage_areas",
                path: "/storage-areas"
            },
            {
                label: "Services",
                permission: "services",
                path: "/services"
            },
            {
                label: "Pricing Rules",
                permission: "pricing_rules",
                path: "/pricing-rules"
            },
            {
                label: "Insurance Plans",
                permission: "insurance_plans",
                path: "/insurance-plans"
            }
        ]
    },

    // =========================================================
    // CUSTOMER
    // =========================================================
    {
        key: "customer",
        label: "Customer",
        entities: [
            {
                label: "Customers",
                permission: "customers",
                path: "/customers"
            },
            {
                label: "Customer Addresses",
                permission: "customer_addresses",
                children: [
                    {
                        label: "My Addresses",
                        scope: "own",
                        path: "/my/customer-addresses"
                    },
                    {
                        label: "All Addresses",
                        scope: "all",
                        path: "/customer-addresses"
                    }
                ]
            }
        ]
    },

    // =========================================================
    // SHIPMENT
    // =========================================================
    {
        key: "shipment",
        label: "Shipment",
        entities: [
            {
                label: "Shipment Requests",
                permission: "shipment_requests",
                children: [
                    {
                        label: "My Shipment Requests",
                        scope: "own",
                        path: "/my/shipment-requests"
                    },
                    {
                        label: "All Shipment Requests",
                        scope: "all",
                        path: "/shipment-requests"
                    }
                ]
            },

            {
                label: "Shipments",
                permission: "shipments",
                children: [
                    {
                        label: "My Shipments",
                        scope: "own",
                        path: "/my/shipments"
                    },
                    {
                        label: "All Shipments",
                        scope: "all",
                        path: "/shipments"
                    }
                ]
            },

            {
                label: "Shipment Contacts",
                permission: "shipment_contacts",
                children: [
                    {
                        label: "My Contacts",
                        scope: "own",
                        path: "/my/shipment-contacts"
                    },
                    {
                        label: "All Contacts",
                        scope: "all",
                        path: "/shipment-contacts"
                    }
                ]
            },

            {
                label: "Shipment Charges",
                permission: "shipment_charges",
                children: [
                    {
                        label: "My Charges",
                        scope: "own",
                        path: "/my/shipment-charges"
                    },
                    {
                        label: "All Charges",
                        scope: "all",
                        path: "/shipment-charges"
                    }
                ]
            },

            // -------------------------------------------------
            // Manifest is the parent.
            // Manifest Items are NOT a separate menu item.
            // -------------------------------------------------
            {
                label: "Shipment Manifests",
                permission: "shipment_manifests",
                path: "/shipment-manifests"
            },

            {
                label: "Shipment Status History",
                permission: "shipment_status_history",
                path: "/shipment-status-history"
            }
        ]
    },

    // =========================================================
    // TRANSPORTATION
    // =========================================================
    {
        key: "transportation",
        label: "Transportation",
        entities: [
            {
                label: "Vehicles",
                permission: "vehicles",
                path: "/vehicles"
            },

            {
                label: "Vehicle Maintenance",
                permission: "vehicle_maintenance",
                path: "/vehicle-maintenance"
            },

            {
                label: "Vehicle Fuel Logs",
                permission: "vehicle_fuel_logs",
                path: "/vehicle-fuel-logs"
            },

            {
                label: "Vehicle GPS",
                permission: "vehicle_gps",
                path: "/vehicle-gps"
            },

            {
                label: "Routes",
                permission: "routes",
                path: "/routes"
            },

            {
                label: "Transport Orders",
                permission: "transport_orders",
                path: "/transport-orders"
            }
        ]
    },

    // =========================================================
    // DELIVERY & TRACKING
    // =========================================================
    {
        key: "delivery",
        label: "Delivery & Tracking",
        entities: [
            {
                label: "Delivery Assignments",
                permission: "delivery_assignments",
                path: "/delivery-assignments"
            },

            {
                label: "Delivery Attempts",
                permission: "delivery_attempts",
                path: "/delivery-attempts"
            },

            {
                label: "Proof of Delivery",
                permission: "proof_of_delivery",
                path: "/proof-of-delivery"
            },

            {
                label: "Tracking Events",
                permission: "tracking_events",
                path: "/tracking-events"
            },

            {
                label: "Tracking Status",
                permission: "tracking_status",
                path: "/tracking-status"
            },

            {
                label: "Package Scans",
                permission: "package_scans",
                path: "/package-scans"
            }
        ]
    },

    // =========================================================
    // FINANCE
    // =========================================================
    {
        key: "finance",
        label: "Finance",
        entities: [
            {
                label: "Invoices",
                permission: "invoices",
                children: [
                    {
                        label: "My Invoices",
                        scope: "own",
                        path: "/my/invoices"
                    },
                    {
                        label: "All Invoices",
                        scope: "all",
                        path: "/invoices"
                    }
                ]
            },

            {
                label: "Payments",
                permission: "payments",
                children: [
                    {
                        label: "My Payments",
                        scope: "own",
                        path: "/my/payments"
                    },
                    {
                        label: "All Payments",
                        scope: "all",
                        path: "/payments"
                    }
                ]
            },

            {
                label: "Expenses",
                permission: "expenses",
                path: "/expenses"
            }
        ]
    },

    // =========================================================
    // SYSTEM / LOGS
    // =========================================================
    {
        key: "logs",
        label: "System & Logs",
        entities: [
            {
                label: "Audit Logs",
                permission: "audit_logs",
                path: "/audit-logs"
            },

            {
                label: "Login History",
                permission: "login_history",
                path: "/login-history"
            },

            {
                label: "Notifications",
                permission: "notifications",
                children: [
                    {
                        label: "My Notifications",
                        scope: "own",
                        path: "/my/notifications"
                    },
                    {
                        label: "All Notifications",
                        scope: "all",
                        path: "/notifications"
                    }
                ]
            }
        ]
    }
];

export { MENU_GROUPS };