-- =============================================
-- ENUMS
-- =============================================

CREATE TYPE user_status AS ENUM ('active', 'inactive', 'locked');
CREATE TYPE shipment_status AS ENUM ('created', 'pickup_scheduled', 'in_sorting', 'loaded', 'in_transit', 'out_for_delivery', 'delivered', 'exception', 'cancelled');
CREATE TYPE shipment_request_status AS ENUM ('pending', 'approved', 'rejected');
CREATE TYPE invoice_status AS ENUM ('draft', 'issued', 'paid', 'partially_paid', 'overdue', 'cancelled');
CREATE TYPE payment_status AS ENUM ('pending', 'completed', 'failed', 'refunded');
CREATE TYPE payment_method AS ENUM ('cash', 'card', 'online', 'vpp');
CREATE TYPE transport_order_status AS ENUM ('created', 'planned', 'assigned', 'in_transit', 'delivered', 'cancelled');
CREATE TYPE manifest_status AS ENUM ('planned', 'in_progress', 'completed', 'delayed', 'cancelled');
CREATE TYPE delivery_attempt_status AS ENUM ('attempted', 'delivered', 'failed');
CREATE TYPE expense_status AS ENUM ('pending', 'approved', 'rejected', 'paid');
CREATE TYPE notification_status AS ENUM ('pending', 'sent', 'failed', 'read');
CREATE TYPE location_type AS ENUM ('branch', 'distribution_center', 'vehicle');

-- =============================================
-- MODULE 1: IDENTITY
-- =============================================

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    password_hash VARCHAR(255) NOT NULL,
    mfa_enabled BOOLEAN DEFAULT FALSE,
    mfa_secret VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    last_login TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE departments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) UNIQUE NOT NULL,
    description VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE positions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) UNIQUE NOT NULL,
    description VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE employees (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    department_id UUID,
    position_id UUID,
    branch_id UUID,
    hire_date DATE,
    employee_code VARCHAR(50) UNIQUE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE customers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID UNIQUE NOT NULL,
    company_name VARCHAR(200),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    tax_id VARCHAR(50),
    account_number VARCHAR(50) UNIQUE,
    credit_limit DECIMAL(15,2),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(50) UNIQUE NOT NULL,
    description VARCHAR(255),
    is_system BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE permissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) UNIQUE NOT NULL,
    resource VARCHAR(100) NOT NULL,
    action VARCHAR(50) NOT NULL,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE role_permissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role_id UUID NOT NULL,
    permission_id UUID NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
    FOREIGN KEY (permission_id) REFERENCES permissions(id) ON DELETE CASCADE,
    CONSTRAINT unique_role_permission UNIQUE (role_id, permission_id)
);

CREATE TABLE user_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    role_id UUID NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
    CONSTRAINT unique_user_role UNIQUE (user_id, role_id)
);

-- =============================================
-- MODULE 2: CUSTOMER
-- =============================================

CREATE TABLE customer_addresses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL,
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
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
);

CREATE TABLE shipment_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    request_number VARCHAR(50) UNIQUE NOT NULL,
    customer_id UUID NOT NULL,
    sender_address_id UUID NOT NULL,
    receiver_address_id UUID NOT NULL,
    service_id UUID,
    package_type VARCHAR(50) NOT NULL,
    weight DECIMAL(10,3) NOT NULL,
    length DECIMAL(10,2),
    width DECIMAL(10,2),
    height DECIMAL(10,2),
    declared_value DECIMAL(15,2),
    insurance_plan_id UUID,
    special_instructions TEXT,
    is_fragile BOOLEAN DEFAULT FALSE,
    is_large BOOLEAN DEFAULT FALSE,
    status shipment_request_status DEFAULT 'pending',
    estimated_cost DECIMAL(15,2),
    approved_by UUID,
    approved_at TIMESTAMP,
    rejection_reason TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
    FOREIGN KEY (sender_address_id) REFERENCES customer_addresses(id),
    FOREIGN KEY (receiver_address_id) REFERENCES customer_addresses(id)
);

-- =============================================
-- MODULE 3: FACILITIES
-- =============================================

CREATE TABLE facilities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(200) NOT NULL,
    facility_type VARCHAR(20) NOT NULL CHECK (facility_type IN ('Branch', 'DistributionCenter')),
    address_line1 VARCHAR(255) NOT NULL,
    address_line2 VARCHAR(255),
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    pincode VARCHAR(20) NOT NULL,
    country VARCHAR(100) DEFAULT 'India',
    phone VARCHAR(20),
    email VARCHAR(255),
    branch_manager_id UUID,
    capacity DECIMAL(15,2),
    current_occupancy DECIMAL(15,2),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE pincodes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    pincode VARCHAR(20) UNIQUE NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    country VARCHAR(100) DEFAULT 'India',
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    facility_id UUID,
    serviceable BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (facility_id) REFERENCES facilities(id) ON DELETE SET NULL
);

CREATE TABLE storage_areas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    facility_id UUID NOT NULL,
    zone_code VARCHAR(50) NOT NULL,
    shelf VARCHAR(50),
    container VARCHAR(50),
    capacity DECIMAL(15,2),
    current_occupancy DECIMAL(15,2),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (facility_id) REFERENCES facilities(id) ON DELETE CASCADE
);

-- =============================================
-- MODULE 4: PRICING
-- =============================================

CREATE TABLE services (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    service_type VARCHAR(50) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE pricing_rules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    service_id UUID NOT NULL,
    name VARCHAR(100) NOT NULL,
    rule_type VARCHAR(50) NOT NULL,
    calculation_type VARCHAR(50) NOT NULL,
    min_value DECIMAL(15,2),
    max_value DECIMAL(15,2),
    rate DECIMAL(15,4) NOT NULL,
    condition_expression TEXT,
    priority INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE
);

CREATE TABLE insurance_plans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    min_cover DECIMAL(15,2) NOT NULL,
    max_cover DECIMAL(15,2) NOT NULL,
    rate_percentage DECIMAL(5,2) NOT NULL,
    fixed_charge DECIMAL(15,2) DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- =============================================
-- MODULE 5: SHIPMENT
-- =============================================

CREATE TABLE shipments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tracking_number VARCHAR(50) UNIQUE NOT NULL,
    shipment_request_id UUID,
    service_id UUID NOT NULL,
    customer_id UUID NOT NULL,
    sender_address_id UUID NOT NULL,
    receiver_address_id UUID NOT NULL,
    weight DECIMAL(10,3) NOT NULL,
    length DECIMAL(10,2),
    width DECIMAL(10,2),
    height DECIMAL(10,2),
    declared_value DECIMAL(15,2),
    insurance_plan_id UUID,
    insurance_amount DECIMAL(15,2),
    package_type VARCHAR(50) NOT NULL,
    special_instructions TEXT,
    is_fragile BOOLEAN DEFAULT FALSE,
    is_large BOOLEAN DEFAULT FALSE,
    current_status shipment_status DEFAULT 'created',
    estimated_delivery DATE,
    actual_delivery TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (shipment_request_id) REFERENCES shipment_requests(id) ON DELETE SET NULL,
    FOREIGN KEY (service_id) REFERENCES services(id),
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    FOREIGN KEY (sender_address_id) REFERENCES customer_addresses(id),
    FOREIGN KEY (receiver_address_id) REFERENCES customer_addresses(id),
    FOREIGN KEY (insurance_plan_id) REFERENCES insurance_plans(id) ON DELETE SET NULL
);

CREATE TABLE shipment_contacts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    shipment_id UUID NOT NULL,
    contact_type VARCHAR(20) NOT NULL CHECK (contact_type IN ('sender', 'receiver')),
    name VARCHAR(200) NOT NULL,
    phone VARCHAR(20),
    address_line1 VARCHAR(255) NOT NULL,
    address_line2 VARCHAR(255),
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    pincode VARCHAR(20) NOT NULL,
    country VARCHAR(100) DEFAULT 'India',
    landmark VARCHAR(255),
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (shipment_id) REFERENCES shipments(id) ON DELETE CASCADE
);

CREATE TABLE shipment_status_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    shipment_id UUID NOT NULL,
    status shipment_status NOT NULL,
    changed_by UUID,
    changed_at TIMESTAMP DEFAULT NOW(),
    notes TEXT,
    FOREIGN KEY (shipment_id) REFERENCES shipments(id) ON DELETE CASCADE,
    FOREIGN KEY (changed_by) REFERENCES employees(id) ON DELETE SET NULL
);

CREATE TABLE tracking_status (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    is_public BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE package_scans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    scan_number VARCHAR(50) UNIQUE NOT NULL,
    shipment_id UUID NOT NULL,
    employee_id UUID NOT NULL,
    facility_id UUID,
    vehicle_id UUID,
    location_type location_type NOT NULL,
    scan_type VARCHAR(50) NOT NULL,
    scan_time TIMESTAMP DEFAULT NOW(),
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    ip_address VARCHAR(45),
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (shipment_id) REFERENCES shipments(id) ON DELETE CASCADE,
    FOREIGN KEY (employee_id) REFERENCES employees(id),
    FOREIGN KEY (facility_id) REFERENCES facilities(id) ON DELETE SET NULL,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE SET NULL
);

CREATE TABLE tracking_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    shipment_id UUID NOT NULL,
    package_scan_id UUID,
    tracking_status_id UUID NOT NULL,
    event_location VARCHAR(255),
    event_time TIMESTAMP DEFAULT NOW(),
    is_public BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (shipment_id) REFERENCES shipments(id) ON DELETE CASCADE,
    FOREIGN KEY (package_scan_id) REFERENCES package_scans(id) ON DELETE SET NULL,
    FOREIGN KEY (tracking_status_id) REFERENCES tracking_status(id)
);

CREATE TABLE delivery_attempts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    shipment_id UUID NOT NULL,
    delivery_assignment_id UUID NOT NULL,
    attempt_number INTEGER NOT NULL,
    attempt_time TIMESTAMP DEFAULT NOW(),
    status delivery_attempt_status NOT NULL,
    reason VARCHAR(255),
    notes TEXT,
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    is_delivered BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (shipment_id) REFERENCES shipments(id) ON DELETE CASCADE
);

CREATE TABLE proof_of_delivery (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    shipment_id UUID UNIQUE NOT NULL,
    delivery_attempt_id UUID NOT NULL,
    receiver_name VARCHAR(200) NOT NULL,
    receiver_signature TEXT,
    receiver_relation VARCHAR(100),
    delivery_photo TEXT,
    delivery_time TIMESTAMP NOT NULL,
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    gps_accuracy DECIMAL(5,2),
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (shipment_id) REFERENCES shipments(id) ON DELETE CASCADE,
    FOREIGN KEY (delivery_attempt_id) REFERENCES delivery_attempts(id)
);

CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tracking_event_id UUID NOT NULL,
    customer_id UUID NOT NULL,
    notification_type VARCHAR(50) NOT NULL,
    subject VARCHAR(255),
    content TEXT NOT NULL,
    recipient VARCHAR(255) NOT NULL,
    status notification_status DEFAULT 'pending',
    sent_at TIMESTAMP,
    read_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (tracking_event_id) REFERENCES tracking_events(id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
);

-- =============================================
-- MODULE 6: TRANSPORTATION
-- =============================================

CREATE TABLE vehicles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    vehicle_number VARCHAR(50) UNIQUE NOT NULL,
    vehicle_type VARCHAR(50) NOT NULL,
    brand VARCHAR(50),
    model VARCHAR(50),
    year INTEGER,
    capacity DECIMAL(15,2) NOT NULL,
    status VARCHAR(50) DEFAULT 'Available',
    registration_number VARCHAR(50) UNIQUE,
    insurance_expiry DATE,
    maintenance_due DATE,
    assigned_driver_id UUID,
    fuel_type VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (assigned_driver_id) REFERENCES employees(id) ON DELETE SET NULL
);

CREATE TABLE vehicle_maintenance (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    vehicle_id UUID NOT NULL,
    maintenance_date DATE NOT NULL,
    description TEXT,
    cost DECIMAL(15,2),
    performed_by UUID,
    next_maintenance_date DATE,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE
);

CREATE TABLE vehicle_fuel_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    vehicle_id UUID NOT NULL,
    fuel_date DATE NOT NULL,
    fuel_type VARCHAR(50),
    quantity DECIMAL(10,2),
    cost DECIMAL(15,2),
    odometer_reading DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE
);

CREATE TABLE vehicle_gps (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    vehicle_id UUID NOT NULL,
    recorded_at TIMESTAMP DEFAULT NOW(),
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    speed DECIMAL(8,2),
    heading DECIMAL(5,2),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE
);

CREATE TABLE routes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    route_code VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(200) NOT NULL,
    origin_facility_id UUID NOT NULL,
    destination_facility_id UUID NOT NULL,
    distance DECIMAL(10,2) NOT NULL,
    estimated_duration INTEGER,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (origin_facility_id) REFERENCES facilities(id),
    FOREIGN KEY (destination_facility_id) REFERENCES facilities(id)
);

CREATE TABLE route_stops (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    route_id UUID NOT NULL,
    stop_sequence INTEGER NOT NULL,
    facility_id UUID NOT NULL,
    stop_name VARCHAR(200) NOT NULL,
    pincode VARCHAR(20),
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    estimated_arrival INTEGER,
    estimated_departure INTEGER,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (route_id) REFERENCES routes(id) ON DELETE CASCADE,
    FOREIGN KEY (facility_id) REFERENCES facilities(id)
);

CREATE TABLE transport_orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_number VARCHAR(50) UNIQUE NOT NULL,
    shipment_id UUID NOT NULL,
    priority INTEGER DEFAULT 5,
    weight DECIMAL(10,3) NOT NULL,
    volume DECIMAL(10,3),
    special_instructions TEXT,
    status transport_order_status DEFAULT 'created',
    created_by UUID,
    assigned_vehicle_id UUID,
    assigned_driver_id UUID,
    planned_departure TIMESTAMP,
    planned_arrival TIMESTAMP,
    actual_departure TIMESTAMP,
    actual_arrival TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (shipment_id) REFERENCES shipments(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES employees(id) ON DELETE SET NULL,
    FOREIGN KEY (assigned_vehicle_id) REFERENCES vehicles(id) ON DELETE SET NULL,
    FOREIGN KEY (assigned_driver_id) REFERENCES employees(id) ON DELETE SET NULL
);

CREATE TABLE shipment_manifests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    manifest_number VARCHAR(50) UNIQUE NOT NULL,
    vehicle_id UUID NOT NULL,
    driver_id UUID NOT NULL,
    route_id UUID NOT NULL,
    departure_facility_id UUID NOT NULL,
    departure_time TIMESTAMP NOT NULL,
    arrival_time TIMESTAMP,
    status manifest_status DEFAULT 'planned',
    total_packages INTEGER DEFAULT 0,
    total_weight DECIMAL(15,2) DEFAULT 0,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id),
    FOREIGN KEY (driver_id) REFERENCES employees(id),
    FOREIGN KEY (route_id) REFERENCES routes(id),
    FOREIGN KEY (departure_facility_id) REFERENCES facilities(id)
);

CREATE TABLE manifest_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    manifest_id UUID NOT NULL,
    transport_order_id UUID NOT NULL,
    loading_sequence INTEGER,
    status VARCHAR(50) DEFAULT 'Loaded',
    loaded_at TIMESTAMP,
    unloaded_at TIMESTAMP,
    unloaded_facility_id UUID,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (manifest_id) REFERENCES shipment_manifests(id) ON DELETE CASCADE,
    FOREIGN KEY (transport_order_id) REFERENCES transport_orders(id) ON DELETE CASCADE,
    FOREIGN KEY (unloaded_facility_id) REFERENCES facilities(id) ON DELETE SET NULL,
    CONSTRAINT unique_manifest_transport_order UNIQUE (manifest_id, transport_order_id)
);

CREATE TABLE delivery_assignments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    assignment_number VARCHAR(50) UNIQUE NOT NULL,
    manifest_id UUID NOT NULL,
    driver_id UUID NOT NULL,
    vehicle_id UUID NOT NULL,
    route_stop_id UUID NOT NULL,
    assigned_at TIMESTAMP DEFAULT NOW(),
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    status VARCHAR(50) DEFAULT 'Assigned',
    sequence_number INTEGER,
    estimated_delivery_time TIMESTAMP,
    actual_delivery_time TIMESTAMP,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (manifest_id) REFERENCES shipment_manifests(id) ON DELETE CASCADE,
    FOREIGN KEY (driver_id) REFERENCES employees(id),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id),
    FOREIGN KEY (route_stop_id) REFERENCES route_stops(id)
);

-- =============================================
-- MODULE 7: FINANCE
-- =============================================

CREATE TABLE invoices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    invoice_number VARCHAR(50) UNIQUE NOT NULL,
    shipment_id UUID NOT NULL,
    invoice_date DATE NOT NULL,
    due_date DATE,
    total_amount DECIMAL(15,2) NOT NULL,
    discount_amount DECIMAL(15,2) DEFAULT 0,
    net_amount DECIMAL(15,2) NOT NULL,
    status invoice_status DEFAULT 'draft',
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (shipment_id) REFERENCES shipments(id) ON DELETE CASCADE
);

CREATE TABLE shipment_charges (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    shipment_id UUID NOT NULL,
    invoice_id UUID,
    charge_type VARCHAR(50) NOT NULL,
    description VARCHAR(255),
    amount DECIMAL(15,2) NOT NULL,
    calculation_reference VARCHAR(255),
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (shipment_id) REFERENCES shipments(id) ON DELETE CASCADE,
    FOREIGN KEY (invoice_id) REFERENCES invoices(id) ON DELETE SET NULL
);

CREATE TABLE payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    payment_number VARCHAR(50) UNIQUE NOT NULL,
    invoice_id UUID NOT NULL,
    customer_id UUID NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    payment_method payment_method NOT NULL,
    payment_status payment_status DEFAULT 'pending',
    transaction_id VARCHAR(100),
    payment_date TIMESTAMP,
    reference_number VARCHAR(100),
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (invoice_id) REFERENCES invoices(id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

CREATE TABLE expenses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    expense_number VARCHAR(50) UNIQUE NOT NULL,
    expense_type VARCHAR(50) NOT NULL,
    facility_id UUID,
    vehicle_id UUID,
    employee_id UUID,
    amount DECIMAL(15,2) NOT NULL,
    expense_date DATE NOT NULL,
    description TEXT,
    invoice_number VARCHAR(100),
    approved_by UUID,
    approved_at TIMESTAMP,
    status expense_status DEFAULT 'pending',
    payment_status VARCHAR(50) DEFAULT 'Unpaid',
    payment_date DATE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (facility_id) REFERENCES facilities(id) ON DELETE SET NULL,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE SET NULL,
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE SET NULL,
    FOREIGN KEY (approved_by) REFERENCES employees(id) ON DELETE SET NULL
);

-- =============================================
-- MODULE 8: ADMINISTRATION
-- =============================================

CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    action VARCHAR(100) NOT NULL,
    table_name VARCHAR(100) NOT NULL,
    record_id UUID NOT NULL,
    old_data JSONB,
    new_data JSONB,
    ip_address VARCHAR(45),
    user_agent TEXT,
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE login_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    login_time TIMESTAMP DEFAULT NOW(),
    logout_time TIMESTAMP,
    ip_address VARCHAR(45),
    user_agent TEXT,
    login_status VARCHAR(50) NOT NULL,
    failure_reason TEXT,
    session_id VARCHAR(100),
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE employee_profile_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    employee_id UUID NOT NULL,
    requested_by UUID NOT NULL,
    field_name VARCHAR(100) NOT NULL,
    old_value TEXT,
    new_value TEXT NOT NULL,
    reason TEXT,
    status VARCHAR(50) DEFAULT 'Pending',
    approved_by UUID,
    approved_at TIMESTAMP,
    rejection_reason TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE,
    FOREIGN KEY (requested_by) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (approved_by) REFERENCES users(id) ON DELETE SET NULL
);

-- =============================================
-- ADD FOREIGN KEYS THAT COULDN'T BE ADDED EARLIER
-- (Due to circular dependencies)
-- =============================================

ALTER TABLE employees ADD FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL;
ALTER TABLE employees ADD FOREIGN KEY (position_id) REFERENCES positions(id) ON DELETE SET NULL;
ALTER TABLE employees ADD FOREIGN KEY (branch_id) REFERENCES facilities(id) ON DELETE SET NULL;
ALTER TABLE facilities ADD FOREIGN KEY (branch_manager_id) REFERENCES employees(id) ON DELETE SET NULL;

-- =============================================
-- INDEXES FOR PERFORMANCE
-- =============================================

-- Identity Module
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_employees_branch ON employees(branch_id);
CREATE INDEX idx_employees_user_id ON employees(user_id);
CREATE INDEX idx_customers_user_id ON customers(user_id);
CREATE INDEX idx_customers_account_number ON customers(account_number);

-- Customer Module
CREATE INDEX idx_customer_addresses_customer ON customer_addresses(customer_id);
CREATE INDEX idx_shipment_requests_customer ON shipment_requests(customer_id);
CREATE INDEX idx_shipment_requests_status ON shipment_requests(status);
CREATE INDEX idx_shipment_requests_created_at ON shipment_requests(created_at);

-- Shipment Module
CREATE INDEX idx_shipments_tracking ON shipments(tracking_number);
CREATE INDEX idx_shipments_customer ON shipments(customer_id);
CREATE INDEX idx_shipments_status ON shipments(current_status);
CREATE INDEX idx_shipments_estimated_delivery ON shipments(estimated_delivery);
CREATE INDEX idx_shipments_created_at ON shipments(created_at);
CREATE INDEX idx_shipment_contacts_shipment ON shipment_contacts(shipment_id);
CREATE INDEX idx_shipment_status_history_shipment ON shipment_status_history(shipment_id);
CREATE INDEX idx_shipment_status_history_status ON shipment_status_history(status);
CREATE INDEX idx_shipment_status_history_changed_at ON shipment_status_history(changed_at);

-- Package Scans & Tracking
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

-- Transportation Module
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

-- Finance Module
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

-- =============================================
-- CREATE UPDATED AT TRIGGER FUNCTION
-- =============================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- APPLY UPDATED AT TRIGGERS
-- =============================================

-- Users
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Employees
CREATE TRIGGER update_employees_updated_at BEFORE UPDATE ON employees FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Customers
CREATE TRIGGER update_customers_updated_at BEFORE UPDATE ON customers FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Roles
CREATE TRIGGER update_roles_updated_at BEFORE UPDATE ON roles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Customer Addresses
CREATE TRIGGER update_customer_addresses_updated_at BEFORE UPDATE ON customer_addresses FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Shipment Requests
CREATE TRIGGER update_shipment_requests_updated_at BEFORE UPDATE ON shipment_requests FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Facilities
CREATE TRIGGER update_facilities_updated_at BEFORE UPDATE ON facilities FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Pincodes
CREATE TRIGGER update_pincodes_updated_at BEFORE UPDATE ON pincodes FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Storage Areas
CREATE TRIGGER update_storage_areas_updated_at BEFORE UPDATE ON storage_areas FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Services
CREATE TRIGGER update_services_updated_at BEFORE UPDATE ON services FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Pricing Rules
CREATE TRIGGER update_pricing_rules_updated_at BEFORE UPDATE ON pricing_rules FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insurance Plans
CREATE TRIGGER update_insurance_plans_updated_at BEFORE UPDATE ON insurance_plans FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Shipments
CREATE TRIGGER update_shipments_updated_at BEFORE UPDATE ON shipments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Delivery Attempts
CREATE TRIGGER update_delivery_attempts_updated_at BEFORE UPDATE ON delivery_attempts FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Notifications
CREATE TRIGGER update_notifications_updated_at BEFORE UPDATE ON notifications FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Vehicles
CREATE TRIGGER update_vehicles_updated_at BEFORE UPDATE ON vehicles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Routes
CREATE TRIGGER update_routes_updated_at BEFORE UPDATE ON routes FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Route Stops
CREATE TRIGGER update_route_stops_updated_at BEFORE UPDATE ON route_stops FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Transport Orders
CREATE TRIGGER update_transport_orders_updated_at BEFORE UPDATE ON transport_orders FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Shipment Manifests
CREATE TRIGGER update_shipment_manifests_updated_at BEFORE UPDATE ON shipment_manifests FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Manifest Items
CREATE TRIGGER update_manifest_items_updated_at BEFORE UPDATE ON manifest_items FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Delivery Assignments
CREATE TRIGGER update_delivery_assignments_updated_at BEFORE UPDATE ON delivery_assignments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Invoices
CREATE TRIGGER update_invoices_updated_at BEFORE UPDATE ON invoices FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Payments
CREATE TRIGGER update_payments_updated_at BEFORE UPDATE ON payments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Expenses
CREATE TRIGGER update_expenses_updated_at BEFORE UPDATE ON expenses FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Employee Profile Requests
CREATE TRIGGER update_employee_profile_requests_updated_at BEFORE UPDATE ON employee_profile_requests FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();