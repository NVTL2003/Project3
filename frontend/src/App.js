import {
    BrowserRouter,
    Routes,
    Route,
    Navigate
} from "react-router-dom";

import LoginPage from "./pages/LoginPage";

function Dashboard() {

    const token = localStorage.getItem("token");

    if (!token) {
        return <Navigate to="/login" replace />;
    }

    const logout = () => {

        localStorage.removeItem("token");

        window.location.href = "/login";
    };

    return (

        <div style={styles.page}>

            <div style={styles.header}>

                <h2>
                    Enterprise Logistics Management System
                </h2>

                <button
                    style={styles.logout}
                    onClick={logout}
                >
                    Logout
                </button>

            </div>

            <div style={styles.card}>

                <h1>Dashboard</h1>

                <p>
                    Welcome to ELMS.
                </p>

                <p>
                    Authentication successful.
                </p>

                <hr />

                <h3>Milestone 1</h3>

                <h2>Project Progress</h2>

                <ul>

                    <li>
                        <strong>Milestone 0 - Infrastructure</strong>

                        <ul>
                            <li> Database Generated (43 Tables)</li>
                            <li> EF Core</li>
                            <li> DbContext</li>
                            <li> Generic CRUD Service</li>
                            <li> Generic Controller</li>
                            <li> DTO Structure</li>
                            <li> React Login</li>
                            <li> JWT Login</li>
                            <li> Repository Pattern</li>
                            <li> Validation</li>
                            <li> Logging</li>
                            <li> Global Exception Handling</li>
                        </ul>
                    </li>

                    <br />

                    <li>
                         <strong>Milestone 1 - Identity (9 Tables)</strong>

                        <ul>
                            <li>Users</li>
                            <li>Departments</li>
                            <li>Positions</li>
                            <li>Employees</li>
                            <li>Customers</li>
                            <li>Roles</li>
                            <li>Permissions</li>
                            <li>RolePermissions</li>
                            <li>UserRoles</li>
                        </ul>
                    </li>

                    <br />

                    <li>
                         <strong>Milestone 2 - Company Setup (6 Tables)</strong>

                        <ul>
                            <li>Facilities</li>
                            <li>Pincodes</li>
                            <li>StorageAreas</li>
                            <li>Services</li>
                            <li>PricingRules</li>
                            <li>InsurancePlans</li>
                        </ul>
                    </li>

                    <br />

                    <li>
                         <strong>Milestone 3 - Customer Shipping (2 Tables)</strong>

                        <ul>
                            <li>CustomerAddresses</li>
                            <li>ShipmentRequests</li>
                        </ul>
                    </li>

                    <br />

                    <li>
                         <strong>Milestone 4 - Shipment Processing (5 Tables)</strong>

                        <ul>
                            <li>Shipments</li>
                            <li>ShipmentContacts</li>
                            <li>ShipmentCharges</li>
                            <li>ShipmentStatusHistory</li>
                            <li>TrackingStatus</li>
                        </ul>
                    </li>

                    <br />

                    <li>
                         <strong>Milestone 5 - Tracking (3 Tables)</strong>

                        <ul>
                            <li>PackageScans</li>
                            <li>TrackingEvents</li>
                            <li>Notifications</li>
                        </ul>
                    </li>

                    <br />

                    <li>
                         <strong>Milestone 6 - Transportation (10 Tables)</strong>

                        <ul>
                            <li>Vehicles</li>
                            <li>VehicleMaintenance</li>
                            <li>VehicleFuelLogs</li>
                            <li>VehicleGPS</li>
                            <li>Routes</li>
                            <li>RouteStops</li>
                            <li>TransportOrders</li>
                            <li>ShipmentManifests</li>
                            <li>ManifestItems</li>
                            <li>DeliveryAssignments</li>
                        </ul>
                    </li>

                    <br />

                    <li>
                         <strong>Milestone 7 - Delivery (2 Tables)</strong>

                        <ul>
                            <li>DeliveryAttempts</li>
                            <li>ProofOfDelivery</li>
                        </ul>
                    </li>

                    <br />

                    <li>
                         <strong>Milestone 8 - Finance (3 Tables)</strong>

                        <ul>
                            <li>Invoices</li>
                            <li>Payments</li>
                            <li>Expenses</li>
                        </ul>
                    </li>

                    <br />

                    <li>
                         <strong>Milestone 9 - Administration (3 Tables)</strong>

                        <ul>
                            <li>AuditLogs</li>
                            <li>LoginHistory</li>
                            <li>EmployeeProfileRequests</li>
                        </ul>
                    </li>

                </ul>

                <hr />

            </div>

        </div>

    );
}

function App() {

    return (

        <BrowserRouter>

            <Routes>

                <Route
                    path="/login"
                    element={<LoginPage />}
                />

                <Route
                    path="/"
                    element={<Dashboard />}
                />

            </Routes>

        </BrowserRouter>

    );
}

const styles = {

    page: {

        minHeight: "100vh",
        background: "#f4f6f9",
        fontFamily: "Segoe UI"

    },

    header: {

        background: "#1565c0",
        color: "white",
        padding: "20px 40px",

        display: "flex",
        justifyContent: "space-between",
        alignItems: "center"

    },

    logout: {

        background: "#fff",
        color: "#1565c0",

        border: "none",
        padding: "10px 18px",

        borderRadius: "5px",
        cursor: "pointer"

    },

    card: {

        maxWidth: "1000px",

        margin: "40px auto",

        background: "#fff",

        padding: "30px",

        borderRadius: "10px",

        boxShadow: "0 8px 20px rgba(0,0,0,.1)"

    }

};

export default App;