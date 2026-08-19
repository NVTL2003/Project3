// import React from "react";
// import GenericEntityPage from "./GenericEntityPage";
// import customerAddressService from "../services/customerAddressService";

// const customerAddressFieldConfig = [
//     {
//         name: "id",
//         type: "hidden"
//     },
//     {
//         name: "addressLine1",
//         label: "Address Line 1",
//         required: true
//     },
//     {
//         name: "addressLine2",
//         label: "Address Line 2",
//         required: false
//     },
//     {
//         name: "city",
//         label: "City",
//         required: true
//     },
//     {
//         name: "state",
//         label: "State",
//         required: true
//     },
//     {
//         name: "pincode",
//         label: "Pincode",
//         required: true
//     },
//     {
//         name: "country",
//         label: "Country",
//         required: true,
//         defaultValue: "Vietnam"
//     },
//     {
//         name: "phone",
//         label: "Phone",
//         required: false
//     },
//     {
//         name: "isDefault",
//         label: "Default Address",
//         type: "checkbox",
//         required: false,
//         defaultValue: false
//     }
// ];

// const customerAddressDisplayColumns = [
//     {
//         key: "addressLine1",
//         label: "Address"
//     },
//     {
//         key: "city",
//         label: "City"
//     },
//     {
//         key: "state",
//         label: "State"
//     },
//     {
//         key: "pincode",
//         label: "Pincode"
//     },
//     {
//         key: "country",
//         label: "Country"
//     },
//     {
//         key: "phone",
//         label: "Phone"
//     },
//     {
//         key: "isDefault",
//         label: "Default"
//     }
// ];

// const customerAddressSortOptions = [
//     {
//         value: "city",
//         label: "City"
//     },
//     {
//         value: "state",
//         label: "State"
//     },
//     {
//         value: "pincode",
//         label: "Pincode"
//     },
//     {
//         value: "createdAt",
//         label: "Created Date"
//     }
// ];

// const CustomerAddressPage = ({
//     scope = "global"
// }) => {

//     const isMine = scope === "me";

//     const service = isMine
//         ? customerAddressService.me
//         : customerAddressService.global;

//     return (
//         <GenericEntityPage
//             entityName={
//                 isMine
//                     ? "My Addresses"
//                     : "Customer Addresses"
//             }

//             permissionPrefix={
//                 isMine
//                     ? null
//                     : "customer_addresses"
//             }

//             requirePermission={!isMine}

//             service={service}

//             fieldConfig={customerAddressFieldConfig}

//             displayColumns={customerAddressDisplayColumns}

//             sortOptions={customerAddressSortOptions}

//             filterOptions={[]}
//         />
//     );
// };

// export default CustomerAddressPage;
import React from "react";
import GenericEntityPage from "./GenericEntityPage";
import customerAddressService from "../services/customerAddressService";

const customerAddressFieldConfig = [
    { name: "id", type: "hidden" },
    { name: "addressType", label: "Address Type", required: true },
    { name: "recipientName", label: "Recipient Name", required: true },
    { name: "phone", label: "Phone", required: false },
    { name: "addressLine1", label: "Address Line 1", required: true },
    { name: "addressLine2", label: "Address Line 2", required: false },
    { name: "city", label: "City", required: true },
    { name: "state", label: "State", required: false },
    { name: "pincode", label: "Pincode", required: true },
    { name: "country", label: "Country", required: false, defaultValue: "India" },
    { name: "landmark", label: "Landmark", required: false },
    { name: "isDefault", label: "Default", type: "checkbox", required: false, defaultValue: false },
    { name: "isActive", label: "Active", type: "checkbox", required: false, defaultValue: true },
];

const customerAddressDisplayColumns = [
    { key: "recipientName", label: "Recipient" },
    { key: "addressType", label: "Type" },
    { key: "addressLine1", label: "Address" },
    { key: "city", label: "City" },
    { key: "pincode", label: "Pincode" },
    { key: "isDefault", label: "Default" },
];

const CustomerAddressPage = ({ scope = "me" }) => {
    // Use "me" service by default since that's what exists
    const service = customerAddressService.me;

    return (
        <GenericEntityPage
            entityName="My Addresses"
            permissionPrefix="customer_addresses"
            service={service}
            fieldConfig={customerAddressFieldConfig}
            displayColumns={customerAddressDisplayColumns}
        />
    );
};

export default CustomerAddressPage;