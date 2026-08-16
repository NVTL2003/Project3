// frontend/src/App.js
import {
    BrowserRouter,
    Routes,
    Route,
    Navigate,
    Link          // added for SPA navigation
} from "react-router-dom";

import LoginPage from "./pages/LoginPage";
import FacilitiesPage from "./pages/FacilitiesPage";   // new
import ProtectedRoute from "./auth/ProtectedRoute";    // new

function Dashboard() {
    const token = localStorage.getItem("token");

    if (!token) {
        return <Navigate to="/login" replace />;
    }

    const logout = () => {
        localStorage.removeItem("token");
        localStorage.removeItem("user");
        localStorage.removeItem("roles");
        localStorage.removeItem("permissions");

        window.location.href = "/login";
    };

    return (
        <div style={styles.page}>
            <div style={styles.header}>
                <h2>Enterprise Logistics Management System</h2>
                <div style={{ display: "flex", gap: "20px", alignItems: "center" }}>
                    <Link to="/" style={{ color: "white", textDecoration: "none" }}>
                        Dashboard
                    </Link>
                    <Link to="/facilities" style={{ color: "white", textDecoration: "none" }}>
                        Facilities
                    </Link>
                    {/* Add more links later */}
                    <button style={styles.logout} onClick={logout}>
                        Logout
                    </button>
                </div>
            </div>

            <div style={styles.card}>
                <h1>Dashboard</h1>
                <p>Welcome to ELMS.</p>
                <p>Authentication successful.</p>
                <hr />
                <h3>Milestone 1</h3>
                <h2>Project Progress</h2>
                <ul>
                    <li><strong>Milestone 0 - Infrastructure</strong>
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
                    <li><strong>Milestone 1 - Identity (9 Tables)</strong>
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
                    <li><strong>Milestone 2 - Company Setup (6 Tables)</strong>
                        <ul>
                            <li>Facilities</li>
                            <li>Pincodes</li>
                            <li>StorageAreas</li>
                            <li>Services</li>
                            <li>PricingRules</li>
                            <li>InsurancePlans</li>
                        </ul>
                    </li>
                    {/* ... rest of milestones ... */}
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
                <Route path="/login" element={<LoginPage />} />
                <Route
                    path="/"
                    element={
                        <ProtectedRoute>
                            <Dashboard />
                        </ProtectedRoute>
                    }
                />
                <Route
                    path="/facilities"
                    element={
                        <ProtectedRoute>
                            <FacilitiesPage />
                        </ProtectedRoute>
                    }
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