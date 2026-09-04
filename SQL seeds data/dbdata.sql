-- =============================================
-- TRUNCATE ALL TABLES (with foreign key checks disabled)
-- =============================================

SET FOREIGN_KEY_CHECKS = 0;

-- Module 8: Administration
TRUNCATE TABLE employee_profile_requests;
TRUNCATE TABLE login_history;
TRUNCATE TABLE audit_logs;

-- Module 7: Finance
TRUNCATE TABLE payments;
TRUNCATE TABLE shipment_charges;
TRUNCATE TABLE invoices;
TRUNCATE TABLE expenses;

-- Module 6: Transportation
TRUNCATE TABLE delivery_assignments;
TRUNCATE TABLE manifest_items;
TRUNCATE TABLE shipment_manifests;
TRUNCATE TABLE transport_orders;
TRUNCATE TABLE route_stops;
TRUNCATE TABLE routes;
TRUNCATE TABLE vehicle_gps;
TRUNCATE TABLE vehicle_fuel_logs;
TRUNCATE TABLE vehicle_maintenance;
TRUNCATE TABLE vehicles;

-- Module 5: Shipment
TRUNCATE TABLE notifications;
TRUNCATE TABLE proof_of_delivery;
TRUNCATE TABLE delivery_attempts;
TRUNCATE TABLE tracking_events;
TRUNCATE TABLE package_scans;
TRUNCATE TABLE tracking_status;
TRUNCATE TABLE shipment_status_history;
TRUNCATE TABLE shipment_contacts;
TRUNCATE TABLE shipments;

-- Module 4: Pricing
TRUNCATE TABLE pricing_rules;
TRUNCATE TABLE insurance_plans;
TRUNCATE TABLE services;

-- Module 3: Facilities
TRUNCATE TABLE storage_areas;
TRUNCATE TABLE pincodes;
TRUNCATE TABLE facilities;

-- Module 2: Customer
TRUNCATE TABLE shipment_requests;
TRUNCATE TABLE customer_addresses;

-- Module 1: Identity
TRUNCATE TABLE user_roles;
TRUNCATE TABLE role_permissions;
TRUNCATE TABLE permissions;
TRUNCATE TABLE roles;
TRUNCATE TABLE customers;
TRUNCATE TABLE employees;
TRUNCATE TABLE positions;
TRUNCATE TABLE departments;
TRUNCATE TABLE users;

SET FOREIGN_KEY_CHECKS = 1;

-- =============================================
-- ADD UNIQUE CONSTRAINTS TO PREVENT DUPLICATES
-- (Conditionally drop existing indexes)
-- =============================================

DELIMITER $$
CREATE PROCEDURE DropIndexIfExists(IN tableName VARCHAR(64), IN indexName VARCHAR(64))
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.statistics 
               WHERE table_schema = DATABASE() 
               AND table_name = tableName 
               AND index_name = indexName) THEN
        SET @sql = CONCAT('DROP INDEX ', indexName, ' ON ', tableName);
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
END$$
DELIMITER ;

CALL DropIndexIfExists('permissions', 'idx_unique_resource_action');
CALL DropIndexIfExists('role_permissions', 'idx_unique_role_permission');
CALL DropIndexIfExists('user_roles', 'idx_unique_user_role');
CALL DropIndexIfExists('roles', 'idx_unique_role_name');
CALL DropIndexIfExists('users', 'idx_unique_username');

DROP PROCEDURE DropIndexIfExists;

-- Now create the unique indexes
ALTER TABLE permissions ADD UNIQUE INDEX idx_unique_resource_action (resource, action);
ALTER TABLE role_permissions ADD UNIQUE INDEX idx_unique_role_permission (role_id, permission_id);
ALTER TABLE user_roles ADD UNIQUE INDEX idx_unique_user_role (user_id, role_id);
ALTER TABLE roles ADD UNIQUE INDEX idx_unique_role_name (name);
ALTER TABLE users ADD UNIQUE INDEX idx_unique_username (username);

-- =============================================
-- INSERT DATA WITH PROPER GUIDS
-- =============================================

-- MODULE 1: Identity - Users
-- admin password : admin123
-- employee password : employee123  
-- customer password : customer123

INSERT IGNORE INTO users (id, username, email, phone, password_hash, mfa_enabled, mfa_secret, is_active, last_login) VALUES
(UUID(), 'admin', 'admin@elms.com', '9876543210', '$2a$11$EQPgCEs7kvisAluKlwcmOugU7NeUvxVrPwFvt0LOy7bceGdxMQa2S', FALSE, NULL, TRUE, NOW()), 
(UUID(), 'employee', 'employee@elms.com', '9876543211', '$2a$11$u5OW/VulwjeIpV6x.yTb8ecxESrVLAIMyPyJ4IOeKpqsfsX5on6UC', FALSE, NULL, TRUE, NOW()),
(UUID(), 'customer', 'customer@elms.com', '9876543212', '$2a$11$HdcX.Tk1fvvV53J4tE2jsuxz4fYE/2807mjhHGz4TzIRYmpPaBXbm', FALSE, NULL, TRUE, NOW()),
(UUID(), 'john.doe', 'john.doe@elms.com', '9876543213', '$2a$11$K7x5nXxY7xZ8xW9xY6xZ8xW9xY6xZ8xW9xY6xZ8xW9xY6xZ8xW9xY6xZ8x', FALSE, NULL, TRUE, NOW()),
(UUID(), 'jane.smith', 'jane.smith@elms.com', '9876543214', '$2a$11$K7x5nXxY7xZ8xW9xY6xZ8xW9xY6xZ8xW9xY6xZ8xW9xY6xZ8xW9xY6xZ8x', FALSE, NULL, TRUE, NOW()),
(UUID(), 'mike.wilson', 'mike.wilson@elms.com', '9876543215', '$2a$11$K7x5nXxY7xZ8xW9xY6xZ8xW9xY6xZ8xW9xY6xZ8xW9xY6xZ8xW9xY6xZ8x', FALSE, NULL, TRUE, NOW()),
(UUID(), 'sarah.parker', 'sarah.parker@elms.com', '9876543216', '$2a$11$K7x5nXxY7xZ8xW9xY6xZ8xW9xY6xZ8xW9xY6xZ8xW9xY6xZ8xW9xY6xZ8x', FALSE, NULL, TRUE, NOW()),
(UUID(), 'robert.taylor', 'robert.taylor@elms.com', '9876543217', '$2a$11$K7x5nXxY7xZ8xW9xY6xZ8xW9xY6xZ8xW9xY6xZ8xW9xY6xZ8xW9xY6xZ8x', FALSE, NULL, TRUE, NOW());

-- MODULE 1: Identity - Departments
INSERT IGNORE INTO departments (id, name, description, is_active) VALUES
(UUID(), 'Warehouse Operations', 'Manages all warehouse activities', TRUE),
(UUID(), 'Transportation', 'Manages fleet and delivery operations', TRUE),
(UUID(), 'Customer Service', 'Handles customer inquiries and support', TRUE),
(UUID(), 'Finance', 'Manages billing, payments, and accounting', TRUE),
(UUID(), 'Human Resources', 'Manages employee relations and hiring', TRUE),
(UUID(), 'IT Department', 'Manages technology infrastructure', TRUE);

-- MODULE 1: Identity - Positions
INSERT IGNORE INTO positions (id, name, description, is_active) VALUES
(UUID(), 'Warehouse Manager', 'Oversees warehouse operations', TRUE),
(UUID(), 'Operations Manager', 'Manages overall operations', TRUE),
(UUID(), 'Customer Service Representative', 'Handles customer inquiries', TRUE),
(UUID(), 'Accountant', 'Manages financial records', TRUE),
(UUID(), 'HR Manager', 'Oversees human resources', TRUE),
(UUID(), 'Systems Administrator', 'Manages IT systems', TRUE),
(UUID(), 'Driver', 'Operates delivery vehicles', TRUE),
(UUID(), 'Warehouse Staff', 'Handles warehouse tasks', TRUE),
(UUID(), 'Branch Manager', 'Manages branch operations', TRUE);

-- MODULE 3: Facilities
INSERT IGNORE INTO facilities (id, code, name, facility_type, address_line1, address_line2, city, state, pincode, country, phone, email, branch_manager_id, capacity, current_occupancy, is_active) VALUES
(UUID(), 'BOM-001', 'Mumbai Branch', 'Branch', '123 Marine Drive', 'Opposite Gateway', 'Mumbai', 'Maharashtra', '400001', 'India', '022-1234567', 'mumbai@elms.com', NULL, 5000.00, 2500.00, TRUE),
(UUID(), 'BOM-DC', 'Mumbai Distribution Center', 'DistributionCenter', '456 Warehouse Road', 'Near Andheri', 'Mumbai', 'Maharashtra', '400053', 'India', '022-7654321', 'mumbai.dc@elms.com', NULL, 10000.00, 6500.00, TRUE),
(UUID(), 'DEL-001', 'Delhi Branch', 'Branch', '789 Connaught Place', 'Near Metro Station', 'Delhi', 'Delhi', '110001', 'India', '011-1234567', 'delhi@elms.com', NULL, 4500.00, 2000.00, TRUE),
(UUID(), 'CHE-001', 'Chennai Branch', 'Branch', '456 Anna Salai', 'Near Egmore', 'Chennai', 'Tamil Nadu', '600001', 'India', '044-1234567', 'chennai@elms.com', NULL, 4000.00, 1500.00, TRUE),
(UUID(), 'HYD-001', 'Hyderabad Branch', 'Branch', '789 Banjara Hills', 'Road No 1', 'Hyderabad', 'Telangana', '500034', 'India', '040-1234567', 'hyderabad@elms.com', NULL, 3500.00, 1200.00, TRUE),
(UUID(), 'KOL-001', 'Kolkata Branch', 'Branch', '321 Park Street', 'Near Park Hotel', 'Kolkata', 'West Bengal', '700016', 'India', '033-1234567', 'kolkata@elms.com', NULL, 3800.00, 1400.00, TRUE);

-- MODULE 1: Identity - Employees
INSERT IGNORE INTO employees (id, user_id, first_name, last_name, department_id, position_id, branch_id, hire_date, employee_code, is_active) VALUES
(UUID(), (SELECT id FROM users WHERE username = 'admin'), 'System', 'Admin', (SELECT id FROM departments WHERE name = 'IT Department'), (SELECT id FROM positions WHERE name = 'Systems Administrator'), NULL, '2024-01-01', 'EMP-001', TRUE),
(UUID(), (SELECT id FROM users WHERE username = 'employee'), 'John', 'Doe', (SELECT id FROM departments WHERE name = 'Warehouse Operations'), (SELECT id FROM positions WHERE name = 'Warehouse Manager'), (SELECT id FROM facilities WHERE code = 'BOM-001'), '2024-01-15', 'EMP-002', TRUE),
(UUID(), (SELECT id FROM users WHERE username = 'john.doe'), 'John', 'Doe', (SELECT id FROM departments WHERE name = 'Warehouse Operations'), (SELECT id FROM positions WHERE name = 'Warehouse Manager'), (SELECT id FROM facilities WHERE code = 'BOM-001'), '2024-01-15', 'EMP-003', TRUE),
(UUID(), (SELECT id FROM users WHERE username = 'jane.smith'), 'Jane', 'Smith', (SELECT id FROM departments WHERE name = 'Customer Service'), (SELECT id FROM positions WHERE name = 'Customer Service Representative'), (SELECT id FROM facilities WHERE code = 'BOM-001'), '2024-02-01', 'EMP-004', TRUE),
(UUID(), (SELECT id FROM users WHERE username = 'mike.wilson'), 'Mike', 'Wilson', (SELECT id FROM departments WHERE name = 'Transportation'), (SELECT id FROM positions WHERE name = 'Driver'), (SELECT id FROM facilities WHERE code = 'BOM-DC'), '2024-02-15', 'EMP-005', TRUE),
(UUID(), (SELECT id FROM users WHERE username = 'sarah.parker'), 'Sarah', 'Parker', (SELECT id FROM departments WHERE name = 'Warehouse Operations'), (SELECT id FROM positions WHERE name = 'Warehouse Staff'), (SELECT id FROM facilities WHERE code = 'BOM-DC'), '2024-03-01', 'EMP-006', TRUE),
(UUID(), (SELECT id FROM users WHERE username = 'robert.taylor'), 'Robert', 'Taylor', (SELECT id FROM departments WHERE name = 'Warehouse Operations'), (SELECT id FROM positions WHERE name = 'Branch Manager'), (SELECT id FROM facilities WHERE code = 'DEL-001'), '2024-01-15', 'EMP-007', TRUE);

-- Update facilities with branch managers
UPDATE facilities SET branch_manager_id = (SELECT id FROM employees WHERE employee_code = 'EMP-003') WHERE code = 'BOM-001';
UPDATE facilities SET branch_manager_id = (SELECT id FROM employees WHERE employee_code = 'EMP-003') WHERE code = 'BOM-DC';
UPDATE facilities SET branch_manager_id = (SELECT id FROM employees WHERE employee_code = 'EMP-007') WHERE code = 'DEL-001';
UPDATE facilities SET branch_manager_id = (SELECT id FROM employees WHERE employee_code = 'EMP-007') WHERE code = 'CHE-001';
UPDATE facilities SET branch_manager_id = (SELECT id FROM employees WHERE employee_code = 'EMP-007') WHERE code = 'HYD-001';
UPDATE facilities SET branch_manager_id = (SELECT id FROM employees WHERE employee_code = 'EMP-007') WHERE code = 'KOL-001';

-- MODULE 1: Identity - Customers
INSERT IGNORE INTO customers (id, user_id, company_name, first_name, last_name, tax_id, account_number, credit_limit, is_active) VALUES
(UUID(), (SELECT id FROM users WHERE username = 'customer'), 'ELMS Corporate', 'Customer', 'One', 'TAX-001', 'ACC-001', 100000.00, TRUE),
(UUID(), (SELECT id FROM users WHERE username = 'john.doe'), 'Tech Solutions Ltd', 'John', 'Doe', 'TAX-002', 'ACC-002', 50000.00, TRUE),
(UUID(), (SELECT id FROM users WHERE username = 'jane.smith'), 'Global Logistics Inc', 'Jane', 'Smith', 'TAX-003', 'ACC-003', 75000.00, TRUE),
(UUID(), (SELECT id FROM users WHERE username = 'mike.wilson'), 'Fast Delivery Services', 'Mike', 'Wilson', 'TAX-004', 'ACC-004', 25000.00, TRUE);

-- MODULE 1: Identity - Roles (3 main roles)
INSERT IGNORE INTO roles (id, name, description, is_system) VALUES
(UUID(), 'Admin', 'Full system access - can manage everything', TRUE),
(UUID(), 'Employee', 'Can manage shipments, facilities, and operations', FALSE),
(UUID(), 'Customer', 'Can view their own shipments and create new ones', FALSE),
(UUID(), 'Branch Manager', 'Manages branch operations', FALSE),
(UUID(), 'Driver', 'Delivery personnel', FALSE);

-- MODULE 1: Identity - Permissions (All permissions with duplicate prevention)
INSERT IGNORE INTO permissions (id, name, resource, action, description) VALUES
-- Admin permissions (all)
(UUID(), 'admin.access', 'admin', 'access', 'Full admin access'),
(UUID(), 'users.manage', 'users', 'manage', 'Manage all users'),
(UUID(), 'roles.manage', 'roles', 'manage', 'Manage roles and permissions'),

-- Employee permissions
(UUID(), 'facilities.view', 'facilities', 'view', 'View facilities'),
(UUID(), 'facilities.create', 'facilities', 'create', 'Create facilities'),
(UUID(), 'facilities.edit', 'facilities', 'edit', 'Edit facilities'),
(UUID(), 'facilities.delete', 'facilities', 'delete', 'Delete facilities'),

(UUID(), 'shipments.view', 'shipments', 'view', 'View all shipments'),
(UUID(), 'shipments.create', 'shipments', 'create', 'Create shipments'),
(UUID(), 'shipments.edit', 'shipments', 'edit', 'Edit shipments'),
(UUID(), 'shipments.delete', 'shipments', 'delete', 'Delete shipments'),
(UUID(), 'shipments.assign', 'shipments', 'assign', 'Assign shipments'),

(UUID(), 'employees.view', 'employees', 'view', 'View employees'),
(UUID(), 'employees.manage', 'employees', 'manage', 'Manage employees'),

-- Customer permissions (limited)
(UUID(), 'customer.shipments.view', 'customer_shipments', 'view', 'View own shipments'),
(UUID(), 'customer.shipments.create', 'customer_shipments', 'create', 'Create shipment requests'),
(UUID(), 'customer.shipments.track', 'customer_shipments', 'track', 'Track own shipments'),
(UUID(), 'customer.profile.view', 'customer_profile', 'view', 'View own profile'),
(UUID(), 'customer.profile.edit', 'customer_profile', 'edit', 'Edit own profile'),

-- Driver permissions
(UUID(), 'driver.shipments.view', 'driver_shipments', 'view', 'View assigned shipments'),
(UUID(), 'driver.shipments.update', 'driver_shipments', 'update', 'Update shipment status'),
(UUID(), 'driver.routes.view', 'driver_routes', 'view', 'View routes'),

-- Identity Module Permissions
(UUID(), 'users.read', 'users', 'read', 'View users'),
(UUID(), 'users.create', 'users', 'create', 'Create users'),
(UUID(), 'users.update', 'users', 'update', 'Update users'),
(UUID(), 'users.delete', 'users', 'delete', 'Delete users'),

(UUID(), 'roles.read', 'roles', 'read', 'View roles'),
(UUID(), 'roles.create', 'roles', 'create', 'Create roles'),
(UUID(), 'roles.update', 'roles', 'update', 'Update roles'),
(UUID(), 'roles.delete', 'roles', 'delete', 'Delete roles'),

(UUID(), 'permissions.read', 'permissions', 'read', 'View permissions'),
(UUID(), 'permissions.create', 'permissions', 'create', 'Create permissions'),
(UUID(), 'permissions.update', 'permissions', 'update', 'Update permissions'),
(UUID(), 'permissions.delete', 'permissions', 'delete', 'Delete permissions'),

(UUID(), 'user_roles.read', 'user_roles', 'read', 'View user roles'),
(UUID(), 'user_roles.create', 'user_roles', 'create', 'Assign roles to users'),
(UUID(), 'user_roles.update', 'user_roles', 'update', 'Update user roles'),
(UUID(), 'user_roles.delete', 'user_roles', 'delete', 'Remove roles from users'),

(UUID(), 'role_permissions.read', 'role_permissions', 'read', 'View role permissions'),
(UUID(), 'role_permissions.create', 'role_permissions', 'create', 'Assign permissions to roles'),
(UUID(), 'role_permissions.update', 'role_permissions', 'update', 'Update role permissions'),
(UUID(), 'role_permissions.delete', 'role_permissions', 'delete', 'Remove permissions from roles'),

(UUID(), 'departments.read', 'departments', 'read', 'View departments'),
(UUID(), 'departments.create', 'departments', 'create', 'Create departments'),
(UUID(), 'departments.update', 'departments', 'update', 'Update departments'),
(UUID(), 'departments.delete', 'departments', 'delete', 'Delete departments'),

(UUID(), 'positions.read', 'positions', 'read', 'View positions'),
(UUID(), 'positions.create', 'positions', 'create', 'Create positions'),
(UUID(), 'positions.update', 'positions', 'update', 'Update positions'),
(UUID(), 'positions.delete', 'positions', 'delete', 'Delete positions'),

(UUID(), 'employees.read', 'employees', 'read', 'View employees'),
(UUID(), 'employees.create', 'employees', 'create', 'Create employees'),
(UUID(), 'employees.update', 'employees', 'update', 'Update employees'),
(UUID(), 'employees.delete', 'employees', 'delete', 'Delete employees'),

(UUID(), 'customers.read', 'customers', 'read', 'View customers'),
(UUID(), 'customers.create', 'customers', 'create', 'Create customers'),
(UUID(), 'customers.update', 'customers', 'update', 'Update customers'),
(UUID(), 'customers.delete', 'customers', 'delete', 'Delete customers'),

-- Customer Module Permissions
(UUID(), 'customer_addresses.read', 'customer_addresses', 'read', 'View customer addresses'),
(UUID(), 'customer_addresses.create', 'customer_addresses', 'create', 'Create customer addresses'),
(UUID(), 'customer_addresses.update', 'customer_addresses', 'update', 'Update customer addresses'),
(UUID(), 'customer_addresses.delete', 'customer_addresses', 'delete', 'Delete customer addresses'),

(UUID(), 'shipment_requests.read', 'shipment_requests', 'read', 'View shipment requests'),
(UUID(), 'shipment_requests.create', 'shipment_requests', 'create', 'Create shipment requests'),
(UUID(), 'shipment_requests.update', 'shipment_requests', 'update', 'Update shipment requests'),
(UUID(), 'shipment_requests.delete', 'shipment_requests', 'delete', 'Delete shipment requests'),

-- Facilities Module Permissions
(UUID(), 'facilities.read', 'facilities', 'read', 'View facilities'),
(UUID(), 'facilities.create', 'facilities', 'create', 'Create facilities'),
(UUID(), 'facilities.update', 'facilities', 'update', 'Update facilities'),
(UUID(), 'facilities.delete', 'facilities', 'delete', 'Delete facilities'),

(UUID(), 'pincodes.read', 'pincodes', 'read', 'View pincodes'),
(UUID(), 'pincodes.create', 'pincodes', 'create', 'Create pincodes'),
(UUID(), 'pincodes.update', 'pincodes', 'update', 'Update pincodes'),
(UUID(), 'pincodes.delete', 'pincodes', 'delete', 'Delete pincodes'),

(UUID(), 'storage_areas.read', 'storage_areas', 'read', 'View storage areas'),
(UUID(), 'storage_areas.create', 'storage_areas', 'create', 'Create storage areas'),
(UUID(), 'storage_areas.update', 'storage_areas', 'update', 'Update storage areas'),
(UUID(), 'storage_areas.delete', 'storage_areas', 'delete', 'Delete storage areas'),

-- Pricing Module Permissions
(UUID(), 'services.read', 'services', 'read', 'View services'),
(UUID(), 'services.create', 'services', 'create', 'Create services'),
(UUID(), 'services.update', 'services', 'update', 'Update services'),
(UUID(), 'services.delete', 'services', 'delete', 'Delete services'),

(UUID(), 'pricing_rules.read', 'pricing_rules', 'read', 'View pricing rules'),
(UUID(), 'pricing_rules.create', 'pricing_rules', 'create', 'Create pricing rules'),
(UUID(), 'pricing_rules.update', 'pricing_rules', 'update', 'Update pricing rules'),
(UUID(), 'pricing_rules.delete', 'pricing_rules', 'delete', 'Delete pricing rules'),

(UUID(), 'insurance_plans.read', 'insurance_plans', 'read', 'View insurance plans'),
(UUID(), 'insurance_plans.create', 'insurance_plans', 'create', 'Create insurance plans'),
(UUID(), 'insurance_plans.update', 'insurance_plans', 'update', 'Update insurance plans'),
(UUID(), 'insurance_plans.delete', 'insurance_plans', 'delete', 'Delete insurance plans'),

-- Shipment Module Permissions
(UUID(), 'shipments.read', 'shipments', 'read', 'View shipments'),
(UUID(), 'shipments.create', 'shipments', 'create', 'Create shipments'),
(UUID(), 'shipments.update', 'shipments', 'update', 'Update shipments'),
(UUID(), 'shipments.delete', 'shipments', 'delete', 'Delete shipments'),

(UUID(), 'shipment_contacts.read', 'shipment_contacts', 'read', 'View shipment contacts'),
(UUID(), 'shipment_contacts.create', 'shipment_contacts', 'create', 'Create shipment contacts'),
(UUID(), 'shipment_contacts.update', 'shipment_contacts', 'update', 'Update shipment contacts'),
(UUID(), 'shipment_contacts.delete', 'shipment_contacts', 'delete', 'Delete shipment contacts'),

(UUID(), 'shipment_status_history.read', 'shipment_status_history', 'read', 'View shipment status history'),
(UUID(), 'shipment_status_history.create', 'shipment_status_history', 'create', 'Create shipment status history'),
(UUID(), 'shipment_status_history.update', 'shipment_status_history', 'update', 'Update shipment status history'),
(UUID(), 'shipment_status_history.delete', 'shipment_status_history', 'delete', 'Delete shipment status history'),

(UUID(), 'tracking_status.read', 'tracking_status', 'read', 'View tracking statuses'),
(UUID(), 'tracking_status.create', 'tracking_status', 'create', 'Create tracking statuses'),
(UUID(), 'tracking_status.update', 'tracking_status', 'update', 'Update tracking statuses'),
(UUID(), 'tracking_status.delete', 'tracking_status', 'delete', 'Delete tracking statuses'),

(UUID(), 'package_scans.read', 'package_scans', 'read', 'View package scans'),
(UUID(), 'package_scans.create', 'package_scans', 'create', 'Create package scans'),
(UUID(), 'package_scans.update', 'package_scans', 'update', 'Update package scans'),
(UUID(), 'package_scans.delete', 'package_scans', 'delete', 'Delete package scans'),

(UUID(), 'tracking_events.read', 'tracking_events', 'read', 'View tracking events'),
(UUID(), 'tracking_events.create', 'tracking_events', 'create', 'Create tracking events'),
(UUID(), 'tracking_events.update', 'tracking_events', 'update', 'Update tracking events'),
(UUID(), 'tracking_events.delete', 'tracking_events', 'delete', 'Delete tracking events'),

(UUID(), 'delivery_attempts.read', 'delivery_attempts', 'read', 'View delivery attempts'),
(UUID(), 'delivery_attempts.create', 'delivery_attempts', 'create', 'Create delivery attempts'),
(UUID(), 'delivery_attempts.update', 'delivery_attempts', 'update', 'Update delivery attempts'),
(UUID(), 'delivery_attempts.delete', 'delivery_attempts', 'delete', 'Delete delivery attempts'),

(UUID(), 'proof_of_delivery.read', 'proof_of_delivery', 'read', 'View proof of delivery'),
(UUID(), 'proof_of_delivery.create', 'proof_of_delivery', 'create', 'Create proof of delivery'),
(UUID(), 'proof_of_delivery.update', 'proof_of_delivery', 'update', 'Update proof of delivery'),
(UUID(), 'proof_of_delivery.delete', 'proof_of_delivery', 'delete', 'Delete proof of delivery'),

(UUID(), 'notifications.read', 'notifications', 'read', 'View notifications'),
(UUID(), 'notifications.create', 'notifications', 'create', 'Create notifications'),
(UUID(), 'notifications.update', 'notifications', 'update', 'Update notifications'),
(UUID(), 'notifications.delete', 'notifications', 'delete', 'Delete notifications'),

-- Transportation Module Permissions
(UUID(), 'vehicles.read', 'vehicles', 'read', 'View vehicles'),
(UUID(), 'vehicles.create', 'vehicles', 'create', 'Create vehicles'),
(UUID(), 'vehicles.update', 'vehicles', 'update', 'Update vehicles'),
(UUID(), 'vehicles.delete', 'vehicles', 'delete', 'Delete vehicles'),

(UUID(), 'vehicle_maintenance.read', 'vehicle_maintenance', 'read', 'View vehicle maintenance'),
(UUID(), 'vehicle_maintenance.create', 'vehicle_maintenance', 'create', 'Create vehicle maintenance'),
(UUID(), 'vehicle_maintenance.update', 'vehicle_maintenance', 'update', 'Update vehicle maintenance'),
(UUID(), 'vehicle_maintenance.delete', 'vehicle_maintenance', 'delete', 'Delete vehicle maintenance'),

(UUID(), 'vehicle_fuel_logs.read', 'vehicle_fuel_logs', 'read', 'View vehicle fuel logs'),
(UUID(), 'vehicle_fuel_logs.create', 'vehicle_fuel_logs', 'create', 'Create vehicle fuel logs'),
(UUID(), 'vehicle_fuel_logs.update', 'vehicle_fuel_logs', 'update', 'Update vehicle fuel logs'),
(UUID(), 'vehicle_fuel_logs.delete', 'vehicle_fuel_logs', 'delete', 'Delete vehicle fuel logs'),

(UUID(), 'vehicle_gps.read', 'vehicle_gps', 'read', 'View vehicle GPS'),
(UUID(), 'vehicle_gps.create', 'vehicle_gps', 'create', 'Create vehicle GPS'),
(UUID(), 'vehicle_gps.update', 'vehicle_gps', 'update', 'Update vehicle GPS'),
(UUID(), 'vehicle_gps.delete', 'vehicle_gps', 'delete', 'Delete vehicle GPS'),

(UUID(), 'routes.read', 'routes', 'read', 'View routes'),
(UUID(), 'routes.create', 'routes', 'create', 'Create routes'),
(UUID(), 'routes.update', 'routes', 'update', 'Update routes'),
(UUID(), 'routes.delete', 'routes', 'delete', 'Delete routes'),

(UUID(), 'route_stops.read', 'route_stops', 'read', 'View route stops'),
(UUID(), 'route_stops.create', 'route_stops', 'create', 'Create route stops'),
(UUID(), 'route_stops.update', 'route_stops', 'update', 'Update route stops'),
(UUID(), 'route_stops.delete', 'route_stops', 'delete', 'Delete route stops'),

(UUID(), 'transport_orders.read', 'transport_orders', 'read', 'View transport orders'),
(UUID(), 'transport_orders.create', 'transport_orders', 'create', 'Create transport orders'),
(UUID(), 'transport_orders.update', 'transport_orders', 'update', 'Update transport orders'),
(UUID(), 'transport_orders.delete', 'transport_orders', 'delete', 'Delete transport orders'),

(UUID(), 'shipment_manifests.read', 'shipment_manifests', 'read', 'View shipment manifests'),
(UUID(), 'shipment_manifests.create', 'shipment_manifests', 'create', 'Create shipment manifests'),
(UUID(), 'shipment_manifests.update', 'shipment_manifests', 'update', 'Update shipment manifests'),
(UUID(), 'shipment_manifests.delete', 'shipment_manifests', 'delete', 'Delete shipment manifests'),

(UUID(), 'manifest_items.read', 'manifest_items', 'read', 'View manifest items'),
(UUID(), 'manifest_items.create', 'manifest_items', 'create', 'Create manifest items'),
(UUID(), 'manifest_items.update', 'manifest_items', 'update', 'Update manifest items'),
(UUID(), 'manifest_items.delete', 'manifest_items', 'delete', 'Delete manifest items'),

(UUID(), 'delivery_assignments.read', 'delivery_assignments', 'read', 'View delivery assignments'),
(UUID(), 'delivery_assignments.create', 'delivery_assignments', 'create', 'Create delivery assignments'),
(UUID(), 'delivery_assignments.update', 'delivery_assignments', 'update', 'Update delivery assignments'),
(UUID(), 'delivery_assignments.delete', 'delivery_assignments', 'delete', 'Delete delivery assignments'),

-- Finance Module Permissions
(UUID(), 'invoices.read', 'invoices', 'read', 'View invoices'),
(UUID(), 'invoices.create', 'invoices', 'create', 'Create invoices'),
(UUID(), 'invoices.update', 'invoices', 'update', 'Update invoices'),
(UUID(), 'invoices.delete', 'invoices', 'delete', 'Delete invoices'),

(UUID(), 'shipment_charges.read', 'shipment_charges', 'read', 'View shipment charges'),
(UUID(), 'shipment_charges.create', 'shipment_charges', 'create', 'Create shipment charges'),
(UUID(), 'shipment_charges.update', 'shipment_charges', 'update', 'Update shipment charges'),
(UUID(), 'shipment_charges.delete', 'shipment_charges', 'delete', 'Delete shipment charges'),

(UUID(), 'payments.read', 'payments', 'read', 'View payments'),
(UUID(), 'payments.create', 'payments', 'create', 'Create payments'),
(UUID(), 'payments.update', 'payments', 'update', 'Update payments'),
(UUID(), 'payments.delete', 'payments', 'delete', 'Delete payments'),

(UUID(), 'expenses.read', 'expenses', 'read', 'View expenses'),
(UUID(), 'expenses.create', 'expenses', 'create', 'Create expenses'),
(UUID(), 'expenses.update', 'expenses', 'update', 'Update expenses'),
(UUID(), 'expenses.delete', 'expenses', 'delete', 'Delete expenses'),

-- Administration Module Permissions
(UUID(), 'audit_logs.read', 'audit_logs', 'read', 'View audit logs'),
(UUID(), 'audit_logs.create', 'audit_logs', 'create', 'Create audit logs'),
(UUID(), 'audit_logs.update', 'audit_logs', 'update', 'Update audit logs'),
(UUID(), 'audit_logs.delete', 'audit_logs', 'delete', 'Delete audit logs'),

(UUID(), 'login_history.read', 'login_history', 'read', 'View login history'),
(UUID(), 'login_history.create', 'login_history', 'create', 'Create login history'),
(UUID(), 'login_history.update', 'login_history', 'update', 'Update login history'),
(UUID(), 'login_history.delete', 'login_history', 'delete', 'Delete login history'),

(UUID(), 'employee_profile_requests.read', 'employee_profile_requests', 'read', 'View employee profile requests'),
(UUID(), 'employee_profile_requests.create', 'employee_profile_requests', 'create', 'Create employee profile requests'),
(UUID(), 'employee_profile_requests.update', 'employee_profile_requests', 'update', 'Update employee profile requests'),
(UUID(), 'employee_profile_requests.delete', 'employee_profile_requests', 'delete', 'Delete employee profile requests');

-- MODULE 1: Identity - Role Permissions (Using INSERT IGNORE to prevent duplicates)

-- Admin gets all permissions
INSERT IGNORE INTO role_permissions (id, role_id, permission_id) 
SELECT UUID(), (SELECT id FROM roles WHERE name = 'Admin'), id 
FROM permissions;

-- Employee permissions
INSERT IGNORE INTO role_permissions (id, role_id, permission_id) 
SELECT UUID(), (SELECT id FROM roles WHERE name = 'Employee'), id 
FROM permissions 
WHERE name IN (
    'facilities.view', 'facilities.create', 'facilities.edit',
    'shipments.view', 'shipments.create', 'shipments.edit', 'shipments.assign',
    'employees.view'
);

-- Customer permissions (limited access)
INSERT IGNORE INTO role_permissions (id, role_id, permission_id) 
SELECT UUID(), (SELECT id FROM roles WHERE name = 'Customer'), id 
FROM permissions 
WHERE name IN (
    'customer.shipments.view', 'customer.shipments.create', 'customer.shipments.track',
    'customer.profile.view', 'customer.profile.edit'
);

-- Driver permissions
INSERT IGNORE INTO role_permissions (id, role_id, permission_id) 
SELECT UUID(), (SELECT id FROM roles WHERE name = 'Driver'), id 
FROM permissions 
WHERE name IN (
    'driver.shipments.view', 'driver.shipments.update',
    'driver.routes.view', 'shipments.view'
);

-- Branch Manager gets employee permissions + some extra
INSERT IGNORE INTO role_permissions (id, role_id, permission_id) 
SELECT UUID(), (SELECT id FROM roles WHERE name = 'Branch Manager'), id 
FROM permissions 
WHERE name IN (
    'facilities.view', 'facilities.create', 'facilities.edit',
    'shipments.view', 'shipments.create', 'shipments.edit', 'shipments.assign',
    'employees.view', 'employees.manage',
    'driver.shipments.view', 'driver.routes.view'
);

-- MODULE 1: Identity - User Roles (Using INSERT IGNORE)
INSERT IGNORE INTO user_roles (id, user_id, role_id) VALUES
-- Admin user gets Admin role
(UUID(), (SELECT id FROM users WHERE username = 'admin'), (SELECT id FROM roles WHERE name = 'Admin')),
-- Employee users get Employee role
(UUID(), (SELECT id FROM users WHERE username = 'employee'), (SELECT id FROM roles WHERE name = 'Employee')),
(UUID(), (SELECT id FROM users WHERE username = 'john.doe'), (SELECT id FROM roles WHERE name = 'Employee')),
(UUID(), (SELECT id FROM users WHERE username = 'jane.smith'), (SELECT id FROM roles WHERE name = 'Employee')),
(UUID(), (SELECT id FROM users WHERE username = 'sarah.parker'), (SELECT id FROM roles WHERE name = 'Employee')),
-- Customer users get Customer role
(UUID(), (SELECT id FROM users WHERE username = 'customer'), (SELECT id FROM roles WHERE name = 'Customer')),
-- Driver gets Driver role
(UUID(), (SELECT id FROM users WHERE username = 'mike.wilson'), (SELECT id FROM roles WHERE name = 'Driver')),
-- Branch Manager
(UUID(), (SELECT id FROM users WHERE username = 'robert.taylor'), (SELECT id FROM roles WHERE name = 'Branch Manager'));

-- MODULE 2: Customer Addresses
INSERT IGNORE INTO customer_addresses (id, customer_id, address_type, recipient_name, phone, address_line1, address_line2, city, state, pincode, country, landmark, is_default, is_active) VALUES
(UUID(), (SELECT id FROM customers WHERE account_number = 'ACC-001'), 'office', 'ELMS Corporate', '9876543210', '123 Corporate Tower', 'BKC', 'Mumbai', 'Maharashtra', '400051', 'India', 'Near BKC Junction', TRUE, TRUE),
(UUID(), (SELECT id FROM customers WHERE account_number = 'ACC-002'), 'office', 'Tech Solutions Ltd', '9876543211', '456 Tech Park', 'Electronic City', 'Bangalore', 'Karnataka', '560100', 'India', 'Opposite Intel', TRUE, TRUE),
(UUID(), (SELECT id FROM customers WHERE account_number = 'ACC-002'), 'warehouse', 'Tech Solutions Warehouse', '9876543212', '789 Logistics Park', 'Peenya', 'Bangalore', 'Karnataka', '560058', 'India', 'Near Peenya Industrial', FALSE, TRUE),
(UUID(), (SELECT id FROM customers WHERE account_number = 'ACC-003'), 'office', 'Global Logistics Inc', '9876543213', '321 Trade Center', 'Vashi', 'Navi Mumbai', 'Maharashtra', '400703', 'India', 'Near Vashi Station', TRUE, TRUE),
(UUID(), (SELECT id FROM customers WHERE account_number = 'ACC-004'), 'office', 'Fast Delivery Services', '9876543214', '654 Speed Complex', 'Andheri East', 'Mumbai', 'Maharashtra', '400093', 'India', 'Near Airport', TRUE, TRUE);

-- MODULE 4: Services
INSERT IGNORE INTO services (id, code, name, description, service_type, is_active) VALUES
(UUID(), 'EXP-001', 'Express Delivery', 'Same day delivery service', 'Express', TRUE),
(UUID(), 'STD-001', 'Standard Delivery', 'Standard 2-3 day delivery', 'Standard', TRUE),
(UUID(), 'ECO-001', 'Economy Delivery', 'Cost effective delivery within 5-7 days', 'Economy', TRUE),
(UUID(), 'FRG-001', 'Fragile Handling', 'Special handling for fragile items', 'Special', TRUE),
(UUID(), 'LAR-001', 'Large Items', 'Special service for oversized items', 'Special', TRUE);

-- MODULE 4: Pricing Rules
INSERT IGNORE INTO pricing_rules (id, service_id, name, rule_type, calculation_type, min_value, max_value, rate, condition_expression, priority, is_active) VALUES
(UUID(), (SELECT id FROM services WHERE code = 'EXP-001'), 'Express - Basic', 'weight', 'per_kg', 0, 10, 150.0000, NULL, 1, TRUE),
(UUID(), (SELECT id FROM services WHERE code = 'EXP-001'), 'Express - Heavy', 'weight', 'per_kg', 10, 50, 120.0000, NULL, 2, TRUE),
(UUID(), (SELECT id FROM services WHERE code = 'STD-001'), 'Standard - Basic', 'weight', 'per_kg', 0, 20, 80.0000, NULL, 1, TRUE),
(UUID(), (SELECT id FROM services WHERE code = 'STD-001'), 'Standard - Heavy', 'weight', 'per_kg', 20, 100, 60.0000, NULL, 2, TRUE),
(UUID(), (SELECT id FROM services WHERE code = 'ECO-001'), 'Economy - Basic', 'weight', 'per_kg', 0, 50, 40.0000, NULL, 1, TRUE);

-- MODULE 4: Insurance Plans
INSERT IGNORE INTO insurance_plans (id, name, description, min_cover, max_cover, rate_percentage, fixed_charge, is_active) VALUES
(UUID(), 'Basic Cover', 'Basic insurance coverage up to 10,000', 1000.00, 10000.00, 2.50, 50.00, TRUE),
(UUID(), 'Standard Cover', 'Standard insurance coverage up to 50,000', 10000.00, 50000.00, 2.00, 100.00, TRUE),
(UUID(), 'Premium Cover', 'Premium insurance coverage up to 200,000', 50000.00, 200000.00, 1.50, 200.00, TRUE),
(UUID(), 'Comprehensive Cover', 'Comprehensive coverage up to 500,000', 200000.00, 500000.00, 1.00, 500.00, TRUE);

-- MODULE 6: Vehicles
INSERT IGNORE INTO vehicles (id, vehicle_number, vehicle_type, brand, model, year, capacity, status, registration_number, insurance_expiry, maintenance_due, assigned_driver_id, fuel_type) VALUES
(UUID(), 'MH-01-AB-1234', 'Truck', 'Tata', 'Tata 407', 2022, 2500.00, 'Available', 'MH01AB1234', '2025-12-31', '2024-12-31', NULL, 'Diesel'),
(UUID(), 'MH-02-CD-5678', 'Van', 'Maruti Suzuki', 'Eeco', 2023, 800.00, 'Available', 'MH02CD5678', '2025-11-30', '2024-11-30', NULL, 'Petrol'),
(UUID(), 'DL-01-EF-9012', 'Truck', 'Ashok Leyland', 'Dost', 2022, 1200.00, 'In Route', 'DL01EF9012', '2025-10-31', '2024-10-31', NULL, 'Diesel'),
(UUID(), 'MH-03-GH-3456', 'Van', 'Ford', 'Transit', 2023, 1000.00, 'Available', 'MH03GH3456', '2025-09-30', '2024-09-30', NULL, 'Diesel'),
(UUID(), 'MH-04-IJ-7890', 'Truck', 'Eicher', 'Pro 3015', 2022, 3500.00, 'Available', 'MH04IJ7890', '2025-08-31', '2024-08-31', NULL, 'Diesel'),
(UUID(), 'DL-02-KL-1234', 'Van', 'Tata', 'Ace', 2023, 700.00, 'Available', 'DL02KL1234', '2025-07-31', '2024-07-31', NULL, 'Petrol');

-- MODULE 5: Shipments
INSERT IGNORE INTO shipments (id, tracking_number, shipment_request_id, service_id, customer_id, sender_address_id, receiver_address_id, weight, length, width, height, declared_value, insurance_plan_id, insurance_amount, package_type, special_instructions, is_fragile, is_large, current_status, estimated_delivery, actual_delivery, is_active) VALUES
(UUID(), 'TRK-001-2024', NULL, (SELECT id FROM services WHERE code = 'EXP-001'), (SELECT id FROM customers WHERE account_number = 'ACC-002'), 
 (SELECT id FROM customer_addresses WHERE address_type = 'office' AND customer_id = (SELECT id FROM customers WHERE account_number = 'ACC-002') LIMIT 1),
 (SELECT id FROM customer_addresses WHERE address_type = 'office' AND customer_id = (SELECT id FROM customers WHERE account_number = 'ACC-003') LIMIT 1),
 5.500, 30.00, 20.00, 15.00, 5000.00, (SELECT id FROM insurance_plans WHERE name = 'Basic Cover'), 125.00, 'Box', 'Handle with care', FALSE, FALSE, 'created', DATE_ADD(NOW(), INTERVAL 1 DAY), NULL, TRUE),
(UUID(), 'TRK-002-2024', NULL, (SELECT id FROM services WHERE code = 'STD-001'), (SELECT id FROM customers WHERE account_number = 'ACC-003'),
 (SELECT id FROM customer_addresses WHERE address_type = 'office' AND customer_id = (SELECT id FROM customers WHERE account_number = 'ACC-003') LIMIT 1),
 (SELECT id FROM customer_addresses WHERE address_type = 'office' AND customer_id = (SELECT id FROM customers WHERE account_number = 'ACC-004') LIMIT 1),
 12.000, 40.00, 30.00, 25.00, 15000.00, (SELECT id FROM insurance_plans WHERE name = 'Standard Cover'), 300.00, 'Crate', 'Fragile items', TRUE, FALSE, 'in_transit', DATE_ADD(NOW(), INTERVAL 3 DAY), NULL, TRUE),
(UUID(), 'TRK-003-2024', NULL, (SELECT id FROM services WHERE code = 'ECO-001'), (SELECT id FROM customers WHERE account_number = 'ACC-001'),
 (SELECT id FROM customer_addresses WHERE address_type = 'office' AND customer_id = (SELECT id FROM customers WHERE account_number = 'ACC-001') LIMIT 1),
 (SELECT id FROM customer_addresses WHERE address_type = 'office' AND customer_id = (SELECT id FROM customers WHERE account_number = 'ACC-002') LIMIT 1),
 20.000, 50.00, 40.00, 30.00, 25000.00, (SELECT id FROM insurance_plans WHERE name = 'Premium Cover'), 375.00, 'Pallet', 'Heavy items', FALSE, TRUE, 'delivered', DATE_ADD(NOW(), INTERVAL -2 DAY), DATE_ADD(NOW(), INTERVAL -1 DAY), TRUE);

-- MODULE 5: Shipment Contacts
INSERT IGNORE INTO shipment_contacts (id, shipment_id, contact_type, name, phone, address_line1, address_line2, city, state, pincode, country, landmark) 
SELECT UUID(), s.id, 'sender', c.company_name, '9876543215', ca.address_line1, ca.address_line2, ca.city, ca.state, ca.pincode, ca.country, ca.landmark
FROM shipments s
JOIN customers c ON s.customer_id = c.id
JOIN customer_addresses ca ON ca.customer_id = c.id AND ca.is_default = TRUE
WHERE s.tracking_number IN ('TRK-001-2024', 'TRK-002-2024', 'TRK-003-2024');

INSERT IGNORE INTO shipment_contacts (id, shipment_id, contact_type, name, phone, address_line1, address_line2, city, state, pincode, country, landmark)
SELECT UUID(), s.id, 'receiver', 
  CASE s.tracking_number
    WHEN 'TRK-001-2024' THEN 'Global Logistics Inc'
    WHEN 'TRK-002-2024' THEN 'Fast Delivery Services'
    WHEN 'TRK-003-2024' THEN 'Tech Solutions Ltd'
  END,
  CASE s.tracking_number
    WHEN 'TRK-001-2024' THEN '9876543216'
    WHEN 'TRK-002-2024' THEN '9876543217'
    WHEN 'TRK-003-2024' THEN '9876543218'
  END,
  CASE s.tracking_number
    WHEN 'TRK-001-2024' THEN '321 Trade Center'
    WHEN 'TRK-002-2024' THEN '654 Speed Complex'
    WHEN 'TRK-003-2024' THEN '456 Tech Park'
  END,
  CASE s.tracking_number
    WHEN 'TRK-001-2024' THEN 'Vashi'
    WHEN 'TRK-002-2024' THEN 'Andheri East'
    WHEN 'TRK-003-2024' THEN 'Electronic City'
  END,
  CASE s.tracking_number
    WHEN 'TRK-001-2024' THEN 'Navi Mumbai'
    WHEN 'TRK-002-2024' THEN 'Mumbai'
    WHEN 'TRK-003-2024' THEN 'Bangalore'
  END,
  CASE s.tracking_number
    WHEN 'TRK-001-2024' THEN 'Maharashtra'
    WHEN 'TRK-002-2024' THEN 'Maharashtra'
    WHEN 'TRK-003-2024' THEN 'Karnataka'
  END,
  CASE s.tracking_number
    WHEN 'TRK-001-2024' THEN '400703'
    WHEN 'TRK-002-2024' THEN '400093'
    WHEN 'TRK-003-2024' THEN '560100'
  END,
  'India',
  CASE s.tracking_number
    WHEN 'TRK-001-2024' THEN 'Near Vashi Station'
    WHEN 'TRK-002-2024' THEN 'Near Airport'
    WHEN 'TRK-003-2024' THEN 'Opposite Intel'
  END
FROM shipments s
WHERE s.tracking_number IN ('TRK-001-2024', 'TRK-002-2024', 'TRK-003-2024');

-- MODULE 6: Routes
INSERT IGNORE INTO routes (id, route_code, name, origin_facility_id, destination_facility_id, distance, estimated_duration, is_active) VALUES
(UUID(), 'RTE-BOM-DEL', 'Mumbai to Delhi Route', (SELECT id FROM facilities WHERE code = 'BOM-001'), (SELECT id FROM facilities WHERE code = 'DEL-001'), 1400.00, 24, TRUE),
(UUID(), 'RTE-BOM-CHE', 'Mumbai to Chennai Route', (SELECT id FROM facilities WHERE code = 'BOM-DC'), (SELECT id FROM facilities WHERE code = 'CHE-001'), 1300.00, 20, TRUE),
(UUID(), 'RTE-DEL-HYD', 'Delhi to Hyderabad Route', (SELECT id FROM facilities WHERE code = 'DEL-001'), (SELECT id FROM facilities WHERE code = 'HYD-001'), 1500.00, 26, TRUE),
(UUID(), 'RTE-BOM-KOL', 'Mumbai to Kolkata Route', (SELECT id FROM facilities WHERE code = 'BOM-001'), (SELECT id FROM facilities WHERE code = 'KOL-001'), 1800.00, 30, TRUE);

-- MODULE 6: Route Stops
INSERT IGNORE INTO route_stops (id, route_id, stop_sequence, facility_id, stop_name, pincode, latitude, longitude, estimated_arrival, estimated_departure, is_active) 
SELECT UUID(), r.id, 1, f.id, f.name, f.pincode, 19.0760, 72.8777, 0, 0, TRUE
FROM routes r
JOIN facilities f ON r.origin_facility_id = f.id
WHERE r.route_code = 'RTE-BOM-DEL';

INSERT IGNORE INTO route_stops (id, route_id, stop_sequence, facility_id, stop_name, pincode, latitude, longitude, estimated_arrival, estimated_departure, is_active) 
SELECT UUID(), r.id, 2, f.id, f.name, f.pincode, 28.6139, 77.2090, 24, 25, TRUE
FROM routes r
JOIN facilities f ON r.destination_facility_id = f.id
WHERE r.route_code = 'RTE-BOM-DEL';

-- MODULE 7: Invoices
INSERT IGNORE INTO invoices (id, invoice_number, shipment_id, invoice_date, due_date, total_amount, discount_amount, net_amount, status, notes) 
SELECT UUID(), CONCAT('INV-', DATE_FORMAT(NOW(), '%Y%m'), '-001'), s.id, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 15 DAY), 750.00, 0, 750.00, 'issued', 'Standard invoice'
FROM shipments s
WHERE s.tracking_number = 'TRK-001-2024';

INSERT IGNORE INTO invoices (id, invoice_number, shipment_id, invoice_date, due_date, total_amount, discount_amount, net_amount, status, notes) 
SELECT UUID(), CONCAT('INV-', DATE_FORMAT(NOW(), '%Y%m'), '-002'), s.id, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 15 DAY), 1200.00, 100.00, 1100.00, 'paid', 'Paid invoice'
FROM shipments s
WHERE s.tracking_number = 'TRK-002-2024';

INSERT IGNORE INTO invoices (id, invoice_number, shipment_id, invoice_date, due_date, total_amount, discount_amount, net_amount, status, notes) 
SELECT UUID(), CONCAT('INV-', DATE_FORMAT(NOW(), '%Y%m'), '-003'), s.id, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 15 DAY), 2500.00, 200.00, 2300.00, 'overdue', 'Overdue invoice'
FROM shipments s
WHERE s.tracking_number = 'TRK-003-2024';

-- MODULE 7: Shipment Charges
INSERT IGNORE INTO shipment_charges (id, shipment_id, invoice_id, charge_type, description, amount, calculation_reference) 
SELECT UUID(), s.id, i.id, 'Base Freight', 'Standard shipping charge', 500.00, 'Weight: 5.5 kg'
FROM shipments s
JOIN invoices i ON i.shipment_id = s.id
WHERE s.tracking_number = 'TRK-001-2024'
LIMIT 1;

INSERT IGNORE INTO shipment_charges (id, shipment_id, invoice_id, charge_type, description, amount, calculation_reference) 
SELECT UUID(), s.id, i.id, 'Insurance', 'Basic Cover Insurance', 125.00, 'Coverage: 5000'
FROM shipments s
JOIN invoices i ON i.shipment_id = s.id
WHERE s.tracking_number = 'TRK-001-2024'
LIMIT 1;

-- MODULE 7: Payments
INSERT IGNORE INTO payments (id, payment_number, invoice_id, customer_id, amount, payment_method, payment_status, transaction_id, payment_date, reference_number) 
SELECT UUID(), CONCAT('PAY-', DATE_FORMAT(NOW(), '%Y%m'), '-001'), i.id, c.id, i.net_amount, 'online', 'completed', 'TXN-001', NOW(), 'REF-001'
FROM invoices i
JOIN shipments s ON i.shipment_id = s.id
JOIN customers c ON s.customer_id = c.id
WHERE s.tracking_number = 'TRK-002-2024'
LIMIT 1;

-- MODULE 7: Expenses
INSERT IGNORE INTO expenses (id, expense_number, expense_type, facility_id, vehicle_id, employee_id, amount, expense_date, description, invoice_number, approved_by, approved_at, status, payment_status, notes) VALUES
(UUID(), 'EXP-001-2024', 'Fuel', (SELECT id FROM facilities WHERE code = 'BOM-001'), (SELECT id FROM vehicles WHERE vehicle_number = 'MH-01-AB-1234'), NULL, 2500.00, CURDATE(), 'Monthly fuel expense', 'FUEL-001', NULL, NULL, 'pending', 'Unpaid', 'Regular fuel charge'),
(UUID(), 'EXP-002-2024', 'Maintenance', (SELECT id FROM facilities WHERE code = 'BOM-DC'), (SELECT id FROM vehicles WHERE vehicle_number = 'MH-02-CD-5678'), NULL, 15000.00, CURDATE(), 'Vehicle maintenance - oil change and service', 'MAINT-001', NULL, NULL, 'pending', 'Unpaid', 'Scheduled maintenance'),
(UUID(), 'EXP-003-2024', 'Rent', (SELECT id FROM facilities WHERE code = 'DEL-001'), NULL, NULL, 50000.00, CURDATE(), 'Monthly branch rent', 'RENT-001', (SELECT id FROM employees WHERE employee_code = 'EMP-003'), NOW(), 'approved', 'Unpaid', 'Branch rent payment');

-- MODULE 8: Audit Logs
INSERT IGNORE INTO audit_logs (id, user_id, action, table_name, record_id, old_data, new_data, ip_address, user_agent, description) VALUES
(UUID(), (SELECT id FROM users WHERE username = 'admin'), 'CREATE', 'facilities', (SELECT id FROM facilities WHERE code = 'BOM-001'), NULL, '{"name":"Mumbai Branch","code":"BOM-001"}', '192.168.1.1', 'Mozilla/5.0', 'Facility created'),
(UUID(), (SELECT id FROM users WHERE username = 'admin'), 'CREATE', 'facilities', (SELECT id FROM facilities WHERE code = 'BOM-DC'), NULL, '{"name":"Mumbai Distribution Center","code":"BOM-DC"}', '192.168.1.1', 'Mozilla/5.0', 'Facility created'),
(UUID(), (SELECT id FROM users WHERE username = 'admin'), 'UPDATE', 'facilities', (SELECT id FROM facilities WHERE code = 'DEL-001'), '{"capacity":4000}', '{"capacity":4500}', '192.168.1.1', 'Mozilla/5.0', 'Capacity updated'),
(UUID(), (SELECT id FROM users WHERE username = 'employee'), 'CREATE', 'shipments', (SELECT id FROM shipments WHERE tracking_number = 'TRK-001-2024'), NULL, '{"tracking":"TRK-001-2024"}', '192.168.1.2', 'Mozilla/5.0', 'Shipment created');

-- MODULE 8: Login History
INSERT IGNORE INTO login_history (id, user_id, login_time, logout_time, ip_address, user_agent, login_status, failure_reason, session_id) VALUES
(UUID(), (SELECT id FROM users WHERE username = 'admin'), DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY) + INTERVAL 8 HOUR, '192.168.1.1', 'Mozilla/5.0', 'success', NULL, 'SESS-001'),
(UUID(), (SELECT id FROM users WHERE username = 'employee'), DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY) + INTERVAL 6 HOUR, '192.168.1.2', 'Mozilla/5.0', 'success', NULL, 'SESS-002'),
(UUID(), (SELECT id FROM users WHERE username = 'customer'), DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY) + INTERVAL 7 HOUR, '192.168.1.3', 'Mozilla/5.0', 'success', NULL, 'SESS-003'),
(UUID(), (SELECT id FROM users WHERE username = 'admin'), DATE_SUB(NOW(), INTERVAL 2 HOUR), NULL, '192.168.1.4', 'Mozilla/5.0', 'success', NULL, 'SESS-004');

-- MODULE 8: Employee Profile Requests
INSERT IGNORE INTO employee_profile_requests (id, employee_id, requested_by, field_name, old_value, new_value, reason, status, approved_by, approved_at, rejection_reason) VALUES
(UUID(), (SELECT id FROM employees WHERE employee_code = 'EMP-004'), (SELECT id FROM users WHERE username = 'employee'), 'phone', NULL, '9876543219', 'New phone number', 'Pending', NULL, NULL, NULL),
(UUID(), (SELECT id FROM employees WHERE employee_code = 'EMP-005'), (SELECT id FROM users WHERE username = 'employee'), 'position', 'Driver', 'Senior Driver', 'Promotion request', 'Approved', (SELECT id FROM users WHERE username = 'admin'), NOW(), NULL),
(UUID(), (SELECT id FROM employees WHERE employee_code = 'EMP-006'), (SELECT id FROM users WHERE username = 'employee'), 'department', 'Warehouse Operations', 'Customer Service', 'Department transfer', 'Rejected', (SELECT id FROM users WHERE username = 'admin'), NOW(), 'Position not available'),
(UUID(), (SELECT id FROM employees WHERE employee_code = 'EMP-007'), (SELECT id FROM users WHERE username = 'admin'), 'salary', '50000', '60000', 'Annual increment', 'Pending', NULL, NULL, NULL);

-- =============================================
-- VERIFY DATA
-- =============================================

SELECT '========== USER ROLES SUMMARY ==========' as '';
SELECT 
    u.username,
    u.email,
    r.name as role_name,
    CASE 
        WHEN r.name = 'Admin' THEN 'Full System Access'
        WHEN r.name = 'Employee' THEN 'Operations Management'
        WHEN r.name = 'Customer' THEN 'Self-Service Only'
        WHEN r.name = 'Driver' THEN 'Delivery Access'
        WHEN r.name = 'Branch Manager' THEN 'Branch Management'
    END as access_level
FROM users u
JOIN user_roles ur ON u.id = ur.user_id
JOIN roles r ON ur.role_id = r.id;

SELECT 'Users' AS table_name, COUNT(*) AS row_count FROM users
UNION ALL
SELECT 'Departments', COUNT(*) FROM departments
UNION ALL
SELECT 'Positions', COUNT(*) FROM positions
UNION ALL
SELECT 'Employees', COUNT(*) FROM employees
UNION ALL
SELECT 'Customers', COUNT(*) FROM customers
UNION ALL
SELECT 'Facilities', COUNT(*) FROM facilities
UNION ALL
SELECT 'Services', COUNT(*) FROM services
UNION ALL
SELECT 'Pricing Rules', COUNT(*) FROM pricing_rules
UNION ALL
SELECT 'Insurance Plans', COUNT(*) FROM insurance_plans
UNION ALL
SELECT 'Shipments', COUNT(*) FROM shipments
UNION ALL
SELECT 'Vehicles', COUNT(*) FROM vehicles
UNION ALL
SELECT 'Routes', COUNT(*) FROM routes
UNION ALL
SELECT 'Invoices', COUNT(*) FROM invoices
UNION ALL
SELECT 'Payments', COUNT(*) FROM payments
UNION ALL
SELECT 'Expenses', COUNT(*) FROM expenses;

SELECT 
    username,
    email,
    'admin123' as password,
    (SELECT name FROM roles WHERE id = ur.role_id) as role
FROM users u
JOIN user_roles ur ON u.id = ur.user_id
WHERE username IN ('admin', 'employee', 'customer');

-- =============================================
-- ADMIN SETUP SCRIPT (WITH DUPLICATE PREVENTION)
-- =============================================

USE PJ3;

START TRANSACTION;

-- =========================================================
-- VARIABLES
-- =========================================================

SET @admin_user_id = UUID();
SET @admin_role_id = UUID();
SET @admin_employee_id = UUID();

-- =========================================================
-- 1. CREATE OR UPDATE ADMIN USER (Skip if exists)
-- =========================================================
-- IMPORTANT:
-- Replace the password_hash value with a BCrypt hash
-- generated by BCrypt.Net-Next for:
--
-- Admin123!
--
-- Example:
-- $2a$11$.....................................................

INSERT IGNORE INTO users (
    id,
    username,
    email,
    phone,
    password_hash,
    mfa_enabled,
    is_active
)
VALUES (
    @admin_user_id,
    'admin',
    'admin@pj3.com',
    '0900000000',
    '$2a$11$EQPgCEs7kvisAluKlwcmOugU7NeUvxVrPwFvt0LOy7bceGdxMQa2S',
    FALSE,
    TRUE
);

-- =========================================================
-- 2. CREATE OR UPDATE ADMIN ROLE (Skip if exists)
-- =========================================================

INSERT IGNORE INTO roles (
    id,
    name,
    description,
    is_system
)
VALUES (
    @admin_role_id,
    'Administrator',
    'Full system administrator with unrestricted application permissions',
    TRUE
);

-- =========================================================
-- 3. ASSIGN ADMIN ROLE TO ADMIN USER (Skip if exists)
-- =========================================================

INSERT IGNORE INTO user_roles (
    id,
    user_id,
    role_id
)
VALUES (
    UUID(),
    @admin_user_id,
    @admin_role_id
);

-- =========================================================
-- 4. CREATE OR UPDATE ADMIN EMPLOYEE (Skip if exists)
-- =========================================================

INSERT IGNORE INTO employees (
    id,
    user_id,
    first_name,
    last_name,
    hire_date,
    employee_code,
    is_active
)
VALUES (
    @admin_employee_id,
    @admin_user_id,
    'System',
    'Administrator',
    CURDATE(),
    'EMP-ADMIN-001',
    TRUE
);

-- =========================================================
-- 5. GIVE ADMIN ROLE EVERY PERMISSION (Skip duplicates)
-- =========================================================

INSERT IGNORE INTO role_permissions (
    id,
    role_id,
    permission_id
)
SELECT
    UUID(),
    @admin_role_id,
    id
FROM permissions;
SET SQL_SAFE_UPDATES = 0;
DELETE FROM roles
WHERE LOWER(name) = 'administrator';
SET SQL_SAFE_UPDATES = 1;
COMMIT;

-- =============================================
-- FINAL VERIFICATION
-- =============================================

SELECT '========== FINAL DATA SUMMARY ==========' as '';
SELECT 'Total Users:' as '', COUNT(*) as '' FROM users;
SELECT 'Total Roles:' as '', COUNT(*) as '' FROM roles;
SELECT 'Total Permissions:' as '', COUNT(*) as '' FROM permissions;
SELECT 'Total Role-Permission Assignments:' as '', COUNT(*) as '' FROM role_permissions;
SELECT 'Total User-Role Assignments:' as '', COUNT(*) as '' FROM user_roles;
SELECT 'Total Employees:' as '', COUNT(*) as '' FROM employees;
SELECT 'Total Customers:' as '', COUNT(*) as '' FROM customers;

USE PJ3;

START TRANSACTION;

-- ============================================================
-- 1. FACILITIES
-- ============================================================

INSERT INTO facilities (
    id,
    name,
    code,
    address,
    city,
    province,
    postal_code,
    phone,
    email,
    facility_type,
    is_active,
    created_at,
    updated_at
)
SELECT
    UUID(),
    'Hanoi Distribution Hub',
    'FAC-HN-001',
    '123 Nguyen Van Linh',
    'Hanoi',
    'Hanoi',
    '100000',
    '024-11111111',
    'hanoi.hub@demo.com',
    'distribution_center',
    1,
    UTC_TIMESTAMP(),
    UTC_TIMESTAMP()
WHERE NOT EXISTS (
    SELECT 1
    FROM facilities
    WHERE code = 'FAC-HN-001'
);


INSERT INTO facilities (
    id,
    name,
    code,
    address,
    city,
    province,
    postal_code,
    phone,
    email,
    facility_type,
    is_active,
    created_at,
    updated_at
)
SELECT
    UUID(),
    'Bac Ninh Distribution Center',
    'FAC-BN-001',
    '456 Le Thai To',
    'Bac Ninh',
    'Bac Ninh',
    '160000',
    '0222-2222222',
    'bacninh.dc@demo.com',
    'distribution_center',
    1,
    UTC_TIMESTAMP(),
    UTC_TIMESTAMP()
WHERE NOT EXISTS (
    SELECT 1
    FROM facilities
    WHERE code = 'FAC-BN-001'
);


INSERT INTO facilities (
    id,
    name,
    code,
    address,
    city,
    province,
    postal_code,
    phone,
    email,
    facility_type,
    is_active,
    created_at,
    updated_at
)
SELECT
    UUID(),
    'Gia Lam Sorting Facility',
    'FAC-GL-001',
    '789 Nguyen Van Cu',
    'Hanoi',
    'Hanoi',
    '100000',
    '024-33333333',
    'gialam.sorting@demo.com',
    'sorting_center',
    1,
    UTC_TIMESTAMP(),
    UTC_TIMESTAMP()
WHERE NOT EXISTS (
    SELECT 1
    FROM facilities
    WHERE code = 'FAC-GL-001'
);


-- ============================================================
-- 2. GET FACILITY IDS
-- ============================================================

SET @HN = (
    SELECT id
    FROM facilities
    WHERE code = 'FAC-HN-001'
    LIMIT 1
);

SET @BN = (
    SELECT id
    FROM facilities
    WHERE code = 'FAC-BN-001'
    LIMIT 1
);

SET @GL = (
    SELECT id
    FROM facilities
    WHERE code = 'FAC-GL-001'
    LIMIT 1
);


-- ============================================================
-- 3. ROUTE: HANOI -> BAC NINH
-- ============================================================

INSERT INTO routes (
    id,
    route_code,
    name,
    origin_facility_id,
    destination_facility_id,
    distance,
    estimated_duration,
    is_active,
    created_at,
    updated_at
)
SELECT
    UUID(),
    'HN-BN-001',
    'Hanoi - Bac Ninh Express Route',
    @HN,
    @BN,
    35.00,
    60,
    1,
    UTC_TIMESTAMP(),
    UTC_TIMESTAMP()
WHERE NOT EXISTS (
    SELECT 1
    FROM routes
    WHERE route_code = 'HN-BN-001'
);


-- ============================================================
-- 4. GET ROUTE ID
-- ============================================================

SET @HN_BN_ROUTE = (
    SELECT id
    FROM routes
    WHERE route_code = 'HN-BN-001'
    LIMIT 1
);


-- ============================================================
-- 5. ROUTE STOPS
-- ============================================================

-- Stop 1: Bac Ninh
INSERT INTO route_stops (
    id,
    route_id,
    stop_sequence,
    facility_id,
    stop_name,
    pincode,
    latitude,
    longitude,
    estimated_arrival,
    estimated_departure,
    is_active,
    created_at,
    updated_at
)
SELECT
    UUID(),
    @HN_BN_ROUTE,
    1,
    @BN,
    'Bac Ninh Distribution Center',
    '160000',
    21.1861,
    106.0763,
    NULL,
    NULL,
    1,
    UTC_TIMESTAMP(),
    UTC_TIMESTAMP()
WHERE NOT EXISTS (
    SELECT 1
    FROM route_stops
    WHERE route_id = @HN_BN_ROUTE
      AND stop_sequence = 1
);


-- ============================================================
-- 6. OPTIONAL: HANOI -> BAC NINH -> BAC GIANG
--    Add another destination facility
-- ============================================================

INSERT INTO facilities (
    id,
    name,
    code,
    address,
    city,
    province,
    postal_code,
    phone,
    email,
    facility_type,
    is_active,
    created_at,
    updated_at
)
SELECT
    UUID(),
    'Bac Giang Distribution Center',
    'FAC-BG-001',
    '100 Hoang Van Thu',
    'Bac Giang',
    'Bac Giang',
    '260000',
    '0204-4444444',
    'bacgiang.dc@demo.com',
    'distribution_center',
    1,
    UTC_TIMESTAMP(),
    UTC_TIMESTAMP()
WHERE NOT EXISTS (
    SELECT 1
    FROM facilities
    WHERE code = 'FAC-BG-001'
);


SET @BG = (
    SELECT id
    FROM facilities
    WHERE code = 'FAC-BG-001'
    LIMIT 1
);


-- ============================================================
-- 7. SECOND ROUTE
-- ============================================================

INSERT INTO routes (
    id,
    route_code,
    name,
    origin_facility_id,
    destination_facility_id,
    distance,
    estimated_duration,
    is_active,
    created_at,
    updated_at
)
SELECT
    UUID(),
    'HN-BN-BG-001',
    'Hanoi - Bac Ninh - Bac Giang Route',
    @HN,
    @BG,
    70.00,
    120,
    1,
    UTC_TIMESTAMP(),
    UTC_TIMESTAMP()
WHERE NOT EXISTS (
    SELECT 1
    FROM routes
    WHERE route_code = 'HN-BN-BG-001'
);


SET @HN_BN_BG_ROUTE = (
    SELECT id
    FROM routes
    WHERE route_code = 'HN-BN-BG-001'
    LIMIT 1
);


-- ============================================================
-- 8. ROUTE STOPS FOR SECOND ROUTE
-- ============================================================

-- Stop 1: Bac Ninh
INSERT INTO route_stops (
    id,
    route_id,
    stop_sequence,
    facility_id,
    stop_name,
    pincode,
    latitude,
    longitude,
    estimated_arrival,
    estimated_departure,
    is_active,
    created_at,
    updated_at
)
SELECT
    UUID(),
    @HN_BN_BG_ROUTE,
    1,
    @BN,
    'Bac Ninh Distribution Center',
    '160000',
    21.1861,
    106.0763,
    NULL,
    NULL,
    1,
    UTC_TIMESTAMP(),
    UTC_TIMESTAMP()
WHERE NOT EXISTS (
    SELECT 1
    FROM route_stops
    WHERE route_id = @HN_BN_BG_ROUTE
      AND stop_sequence = 1
);


-- Stop 2: Bac Giang
INSERT INTO route_stops (
    id,
    route_id,
    stop_sequence,
    facility_id,
    stop_name,
    pincode,
    latitude,
    longitude,
    estimated_arrival,
    estimated_departure,
    is_active,
    created_at,
    updated_at
)
SELECT
    UUID(),
    @HN_BN_BG_ROUTE,
    2,
    @BG,
    'Bac Giang Distribution Center',
    '260000',
    21.2819,
    106.1970,
    NULL,
    NULL,
    1,
    UTC_TIMESTAMP(),
    UTC_TIMESTAMP()
WHERE NOT EXISTS (
    SELECT 1
    FROM route_stops
    WHERE route_id = @HN_BN_BG_ROUTE
      AND stop_sequence = 2;


COMMIT;