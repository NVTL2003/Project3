import api from "../api/client";

const createResourceService = (basePath) => {

    const global = {

        getAll: () =>
            api.get(basePath),

        getPaged: (params = {}, config = {}) =>
            api.get(`${basePath}/paged`, {
                params,
                ...config
            }),

        getById: (id) =>
            api.get(`${basePath}/${id}`),

        create: (data) =>
            api.post(basePath, data),

        update: (id, data) =>
            api.put(`${basePath}/${id}`, data),

        remove: (id) =>
            api.delete(`${basePath}/${id}`)
    };


    const me = {

        getAll: () =>
            api.get(`${basePath}/me`),

        getPaged: (params = {}, config = {}) =>
            api.get(`${basePath}/me/paged`, {
                params,
                ...config
            }),

        getById: (id) =>
            api.get(`${basePath}/me/${id}`),

        create: (data) =>
            api.post(`${basePath}/me`, data),

        update: (id, data) =>
            api.put(`${basePath}/me/${id}`, data),

        remove: (id) =>
            api.delete(`${basePath}/me/${id}`)
    };


    return {
        ...global,
        me
    };
};

export default createResourceService;