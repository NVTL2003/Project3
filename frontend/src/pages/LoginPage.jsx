import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import authService from "../services/authService";

function LoginPage() {
    const navigate = useNavigate();

    const [username, setUsername] = useState("");
    const [password, setPassword] = useState("");

    const [loading, setLoading] = useState(false);
    const [error, setError] = useState("");

    const handleLogin = async (e) => {
        e.preventDefault();

        setLoading(true);
        setError("");

        try {
            const response = await authService.login(
                username,
                password
            );

            console.log("========== LOGIN RESPONSE ==========");
            console.log(response);
            console.log("STATUS:", response.status);
            console.log("DATA:", response.data);
            console.log("TOKEN:", response.data?.token);
            console.log("USER:", response.data?.user);
            console.log("====================================");

            const data = response.data;

            if (!data) {
                throw new Error("Backend returned no response data.");
            }

            if (!data.token) {
                throw new Error("Backend returned no JWT token.");
            }

            // Store token
            localStorage.setItem("token", data.token);

            // Store user
            if (data.user) {
                localStorage.setItem(
                    "user",
                    JSON.stringify(data.user)
                );
            }

            // Store roles
            localStorage.setItem(
                "roles",
                JSON.stringify(data.user?.roles || [])
            );

            // Store permissions
            localStorage.setItem(
                "permissions",
                JSON.stringify(data.user?.permissions || [])
            );

            console.log("========== LOCAL STORAGE ==========");
            console.log("token:", localStorage.getItem("token"));
            console.log("user:", localStorage.getItem("user"));
            console.log("roles:", localStorage.getItem("roles"));
            console.log(
                "permissions:",
                localStorage.getItem("permissions")
            );
            console.log("===================================");

            navigate("/", { replace: true });

        } catch (err) {

            console.error("========== LOGIN ERROR ==========");
            console.error(err);
            console.error("Response:", err.response);
            console.error("Response data:", err.response?.data);
            console.error("=================================");

            setError(
                err.response?.data?.message ||
                err.message ||
                "Login failed."
            );

        } finally {

            setLoading(false);

        }
    };

    return (
        <div style={styles.page}>

            <div style={styles.card}>

                <h1 style={styles.title}>
                    ELMS
                </h1>

                <p style={styles.subtitle}>
                    Enterprise Logistics Management System
                </p>

                <form onSubmit={handleLogin}>

                    <div style={styles.group}>
                        <label>Username</label>

                        <input
                            style={styles.input}
                            type="text"
                            value={username}
                            onChange={(e) => setUsername(e.target.value)}
                            placeholder="Enter username"
                            required
                        />
                    </div>

                    <div style={styles.group}>
                        <label>Password</label>

                        <input
                            style={styles.input}
                            type="password"
                            value={password}
                            onChange={(e) => setPassword(e.target.value)}
                            placeholder="Enter password"
                            required
                        />
                    </div>

                    {error && (
                        <div style={styles.error}>
                            {error}
                        </div>
                    )}

                    <button
                        type="submit"
                        style={styles.button}
                        disabled={loading}
                    >
                        {loading ? "Signing In..." : "Sign In"}
                    </button>
                    <div style={styles.registerLink}>
                        <span>Don't have an account?</span>

                        <Link to="/register">
                            Create a customer account
                        </Link>
                    </div>
                </form>

            </div>

        </div>
    );
}

const styles = {

    page: {
        height: "100vh",
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
        background: "#f4f6f9",
        fontFamily: "Segoe UI"
    },

    card: {
        width: "400px",
        background: "#fff",
        borderRadius: "10px",
        padding: "35px",
        boxShadow: "0 10px 30px rgba(0,0,0,.15)"
    },

    title: {
        margin: 0,
        textAlign: "center",
        color: "#1565c0"
    },

    subtitle: {
        textAlign: "center",
        marginBottom: "30px",
        color: "#666"
    },

    group: {
        display: "flex",
        flexDirection: "column",
        marginBottom: "18px"
    },

    input: {
        marginTop: "6px",
        padding: "12px",
        fontSize: "15px",
        border: "1px solid #ccc",
        borderRadius: "6px"
    },

    button: {
        width: "100%",
        padding: "12px",
        border: "none",
        borderRadius: "6px",
        background: "#1565c0",
        color: "#fff",
        fontSize: "16px",
        cursor: "pointer"
    },

    error: {
        background: "#ffebee",
        color: "#d32f2f",
        padding: "10px",
        marginBottom: "15px",
        borderRadius: "5px"
    },
    registerLink: {
        marginTop: "20px",
        textAlign: "center",
        display: "flex",
        justifyContent: "center",
        gap: "6px",
        fontSize: "14px",
        color: "#666"
    }
};

export default LoginPage;