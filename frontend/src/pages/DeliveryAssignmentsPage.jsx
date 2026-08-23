// import React from "react";
// import GenericEntityPage from "./GenericEntityPage";
// import { deliveryAssignmentService } from "../services/shipmentService";

// const deliveryAssignmentFieldConfig = [
//     { name: "id", type: "hidden" },
//     { name: "manifestId", label: "Manifest ID", required: true },
//     { name: "driverId", label: "Driver ID", required: true },
//     { name: "vehicleId", label: "Vehicle ID", required: true },
//     { name: "routeStopId", label: "Route Stop ID", required: true },
//     { name: "sequenceNumber", label: "Sequence Number", required: false },
//     { name: "estimatedDeliveryTime", label: "Estimated Delivery Time", required: false },
//     { name: "notes", label: "Notes", type: "textarea", required: false },
// ];

// const deliveryAssignmentDisplayColumns = [
//     { key: "assignmentNumber", label: "Assignment #" },
//     { key: "driverId", label: "Driver" },
//     { key: "vehicleId", label: "Vehicle" },
//     { key: "status", label: "Status" },
//     { key: "assignedAt", label: "Assigned At" },
// ];

// const DeliveryAssignmentsPage = () => {
//     return (
//         <GenericEntityPage
//             entityName="Delivery Assignments"
//             permissionPrefix="delivery_assignments"
//             service={deliveryAssignmentService}
//             fieldConfig={deliveryAssignmentFieldConfig}
//             displayColumns={deliveryAssignmentDisplayColumns}
//             requirePermission={false}
//         />
//     );
// };

// export default DeliveryAssignmentsPage;