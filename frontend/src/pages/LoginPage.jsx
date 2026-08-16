import { useState } from "react";
import { useNavigate } from "react-router-dom";
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
            const response =
                await authService.login(
                    username,
                    password
                );

            const data = response.data;

            console.log("Login response:", data);

            // ==========================================
            // TOKEN
            // ==========================================

            localStorage.setItem(
                "token",
                data.token
            );

            // ==========================================
            // USER
            // ==========================================

            if (data.user) {
                localStorage.setItem(
                    "user",
                    JSON.stringify(data.user)
                );
            }

            // ==========================================
            // ROLES
            // ==========================================

            if (data.user?.roles) {
                localStorage.setItem(
                    "roles",
                    JSON.stringify(data.user.roles)
                );
            } else {
                localStorage.setItem(
                    "roles",
                    JSON.stringify([])
                );
            }

            // ==========================================
            // PERMISSIONS
            // ==========================================

            if (data.user?.permissions) {
                localStorage.setItem(
                    "permissions",
                    JSON.stringify(data.user.permissions)
                );
            } else {
                localStorage.setItem(
                    "permissions",
                    JSON.stringify([])
                );
            }

            navigate("/");

        } catch (err) {

            console.error(
                "Login error:",
                err
            );

            setError(
                err.response?.data?.message ||
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
    }

};

export default LoginPage;