// import React from "react";
// import GenericEntityPage from "./GenericEntityPage";
// import { transportOrderService } from "../services/shipmentService";

// const transportOrderFieldConfig = [
//     { name: "id", type: "hidden" },
//     { name: "shipmentId", label: "Shipment ID", required: true },
//     { name: "priority", label: "Priority (1-10)", required: false },
//     { name: "weight", label: "Weight (kg)", required: true },
//     { name: "volume", label: "Volume (m³)", required: false },
//     Remove these for now - they're causing issues
//     { name: "assignedVehicleId", label: "Vehicle ID", required: false },
//     { name: "assignedDriverId", label: "Driver ID", required: false },
//     { name: "plannedDeparture", label: "Planned Departure", required: false },
//     { name: "plannedArrival", label: "Planned Arrival", required: false },
//     { name: "specialInstructions", label: "Special Instructions", type: "textarea", required: false },
// ];

// const transportOrderDisplayColumns = [
//     { key: "orderNumber", label: "Order #" },
//     { key: "shipmentId", label: "Shipment ID" },
//     { key: "status", label: "Status" },
//     { key: "priority", label: "Priority" },
//     { key: "assignedVehicleId", label: "Vehicle" },
//     { key: "assignedDriverId", label: "Driver" },
//     { key: "createdAt", label: "Created" },
// ];

// const sortOptions = [
//     { value: "orderNumber", label: "Order #" },
//     { value: "status", label: "Status" },
//     { value: "priority", label: "Priority" },
//     { value: "createdAt", label: "Created Date" }
// ];

// const filterOptions = [
//     {
//         key: "status",
//         label: "Status",
//         options: [
//             { value: "created", label: "Created" },
//             { value: "planned", label: "Planned" },
//             { value: "assigned", label: "Assigned" },
//             { value: "in_transit", label: "In Transit" },
//             { value: "delivered", label: "Delivered" },
//             { value: "cancelled", label: "Cancelled" }
//         ]
//     }
// ];

// const TransportOrdersPage = () => {
//     return (
//         <GenericEntityPage
//             entityName="Transport Orders"
//             permissionPrefix="transport_orders"
//             service={transportOrderService}
//             fieldConfig={transportOrderFieldConfig}
//             displayColumns={transportOrderDisplayColumns}
//             sortOptions={sortOptions}
//             filterOptions={filterOptions}
//             requirePermission={false}
//         />
//     );
// };

// export default TransportOrdersPage;