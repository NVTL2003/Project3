import api from "../api/client";

const authService = {

    login: (usernameOrEmail, password) => {
        return api.post("/auth/login", {
            usernameOrEmail,
            password
        });
    },

    register: (registerData) => {
        return api.post("/auth/register", registerData);
    }

};

export default authService;