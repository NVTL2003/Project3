import api from "../api/client";

export const packageScanService = {
    getPaged: (params = {}, config = {}) =>
        api.get("/PackageScans/paged", {
            params,
            ...config
        }),

    getById: (id) =>
        api.get(`/PackageScans/${id}`),

    scan: (data) =>
        api.post("/PackageScans/scan", data),

    update: (id, data) =>
        api.put(`/PackageScans/${id}`, data),

    delete: (id) =>
        api.delete(`/PackageScans/${id}`)
};