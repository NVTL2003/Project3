import React, {
    useEffect,
    useState
} from "react";

import {
    Link,
    useNavigate
} from "react-router-dom";

import meService from "../api/meService";

import AppNavigation from "./navigation/AppNavigation";

import "../styles/app-header.css";


function AppHeader() {

    const navigate = useNavigate();

    const [user, setUser] =
        useState(null);

    const [loading, setLoading] =
        useState(true);


    /*
     * Load current user
     */
    useEffect(() => {

        let mounted = true;

        const loadUser = async () => {

            try {

                const response =
                    await meService.getMe();

                if (!mounted) {
                    return;
                }

                const userData =
                    response?.data ?? response;

                console.log(
                    "👤 Header user:",
                    userData
                );

                setUser(userData);

            } catch (error) {

                console.error(
                    "Failed to load header user:",
                    error
                );

            } finally {

                if (mounted) {
                    setLoading(false);
                }

            }

        };

        loadUser();

        return () => {
            mounted = false;
        };

    }, []);


    /*
     * Logout
     */
    const logout = () => {

        localStorage.removeItem("token");
        localStorage.removeItem("user");
        localStorage.removeItem("roles");
        localStorage.removeItem("permissions");

        window.location.href = "/login";
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

                    <div className="app-brand-text">

                        <div className="app-brand-title">
                            ELMS
                        </div>

                        <div className="app-brand-subtitle">
                            Logistics Management
                        </div>

                    </div>

                </Link>


                {/* NAVIGATION */}

                {!loading && (
                    <AppNavigation />
                )}


                {/* USER */}

                <div className="app-header-user">

                    <button
                        className="app-user-button"
                        onClick={() =>
                            navigate("/profile")
                        }
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