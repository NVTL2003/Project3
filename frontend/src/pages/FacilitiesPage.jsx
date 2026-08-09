// import React from "react";
// import GenericEntityPage from "./GenericEntityPage";
// import facilityService from "../services/facilityService";

// const facilityFieldConfig = [
//     { name: "name", label: "Facility Name", required: true },
//     { name: "code", label: "Facility Code", required: false },
//     {
//         name: "facilityType",
//         label: "Facility Type",
//         type: "select",
//         required: true,
//         options: [
//             { value: "Branch", label: "Branch" },
//             { value: "DistributionCenter", label: "Distribution Center" }
//         ]
//     },
//     { name: "addressLine1", label: "Address Line 1", required: true },
//     { name: "addressLine2", label: "Address Line 2", required: false, nullable: true },
//     { name: "city", label: "City", required: true },
//     { name: "state", label: "State", required: true },
//     { name: "pincode", label: "Pincode", required: true },
//     { name: "country", label: "Country", required: false, defaultValue: "Country" },
//     { name: "phone", label: "Phone", required: false, nullable: true },
//     { name: "email", label: "Email", required: false, nullable: true },
//     { name: "isActive", label: "Active", type: "checkbox", required: false, defaultValue: true },
// ];

// const facilityDisplayColumns = [
//     { key: "code", label: "Code" },
//     { key: "name", label: "Name" },
//     { key: "facilityType", label: "Type" },
//     { key: "addressLine1", label: "Address" },
//     { key: "city", label: "City" },
//     { key: "state", label: "State" },
//     { key: "phone", label: "Phone" },
//     { key: "isActive", label: "Active" },
// ];

// const FacilitiesPage = () => {
//     return (
//         <GenericEntityPage
//             entityName="Facilities"
//             service={facilityService}
//             fieldConfig={facilityFieldConfig}
//             displayColumns={facilityDisplayColumns}
//         />
//     );
// };

// export default FacilitiesPage;

import React from "react";
import GenericEntityPage from "./GenericEntityPage";
import facilityService from "../services/facilityService";

const facilityFieldConfig = [
    { name: "id", type: "hidden" },
    { name: "name", label: "Facility Name", required: true },
    { name: "code", label: "Facility Code", required: false },
    {
        name: "facilityType",
        label: "Facility Type",
        type: "select",
        required: true,
        options: [
            { value: "Branch", label: "Branch" },
            { value: "DistributionCenter", label: "Distribution Center" }
        ]
    },
    { name: "addressLine1", label: "Address Line 1", required: true },
    { name: "addressLine2", label: "Address Line 2", required: false },
    { name: "city", label: "City", required: true },
    { name: "state", label: "State", required: true },
    { name: "pincode", label: "Pincode", required: true },
    { name: "country", label: "Country", required: false, defaultValue: "India" },
    { name: "phone", label: "Phone", required: false },
    { name: "email", label: "Email", required: false },
    { name: "isActive", label: "Active", type: "checkbox", required: false, defaultValue: true },
];

const facilityDisplayColumns = [
    { key: "code", label: "Code" },
    { key: "name", label: "Name" },
    { key: "facilityType", label: "Type" },
    { key: "city", label: "City" },
    { key: "state", label: "State" },
    { key: "phone", label: "Phone" },
    { key: "isActive", label: "Active" },
];

// Sort options
const sortOptions = [
    { value: "name", label: "Name" },
    { value: "code", label: "Code" },
    { value: "city", label: "City" },
    { value: "state", label: "State" },
    { value: "createdAt", label: "Created Date" }
];

// Filter options
const filterOptions = [
    {
        key: "facilityType",
        label: "Type",
        options: [
            { value: "Branch", label: "Branch" },
            { value: "DistributionCenter", label: "Distribution Center" }
        ]
    },
    {
        key: "isActive",
        label: "Status",
        options: [
            { value: "true", label: "Active" },
            { value: "false", label: "Inactive" }
        ]
    }
];

const FacilitiesPage = () => {
    return (
        <GenericEntityPage
            entityName="Facilities"
            service={facilityService}
            fieldConfig={facilityFieldConfig}
            displayColumns={facilityDisplayColumns}
            sortOptions={sortOptions}
            filterOptions={filterOptions}
        />
    );
};

export default FacilitiesPage;