import {
    BrowserRouter,
    Routes,
    Route,
    Navigate
} from "react-router-dom";

import LoginPage from "./pages/LoginPage";
import RegisterPage from "./pages/RegisterPage";
import Dashboard from "./pages/Dashboard";
import FacilitiesPage from "./pages/FacilitiesPage";
import ProfilePage from "./pages/ProfilePage";

import CustomerAddressPage from "./pages/CustomerAddressPage";
import ShipmentRequestsPage from "./pages/ShipmentRequestsPage";
import ShipmentsPage from "./pages/ShipmentsPage";
import PackageScansPage from "./pages/PackageScansPage";
import RoutesPage from "./pages/RoutesPage";
import TransportOrdersPage from "./pages/TransportOrdersPage";

import ProtectedRoute from "./auth/ProtectedRoute";
import { AuthProvider } from "./auth/AuthContext";
import AppLayout from "./components/AppLayout";
import RouteDetailsPage from "./pages/RouteDetailsPage";
import "./styles/app.css";

function App() {

    return (
        <BrowserRouter>

            <AuthProvider>

                <Routes>

                    {/* ============================= */}
                    {/* PUBLIC */}
                    {/* ============================= */}

                    <Route
                        path="/login"
                        element={<LoginPage />}
                    />

                    <Route
                        path="/register"
                        element={<RegisterPage />}
                    />


                    {/* ============================= */}
                    {/* PROTECTED */}
                    {/* ============================= */}

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
                            path="/profile"
                            element={<ProfilePage />}
                        />

                        <Route
                            path="/facilities"
                            element={<FacilitiesPage />}
                        />


                        {/* CUSTOMER ADDRESSES */}

                        <Route
                            path="/customer-addresses"
                            element={
                                <CustomerAddressPage
                                    scope="global"
                                />
                            }
                        />

                        <Route
                            path="/my/customer-addresses"
                            element={
                                <CustomerAddressPage
                                    scope="me"
                                />
                            }
                        />


                        {/* SHIPMENT REQUESTS */}

                        <Route
                            path="/shipment-requests"
                            element={
                                <ShipmentRequestsPage
                                    scope="global"
                                />
                            }
                        />

                        <Route
                            path="/my/shipment-requests"
                            element={
                                <ShipmentRequestsPage
                                    scope="me"
                                />
                            }
                        />


                        {/* SHIPMENTS */}

                        <Route
                            path="/shipments"
                            element={<ShipmentsPage />}
                        />

                        <Route
                            path="/package-scans"
                            element={<PackageScansPage />}
                        />

                        <Route
                            path="/routes"
                            element={<RoutesPage />}
                        />

                        <Route
                            path="/routes/:id"
                            element={<RouteDetailsPage />}
                        />

                        <Route
                            path="/transport-orders"
                            element={<TransportOrdersPage />}
                        />


                    </Route>


                    {/* ============================= */}
                    {/* FALLBACK */}
                    {/* ============================= */}

                    <Route
                        path="*"
                        element={
                            <Navigate
                                to="/"
                                replace
                            />
                        }
                    />

                </Routes>

            </AuthProvider>

        </BrowserRouter>
    );
}

export default App;