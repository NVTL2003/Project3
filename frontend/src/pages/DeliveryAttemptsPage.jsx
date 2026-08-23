// import React from "react";
// import GenericEntityPage from "./GenericEntityPage";
// import { deliveryAttemptService } from "../services/shipmentService";

// const deliveryAttemptFieldConfig = [
//     { name: "id", type: "hidden" },
//     { name: "shipmentId", label: "Shipment ID", required: true },
//     Remove deliveryAssignmentId - it's optional for demo
//     { name: "attemptNumber", label: "Attempt Number", required: true },
//     {
//         name: "status",
//         label: "Status",
//         type: "select",
//         required: true,
//         options: [
//             { value: "attempted", label: "Attempted" },
//             { value: "delivered", label: "Delivered" },
//             { value: "failed", label: "Failed" }
//         ]
//     },
//     { name: "reason", label: "Reason (if failed)", required: false },
//     { name: "notes", label: "Notes", type: "textarea", required: false },
// ];

// const deliveryAttemptDisplayColumns = [
//     { key: "shipmentId", label: "Shipment ID" },
//     { key: "attemptNumber", label: "Attempt #" },
//     { key: "status", label: "Status" },
//     { key: "attemptTime", label: "Time" },
//     { key: "isDelivered", label: "Delivered" },
// ];

// const DeliveryAttemptsPage = () => {
//     return (
//         <GenericEntityPage
//             entityName="Delivery Attempts"
//             permissionPrefix="delivery_attempts"
//             service={deliveryAttemptService}
//             fieldConfig={deliveryAttemptFieldConfig}
//             displayColumns={deliveryAttemptDisplayColumns}
//             requirePermission={false}
//         />
//     );
// };

// export default DeliveryAttemptsPage;