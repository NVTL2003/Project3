-- ============================================
-- DEMO SEED DATA FOR ELMS WORKFLOW (FIXED)
-- ============================================

USE PJ3;

SET FOREIGN_KEY_CHECKS = 0;

-- Clear existing data (in correct order)
TRUNCATE TABLE delivery_assignments;
TRUNCATE TABLE manifest_items;
TRUNCATE TABLE shipment_manifests;
TRUNCATE TABLE transport_orders;
TRUNCATE TABLE route_stops;
TRUNCATE TABLE routes;
TRUNCATE TABLE vehicles;
TRUNCATE TABLE proof_of_delivery;
TRUNCATE TABLE delivery_attempts;
TRUNCATE TABLE tracking_events;
TRUNCATE TABLE package_scans;
TRUNCATE TABLE tracking_status;
TRUNCATE TABLE shipments;
TRUNCATE TABLE shipment_requests;
TRUNCATE TABLE customer_addresses;
TRUNCATE TABLE customers;
TRUNCATE TABLE employees;
TRUNCATE TABLE user_roles;
TRUNCATE TABLE role_permissions;
TRUNCATE TABLE permissions;
TRUNCATE TABLE roles;
TRUNCATE TABLE users;
TRUNCATE TABLE facilities;
TRUNCATE TABLE services;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================
-- 1. USERS
-- ============================================
-- admin/admin123
-- employee/employee123
-- customer/customer123

INSERT INTO users (id, username, email, phone, password_hash, mfa_enabled, is_active) VALUES
(UUID(), 'admin', 'admin@elms.com', '9876543210', '$2a$11$EQPgCEs7kvisAluKlwcmOugU7NeUvxVrPwFvt0LOy7bceGdxMQa2S', FALSE, TRUE),
(UUID(), 'employee', 'employee@elms.com', '9876543211', '$2a$11$u5OW/VulwjeIpV6x.yTb8ecxESrVLAIMyPyJ4IOeKpqsfsX5on6UC', FALSE, TRUE),
(UUID(), 'customer', 'customer@elms.com', '9876543212', '$2a$11$HdcX.Tk1fvvV53J4tE2jsuxz4fYE/2807mjhHGz4TzIRYmpPaBXbm', FALSE, TRUE);

-- ============================================
-- 2. ROLES
-- ============================================
INSERT INTO roles (id, name, description, is_system) VALUES
(UUID(), 'Admin', 'Full system access', TRUE),
(UUID(), 'Employee', 'Operations management', FALSE),
(UUID(), 'Customer', 'Self-service access', FALSE);

-- ============================================
-- 3. FACILITIES
-- ============================================
INSERT INTO facilities (id, code, name, facility_type, address_line1, city, state, pincode, country, phone, email, is_active) VALUES
(UUID(), 'BOM-001', 'Mumbai Branch', 'Branch', '123 Marine Drive', 'Mumbai', 'Maharashtra', '400001', 'India', '022-1234567', 'mumbai@elms.com', TRUE),
(UUID(), 'BOM-DC', 'Mumbai Distribution Center', 'DistributionCenter', '456 Warehouse Road', 'Mumbai', 'Maharashtra', '400053', 'India', '022-7654321', 'mumbai.dc@elms.com', TRUE),
(UUID(), 'DEL-001', 'Delhi Branch', 'Branch', '789 Connaught Place', 'Delhi', 'Delhi', '110001', 'India', '011-1234567', 'delhi@elms.com', TRUE);

-- ============================================
-- 4. EMPLOYEES (each with unique user_id)
-- ============================================
INSERT INTO employees (id, user_id, first_name, last_name, branch_id, hire_date, employee_code, is_active) VALUES
(UUID(), (SELECT id FROM users WHERE username = 'admin'), 'System', 'Admin', (SELECT id FROM facilities WHERE code = 'BOM-001'), '2024-01-01', 'EMP-001', TRUE),
(UUID(), (SELECT id FROM users WHERE username = 'employee'), 'John', 'Doe', (SELECT id FROM facilities WHERE code = 'BOM-001'), '2024-01-15', 'EMP-002', TRUE);

-- ============================================
-- 5. CUSTOMERS
-- ============================================
INSERT INTO customers (id, user_id, first_name, last_name, account_number, is_active) VALUES
(UUID(), (SELECT id FROM users WHERE username = 'customer'), 'Demo', 'Customer', 'ACC-001', TRUE);

-- ============================================
-- 6. CUSTOMER ADDRESSES
-- ============================================
INSERT INTO customer_addresses (id, customer_id, address_type, recipient_name, phone, address_line1, city, state, pincode, country, is_default, is_active) VALUES
(UUID(), (SELECT id FROM customers WHERE account_number = 'ACC-001'), 'office', 'Demo Customer', '9876543210', '123 Main Street', 'Mumbai', 'Maharashtra', '400001', 'India', TRUE, TRUE),
(UUID(), (SELECT id FROM customers WHERE account_number = 'ACC-001'), 'home', 'Demo Customer', '9876543210', '456 Home Avenue', 'Mumbai', 'Maharashtra', '400053', 'India', FALSE, TRUE);

-- ============================================
-- 7. SERVICES
-- ============================================
INSERT INTO services (id, code, name, description, service_type, is_active) VALUES
(UUID(), 'STD', 'Standard Delivery', 'Standard delivery 2-3 days', 'standard', TRUE),
(UUID(), 'EXP', 'Express Delivery', 'Express delivery 1 day', 'express', TRUE);

-- ============================================
-- 8. VEHICLES
-- ============================================
INSERT INTO vehicles (id, vehicle_number, vehicle_type, brand, model, year, capacity, status, registration_number, fuel_type) VALUES
(UUID(), 'TRK-001', 'Truck', 'Tata', '407', 2022, 5000.00, 'Available', 'MH01AB1234', 'Diesel'),
(UUID(), 'VAN-001', 'Van', 'Maruti Suzuki', 'Eeco', 2023, 1500.00, 'Available', 'MH02CD5678', 'Petrol');

-- ============================================
-- 9. ROUTES
-- ============================================
INSERT INTO routes (id, route_code, name, origin_facility_id, destination_facility_id, distance, is_active) VALUES
(UUID(), 'R001', 'Mumbai to Delhi', 
    (SELECT id FROM facilities WHERE code = 'BOM-001'),
    (SELECT id FROM facilities WHERE code = 'DEL-001'),
    1400.00, TRUE),
(UUID(), 'R002', 'Mumbai Local',
    (SELECT id FROM facilities WHERE code = 'BOM-001'),
    (SELECT id FROM facilities WHERE code = 'BOM-DC'),
    25.00, TRUE);

-- ============================================
-- 10. TRACKING STATUSES
-- ============================================
INSERT INTO tracking_status (id, code, description, is_public) VALUES
(UUID(), 'CREATED', 'Shipment Created', TRUE),
(UUID(), 'PICKED_UP', 'Package Picked Up', TRUE),
(UUID(), 'IN_SORTING', 'Package In Sorting', TRUE),
(UUID(), 'LOADED', 'Package Loaded', TRUE),
(UUID(), 'IN_TRANSIT', 'Package In Transit', TRUE),
(UUID(), 'OUT_FOR_DELIVERY', 'Out for Delivery', TRUE),
(UUID(), 'DELIVERED', 'Package Delivered', TRUE),
(UUID(), 'EXCEPTION', 'Delivery Exception', TRUE);

-- ============================================
-- 11. USER ROLES
-- ============================================
INSERT INTO user_roles (id, user_id, role_id) VALUES
(UUID(), (SELECT id FROM users WHERE username = 'admin'), (SELECT id FROM roles WHERE name = 'Admin')),
(UUID(), (SELECT id FROM users WHERE username = 'employee'), (SELECT id FROM roles WHERE name = 'Employee')),
(UUID(), (SELECT id FROM users WHERE username = 'customer'), (SELECT id FROM roles WHERE name = 'Customer'));

-- ============================================
-- 12. PERMISSIONS
-- ============================================
INSERT INTO permissions (id, name, resource, action, description) VALUES
-- Customer permissions
(UUID(), 'customers.read', 'customers', 'read', 'View customers'),
(UUID(), 'customers.update', 'customers', 'update', 'Update customers'),
(UUID(), 'customer_addresses.read', 'customer_addresses', 'read', 'View addresses'),
(UUID(), 'customer_addresses.create', 'customer_addresses', 'create', 'Create addresses'),
(UUID(), 'customer_addresses.update', 'customer_addresses', 'update', 'Update addresses'),
(UUID(), 'customer_addresses.delete', 'customer_addresses', 'delete', 'Delete addresses'),
(UUID(), 'shipment_requests.read', 'shipment_requests', 'read', 'View shipment requests'),
(UUID(), 'shipment_requests.create', 'shipment_requests', 'create', 'Create shipment requests'),
(UUID(), 'shipment_requests.update', 'shipment_requests', 'update', 'Update shipment requests'),
-- Employee permissions
(UUID(), 'shipments.read', 'shipments', 'read', 'View shipments'),
(UUID(), 'shipments.create', 'shipments', 'create', 'Create shipments'),
(UUID(), 'shipments.update', 'shipments', 'update', 'Update shipments'),
(UUID(), 'package_scans.read', 'package_scans', 'read', 'View package scans'),
(UUID(), 'package_scans.create', 'package_scans', 'create', 'Create package scans'),
(UUID(), 'package_scans.update', 'package_scans', 'update', 'Update package scans'),
(UUID(), 'tracking_events.read', 'tracking_events', 'read', 'View tracking events'),
(UUID(), 'tracking_events.create', 'tracking_events', 'create', 'Create tracking events'),
(UUID(), 'transport_orders.read', 'transport_orders', 'read', 'View transport orders'),
(UUID(), 'transport_orders.create', 'transport_orders', 'create', 'Create transport orders'),
(UUID(), 'transport_orders.update', 'transport_orders', 'update', 'Update transport orders'),
(UUID(), 'delivery_attempts.read', 'delivery_attempts', 'read', 'View delivery attempts'),
(UUID(), 'delivery_attempts.create', 'delivery_attempts', 'create', 'Create delivery attempts'),
(UUID(), 'proof_of_delivery.read', 'proof_of_delivery', 'read', 'View proof of delivery'),
(UUID(), 'proof_of_delivery.create', 'proof_of_delivery', 'create', 'Create proof of delivery'),
(UUID(), 'vehicles.read', 'vehicles', 'read', 'View vehicles'),
(UUID(), 'routes.read', 'routes', 'read', 'View routes'),
(UUID(), 'facilities.read', 'facilities', 'read', 'View facilities');

-- ============================================
-- 13. ROLE PERMISSIONS
-- ============================================
-- Admin gets everything
INSERT INTO role_permissions (id, role_id, permission_id)
SELECT UUID(), (SELECT id FROM roles WHERE name = 'Admin'), id FROM permissions;

-- Employee gets operational permissions
INSERT INTO role_permissions (id, role_id, permission_id)
SELECT UUID(), (SELECT id FROM roles WHERE name = 'Employee'), id 
FROM permissions 
WHERE name IN (
    'shipments.read', 'shipments.create', 'shipments.update',
    'package_scans.read', 'package_scans.create', 'package_scans.update',
    'tracking_events.read', 'tracking_events.create',
    'transport_orders.read', 'transport_orders.create', 'transport_orders.update',
    'delivery_attempts.read', 'delivery_attempts.create',
    'proof_of_delivery.read', 'proof_of_delivery.create',
    'vehicles.read', 'routes.read', 'facilities.read',
    'shipment_requests.read', 'shipment_requests.update',
    'customers.read'
);

-- Customer gets self-service permissions
INSERT INTO role_permissions (id, role_id, permission_id)
SELECT UUID(), (SELECT id FROM roles WHERE name = 'Customer'), id 
FROM permissions 
WHERE name IN (
    'customers.read', 'customers.update',
    'customer_addresses.read', 'customer_addresses.create', 'customer_addresses.update', 'customer_addresses.delete',
    'shipment_requests.read', 'shipment_requests.create',
    'shipments.read',
    'tracking_events.read',
    'proof_of_delivery.read'
);

-- ============================================
-- 14. SHIPMENT MANIFEST (optional - for delivery assignment)
-- ============================================
INSERT INTO shipment_manifests (id, manifest_number, vehicle_id, driver_id, route_id, departure_facility_id, departure_time, status, total_packages, total_weight) 
SELECT 
    UUID(), 'MAN-001', 
    (SELECT id FROM vehicles WHERE vehicle_number = 'TRK-001'),
    (SELECT id FROM employees WHERE employee_code = 'EMP-002'),  -- Using employee as driver for demo
    (SELECT id FROM routes WHERE route_code = 'R001'),
    (SELECT id FROM facilities WHERE code = 'BOM-001'),
    NOW(), 'planned', 0, 0;

-- ============================================
-- VERIFICATION
-- ============================================
SELECT 'Users' as table_name, COUNT(*) as count FROM users
UNION ALL SELECT 'Facilities', COUNT(*) FROM facilities
UNION ALL SELECT 'Employees', COUNT(*) FROM employees
UNION ALL SELECT 'Customers', COUNT(*) FROM customers
UNION ALL SELECT 'Vehicles', COUNT(*) FROM vehicles
UNION ALL SELECT 'Routes', COUNT(*) FROM routes
UNION ALL SELECT 'Services', COUNT(*) FROM services
UNION ALL SELECT 'Tracking Statuses', COUNT(*) FROM tracking_status;