// import createResourceService from "./genericResourceService";

// const customerAddressService = {
//     global: createResourceService(
//         "/customer-addresses"
//     ),

//     me: createResourceService(
//         "/me/customer-addresses",
//         {
//             pagedPath: ""
//         }
//     )
// };

// export default customerAddressService;

import createResourceService from "./genericResourceService";

const customerAddressService = {
    global: createResourceService("/customer-addresses"),
    me: createResourceService("/me/customer-addresses", {
        pagedPath: "" // The me endpoints don't use /paged
    })
};

export default customerAddressService;