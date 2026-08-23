import React from "react";
import { Link, useLocation } from "react-router-dom";

import { useNavigation } from "../../hooks/useNavigation";

const AppNavigation = () => {

    const location =
        useLocation();

    const { visibleGroups } =
        useNavigation();

    const isActive = path =>
        location.pathname === path;

    return (
        <nav className="app-navigation">

            <Link
                to="/"
                className={
                    `app-nav-link ${isActive("/")
                        ? "active"
                        : ""
                    }`
                }
            >
                Dashboard
            </Link>

            {visibleGroups.map(group => (

                <div
                    className="app-nav-dropdown"
                    key={group.key}
                >

                    <button
                        className="app-nav-dropdown-button"
                    >
                        {group.label}

                        <span className="app-nav-chevron">
                            ▾
                        </span>
                    </button>

                    <div className="app-nav-dropdown-menu">

                        <div className="app-nav-dropdown-title">
                            {group.label}
                        </div>

                        {group.entities.map(entity => (

                            <React.Fragment
                                key={entity.permission}
                            >

                                {entity.children ? (

                                    <>
                                        <div className="app-nav-dropdown-section">
                                            {entity.label}
                                        </div>

                                        {entity.children.map(
                                            child => (

                                                <Link
                                                    key={child.path}
                                                    to={child.path}
                                                    className={
                                                        `app-nav-dropdown-item ${isActive(child.path)
                                                            ? "active"
                                                            : ""
                                                        }`
                                                    }
                                                >

                                                    <span>
                                                        {child.label}
                                                    </span>

                                                    <span className="app-nav-item-arrow">
                                                        →
                                                    </span>

                                                </Link>

                                            )
                                        )}

                                    </>

                                ) : (

                                    <Link
                                        to={entity.path}
                                        className={
                                            `app-nav-dropdown-item ${isActive(entity.path)
                                                ? "active"
                                                : ""
                                            }`
                                        }
                                    >

                                        <span>
                                            {entity.label}
                                        </span>

                                        <span className="app-nav-item-arrow">
                                            →
                                        </span>

                                    </Link>

                                )}

                            </React.Fragment>

                        ))}

                    </div>

                </div>

            ))}

        </nav>
    );
};

export default AppNavigation;