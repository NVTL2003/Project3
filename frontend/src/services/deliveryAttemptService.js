// import createResourceService from "./genericResourceService";

// const deliveryAttemptService =
//     createResourceService("/DeliveryAttempts");

// export default deliveryAttemptService;


import createResourceService from "./genericResourceService";

const baseService =
    createResourceService("/DeliveryAttempts");

const deliveryAttemptService = {
    ...baseService,

    createAttempt: (data) =>
        baseService.create(data)
};

export default deliveryAttemptService;
