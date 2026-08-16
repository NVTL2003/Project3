import React, { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import authService from "../services/authService";
import "../styles/register.css";

function RegisterPage() {

    const navigate = useNavigate();

    const [form, setForm] = useState({
        username: "",
        email: "",
        phone: "",
        password: "",
        confirmPassword: "",
        firstName: "",
        lastName: "",
        companyName: "",
        taxId: ""
    });

    const [loading, setLoading] = useState(false);
    const [error, setError] = useState("");
    const [success, setSuccess] = useState("");

    const handleChange = (e) => {

        const { name, value } = e.target;

        setForm(prev => ({
            ...prev,
            [name]: value
        }));
    };

    const handleSubmit = async (e) => {

        e.preventDefault();

        setError("");
        setSuccess("");

        // =============================
        // CLIENT VALIDATION
        // =============================

        if (
            !form.username.trim() ||
            !form.email.trim() ||
            !form.password ||
            !form.firstName.trim() ||
            !form.lastName.trim()
        ) {
            setError(
                "Please fill in all required fields."
            );

            return;
        }

        if (form.password.length < 6) {

            setError(
                "Password must be at least 6 characters."
            );

            return;
        }

        if (form.password !== form.confirmPassword) {

            setError(
                "Passwords do not match."
            );

            return;
        }

        try {

            setLoading(true);

            // =============================
            // REGISTER
            // =============================

            const response =
                await authService.register({

                    username: form.username.trim(),

                    email: form.email.trim(),

                    phone:
                        form.phone.trim() ||
                        null,

                    password:
                        form.password,

                    firstName:
                        form.firstName.trim(),

                    lastName:
                        form.lastName.trim(),

                    companyName:
                        form.companyName.trim() ||
                        null,

                    taxId:
                        form.taxId.trim() ||
                        null

                });

            console.log(
                "========== REGISTER RESPONSE =========="
            );

            console.log(response);

            console.log(
                "STATUS:",
                response.status
            );

            console.log(
                "DATA:",
                response.data
            );

            console.log(
                "=======================================");

            setSuccess(
                "Account created successfully! Redirecting to login..."
            );

            // Give the user a moment to see success message
            setTimeout(() => {

                navigate("/login", {
                    replace: true
                });

            }, 1500);

        }
        catch (err) {

            console.error(
                "========== REGISTER ERROR =========="
            );

            console.error(err);

            console.error(
                "Response:",
                err.response
            );

            console.error(
                "Response data:",
                err.response?.data
            );

            console.error(
                "===================================="
            );

            setError(
                err.response?.data?.message ||
                err.response?.data?.title ||
                err.message ||
                "Unable to create account."
            );

        }
        finally {

            setLoading(false);

        }
    };

    return (

        <div className="register-page">

            <div className="register-card">

                {/* ============================= */}
                {/* HEADER */}
                {/* ============================= */}

                <div className="register-header">

                    <div className="register-logo">
                        EL
                    </div>

                    <div>

                        <h1>
                            Create Customer Account
                        </h1>

                        <p>
                            Enterprise Logistics Management
                        </p>

                    </div>

                </div>


                {/* ============================= */}
                {/* INTRO */}
                {/* ============================= */}

                <div className="register-intro">

                    <h2>
                        Welcome to ELMS
                    </h2>

                    <p>
                        Create an account to manage your
                        shipments and track deliveries.
                    </p>

                </div>


                {/* ============================= */}
                {/* ERROR */}
                {/* ============================= */}

                {error && (

                    <div className="register-alert error">
                        {error}
                    </div>

                )}


                {/* ============================= */}
                {/* SUCCESS */}
                {/* ============================= */}

                {success && (

                    <div className="register-alert success">
                        {success}
                    </div>

                )}


                <form onSubmit={handleSubmit}>

                    {/* ============================= */}
                    {/* ACCOUNT INFORMATION */}
                    {/* ============================= */}

                    <section className="register-section">

                        <div className="section-title">

                            <span className="section-icon">
                                🔐
                            </span>

                            <div>

                                <h3>
                                    Account Information
                                </h3>

                                <p>
                                    Your login credentials
                                </p>

                            </div>

                        </div>


                        <div className="form-grid">

                            <div className="form-group">

                                <label>
                                    Username
                                    <span>*</span>
                                </label>

                                <input
                                    type="text"
                                    name="username"
                                    value={form.username}
                                    onChange={handleChange}
                                    placeholder="Choose a username"
                                    autoComplete="username"
                                    required
                                />

                            </div>


                            <div className="form-group">

                                <label>
                                    Email
                                    <span>*</span>
                                </label>

                                <input
                                    type="email"
                                    name="email"
                                    value={form.email}
                                    onChange={handleChange}
                                    placeholder="your@email.com"
                                    autoComplete="email"
                                    required
                                />

                            </div>


                            <div className="form-group">

                                <label>
                                    Phone
                                </label>

                                <input
                                    type="tel"
                                    name="phone"
                                    value={form.phone}
                                    onChange={handleChange}
                                    placeholder="Phone number"
                                    autoComplete="tel"
                                />

                            </div>


                            <div className="form-group">

                                <label>
                                    Password
                                    <span>*</span>
                                </label>

                                <input
                                    type="password"
                                    name="password"
                                    value={form.password}
                                    onChange={handleChange}
                                    placeholder="Create a password"
                                    autoComplete="new-password"
                                    required
                                />

                            </div>


                            <div className="form-group">

                                <label>
                                    Confirm Password
                                    <span>*</span>
                                </label>

                                <input
                                    type="password"
                                    name="confirmPassword"
                                    value={form.confirmPassword}
                                    onChange={handleChange}
                                    placeholder="Confirm your password"
                                    autoComplete="new-password"
                                    required
                                />

                            </div>

                        </div>

                    </section>


                    {/* ============================= */}
                    {/* CUSTOMER INFORMATION */}
                    {/* ============================= */}

                    <section className="register-section">

                        <div className="section-title">

                            <span className="section-icon">
                                👤
                            </span>

                            <div>

                                <h3>
                                    Customer Information
                                </h3>

                                <p>
                                    Tell us about yourself
                                </p>

                            </div>

                        </div>


                        <div className="form-grid">

                            <div className="form-group">

                                <label>
                                    First Name
                                    <span>*</span>
                                </label>

                                <input
                                    type="text"
                                    name="firstName"
                                    value={form.firstName}
                                    onChange={handleChange}
                                    placeholder="First name"
                                    required
                                />

                            </div>


                            <div className="form-group">

                                <label>
                                    Last Name
                                    <span>*</span>
                                </label>

                                <input
                                    type="text"
                                    name="lastName"
                                    value={form.lastName}
                                    onChange={handleChange}
                                    placeholder="Last name"
                                    required
                                />

                            </div>


                            <div className="form-group">

                                <label>
                                    Company Name
                                </label>

                                <input
                                    type="text"
                                    name="companyName"
                                    value={form.companyName}
                                    onChange={handleChange}
                                    placeholder="Company name"
                                />

                            </div>


                            <div className="form-group">

                                <label>
                                    Tax ID
                                </label>

                                <input
                                    type="text"
                                    name="taxId"
                                    value={form.taxId}
                                    onChange={handleChange}
                                    placeholder="Tax identification number"
                                />

                            </div>

                        </div>

                    </section>


                    {/* ============================= */}
                    {/* ACTIONS */}
                    {/* ============================= */}

                    <div className="register-actions">

                        <button
                            type="submit"
                            className="register-button"
                            disabled={loading}
                        >

                            {loading
                                ? "Creating Account..."
                                : "Create Account"}

                        </button>


                        <Link
                            to="/login"
                            className="back-login"
                        >
                            Already have an account?
                            <strong>
                                {" "}Sign in
                            </strong>
                        </Link>

                    </div>

                </form>

            </div>

        </div>
    );
}

export default RegisterPage;