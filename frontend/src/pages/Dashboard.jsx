import React from "react";

const Dashboard = () => {
    return (
        <div className="dashboard-page">

            <div className="dashboard-card">

                <h1>Dashboard</h1>

                <p>Welcome to ELMS.</p>

                <p>
                    Authentication successful.
                </p>

                <hr />

                <h3>Milestone 1</h3>

                <h2>Project Progress</h2>

                <ul>
                    <li>
                        <strong>
                            Milestone 0 - Infrastructure
                        </strong>

                        <ul>
                            <li>Database Generated (43 Tables)</li>
                            <li>EF Core</li>
                            <li>DbContext</li>
                            <li>Generic CRUD Service</li>
                            <li>Generic Controller</li>
                            <li>DTO Structure</li>
                            <li>React Login</li>
                            <li>JWT Login</li>
                            <li>Repository Pattern</li>
                            <li>Validation</li>
                            <li>Logging</li>
                            <li>Global Exception Handling</li>
                        </ul>
                    </li>

                    <br />

                    <li>
                        <strong>
                            Milestone 1 - Identity
                        </strong>

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
                        <strong>
                            Milestone 2 - Company Setup
                        </strong>

                        <ul>
                            <li>Facilities</li>
                            <li>Pincodes</li>
                            <li>StorageAreas</li>
                            <li>Services</li>
                            <li>PricingRules</li>
                            <li>InsurancePlans</li>
                        </ul>
                    </li>
                </ul>

            </div>

        </div>
    );
};

export default Dashboard;