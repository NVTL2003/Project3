import React, {
    createContext,
    useContext,
    useEffect,
    useState
} from "react";

import meService from "../api/meService";

const AuthContext = createContext(null);

export const AuthProvider = ({ children }) => {

    const [user, setUser] = useState(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {

        const token = localStorage.getItem("token");

        if (!token) {
            setLoading(false);
            return;
        }

        meService.getMe()
            .then(response => {
                setUser(response);
            })
            .catch(error => {

                console.error(
                    "Failed to load current user:",
                    error
                );

                localStorage.removeItem("token");
                localStorage.removeItem("user");
                localStorage.removeItem("roles");
                localStorage.removeItem("permissions");

                setUser(null);
            })
            .finally(() => {
                setLoading(false);
            });

    }, []);

    const logout = () => {

        localStorage.removeItem("token");
        localStorage.removeItem("user");
        localStorage.removeItem("roles");
        localStorage.removeItem("permissions");

        setUser(null);

        window.location.href = "/login";
    };

    return (
        <AuthContext.Provider
            value={{
                user,
                loading,
                logout
            }}
        >
            {children}
        </AuthContext.Provider>
    );
};

export const useAuth = () => {

    const context = useContext(AuthContext);

    if (!context) {
        throw new Error(
            "useAuth must be used inside AuthProvider"
        );
    }

    return context;
};