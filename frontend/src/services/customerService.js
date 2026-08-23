import client from "../api/client";

const getPaged = (params, config = {}) =>
    client.get("/Customers/paged", {
        params,
        ...config
    });

const getMine = (config = {}) =>
    client.get("/Customers/me", config);

const customerService = {
    getPaged,
    getMine,

    me: {
        getMine
    }
};

export default customerService;