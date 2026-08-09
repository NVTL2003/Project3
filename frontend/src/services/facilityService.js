// import api from "../api/client";

// const facilityService = {
//     getAll: () => api.get("/facility"),
//     getById: (id) => api.get(`/facility/${id}`),
//     create: (data) => api.post("/facility", data),
//     update: (id, data) => api.put(`/facility/${id}`, data),
//     delete: (id) => api.delete(`/facility/${id}`),
// };

// export default facilityService;

import api from "../api/client";

const facilityService = {
    getAll: () => api.get("/facility"),
    getPaged: (params, config = {}) => {
        const queryParams = new URLSearchParams();

        if (params.search) queryParams.append('search', params.search);
        if (params.sortBy) queryParams.append('sortBy', params.sortBy);
        if (params.sortOrder) queryParams.append('sortOrder', params.sortOrder);
        if (params.page) queryParams.append('page', params.page);
        if (params.pageSize) queryParams.append('pageSize', params.pageSize);

        // Handle filters properly
        if (params.filters) {
            Object.entries(params.filters).forEach(([key, value]) => {
                if (value) {
                    // Send as filters[key]=value format
                    queryParams.append(`filters[${key}]`, value);
                }
            });
        }

        const url = `/facility/paged?${queryParams.toString()}`;
        console.log('Request URL:', url);

        return api.get(url, {
            ...config,
            signal: config?.signal
        });
    },
    getById: (id) => api.get(`/facility/${id}`),
    create: (data) => api.post("/facility", data),
    update: (id, data) => api.put(`/facility/${id}`, data),
    delete: (id) => api.delete(`/facility/${id}`),
};

export default facilityService;