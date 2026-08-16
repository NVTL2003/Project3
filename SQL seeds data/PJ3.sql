drop database PJ3;
create database PJ3;
use PJ3;

-- =============================================
-- ENUMS are defined inline in columns
-- =============================================

-- =============================================
-- MODULE 1: IDENTITY
-- =============================================

CREATE TABLE users (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    password_hash VARCHAR(255) NOT NULL,
    mfa_enabled BOOLEAN DEFAULT FALSE,
    mfa_secret VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    last_login TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE departments (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    name VARCHAR(100) UNIQUE NOT NULL,
    description VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE positions (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    name VARCHAR(100) UNIQUE NOT NULL,
    description VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE employees (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    user_id CHAR(36) UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    department_id CHAR(36),
    position_id CHAR(36),
    branch_id CHAR(36),
    hire_date DATE,
    employee_code VARCHAR(50) UNIQUE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE customers (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    user_id CHAR(36) UNIQUE NOT NULL,
    company_name VARCHAR(200),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    tax_id VARCHAR(50),
    account_number VARCHAR(50) UNIQUE,
    credit_limit DECIMAL(15,2),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE roles (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    name VARCHAR(50) UNIQUE NOT NULL,
    description VARCHAR(255),
    is_system BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE permissions (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    name VARCHAR(100) UNIQUE NOT NULL,
    resource VARCHAR(100) NOT NULL,
    action VARCHAR(50) NOT NULL,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE role_permissions (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    role_id CHAR(36) NOT NULL,
    permission_id CHAR(36) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_role_permission UNIQUE (role_id, permission_id)
);

CREATE TABLE user_roles (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    user_id CHAR(36) NOT NULL,
    role_id CHAR(36) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_user_role UNIQUE (user_id, role_id)
);

-- =============================================
-- MODULE 2: CUSTOMER
-- =============================================

CREATE TABLE customer_addresses (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    customer_id CHAR(36) NOT NULL,
    address_type VARCHAR(50) NOT NULL,
    recipient_name VARCHAR(200) NOT NULL,
    phone VARCHAR(20),
    address_line1 VARCHAR(255) NOT NULL,
    address_line2 VARCHAR(255),
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    pincode VARCHAR(20) NOT NULL,
    country VARCHAR(100) DEFAULT 'India',
    landmark VARCHAR(255),
    is_default BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE shipment_requests (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    request_number VARCHAR(50) UNIQUE NOT NULL,
    customer_id CHAR(36) NOT NULL,
    sender_address_id CHAR(36) NOT NULL,
    receiver_address_id CHAR(36) NOT NULL,
    service_id CHAR(36),
    package_type VARCHAR(50) NOT NULL,
    weight DECIMAL(10,3) NOT NULL,
    length DECIMAL(10,2),
    width DECIMAL(10,2),
    height DECIMAL(10,2),
    declared_value DECIMAL(15,2),
    insurance_plan_id CHAR(36),
    special_instructions TEXT,
    is_fragile BOOLEAN DEFAULT FALSE,
    is_large BOOLEAN DEFAULT FALSE,
    status ENUM('pending','approved','rejected') DEFAULT 'pending',
    estimated_cost DECIMAL(15,2),
    approved_by CHAR(36),
    approved_at TIMESTAMP,
    rejection_reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =============================================
-- MODULE 3: FACILITIES
-- =============================================

CREATE TABLE facilities (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    code VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(200) NOT NULL,
    facility_type ENUM('Branch','DistributionCenter') NOT NULL,
    address_line1 VARCHAR(255) NOT NULL,
    address_line2 VARCHAR(255),
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    pincode VARCHAR(20) NOT NULL,
    country VARCHAR(100) DEFAULT 'India',
    phone VARCHAR(20),
    email VARCHAR(255),
    branch_manager_id CHAR(36),
    capacity DECIMAL(15,2),
    current_occupancy DECIMAL(15,2),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE pincodes (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    pincode VARCHAR(20) UNIQUE NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    country VARCHAR(100) DEFAULT 'India',
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    facility_id CHAR(36),
    serviceable BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE storage_areas (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    facility_id CHAR(36) NOT NULL,
    zone_code VARCHAR(50) NOT NULL,
    shelf VARCHAR(50),
    container VARCHAR(50),
    capacity DECIMAL(15,2),
    current_occupancy DECIMAL(15,2),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =============================================
-- MODULE 4: PRICING
-- =============================================

CREATE TABLE services (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    code VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    service_type VARCHAR(50) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE pricing_rules (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    service_id CHAR(36) NOT NULL,
    name VARCHAR(100) NOT NULL,
    rule_type VARCHAR(50) NOT NULL,
    calculation_type VARCHAR(50) NOT NULL,
    min_value DECIMAL(15,2),
    max_value DECIMAL(15,2),
    rate DECIMAL(15,4) NOT NULL,
    condition_expression TEXT,
    priority INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE insurance_plans (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    min_cover DECIMAL(15,2) NOT NULL,
    max_cover DECIMAL(15,2) NOT NULL,
    rate_percentage DECIMAL(5,2) NOT NULL,
    fixed_charge DECIMAL(15,2) DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =============================================
-- MODULE 5: SHIPMENT
-- =============================================

CREATE TABLE shipments (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    tracking_number VARCHAR(50) UNIQUE NOT NULL,
    shipment_request_id CHAR(36),
    service_id CHAR(36) NOT NULL,
    customer_id CHAR(36) NOT NULL,
    sender_address_id CHAR(36) NOT NULL,
    receiver_address_id CHAR(36) NOT NULL,
    weight DECIMAL(10,3) NOT NULL,
    length DECIMAL(10,2),
    width DECIMAL(10,2),
    height DECIMAL(10,2),
    declared_value DECIMAL(15,2),
    insurance_plan_id CHAR(36),
    insurance_amount DECIMAL(15,2),
    package_type VARCHAR(50) NOT NULL,
    special_instructions TEXT,
    is_fragile BOOLEAN DEFAULT FALSE,
    is_large BOOLEAN DEFAULT FALSE,
    current_status ENUM('created','pickup_scheduled','in_sorting','loaded','in_transit','out_for_delivery','delivered','exception','cancelled') DEFAULT 'created',
    estimated_delivery DATE,
    actual_delivery TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE shipment_contacts (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    shipment_id CHAR(36) NOT NULL,
    contact_type ENUM('sender','receiver') NOT NULL,
    name VARCHAR(200) NOT NULL,
    phone VARCHAR(20),
    address_line1 VARCHAR(255) NOT NULL,
    address_line2 VARCHAR(255),
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    pincode VARCHAR(20) NOT NULL,
    country VARCHAR(100) DEFAULT 'India',
    landmark VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE shipment_status_history (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    shipment_id CHAR(36) NOT NULL,
    status ENUM('created','pickup_scheduled','in_sorting','loaded','in_transit','out_for_delivery','delivered','exception','cancelled') NOT NULL,
    changed_by CHAR(36),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT
);

CREATE TABLE tracking_status (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    code VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    is_public BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE package_scans (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    scan_number VARCHAR(50) UNIQUE NOT NULL,
    shipment_id CHAR(36) NOT NULL,
    employee_id CHAR(36) NOT NULL,
    facility_id CHAR(36),
    vehicle_id CHAR(36),
    location_type ENUM('branch','distribution_center','vehicle') NOT NULL,
    scan_type VARCHAR(50) NOT NULL,
    scan_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    ip_address VARCHAR(45),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tracking_events (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    shipment_id CHAR(36) NOT NULL,
    package_scan_id CHAR(36),
    tracking_status_id CHAR(36) NOT NULL,
    event_location VARCHAR(255),
    event_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_public BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE delivery_attempts (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    shipment_id CHAR(36) NOT NULL,
    delivery_assignment_id CHAR(36) NOT NULL,
    attempt_number INT NOT NULL,
    attempt_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('attempted','delivered','failed') NOT NULL,
    reason VARCHAR(255),
    notes TEXT,
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    is_delivered BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE proof_of_delivery (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    shipment_id CHAR(36) UNIQUE NOT NULL,
    delivery_attempt_id CHAR(36) NOT NULL,
    receiver_name VARCHAR(200) NOT NULL,
    receiver_signature TEXT,
    receiver_relation VARCHAR(100),
    delivery_photo TEXT,
    delivery_time TIMESTAMP NOT NULL,
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    gps_accuracy DECIMAL(5,2),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE notifications (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    tracking_event_id CHAR(36) NOT NULL,
    customer_id CHAR(36) NOT NULL,
    notification_type VARCHAR(50) NOT NULL,
    subject VARCHAR(255),
    content TEXT NOT NULL,
    recipient VARCHAR(255) NOT NULL,
    status ENUM('pending','sent','failed','read') DEFAULT 'pending',
    sent_at TIMESTAMP,
    read_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =============================================
-- MODULE 6: TRANSPORTATION
-- =============================================

CREATE TABLE vehicles (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    vehicle_number VARCHAR(50) UNIQUE NOT NULL,
    vehicle_type VARCHAR(50) NOT NULL,
    brand VARCHAR(50),
    model VARCHAR(50),
    year INT,
    capacity DECIMAL(15,2) NOT NULL,
    status VARCHAR(50) DEFAULT 'Available',
    registration_number VARCHAR(50) UNIQUE,
    insurance_expiry DATE,
    maintenance_due DATE,
    assigned_driver_id CHAR(36),
    fuel_type VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE vehicle_maintenance (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    vehicle_id CHAR(36) NOT NULL,
    maintenance_date DATE NOT NULL,
    description TEXT,
    cost DECIMAL(15,2),
    performed_by CHAR(36),
    next_maintenance_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE vehicle_fuel_logs (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    vehicle_id CHAR(36) NOT NULL,
    fuel_date DATE NOT NULL,
    fuel_type VARCHAR(50),
    quantity DECIMAL(10,2),
    cost DECIMAL(15,2),
    odometer_reading DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE vehicle_gps (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    vehicle_id CHAR(36) NOT NULL,
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    speed DECIMAL(8,2),
    heading DECIMAL(5,2)
);

CREATE TABLE routes (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    route_code VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(200) NOT NULL,
    origin_facility_id CHAR(36) NOT NULL,
    destination_facility_id CHAR(36) NOT NULL,
    distance DECIMAL(10,2) NOT NULL,
    estimated_duration INT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE route_stops (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    route_id CHAR(36) NOT NULL,
    stop_sequence INT NOT NULL,
    facility_id CHAR(36) NOT NULL,
    stop_name VARCHAR(200) NOT NULL,
    pincode VARCHAR(20),
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    estimated_arrival INT,
    estimated_departure INT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE transport_orders (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    order_number VARCHAR(50) UNIQUE NOT NULL,
    shipment_id CHAR(36) NOT NULL,
    priority INT DEFAULT 5,
    weight DECIMAL(10,3) NOT NULL,
    volume DECIMAL(10,3),
    special_instructions TEXT,
    status ENUM('created','planned','assigned','in_transit','delivered','cancelled') DEFAULT 'created',
    created_by CHAR(36),
    assigned_vehicle_id CHAR(36),
    assigned_driver_id CHAR(36),
    planned_departure TIMESTAMP,
    planned_arrival TIMESTAMP,
    actual_departure TIMESTAMP,
    actual_arrival TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE shipment_manifests (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    manifest_number VARCHAR(50) UNIQUE NOT NULL,
    vehicle_id CHAR(36) NOT NULL,
    driver_id CHAR(36) NOT NULL,
    route_id CHAR(36) NOT NULL,
    departure_facility_id CHAR(36) NOT NULL,
    departure_time TIMESTAMP NOT NULL,
    arrival_time TIMESTAMP,
    status ENUM('planned','in_progress','completed','delayed','cancelled') DEFAULT 'planned',
    total_packages INT DEFAULT 0,
    total_weight DECIMAL(15,2) DEFAULT 0,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE manifest_items (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    manifest_id CHAR(36) NOT NULL,
    transport_order_id CHAR(36) NOT NULL,
    loading_sequence INT,
    status VARCHAR(50) DEFAULT 'Loaded',
    loaded_at TIMESTAMP,
    unloaded_at TIMESTAMP,
    unloaded_facility_id CHAR(36),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT unique_manifest_transport_order UNIQUE (manifest_id, transport_order_id)
);

CREATE TABLE delivery_assignments (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    assignment_number VARCHAR(50) UNIQUE NOT NULL,
    manifest_id CHAR(36) NOT NULL,
    driver_id CHAR(36) NOT NULL,
    vehicle_id CHAR(36) NOT NULL,
    route_stop_id CHAR(36) NOT NULL,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    status VARCHAR(50) DEFAULT 'Assigned',
    sequence_number INT,
    estimated_delivery_time TIMESTAMP,
    actual_delivery_time TIMESTAMP,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =============================================
-- MODULE 7: FINANCE
-- =============================================

CREATE TABLE invoices (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    invoice_number VARCHAR(50) UNIQUE NOT NULL,
    shipment_id CHAR(36) NOT NULL,
    invoice_date DATE NOT NULL,
    due_date DATE,
    total_amount DECIMAL(15,2) NOT NULL,
    discount_amount DECIMAL(15,2) DEFAULT 0,
    net_amount DECIMAL(15,2) NOT NULL,
    status ENUM('draft','issued','paid','partially_paid','overdue','cancelled') DEFAULT 'draft',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE shipment_charges (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    shipment_id CHAR(36) NOT NULL,
    invoice_id CHAR(36),
    charge_type VARCHAR(50) NOT NULL,
    description VARCHAR(255),
    amount DECIMAL(15,2) NOT NULL,
    calculation_reference VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE payments (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    payment_number VARCHAR(50) UNIQUE NOT NULL,
    invoice_id CHAR(36) NOT NULL,
    customer_id CHAR(36) NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    payment_method ENUM('cash','card','online','vpp') NOT NULL,
    payment_status ENUM('pending','completed','failed','refunded') DEFAULT 'pending',
    transaction_id VARCHAR(100),
    payment_date TIMESTAMP,
    reference_number VARCHAR(100),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE expenses (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    expense_number VARCHAR(50) UNIQUE NOT NULL,
    expense_type VARCHAR(50) NOT NULL,
    facility_id CHAR(36),
    vehicle_id CHAR(36),
    employee_id CHAR(36),
    amount DECIMAL(15,2) NOT NULL,
    expense_date DATE NOT NULL,
    description TEXT,
    invoice_number VARCHAR(100),
    approved_by CHAR(36),
    approved_at TIMESTAMP,
    status ENUM('pending','approved','rejected','paid') DEFAULT 'pending',
    payment_status VARCHAR(50) DEFAULT 'Unpaid',
    payment_date DATE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =============================================
-- MODULE 8: ADMINISTRATION
-- =============================================

CREATE TABLE audit_logs (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    user_id CHAR(36) NOT NULL,
    action VARCHAR(100) NOT NULL,
    table_name VARCHAR(100) NOT NULL,
    record_id CHAR(36) NOT NULL,
    old_data JSON,
    new_data JSON,
    ip_address VARCHAR(45),
    user_agent TEXT,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE login_history (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    user_id CHAR(36) NOT NULL,
    login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    logout_time TIMESTAMP,
    ip_address VARCHAR(45),
    user_agent TEXT,
    login_status VARCHAR(50) NOT NULL,
    failure_reason TEXT,
    session_id VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE employee_profile_requests (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    employee_id CHAR(36) NOT NULL,
    requested_by CHAR(36) NOT NULL,
    field_name VARCHAR(100) NOT NULL,
    old_value TEXT,
    new_value TEXT NOT NULL,
    reason TEXT,
    status VARCHAR(50) DEFAULT 'Pending',
    approved_by CHAR(36),
    approved_at TIMESTAMP,
    rejection_reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =============================================
-- ADD FOREIGN KEYS (All after tables are created)
-- =============================================

ALTER TABLE employees ADD CONSTRAINT fk_employees_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
ALTER TABLE employees ADD CONSTRAINT fk_employees_department FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL;
ALTER TABLE employees ADD CONSTRAINT fk_employees_position FOREIGN KEY (position_id) REFERENCES positions(id) ON DELETE SET NULL;
ALTER TABLE employees ADD CONSTRAINT fk_employees_branch FOREIGN KEY (branch_id) REFERENCES facilities(id) ON DELETE SET NULL;

ALTER TABLE customers ADD CONSTRAINT fk_customers_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

ALTER TABLE role_permissions ADD CONSTRAINT fk_role_permissions_role FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE;
ALTER TABLE role_permissions ADD CONSTRAINT fk_role_permissions_permission FOREIGN KEY (permission_id) REFERENCES permissions(id) ON DELETE CASCADE;

ALTER TABLE user_roles ADD CONSTRAINT fk_user_roles_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
ALTER TABLE user_roles ADD CONSTRAINT fk_user_roles_role FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE;

ALTER TABLE customer_addresses ADD CONSTRAINT fk_customer_addresses_customer FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE;

ALTER TABLE shipment_requests ADD CONSTRAINT fk_shipment_requests_customer FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE;
ALTER TABLE shipment_requests ADD CONSTRAINT fk_shipment_requests_sender_address FOREIGN KEY (sender_address_id) REFERENCES customer_addresses(id);
ALTER TABLE shipment_requests ADD CONSTRAINT fk_shipment_requests_receiver_address FOREIGN KEY (receiver_address_id) REFERENCES customer_addresses(id);
ALTER TABLE shipment_requests ADD CONSTRAINT fk_shipment_requests_service FOREIGN KEY (service_id) REFERENCES services(id);
ALTER TABLE shipment_requests ADD CONSTRAINT fk_shipment_requests_insurance FOREIGN KEY (insurance_plan_id) REFERENCES insurance_plans(id);
ALTER TABLE shipment_requests ADD CONSTRAINT fk_shipment_requests_approved_by FOREIGN KEY (approved_by) REFERENCES employees(id);

ALTER TABLE facilities ADD CONSTRAINT fk_facilities_branch_manager FOREIGN KEY (branch_manager_id) REFERENCES employees(id) ON DELETE SET NULL;

ALTER TABLE pincodes ADD CONSTRAINT fk_pincodes_facility FOREIGN KEY (facility_id) REFERENCES facilities(id) ON DELETE SET NULL;

ALTER TABLE storage_areas ADD CONSTRAINT fk_storage_areas_facility FOREIGN KEY (facility_id) REFERENCES facilities(id) ON DELETE CASCADE;

ALTER TABLE pricing_rules ADD CONSTRAINT fk_pricing_rules_service FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE;

ALTER TABLE shipments ADD CONSTRAINT fk_shipments_request FOREIGN KEY (shipment_request_id) REFERENCES shipment_requests(id) ON DELETE SET NULL;
ALTER TABLE shipments ADD CONSTRAINT fk_shipments_service FOREIGN KEY (service_id) REFERENCES services(id);
ALTER TABLE shipments ADD CONSTRAINT fk_shipments_customer FOREIGN KEY (customer_id) REFERENCES customers(id);
ALTER TABLE shipments ADD CONSTRAINT fk_shipments_sender_address FOREIGN KEY (sender_address_id) REFERENCES customer_addresses(id);
ALTER TABLE shipments ADD CONSTRAINT fk_shipments_receiver_address FOREIGN KEY (receiver_address_id) REFERENCES customer_addresses(id);
ALTER TABLE shipments ADD CONSTRAINT fk_shipments_insurance FOREIGN KEY (insurance_plan_id) REFERENCES insurance_plans(id) ON DELETE SET NULL;

ALTER TABLE shipment_contacts ADD CONSTRAINT fk_shipment_contacts_shipment FOREIGN KEY (shipment_id) REFERENCES shipments(id) ON DELETE CASCADE;

ALTER TABLE shipment_status_history ADD CONSTRAINT fk_shipment_status_history_shipment FOREIGN KEY (shipment_id) REFERENCES shipments(id) ON DELETE CASCADE;
ALTER TABLE shipment_status_history ADD CONSTRAINT fk_shipment_status_history_changed_by FOREIGN KEY (changed_by) REFERENCES employees(id) ON DELETE SET NULL;

ALTER TABLE package_scans ADD CONSTRAINT fk_package_scans_shipment FOREIGN KEY (shipment_id) REFERENCES shipments(id) ON DELETE CASCADE;
ALTER TABLE package_scans ADD CONSTRAINT fk_package_scans_employee FOREIGN KEY (employee_id) REFERENCES employees(id);
ALTER TABLE package_scans ADD CONSTRAINT fk_package_scans_facility FOREIGN KEY (facility_id) REFERENCES facilities(id) ON DELETE SET NULL;
ALTER TABLE package_scans ADD CONSTRAINT fk_package_scans_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE SET NULL;

ALTER TABLE tracking_events ADD CONSTRAINT fk_tracking_events_shipment FOREIGN KEY (shipment_id) REFERENCES shipments(id) ON DELETE CASCADE;
ALTER TABLE tracking_events ADD CONSTRAINT fk_tracking_events_package_scan FOREIGN KEY (package_scan_id) REFERENCES package_scans(id) ON DELETE SET NULL;
ALTER TABLE tracking_events ADD CONSTRAINT fk_tracking_events_status FOREIGN KEY (tracking_status_id) REFERENCES tracking_status(id);

ALTER TABLE delivery_attempts ADD CONSTRAINT fk_delivery_attempts_shipment FOREIGN KEY (shipment_id) REFERENCES shipments(id) ON DELETE CASCADE;
ALTER TABLE delivery_attempts ADD CONSTRAINT fk_delivery_attempts_assignment FOREIGN KEY (delivery_assignment_id) REFERENCES delivery_assignments(id);

ALTER TABLE proof_of_delivery ADD CONSTRAINT fk_proof_of_delivery_shipment FOREIGN KEY (shipment_id) REFERENCES shipments(id) ON DELETE CASCADE;
ALTER TABLE proof_of_delivery ADD CONSTRAINT fk_proof_of_delivery_attempt FOREIGN KEY (delivery_attempt_id) REFERENCES delivery_attempts(id);

ALTER TABLE notifications ADD CONSTRAINT fk_notifications_tracking_event FOREIGN KEY (tracking_event_id) REFERENCES tracking_events(id) ON DELETE CASCADE;
ALTER TABLE notifications ADD CONSTRAINT fk_notifications_customer FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE;

ALTER TABLE vehicles ADD CONSTRAINT fk_vehicles_assigned_driver FOREIGN KEY (assigned_driver_id) REFERENCES employees(id) ON DELETE SET NULL;

ALTER TABLE vehicle_maintenance ADD CONSTRAINT fk_vehicle_maintenance_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE;

ALTER TABLE vehicle_fuel_logs ADD CONSTRAINT fk_vehicle_fuel_logs_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE;

ALTER TABLE vehicle_gps ADD CONSTRAINT fk_vehicle_gps_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE;

ALTER TABLE routes ADD CONSTRAINT fk_routes_origin_facility FOREIGN KEY (origin_facility_id) REFERENCES facilities(id);
ALTER TABLE routes ADD CONSTRAINT fk_routes_destination_facility FOREIGN KEY (destination_facility_id) REFERENCES facilities(id);

ALTER TABLE route_stops ADD CONSTRAINT fk_route_stops_route FOREIGN KEY (route_id) REFERENCES routes(id) ON DELETE CASCADE;
ALTER TABLE route_stops ADD CONSTRAINT fk_route_stops_facility FOREIGN KEY (facility_id) REFERENCES facilities(id);

ALTER TABLE transport_orders ADD CONSTRAINT fk_transport_orders_shipment FOREIGN KEY (shipment_id) REFERENCES shipments(id) ON DELETE CASCADE;
ALTER TABLE transport_orders ADD CONSTRAINT fk_transport_orders_created_by FOREIGN KEY (created_by) REFERENCES employees(id) ON DELETE SET NULL;
ALTER TABLE transport_orders ADD CONSTRAINT fk_transport_orders_assigned_vehicle FOREIGN KEY (assigned_vehicle_id) REFERENCES vehicles(id) ON DELETE SET NULL;
ALTER TABLE transport_orders ADD CONSTRAINT fk_transport_orders_assigned_driver FOREIGN KEY (assigned_driver_id) REFERENCES employees(id) ON DELETE SET NULL;

ALTER TABLE shipment_manifests ADD CONSTRAINT fk_shipment_manifests_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicles(id);
ALTER TABLE shipment_manifests ADD CONSTRAINT fk_shipment_manifests_driver FOREIGN KEY (driver_id) REFERENCES employees(id);
ALTER TABLE shipment_manifests ADD CONSTRAINT fk_shipment_manifests_route FOREIGN KEY (route_id) REFERENCES routes(id);
ALTER TABLE shipment_manifests ADD CONSTRAINT fk_shipment_manifests_departure_facility FOREIGN KEY (departure_facility_id) REFERENCES facilities(id);

ALTER TABLE manifest_items ADD CONSTRAINT fk_manifest_items_manifest FOREIGN KEY (manifest_id) REFERENCES shipment_manifests(id) ON DELETE CASCADE;
ALTER TABLE manifest_items ADD CONSTRAINT fk_manifest_items_transport_order FOREIGN KEY (transport_order_id) REFERENCES transport_orders(id) ON DELETE CASCADE;
ALTER TABLE manifest_items ADD CONSTRAINT fk_manifest_items_unloaded_facility FOREIGN KEY (unloaded_facility_id) REFERENCES facilities(id) ON DELETE SET NULL;

ALTER TABLE delivery_assignments ADD CONSTRAINT fk_delivery_assignments_manifest FOREIGN KEY (manifest_id) REFERENCES shipment_manifests(id) ON DELETE CASCADE;
ALTER TABLE delivery_assignments ADD CONSTRAINT fk_delivery_assignments_driver FOREIGN KEY (driver_id) REFERENCES employees(id);
ALTER TABLE delivery_assignments ADD CONSTRAINT fk_delivery_assignments_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicles(id);
ALTER TABLE delivery_assignments ADD CONSTRAINT fk_delivery_assignments_route_stop FOREIGN KEY (route_stop_id) REFERENCES route_stops(id);

ALTER TABLE invoices ADD CONSTRAINT fk_invoices_shipment FOREIGN KEY (shipment_id) REFERENCES shipments(id) ON DELETE CASCADE;

ALTER TABLE shipment_charges ADD CONSTRAINT fk_shipment_charges_shipment FOREIGN KEY (shipment_id) REFERENCES shipments(id) ON DELETE CASCADE;
ALTER TABLE shipment_charges ADD CONSTRAINT fk_shipment_charges_invoice FOREIGN KEY (invoice_id) REFERENCES invoices(id) ON DELETE SET NULL;

ALTER TABLE payments ADD CONSTRAINT fk_payments_invoice FOREIGN KEY (invoice_id) REFERENCES invoices(id) ON DELETE CASCADE;
ALTER TABLE payments ADD CONSTRAINT fk_payments_customer FOREIGN KEY (customer_id) REFERENCES customers(id);

ALTER TABLE expenses ADD CONSTRAINT fk_expenses_facility FOREIGN KEY (facility_id) REFERENCES facilities(id) ON DELETE SET NULL;
ALTER TABLE expenses ADD CONSTRAINT fk_expenses_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE SET NULL;
ALTER TABLE expenses ADD CONSTRAINT fk_expenses_employee FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE SET NULL;
ALTER TABLE expenses ADD CONSTRAINT fk_expenses_approved_by FOREIGN KEY (approved_by) REFERENCES employees(id) ON DELETE SET NULL;

ALTER TABLE audit_logs ADD CONSTRAINT fk_audit_logs_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

ALTER TABLE login_history ADD CONSTRAINT fk_login_history_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

ALTER TABLE employee_profile_requests ADD CONSTRAINT fk_employee_profile_requests_employee FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE;
ALTER TABLE employee_profile_requests ADD CONSTRAINT fk_employee_profile_requests_requested_by FOREIGN KEY (requested_by) REFERENCES users(id) ON DELETE CASCADE;
ALTER TABLE employee_profile_requests ADD CONSTRAINT fk_employee_profile_requests_approved_by FOREIGN KEY (approved_by) REFERENCES users(id) ON DELETE SET NULL;

-- =============================================
-- INDEXES (for performance)
-- =============================================

-- Identity
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_employees_branch ON employees(branch_id);
CREATE INDEX idx_employees_user_id ON employees(user_id);
CREATE INDEX idx_customers_user_id ON customers(user_id);
CREATE INDEX idx_customers_account_number ON customers(account_number);

-- Customer
CREATE INDEX idx_customer_addresses_customer ON customer_addresses(customer_id);
CREATE INDEX idx_shipment_requests_customer ON shipment_requests(customer_id);
CREATE INDEX idx_shipment_requests_status ON shipment_requests(status);
CREATE INDEX idx_shipment_requests_created_at ON shipment_requests(created_at);

-- Shipments
CREATE INDEX idx_shipments_tracking ON shipments(tracking_number);
CREATE INDEX idx_shipments_customer ON shipments(customer_id);
CREATE INDEX idx_shipments_status ON shipments(current_status);
CREATE INDEX idx_shipments_estimated_delivery ON shipments(estimated_delivery);
CREATE INDEX idx_shipments_created_at ON shipments(created_at);
CREATE INDEX idx_shipment_contacts_shipment ON shipment_contacts(shipment_id);
CREATE INDEX idx_shipment_status_history_shipment ON shipment_status_history(shipment_id);
CREATE INDEX idx_shipment_status_history_status ON shipment_status_history(status);
CREATE INDEX idx_shipment_status_history_changed_at ON shipment_status_history(changed_at);

-- Package scans & tracking
CREATE INDEX idx_package_scans_shipment ON package_scans(shipment_id);
CREATE INDEX idx_package_scans_employee ON package_scans(employee_id);
CREATE INDEX idx_package_scans_facility ON package_scans(facility_id);
CREATE INDEX idx_package_scans_scan_time ON package_scans(scan_time);
CREATE INDEX idx_tracking_events_shipment ON tracking_events(shipment_id);
CREATE INDEX idx_tracking_events_status ON tracking_events(tracking_status_id);
CREATE INDEX idx_tracking_events_time ON tracking_events(event_time);
CREATE INDEX idx_delivery_attempts_shipment ON delivery_attempts(shipment_id);
CREATE INDEX idx_delivery_attempts_assignment ON delivery_attempts(delivery_assignment_id);
CREATE INDEX idx_proof_of_delivery_shipment ON proof_of_delivery(shipment_id);

-- Notifications
CREATE INDEX idx_notifications_tracking_event ON notifications(tracking_event_id);
CREATE INDEX idx_notifications_customer ON notifications(customer_id);
CREATE INDEX idx_notifications_status ON notifications(status);

-- Transportation
CREATE INDEX idx_vehicles_assigned_driver ON vehicles(assigned_driver_id);
CREATE INDEX idx_vehicles_status ON vehicles(status);
CREATE INDEX idx_vehicle_maintenance_vehicle ON vehicle_maintenance(vehicle_id);
CREATE INDEX idx_vehicle_fuel_logs_vehicle ON vehicle_fuel_logs(vehicle_id);
CREATE INDEX idx_vehicle_gps_vehicle ON vehicle_gps(vehicle_id);
CREATE INDEX idx_vehicle_gps_recorded_at ON vehicle_gps(recorded_at);

CREATE INDEX idx_routes_origin_facility ON routes(origin_facility_id);
CREATE INDEX idx_routes_destination_facility ON routes(destination_facility_id);
CREATE INDEX idx_route_stops_route ON route_stops(route_id);
CREATE INDEX idx_route_stops_facility ON route_stops(facility_id);

CREATE INDEX idx_transport_orders_shipment ON transport_orders(shipment_id);
CREATE INDEX idx_transport_orders_status ON transport_orders(status);
CREATE INDEX idx_transport_orders_assigned_vehicle ON transport_orders(assigned_vehicle_id);
CREATE INDEX idx_transport_orders_assigned_driver ON transport_orders(assigned_driver_id);
CREATE INDEX idx_transport_orders_planned_departure ON transport_orders(planned_departure);

CREATE INDEX idx_shipment_manifests_vehicle ON shipment_manifests(vehicle_id);
CREATE INDEX idx_shipment_manifests_driver ON shipment_manifests(driver_id);
CREATE INDEX idx_shipment_manifests_route ON shipment_manifests(route_id);
CREATE INDEX idx_shipment_manifests_status ON shipment_manifests(status);
CREATE INDEX idx_shipment_manifests_departure ON shipment_manifests(departure_time);

CREATE INDEX idx_manifest_items_manifest ON manifest_items(manifest_id);
CREATE INDEX idx_manifest_items_transport_order ON manifest_items(transport_order_id);
CREATE INDEX idx_manifest_items_status ON manifest_items(status);

CREATE INDEX idx_delivery_assignments_manifest ON delivery_assignments(manifest_id);
CREATE INDEX idx_delivery_assignments_driver ON delivery_assignments(driver_id);
CREATE INDEX idx_delivery_assignments_route_stop ON delivery_assignments(route_stop_id);
CREATE INDEX idx_delivery_assignments_status ON delivery_assignments(status);

-- Finance
CREATE INDEX idx_invoices_shipment ON invoices(shipment_id);
CREATE INDEX idx_invoices_status ON invoices(status);
CREATE INDEX idx_invoices_invoice_date ON invoices(invoice_date);
CREATE INDEX idx_shipment_charges_shipment ON shipment_charges(shipment_id);
CREATE INDEX idx_shipment_charges_invoice ON shipment_charges(invoice_id);
CREATE INDEX idx_payments_invoice ON payments(invoice_id);
CREATE INDEX idx_payments_customer ON payments(customer_id);
CREATE INDEX idx_payments_status ON payments(payment_status);
CREATE INDEX idx_expenses_facility ON expenses(facility_id);
CREATE INDEX idx_expenses_vehicle ON expenses(vehicle_id);
CREATE INDEX idx_expenses_employee ON expenses(employee_id);
CREATE INDEX idx_expenses_status ON expenses(status);
CREATE INDEX idx_expenses_expense_date ON expenses(expense_date);

-- Administration
CREATE INDEX idx_audit_logs_user ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_record ON audit_logs(record_id);
CREATE INDEX idx_audit_logs_table ON audit_logs(table_name);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at);
CREATE INDEX idx_login_history_user ON login_history(user_id);
CREATE INDEX idx_login_history_login_time ON login_history(login_time);
CREATE INDEX idx_employee_profile_requests_employee ON employee_profile_requests(employee_id);
CREATE INDEX idx_employee_profile_requests_status ON employee_profile_requests(status);