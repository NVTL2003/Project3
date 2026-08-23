import client from "../api/client";

const getPaged = (params, config = {}) =>
    client.get("/InsurancePlans/paged", {
        params,
        ...config
    });

const getMine = (config = {}) =>
    client.get("/InsurancePlans/me", config);

const create = (data, config = {}) =>
    client.post("/InsurancePlans", data, config);

const update = (id, data, config = {}) =>
    client.put(`/InsurancePlans/${id}`, data, config);

const remove = (id, config = {}) =>
    client.delete(`/InsurancePlans/${id}`, config);

const insurancePlanService = {
    getPaged,
    getMine,
    create,
    update,
    delete: remove,

    me: {
        getMine
    }
};

export default insurancePlanService;