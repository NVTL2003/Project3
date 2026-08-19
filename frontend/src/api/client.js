//C:\Users\Admin\Desktop\Project3\frontend\src\api\client.js

import axios from "axios";

const api = axios.create({
    baseURL: "http://localhost:5047/api"
});

api.interceptors.request.use(
    (config) => {

        const token =
            localStorage.getItem("token");

        if (token) {

            config.headers.Authorization =
                `Bearer ${token}`;

        }

        return config;
    },

    (error) =>
        Promise.reject(error)
);

api.interceptors.response.use(

    (response) => response,

    (error) => {

        if (error.response?.status === 401) {

            console.warn(
                "JWT expired or authentication failed."
            );

            localStorage.removeItem("token");
            localStorage.removeItem("user");
            localStorage.removeItem("roles");
            localStorage.removeItem("permissions");

            window.location.href =
                "/login";
        }

        return Promise.reject(error);
    }
);

export default api;