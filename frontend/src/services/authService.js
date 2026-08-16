import api from "../api/client";

const authService = {
    login: (usernameOrEmail, password) => {
        return api.post("/auth/login", {
            usernameOrEmail,
            password
        });
    }
};

export default authService;