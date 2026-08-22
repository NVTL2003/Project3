import React, { useEffect, useMemo, useState } from "react";
import { Link, useNavigate, useLocation } from "react-router-dom";
import meService from "../api/meService";
import "../styles/app-header.css";

/*
|--------------------------------------------------------------------------
| ENTITY MENU CONFIGURATION
|--------------------------------------------------------------------------
|
| Each entity has:
|
|   permission -> permission prefix from backend
|   children   -> scope-based menu items (own/all)
|   path       -> React route (for entities without children)
|
| The header uses the user's permissions to decide what is visible.
|
*/

const MENU_GROUPS = [
    {
        key: "user",
        label: "User",
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
            {
                label: "Shipment Manifests",
                permission: "shipment_manifests",
                path: "/shipment-manifests"
            },
            {
                label: "Manifest Items",
                permission: "manifest_items",
                path: "/manifest-items"
            },
            {
                label: "Shipment Status History",
                permission: "shipment_status_history",
                path: "/shipment-status-history"
            }
        ]
    },

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
                label: "Route Stops",
                permission: "route_stops",
                path: "/route-stops"
            },
            {
                label: "Transport Orders",
                permission: "transport_orders",
                children: [
                    {
                        label: "My Transport Orders",
                        scope: "own",
                        path: "/my/transport-orders"
                    },
                    {
                        label: "All Transport Orders",
                        scope: "all",
                        path: "/transport-orders"
                    }
                ]
            }
        ]
    },

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

    {
        key: "delivery",
        label: "Delivery",
        entities: [
            {
                label: "Delivery Assignments",
                permission: "delivery_assignments",
                children: [
                    {
                        label: "My Assignments",
                        scope: "own",
                        path: "/my/delivery-assignments"
                    },
                    {
                        label: "All Assignments",
                        scope: "all",
                        path: "/delivery-assignments"
                    }
                ]
            },
            {
                label: "Delivery Attempts",
                permission: "delivery_attempts",
                children: [
                    {
                        label: "My Attempts",
                        scope: "own",
                        path: "/my/delivery-attempts"
                    },
                    {
                        label: "All Attempts",
                        scope: "all",
                        path: "/delivery-attempts"
                    }
                ]
            },
            {
                label: "Proof of Delivery",
                permission: "proof_of_delivery",
                children: [
                    {
                        label: "My Proofs",
                        scope: "own",
                        path: "/my/proof-of-delivery"
                    },
                    {
                        label: "All Proofs",
                        scope: "all",
                        path: "/proof-of-delivery"
                    }
                ]
            },
            {
                label: "Tracking Events",
                permission: "tracking_events",
                children: [
                    {
                        label: "My Tracking Events",
                        scope: "own",
                        path: "/my/tracking-events"
                    },
                    {
                        label: "All Tracking Events",
                        scope: "all",
                        path: "/tracking-events"
                    }
                ]
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

    {
        key: "logs",
        label: "Logs",
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

/*
|--------------------------------------------------------------------------
| Permission helpers
|--------------------------------------------------------------------------
*/

/**
 * Check if user has a specific permission for a resource, action, and scope
 * 
 * @param {Array} permissions - User's permission strings
 * @param {string} resource - Resource name (e.g., "customer_addresses")
 * @param {string} action - Action name (e.g., "read", "create", "update", "delete")
 * @param {string} scope - Scope name (e.g., "own", "all")
 * @returns {boolean}
 */
const hasPermission = (
    permissions,
    resource,
    action,
    scope
) => {
    if (!Array.isArray(permissions)) {
        return false;
    }

    const expected =
        `${resource}.${action}.${scope}`.toLowerCase();

    return permissions.some(permission =>
        permission.toLowerCase() === expected
    );
};

/*
|--------------------------------------------------------------------------
| AppHeader
|--------------------------------------------------------------------------
*/

function AppHeader() {

    const navigate = useNavigate();
    const location = useLocation();

    const [user, setUser] =
        useState(null);

    const [loading, setLoading] =
        useState(true);

    /*
     * Load current user from /api/me
     */

    useEffect(() => {

        let mounted = true;

        const loadUser = async () => {

            try {

                const response =
                    await meService.getMe();

                if (!mounted) {
                    return;
                }

                const userData =
                    response?.data ?? response;

                console.log(
                    "👤 Header user:",
                    userData
                );

                setUser(userData);

            } catch (error) {

                console.error(
                    "Failed to load header user:",
                    error
                );

            } finally {

                if (mounted) {
                    setLoading(false);
                }

            }

        };

        loadUser();

        return () => {
            mounted = false;
        };

    }, []);

    /*
     * Logout
     */

    const logout = () => {

        localStorage.removeItem("token");
        localStorage.removeItem("user");
        localStorage.removeItem("roles");
        localStorage.removeItem("permissions");

        window.location.href = "/login";
    };

    /*
     * Current user information
     */

    const primaryRole =
        user?.roles?.[0] ||
        "User";

    const displayName =
        user?.username ||
        "User";

    const permissions =
        user?.permissions ?? [];

    /*
     * Build navigation dynamically.
     *
     * Only groups containing at least one
     * accessible entity are rendered.
     * 
     * For entities with children, each child is
     * checked individually using scope-based permissions.
     */

    const visibleGroups =
        useMemo(() => {

            return MENU_GROUPS
                .map(group => {

                    const visibleEntities =
                        group.entities
                            .map(entity => {

                                // =================================================
                                // ENTITY WITH SCOPES (children)
                                // =================================================

                                if (entity.children) {

                                    const visibleChildren =
                                        entity.children.filter(child => {

                                            return hasPermission(
                                                permissions,
                                                entity.permission,
                                                "read",
                                                child.scope
                                            );

                                        });

                                    if (visibleChildren.length === 0) {
                                        return null;
                                    }

                                    return {
                                        ...entity,
                                        children: visibleChildren
                                    };
                                }

                                // =================================================
                                // NORMAL ENTITY (no children)
                                // =================================================

                                const canRead =
                                    permissions.some(permission =>
                                        permission
                                            .toLowerCase()
                                            .startsWith(
                                                `${entity.permission.toLowerCase()}.`
                                            )
                                    );

                                return canRead
                                    ? entity
                                    : null;

                            })
                            .filter(Boolean);

                    return {
                        ...group,
                        entities: visibleEntities
                    };

                })
                .filter(group =>
                    group.entities.length > 0
                );

        }, [permissions]);

    /*
     * Active route
     */

    const isActive = (path) => {

        return location.pathname === path;

    };

    return (

        <header className="app-header">

            <div className="app-header-inner">

                {/* ================================================= */}
                {/* BRAND */}
                {/* ================================================= */}

                <Link
                    to="/"
                    className="app-brand"
                >

                    <div className="app-brand-icon">
                        EL
                    </div>

                    <div className="app-brand-text">

                        <div className="app-brand-title">
                            ELMS
                        </div>

                        <div className="app-brand-subtitle">
                            Logistics Management
                        </div>

                    </div>

                </Link>

                {/* ================================================= */}
                {/* NAVIGATION */}
                {/* ================================================= */}

                <nav className="app-navigation">

                    {/* DASHBOARD */}

                    <Link
                        to="/"
                        className={
                            `app-nav-link ${isActive("/")
                                ? "active"
                                : ""
                            }`
                        }
                    >
                        Dashboard
                    </Link>

                    {/* DYNAMIC GROUPS */}

                    {!loading &&
                        visibleGroups.map(group => (

                            <div
                                className="app-nav-dropdown"
                                key={group.key}
                            >

                                <button
                                    className="app-nav-dropdown-button"
                                >

                                    {group.label}

                                    <span className="app-nav-chevron">
                                        ▾
                                    </span>

                                </button>

                                <div className="app-nav-dropdown-menu">

                                    <div className="app-nav-dropdown-title">
                                        {group.label}
                                    </div>

                                    {group.entities.map(entity => (

                                        <React.Fragment key={entity.permission}>

                                            {entity.children ? (

                                                <>
                                                    <div className="app-nav-dropdown-section">
                                                        {entity.label}
                                                    </div>

                                                    {entity.children.map(child => (

                                                        <Link
                                                            key={child.path}
                                                            to={child.path}
                                                            className={
                                                                `app-nav-dropdown-item ${isActive(child.path)
                                                                    ? "active"
                                                                    : ""
                                                                }`
                                                            }
                                                        >

                                                            <span>
                                                                {child.label}
                                                            </span>

                                                            <span className="app-nav-item-arrow">
                                                                →
                                                            </span>

                                                        </Link>

                                                    ))}
                                                </>

                                            ) : (

                                                <Link
                                                    key={entity.path}
                                                    to={entity.path}
                                                    className={
                                                        `app-nav-dropdown-item ${isActive(entity.path)
                                                            ? "active"
                                                            : ""
                                                        }`
                                                    }
                                                >

                                                    <span>
                                                        {entity.label}
                                                    </span>

                                                    <span className="app-nav-item-arrow">
                                                        →
                                                    </span>

                                                </Link>

                                            )}

                                        </React.Fragment>

                                    ))}

                                </div>

                            </div>

                        ))}

                </nav>

                {/* ================================================= */}
                {/* USER */}
                {/* ================================================= */}

                <div className="app-header-user">

                    <button
                        className="app-user-button"
                        onClick={() =>
                            navigate("/profile")
                        }
                    >

                        <div className="app-user-avatar">

                            {displayName
                                .charAt(0)
                                .toUpperCase()}

                        </div>

                        <div className="app-user-info">

                            <div className="app-user-name">
                                {displayName}
                            </div>

                            <div className="app-user-role">
                                {primaryRole}
                            </div>

                        </div>

                        <span className="app-user-arrow">
                            ›
                        </span>

                    </button>

                    <button
                        className="app-logout-button"
                        onClick={logout}
                    >
                        Logout
                    </button>

                </div>

            </div>

        </header>

    );

}

export default AppHeader;