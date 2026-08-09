import api from "../api/client";

const authService = {
    login: (username, password) => {
        return api.post("/auth/login", {
            username,
            password
        });
    }
};

export default authService;