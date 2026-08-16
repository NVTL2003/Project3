// frontend/src/pages/ProfilePage.js

import React, { useEffect, useMemo, useState } from "react";
import { Link } from "react-router-dom";

import meService from "../api/meService";
import AppHeader from "../components/AppHeader";

import "../styles/profile.css";

function ProfilePage() {
    const [profile, setProfile] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState("");

    const [expandedGroups, setExpandedGroups] = useState({});
    const [permissionSearch, setPermissionSearch] = useState("");

    // =========================================================
    // LOAD PROFILE
    // =========================================================

    useEffect(() => {
        let mounted = true;

        const loadProfile = async () => {
            try {
                setLoading(true);
                setError("");

                const response = await meService.getMe();

                console.log("👤 Profile response:", response);

                if (mounted) {
                    setProfile(response?.data ?? response);
                }

            } catch (err) {
                console.error("❌ Failed to load profile:", err);

                if (mounted) {
                    setError(
                        "Unable to load your profile. Please try again."
                    );
                }

            } finally {
                if (mounted) {
                    setLoading(false);
                }
            }
        };

        loadProfile();

        return () => {
            mounted = false;
        };
    }, []);

    // =========================================================
    // NORMALIZE PERMISSIONS
    // =========================================================

    const groupedPermissions = useMemo(() => {

        if (!profile?.permissions) {
            return {};
        }

        const groups = {};

        profile.permissions.forEach(permission => {

            if (!permission || typeof permission !== "string") {
                return;
            }

            const parts = permission.split(".");

            if (parts.length < 2) {
                return;
            }

            const resource = parts[0];
            const action = parts.slice(1).join(".");

            if (!groups[resource]) {
                groups[resource] = [];
            }

            groups[resource].push(action);
        });

        // Sort resources alphabetically
        Object.keys(groups).forEach(resource => {
            groups[resource] = [...new Set(groups[resource])].sort();
        });

        return Object.keys(groups)
            .sort()
            .reduce((sorted, key) => {
                sorted[key] = groups[key];
                return sorted;
            }, {});

    }, [profile]);

    // =========================================================
    // FILTER PERMISSIONS
    // =========================================================

    const filteredPermissionGroups = useMemo(() => {

        const search =
            permissionSearch.trim().toLowerCase();

        if (!search) {
            return groupedPermissions;
        }

        const filtered = {};

        Object.entries(groupedPermissions).forEach(
            ([resource, actions]) => {

                const resourceMatches =
                    resource
                        .toLowerCase()
                        .includes(search);

                const matchingActions =
                    actions.filter(action =>
                        action
                            .toLowerCase()
                            .includes(search)
                    );

                if (
                    resourceMatches ||
                    matchingActions.length > 0
                ) {

                    filtered[resource] =
                        resourceMatches
                            ? actions
                            : matchingActions;
                }
            }
        );

        return filtered;

    }, [
        groupedPermissions,
        permissionSearch
    ]);

    // =========================================================
    // PERMISSION COUNT
    // =========================================================

    const permissionCount =
        profile?.permissions?.length ?? 0;

    const roleCount =
        profile?.roles?.length ?? 0;

    // =========================================================
    // GROUP TOGGLE
    // =========================================================

    const toggleGroup = (resource) => {

        setExpandedGroups(prev => ({
            ...prev,
            [resource]:
                !prev[resource]
        }));

    };

    // =========================================================
    // EXPAND / COLLAPSE ALL
    // =========================================================

    const expandAll = () => {

        const expanded = {};

        Object.keys(
            filteredPermissionGroups
        ).forEach(resource => {
            expanded[resource] = true;
        });

        setExpandedGroups(expanded);
    };

    const collapseAll = () => {
        setExpandedGroups({});
    };

    // =========================================================
    // LOADING
    // =========================================================

    if (loading) {
        return (
            <div className="profile-page">

                <AppHeader />

                <main className="profile-container">

                    <div className="profile-loading-card">

                        <div className="profile-spinner" />

                        <p>
                            Loading your profile...
                        </p>

                    </div>

                </main>

            </div>
        );
    }

    // =========================================================
    // ERROR
    // =========================================================

    if (error) {
        return (
            <div className="profile-page">

                <AppHeader />

                <main className="profile-container">

                    <div className="profile-error-card">

                        <div className="profile-error-icon">
                            !
                        </div>

                        <h2>
                            Profile Unavailable
                        </h2>

                        <p>
                            {error}
                        </p>

                        <button
                            className="profile-primary-button"
                            onClick={() =>
                                window.location.reload()
                            }
                        >
                            Try Again
                        </button>

                    </div>

                </main>

            </div>
        );
    }

    // =========================================================
    // UI
    // =========================================================

    return (
        <div className="profile-page">

            {/* <AppHeader /> */}

            <main className="profile-container">

                {/* =================================================
                    PAGE HEADER
                =================================================

                <div className="profile-page-header">

                    <div>

                        <div className="profile-breadcrumb">
                            <Link to="/">
                                Dashboard
                            </Link>

                            <span>/</span>

                            <span>
                                Profile
                            </span>
                        </div>

                        <h1>
                            My Profile
                        </h1>

                        <p>
                            View your account information,
                            roles, and system permissions.
                        </p>

                    </div>

                </div>


                {/* =================================================
                    PROFILE OVERVIEW
                ================================================= */}

                <section className="profile-card profile-overview">

                    <div className="profile-avatar">

                        {profile?.username
                            ?.charAt(0)
                            ?.toUpperCase() || "U"}

                    </div>


                    <div className="profile-main-info">

                        <div className="profile-name-row">

                            <h2>
                                {profile?.username || "User"}
                            </h2>

                            <span className="profile-status">
                                Active
                            </span>

                        </div>

                        <p className="profile-email">
                            {profile?.email ||
                                "No email address"}
                        </p>

                        <p className="profile-user-id">
                            User ID: {profile?.id || "N/A"}
                        </p>

                    </div>


                    <div className="profile-stat-container">

                        <div className="profile-stat">

                            <span className="profile-stat-number">
                                {roleCount}
                            </span>

                            <span className="profile-stat-label">
                                {roleCount === 1
                                    ? "Role"
                                    : "Roles"}
                            </span>

                        </div>


                        <div className="profile-stat-divider" />


                        <div className="profile-stat">

                            <span className="profile-stat-number">
                                {permissionCount}
                            </span>

                            <span className="profile-stat-label">
                                Permissions
                            </span>

                        </div>

                    </div>

                </section>


                {/* =================================================
                    CONTACT INFORMATION
                ================================================= */}

                <section className="profile-card">

                    <div className="profile-section-header">

                        <div>

                            <h2>
                                Account Information
                            </h2>

                            <p>
                                Basic information associated
                                with your account.
                            </p>

                        </div>

                    </div>


                    <div className="profile-info-grid">

                        <div className="profile-info-item">

                            <span className="profile-info-label">
                                Username
                            </span>

                            <span className="profile-info-value">
                                {profile?.username || "N/A"}
                            </span>

                        </div>


                        <div className="profile-info-item">

                            <span className="profile-info-label">
                                Email
                            </span>

                            <span className="profile-info-value">
                                {profile?.email || "N/A"}
                            </span>

                        </div>


                        <div className="profile-info-item">

                            <span className="profile-info-label">
                                Phone
                            </span>

                            <span className="profile-info-value">
                                {profile?.phone || "Not provided"}
                            </span>

                        </div>


                        <div className="profile-info-item">

                            <span className="profile-info-label">
                                Account Status
                            </span>

                            <span className="profile-account-active">
                                ● Active
                            </span>

                        </div>

                    </div>

                </section>


                {/* =================================================
                    ROLES
                ================================================= */}

                <section className="profile-card">

                    <div className="profile-section-header">

                        <div>

                            <h2>
                                Roles
                            </h2>

                            <p>
                                Roles assigned to your account.
                            </p>

                        </div>

                        <span className="profile-count-badge">
                            {roleCount}
                        </span>

                    </div>


                    {profile?.roles?.length > 0 ? (

                        <div className="profile-role-list">

                            {profile.roles.map(
                                (role, index) => (

                                    <div
                                        key={`${role}-${index}`}
                                        className="profile-role-card"
                                    >

                                        <div className="profile-role-icon">
                                            👤
                                        </div>

                                        <div>

                                            <strong>
                                                {role}
                                            </strong>

                                            <span>
                                                System Role
                                            </span>

                                        </div>

                                    </div>

                                )
                            )}

                        </div>

                    ) : (

                        <div className="profile-empty">
                            No roles assigned.
                        </div>

                    )}

                </section>


                {/* =================================================
                    PERMISSIONS
                ================================================= */}

                <section className="profile-card">

                    <div className="profile-section-header">

                        <div>

                            <h2>
                                Permissions
                            </h2>

                            <p>
                                Access rights granted to your account.
                            </p>

                        </div>

                        <span className="profile-count-badge">
                            {permissionCount}
                        </span>

                    </div>


                    {/* SEARCH */}

                    <div className="permission-toolbar">

                        <div className="permission-search">

                            <span>
                                🔎
                            </span>

                            <input
                                type="text"
                                placeholder="Search permissions..."
                                value={permissionSearch}
                                onChange={(e) =>
                                    setPermissionSearch(
                                        e.target.value
                                    )
                                }
                            />

                            {permissionSearch && (
                                <button
                                    onClick={() =>
                                        setPermissionSearch("")
                                    }
                                    className="permission-search-clear"
                                >
                                    ×
                                </button>
                            )}

                        </div>


                        <div className="permission-toolbar-actions">

                            <button
                                type="button"
                                onClick={expandAll}
                            >
                                Expand All
                            </button>

                            <button
                                type="button"
                                onClick={collapseAll}
                            >
                                Collapse All
                            </button>

                        </div>

                    </div>


                    {/* PERMISSION GROUPS */}

                    {Object.keys(
                        filteredPermissionGroups
                    ).length > 0 ? (

                        <div className="permission-groups">

                            {Object.entries(
                                filteredPermissionGroups
                            ).map(
                                ([resource, actions]) => {

                                    const isExpanded =
                                        expandedGroups[resource] ??
                                        false;

                                    return (
                                        <div
                                            key={resource}
                                            className="permission-group"
                                        >

                                            {/* GROUP HEADER */}

                                            <button
                                                type="button"
                                                className="permission-group-header"
                                                onClick={() =>
                                                    toggleGroup(
                                                        resource
                                                    )
                                                }
                                            >

                                                <div className="permission-group-title">

                                                    <span className={
                                                        `permission-chevron ${isExpanded
                                                            ? "expanded"
                                                            : ""
                                                        }`
                                                    }>
                                                        ›
                                                    </span>

                                                    <span className="permission-resource-icon">
                                                        {getResourceIcon(
                                                            resource
                                                        )}
                                                    </span>

                                                    <span>
                                                        {formatResourceName(
                                                            resource
                                                        )}
                                                    </span>

                                                </div>


                                                <span className="permission-action-count">
                                                    {actions.length}
                                                </span>

                                            </button>


                                            {/* ACTIONS */}

                                            {isExpanded && (

                                                <div className="permission-actions">

                                                    {actions.map(
                                                        action => (

                                                            <div
                                                                key={`${resource}.${action}`}
                                                                className="permission-chip"
                                                            >

                                                                <span className="permission-chip-icon">
                                                                    {getActionIcon(
                                                                        action
                                                                    )}
                                                                </span>

                                                                <span>
                                                                    {formatActionName(
                                                                        action
                                                                    )}
                                                                </span>

                                                            </div>

                                                        )
                                                    )}

                                                </div>

                                            )}

                                        </div>
                                    );
                                }
                            )}

                        </div>

                    ) : (

                        <div className="profile-empty">

                            <div className="profile-empty-icon">
                                🔎
                            </div>

                            <strong>
                                No permissions found
                            </strong>

                            <span>
                                Try another search term.
                            </span>

                        </div>

                    )}

                </section>


                {/* =================================================
                    FOOTER
                ================================================= */}

                <div className="profile-footer">

                    <span>
                        Permission information is provided
                        by the authorization system.
                    </span>

                </div>

            </main>

        </div>
    );
}


// =============================================================
// FORMATTERS
// =============================================================

function formatResourceName(resource) {

    return resource
        .replace(/[_-]/g, " ")
        .replace(/\b\w/g, char =>
            char.toUpperCase()
        );
}


function formatActionName(action) {

    return action
        .replace(/[_-]/g, " ")
        .replace(/\b\w/g, char =>
            char.toUpperCase()
        );
}


// =============================================================
// RESOURCE ICONS
// =============================================================

function getResourceIcon(resource) {

    const icons = {

        admin: "👑",

        users: "👥",
        user_roles: "🔗",

        roles: "🛡️",
        permissions: "🔐",
        role_permissions: "🔑",

        employees: "👨‍💼",
        employee_profile_requests: "📋",

        customers: "👤",
        customer_addresses: "📍",

        departments: "🏢",
        positions: "💼",

        facilities: "🏭",
        pincodes: "📮",
        storage_areas: "📦",

        services: "⚙️",
        pricing_rules: "💰",
        insurance_plans: "🛡️",

        shipments: "🚚",
        shipment_requests: "📝",
        shipment_contacts: "📇",
        shipment_manifests: "📋",
        shipment_status_history: "📜",

        delivery_assignments: "📍",
        delivery_attempts: "🚪",

        routes: "🛣️",
        route_stops: "📍",

        vehicles: "🚛",
        vehicle_gps: "📡",
        vehicle_fuel_logs: "⛽",
        vehicle_maintenance: "🔧",

        payments: "💳",
        invoices: "🧾",
        expenses: "💵",

        notifications: "🔔",
        audit_logs: "📊",
        login_history: "🔐",

        tracking_events: "📡",
        tracking_status: "📍",

        package_scans: "📦",
        proof_of_delivery: "✍️",

        transport_orders: "🚛",
        manifest_items: "📋",
        shipment_charges: "💰"

    };

    return icons[resource] || "📁";
}


// =============================================================
// ACTION ICONS
// =============================================================

function getActionIcon(action) {

    const icons = {

        create: "＋",
        read: "👁",
        view: "👁",
        update: "✎",
        edit: "✎",
        delete: "🗑",
        manage: "⚙",
        assign: "↗",
        track: "📍"

    };

    return icons[action] || "•";
}


export default ProfilePage;