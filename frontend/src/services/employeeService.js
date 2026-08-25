import api from "../api/client";

export const employeeService = {
    getPaged: (params) =>
        api.get("/Employees", { params }),

    getById: (id) =>
        api.get(`/Employees/${id}`),

    create: (data) =>
        api.post("/Employees", data),

    update: (id, data) =>
        api.put(`/Employees/${id}`, data),

    delete: (id) =>
        api.delete(`/Employees/${id}`)
};