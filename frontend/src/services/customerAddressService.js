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

// const customerAddressService = {
//     global: createResourceService(
//         "/customer-addresses"
//     ),

//     me: createResourceService(
//         "/customer-addresses/me",
//         {
//             pagedPath: "/paged"
//         }
//     )
// };
const customerAddressService =
    createResourceService("/customer-addresses");


export default customerAddressService;