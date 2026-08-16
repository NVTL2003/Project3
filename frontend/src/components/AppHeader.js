import React, { useEffect, useState } from "react";
import { Link, useNavigate, useLocation } from "react-router-dom";
import meService from "../api/meService";

function AppHeader() {

    const navigate = useNavigate();
    const location = useLocation();

    const [user, setUser] = useState(null);

    useEffect(() => {

        const loadUser = async () => {

            try {

                const response =
                    await meService.getMe();

                setUser(response.data ?? response);

            } catch (error) {

                console.error(
                    "Failed to load header user:",
                    error
                );

            }

        };

        loadUser();

    }, []);

    const logout = () => {

        localStorage.removeItem("token");
        localStorage.removeItem("user");
        localStorage.removeItem("roles");
        localStorage.removeItem("permissions");

        window.location.href = "/login";
    };

    const isActive = (path) => {

        return location.pathname === path
            ? "app-nav-link active"
            : "app-nav-link";

    };

    const primaryRole =
        user?.roles?.[0] ||
        "User";

    const displayName =
        user?.username ||
        "User";

    return (

        <header className="app-header">

            <div className="app-header-inner">

                {/* BRAND */}

                <Link
                    to="/"
                    className="app-brand"
                >

                    <div className="app-brand-icon">
                        EL
                    </div>

                    <div>
                        <div className="app-brand-title">
                            ELMS
                        </div>

                        <div className="app-brand-subtitle">
                            Logistics Management
                        </div>
                    </div>

                </Link>


                {/* NAVIGATION */}

                <nav className="app-navigation">

                    <Link
                        to="/"
                        className={isActive("/")}
                    >
                        Dashboard
                    </Link>

                    <Link
                        to="/facilities"
                        className={isActive("/facilities")}
                    >
                        Facilities
                    </Link>

                </nav>


                {/* USER */}

                <div className="app-header-user">

                    <button
                        className="app-user-button"
                        onClick={() => navigate("/profile")}
                    >

                        <div className="app-user-avatar">
                            {displayName
                                .charAt(0)
                                .toUpperCase()}
                        </div>

                        <div className="app-user-info">

                            <div className="app-user-name">
                                {displayName}
                            </div>

                            <div className="app-user-role">
                                {primaryRole}
                            </div>

                        </div>

                        <span className="app-user-arrow">
                            ›
                        </span>

                    </button>


                    <button
                        className="app-logout-button"
                        onClick={logout}
                    >
                        Logout
                    </button>

                </div>

            </div>

        </header>

    );
}

export default AppHeader;