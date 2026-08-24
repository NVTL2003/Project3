import api from "../api/client";

export const vehicleService = {
    getPaged: (params = {}, config = {}) =>
        api.get("/Vehicles/paged", {
            params,
            ...config
        }),

    getById: (id) =>
        api.get(`/Vehicles/${id}`),

    create: (data) =>
        api.post("/Vehicles", data),

    update: (id, data) =>
        api.put(`/Vehicles/${id}`, data),

    delete: (id) =>
        api.delete(`/Vehicles/${id}`)
};