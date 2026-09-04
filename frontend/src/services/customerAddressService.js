import client from "../api/client";

// =========================================================
// GLOBAL
// =========================================================

const getPaged = (params, config = {}) =>
    client.get("/CustomerAddresses/paged", {
        params,
        ...config
    });

const getById = (id, config = {}) =>
    client.get(`/CustomerAddresses/${ id } `, config);

const create = (data, config = {}) =>
    client.post("/CustomerAddresses", data, config);

const update = (id, data, config = {}) =>
    client.put(`/CustomerAddresses/${ id } `, data, config);

const remove = (id, config = {}) =>
    client.delete(`/CustomerAddresses/${ id } `, config);

// =========================================================
// MINE
// =========================================================

const getMine = (config = {}) =>
    client.get("/CustomerAddresses/me", config);

const getMinePaged = (params, config = {}) =>
    client.get("/CustomerAddresses/me/paged", {
        params,
        ...config
    });

const getMineById = (id, config = {}) =>
    client.get(`/CustomerAddresses/me/ ${ id } `, config);

const createMine = (data, config = {}) =>
    client.post("/CustomerAddresses/me", data, config);

const updateMine = (id, data, config = {}) =>
    client.put(`/CustomerAddresses/me/${ id } `, data, config);

const removeMine = (id, config = {}) =>
    client.delete(`/CustomerAddresses/me/${ id } `, config);

// =========================================================
// SERVICE EXPORT
// =========================================================

const customerAddressService = {

    // Global
    getPaged,
    getById,
    create,
    update,
    delete: remove,

    // Mine
    getMine,
    getMinePaged,
    getMineById,
    createMine,
    updateMine,
    deleteMine: removeMine,

    // Nested mine API
    me: {
        getAll: getMine,
        getPaged: getMinePaged,
        getById: getMineById,
        create: createMine,
        update: updateMine,
        delete: removeMine
    }
};

export default customerAddressService;