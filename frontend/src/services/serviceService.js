import client from "../api/client";

const getPaged = (params, config = {}) =>
    client.get("/Services/paged", {
        params,
        ...config
    });

const serviceService = {
    getPaged
};

export default serviceService;