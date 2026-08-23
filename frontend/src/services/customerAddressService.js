import client from "../api/client";

const getPaged = (params, config = {}) =>
    client.get("/CustomerAddresses/paged", {
        params,
        ...config
    });

const getMine = (config = {}) =>
    client.get("/CustomerAddresses/me", config);

const create = (data, config = {}) =>
    client.post("/CustomerAddresses", data, config);

const update = (id, data, config = {}) =>
    client.put(`/CustomerAddresses/${id}`, data, config);

const remove = (id, config = {}) =>
    client.delete(`/CustomerAddresses/${id}`, config);


const customerAddressService = {

    // Global/admin
    getPaged,
    create,
    update,
    delete: remove,

    // Customer
    me: {
        getPaged: getMine,
        create,
        update,
        delete: remove
    }

};

export default customerAddressService;