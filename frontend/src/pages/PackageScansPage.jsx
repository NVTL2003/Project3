// import React from "react";
// import GenericEntityPage from "./GenericEntityPage";
// import { packageScanService } from "../services/shipmentService";

// const packageScanFieldConfig = [
//     { name: "id", type: "hidden" },
//     { name: "shipmentId", label: "Shipment ID", required: true },
//     {
//         name: "locationType",
//         label: "Location Type",
//         type: "select",
//         required: true,
//         options: [
//             { value: "branch", label: "Branch" },
//             { value: "distribution_center", label: "Distribution Center" },
//             { value: "vehicle", label: "Vehicle" }
//         ]
//     },
//     { name: "facilityId", label: "Facility ID", required: false },
//     { name: "vehicleId", label: "Vehicle ID", required: false },
//     {
//         name: "scanType",
//         label: "Scan Type",
//         type: "select",
//         required: true,
//         options: [
//             { value: "pickup", label: "Pickup" },
//             { value: "sorting", label: "Sorting" },
//             { value: "loaded", label: "Loaded" },
//             { value: "out_for_delivery", label: "Out for Delivery" },
//             { value: "delivered", label: "Delivered" }
//         ]
//     },
// Remove latitude and longitude for now
//     { name: "notes", label: "Notes", type: "textarea", required: false },
// ];

// const packageScanDisplayColumns = [
//     { key: "scanNumber", label: "Scan #" },
//     { key: "shipmentId", label: "Shipment ID" },
//     { key: "scanType", label: "Type" },
//     { key: "locationType", label: "Location" },
//     { key: "scanTime", label: "Time" },
// ];

// const PackageScansPage = () => {
//     return (
//         <GenericEntityPage
//             entityName="Package Scans"
//             permissionPrefix="package_scans"
//             service={packageScanService}
//             fieldConfig={packageScanFieldConfig}
//             displayColumns={packageScanDisplayColumns}
//             requirePermission={false}
//             Pass these to hide edit/delete
//             hideEdit={true}
//             hideDelete={true}
//         />
//     );
// };

// export default PackageScansPage;