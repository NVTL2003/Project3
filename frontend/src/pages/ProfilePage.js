import React, { useEffect, useState } from "react";
import meService from "../api/meService";

function ProfilePage() {

    const [user, setUser] = useState(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {

        const loadProfile = async () => {

            try {

                const response =
                    await meService.getMe();

                setUser(
                    response.data ?? response
                );

            } catch (error) {

                console.error(
                    "Failed to load profile:",
                    error
                );

            } finally {

                setLoading(false);

            }

        };

        loadProfile();

    }, []);


    if (loading) {

        return (
            <div className="profile-page">

                <div className="profile-loading">
                    Loading profile...
                </div>

            </div>
        );

    }


    if (!user) {

        return (
            <div className="profile-page">

                <div className="profile-error">
                    Unable to load profile.
                </div>

            </div>
        );

    }


    return (

        <div className="profile-page">

            <div className="page-header">

                <div>

                    <h1>My Profile</h1>

                    <p>
                        View your account information
                        and permissions.
                    </p>

                </div>

            </div>


            <div className="profile-grid">

                {/* PROFILE CARD */}

                <div className="profile-card">

                    <div className="profile-card-header">

                        <div className="profile-avatar">

                            {user.username
                                ?.charAt(0)
                                .toUpperCase()}

                        </div>

                        <div>

                            <h2>
                                {user.username}
                            </h2>

                            <span className="profile-status">
                                Active
                            </span>

                        </div>

                    </div>


                    <div className="profile-divider" />


                    <div className="profile-details">

                        <ProfileField
                            label="Username"
                            value={user.username}
                        />

                        <ProfileField
                            label="Email"
                            value={user.email}
                        />

                        <ProfileField
                            label="Phone"
                            value={user.phone}
                        />

                        <ProfileField
                            label="User ID"
                            value={user.id}
                        />

                    </div>

                </div>


                {/* ACCESS CARD */}

                <div className="profile-card">

                    <div className="profile-section-title">
                        Access
                    </div>

                    <div className="profile-section-subtitle">
                        Roles assigned to your account.
                    </div>


                    <div className="profile-tags">

                        {user.roles?.map(role => (

                            <span
                                key={role}
                                className="profile-role"
                            >
                                {role}
                            </span>

                        ))}

                    </div>


                    <div className="profile-divider" />


                    <div className="profile-section-title">
                        Permissions
                    </div>

                    <div className="profile-section-subtitle">
                        Permissions granted through your roles.
                    </div>


                    <div className="profile-permissions">

                        {user.permissions?.length > 0
                            ? user.permissions.map(permission => (

                                <span
                                    key={permission}
                                    className="profile-permission"
                                >
                                    {permission}
                                </span>

                            ))
                            : (
                                <span className="profile-empty">
                                    No permissions assigned.
                                </span>
                            )}

                    </div>

                </div>

            </div>

        </div>

    );
}


function ProfileField({ label, value }) {

    return (

        <div className="profile-field">

            <div className="profile-field-label">
                {label}
            </div>

            <div className="profile-field-value">
                {value || "Not provided"}
            </div>

        </div>

    );

}


export default ProfilePage;