// import React from "react";
// import GenericEntityPage from "./GenericEntityPage";
// import pincodeService from "../services/pincodeService";

// const pincodeFieldConfig = [
//     { name: "code", label: "Pincode Code", required: true },
//     { name: "city", label: "City", required: true },
//     { name: "state", label: "State", required: true },
//     { name: "country", label: "Country", required: false, defaultValue: "India" },
//     { name: "latitude", label: "Latitude", type: "number", required: false },
//     { name: "longitude", label: "Longitude", type: "number", required: false },
//     { name: "facilityId", label: "Facility", type: "select", required: false, options: [] }, Options loaded dynamically
//     { name: "serviceable", label: "Serviceable", type: "checkbox", required: false, defaultValue: true },
// ];

// const pincodeDisplayColumns = [
//     { key: "code", label: "Code" },
//     { key: "city", label: "City" },
//     { key: "state", label: "State" },
//     { key: "serviceable", label: "Serviceable" }, Auto-rendered as Yes/No
// ];

// const PincodesPage = () => {
//     Fetch facilities for dropdown
//     const fetchExtraData = async () => {
//         const facilities = await facilityService.getAll();
//         return {
//             facilityId: facilities.data.map(f => ({ value: f.id, label: f.name }))
//         };
//     };

//     return (
//         <GenericEntityPage
//             entityName="Pincodes"
//             service={pincodeService}
//             fieldConfig={pincodeFieldConfig}
//             displayColumns={pincodeDisplayColumns}
//             fetchExtraData={fetchExtraData}
//         />
//     );
// };

// export default PincodesPage;