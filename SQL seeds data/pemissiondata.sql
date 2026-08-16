START TRANSACTION;
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE role_permissions;
TRUNCATE TABLE permissions;

SET FOREIGN_KEY_CHECKS = 1;
INSERT INTO permissions
(
    id,
    name,
    resource,
    action,
    description
)

SELECT
    UUID(),
    CONCAT(r.resource, '.', a.action),
    r.resource,
    a.action,
    CONCAT(
        UPPER(a.action),
        ' permission for ',
        r.resource
    )
FROM
(
    SELECT 'users' AS resource
    UNION ALL SELECT 'roles'
    UNION ALL SELECT 'permissions'
    UNION ALL SELECT 'user_roles'
    UNION ALL SELECT 'role_permissions'

    UNION ALL SELECT 'employees'
    UNION ALL SELECT 'departments'
    UNION ALL SELECT 'positions'

    UNION ALL SELECT 'customers'
    UNION ALL SELECT 'customer_addresses'

    UNION ALL SELECT 'facilities'
    UNION ALL SELECT 'pincodes'
    UNION ALL SELECT 'storage_areas'
    UNION ALL SELECT 'services'
    UNION ALL SELECT 'pricing_rules'
    UNION ALL SELECT 'insurance_plans'

    UNION ALL SELECT 'shipments'
    UNION ALL SELECT 'shipment_contacts'
    UNION ALL SELECT 'shipment_charges'
    UNION ALL SELECT 'shipment_manifests'
    UNION ALL SELECT 'shipment_requests'
    UNION ALL SELECT 'shipment_status_history'

    UNION ALL SELECT 'tracking_events'
    UNION ALL SELECT 'tracking_status'

    UNION ALL SELECT 'routes'
    UNION ALL SELECT 'route_stops'

    UNION ALL SELECT 'delivery_assignments'
    UNION ALL SELECT 'delivery_attempts'

    UNION ALL SELECT 'vehicles'
    UNION ALL SELECT 'vehicle_gps'
    UNION ALL SELECT 'vehicle_maintenance'
    UNION ALL SELECT 'vehicle_fuel_logs'

    UNION ALL SELECT 'transport_orders'
    UNION ALL SELECT 'manifest_items'

    UNION ALL SELECT 'invoices'
    UNION ALL SELECT 'payments'
    UNION ALL SELECT 'expenses'

    UNION ALL SELECT 'notifications'
    UNION ALL SELECT 'login_history'
    UNION ALL SELECT 'audit_logs'

    UNION ALL SELECT 'proof_of_delivery'
    UNION ALL SELECT 'employee_profile_requests'
    UNION ALL SELECT 'package_scans'
) r

CROSS JOIN
(
    SELECT 'create' AS action
    UNION ALL SELECT 'read'
    UNION ALL SELECT 'update'
    UNION ALL SELECT 'delete'
) a;
SELECT COUNT(*) AS total_permissions
FROM permissions;
-- =============================================
-- ROLE PERMISSIONS ASSIGNMENTS
-- =============================================

-- =============================================
-- 1. ADMIN ROLE PERMISSIONS
-- (Full access to everything)
-- =============================================

INSERT INTO role_permissions
(
    id,
    role_id,
    permission_id
)
SELECT
    UUID(),
    r.id,
    p.id
FROM roles r
JOIN permissions p
WHERE LOWER(r.name) = 'admin';

-- =============================================
-- 2. EMPLOYEE ROLE PERMISSIONS
-- =============================================

INSERT INTO role_permissions
(
    id,
    role_id,
    permission_id
)
SELECT
    UUID(),
    r.id,
    p.id
FROM roles r
JOIN permissions p
WHERE LOWER(r.name) = 'employee'
AND (
    -- Read access to most resources
    (p.resource IN (
        'users',
        'employees',
        'departments',
        'positions',
        'facilities',
        'pincodes',
        'storage_areas',
        'services',
        'pricing_rules',
        'insurance_plans',
        'shipments',
        'shipment_contacts',
        'shipment_charges',
        'shipment_status_history',
        'tracking_events',
        'tracking_status',
        'package_scans',
        'proof_of_delivery',
        'notifications',
        'vehicles',
        'vehicle_maintenance',
        'vehicle_fuel_logs',
        'vehicle_gps',
        'routes',
        'route_stops',
        'transport_orders',
        'shipment_manifests',
        'manifest_items',
        'delivery_assignments',
        'delivery_attempts',
        'invoices',
        'payments',
        'expenses',
        'audit_logs',
        'login_history',
        'employee_profile_requests'
    )
    AND p.action = 'read')

    OR

    -- Create access
    (p.resource IN (
        'facilities',
        'shipments',
        'shipment_contacts',
        'shipment_status_history',
        'tracking_events',
        'package_scans',
        'notifications',
        'transport_orders',
        'shipment_manifests',
        'manifest_items',
        'delivery_assignments',
        'delivery_attempts',
        'proof_of_delivery',
        'invoices',
        'expenses',
        'employee_profile_requests'
    )
    AND p.action = 'create')

    OR

    -- Update access
    (p.resource IN (
        'facilities',
        'shipments',
        'shipment_contacts',
        'shipment_status_history',
        'tracking_events',
        'package_scans',
        'notifications',
        'vehicles',
        'vehicle_maintenance',
        'vehicle_fuel_logs',
        'routes',
        'route_stops',
        'transport_orders',
        'shipment_manifests',
        'manifest_items',
        'delivery_assignments',
        'delivery_attempts',
        'proof_of_delivery',
        'invoices',
        'payments',
        'expenses',
        'employee_profile_requests'
    )
    AND p.action = 'update')

    OR

    -- Delete access (limited)
    (p.resource IN (
        'shipments',
        'shipment_contacts',
        'notifications',
        'vehicle_maintenance',
        'vehicle_fuel_logs',
        'expenses'
    )
    AND p.action = 'delete')
);

-- =============================================
-- 3. CUSTOMER ROLE PERMISSIONS
-- =============================================

INSERT INTO role_permissions
(
    id,
    role_id,
    permission_id
)
SELECT
    UUID(),
    r.id,
    p.id
FROM roles r
JOIN permissions p
WHERE LOWER(r.name) = 'customer'
AND (
    (p.resource = 'customers'
        AND p.action IN ('read', 'update'))

    OR

    (p.resource = 'customer_addresses'
        AND p.action IN ('create', 'read', 'update', 'delete'))

    OR

    (p.resource = 'shipment_requests'
        AND p.action IN ('create', 'read', 'update', 'delete'))

    OR

    (p.resource = 'shipments'
        AND p.action IN ('create', 'read'))

    OR

    (p.resource = 'shipment_contacts'
        AND p.action IN ('create', 'read', 'update'))

    OR

    (p.resource = 'shipment_charges'
        AND p.action = 'read')

    OR

    (p.resource = 'shipment_manifests'
        AND p.action = 'read')

    OR

    (p.resource = 'shipment_status_history'
        AND p.action = 'read')

    OR

    (p.resource = 'tracking_events'
        AND p.action = 'read')

    OR

    (p.resource = 'tracking_status'
        AND p.action = 'read')

    OR

    (p.resource = 'package_scans'
        AND p.action = 'read')

    OR

    (p.resource = 'proof_of_delivery'
        AND p.action = 'read')

    OR

    (p.resource = 'invoices'
        AND p.action = 'read')

    OR

    (p.resource = 'payments'
        AND p.action IN ('read', 'create'))

    OR

    (p.resource = 'notifications'
        AND p.action = 'read')
);

-- =============================================
-- 4. BRANCH MANAGER ROLE PERMISSIONS
-- =============================================

INSERT INTO role_permissions
(
    id,
    role_id,
    permission_id
)
SELECT
    UUID(),
    r.id,
    p.id
FROM roles r
JOIN permissions p
WHERE LOWER(r.name) = 'branch manager'
AND (
    -- Read access
    (p.resource IN (
        'users',
        'employees',
        'departments',
        'positions',
        'facilities',
        'pincodes',
        'storage_areas',
        'services',
        'pricing_rules',
        'insurance_plans',
        'shipments',
        'shipment_contacts',
        'shipment_charges',
        'shipment_status_history',
        'tracking_events',
        'tracking_status',
        'package_scans',
        'proof_of_delivery',
        'notifications',
        'vehicles',
        'vehicle_maintenance',
        'vehicle_fuel_logs',
        'vehicle_gps',
        'routes',
        'route_stops',
        'transport_orders',
        'shipment_manifests',
        'manifest_items',
        'delivery_assignments',
        'delivery_attempts',
        'invoices',
        'payments',
        'expenses',
        'audit_logs',
        'login_history',
        'employee_profile_requests'
    )
    AND p.action = 'read')

    OR

    -- Create access
    (p.resource IN (
        'facilities',
        'shipments',
        'shipment_contacts',
        'shipment_status_history',
        'tracking_events',
        'package_scans',
        'notifications',
        'transport_orders',
        'shipment_manifests',
        'manifest_items',
        'delivery_assignments',
        'delivery_attempts',
        'proof_of_delivery',
        'invoices',
        'expenses',
        'employee_profile_requests'
    )
    AND p.action = 'create')

    OR

    -- Update access
    (p.resource IN (
        'facilities',
        'shipments',
        'shipment_contacts',
        'shipment_status_history',
        'tracking_events',
        'package_scans',
        'notifications',
        'vehicles',
        'vehicle_maintenance',
        'vehicle_fuel_logs',
        'routes',
        'route_stops',
        'transport_orders',
        'shipment_manifests',
        'manifest_items',
        'delivery_assignments',
        'delivery_attempts',
        'proof_of_delivery',
        'invoices',
        'payments',
        'expenses',
        'employee_profile_requests'
    )
    AND p.action = 'update')

    OR

    -- Delete access (limited)
    (p.resource IN (
        'shipments',
        'shipment_contacts',
        'notifications',
        'vehicle_maintenance',
        'vehicle_fuel_logs',
        'expenses'
    )
    AND p.action = 'delete')

    OR

    -- Extra management permissions
    (p.resource IN (
        'employees',
        'departments',
        'positions'
    )
    AND p.action IN ('create', 'update', 'delete'))
);

-- =============================================
-- 5. DRIVER ROLE PERMISSIONS
-- =============================================

INSERT INTO role_permissions
(
    id,
    role_id,
    permission_id
)
SELECT
    UUID(),
    r.id,
    p.id
FROM roles r
JOIN permissions p
WHERE LOWER(r.name) = 'driver'
AND (
    (p.resource IN (
        'shipments',
        'shipment_contacts',
        'shipment_manifests',
        'manifest_items',
        'tracking_events',
        'tracking_status',
        'package_scans',
        'proof_of_delivery',
        'delivery_assignments',
        'delivery_attempts',
        'routes',
        'route_stops',
        'vehicles',
        'vehicle_gps'
    )
    AND p.action = 'read')

    OR

    (p.resource IN (
        'tracking_events',
        'package_scans',
        'proof_of_delivery',
        'delivery_attempts',
        'vehicle_gps'
    )
    AND p.action = 'create')

    OR

    (p.resource IN (
        'shipments',
        'tracking_events',
        'tracking_status',
        'package_scans',
        'proof_of_delivery',
        'delivery_assignments',
        'delivery_attempts',
        'vehicle_gps'
    )
    AND p.action = 'update')

    OR

    (p.resource = 'notifications'
        AND p.action = 'read')
);

-- =============================================
-- VERIFY ROLE PERMISSIONS
-- =============================================

SELECT '========== ROLE PERMISSIONS SUMMARY ==========' as '';
SELECT 
    r.name as role_name,
    COUNT(rp.permission_id) as permission_count
FROM roles r
LEFT JOIN role_permissions rp ON r.id = rp.role_id
GROUP BY r.id, r.name
ORDER BY r.name;

SELECT '========== PERMISSIONS BY ROLE ==========' as '';
SELECT 
    r.name as role_name,
    p.resource,
    p.action,
    p.name as permission_name
FROM roles r
JOIN role_permissions rp ON r.id = rp.role_id
JOIN permissions p ON rp.permission_id = p.id
ORDER BY r.name, p.resource, p.action;
COMMIT;