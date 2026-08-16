import {
    BrowserRouter,
    Routes,
    Route,
    Navigate
} from "react-router-dom";

import LoginPage from "./pages/LoginPage";
import RegisterPage from "./pages/RegisterPage";
import FacilitiesPage from "./pages/FacilitiesPage";
import ProfilePage from "./pages/ProfilePage";
import ProtectedRoute from "./auth/ProtectedRoute";
import AppLayout from "./components/AppLayout";
import "./styles/app.css";
function Dashboard() {

    return (

        <div className="dashboard-page">

            <div className="page-header">

                <div>
                    <h1>Dashboard</h1>

                    <p>
                        Welcome to Enterprise Logistics
                        Management System.
                    </p>
                </div>

            </div>


            <div className="dashboard-card">

                <h2>Project Progress</h2>

                <p>
                    System infrastructure and modules.
                </p>

                {/* Your milestone information here */}

            </div>

        </div>

    );
}


function App() {

    return (

        <BrowserRouter>

            <Routes>

                {/* PUBLIC */}

                <Route
                    path="/login"
                    element={<LoginPage />}
                />

                <Route
                    path="/register"
                    element={<RegisterPage />}
                />


                {/* PROTECTED APPLICATION */}

                <Route
                    element={
                        <ProtectedRoute>
                            <AppLayout />
                        </ProtectedRoute>
                    }
                >

                    <Route
                        path="/"
                        element={<Dashboard />}
                    />

                    <Route
                        path="/facilities"
                        element={<FacilitiesPage />}
                    />

                    <Route
                        path="/profile"
                        element={<ProfilePage />}
                    />

                </Route>


                {/* FALLBACK */}

                <Route
                    path="*"
                    element={<Navigate to="/" replace />}
                />

            </Routes>

        </BrowserRouter>

    );
}

export default App;