// import React from "react";
// import GenericEntityPage from "./GenericEntityPage";
// import { trackingEventService } from "../services/shipmentService";

// const trackingEventFieldConfig = [
//     { name: "id", type: "hidden" },
//     { name: "shipmentId", label: "Shipment ID", required: true },
//     { name: "trackingStatusId", label: "Tracking Status ID", required: true },
//     { name: "eventLocation", label: "Event Location", required: false },
//     { name: "isPublic", label: "Public", type: "checkbox", required: false, defaultValue: true },
// ];

// const trackingEventDisplayColumns = [
//     { key: "shipmentId", label: "Shipment ID" },
//     { key: "trackingStatusId", label: "Status" },
//     { key: "eventLocation", label: "Location" },
//     { key: "eventTime", label: "Time" },
// ];

// const TrackingEventsPage = () => {
//     return (
//         <GenericEntityPage
//             entityName="Tracking Events"
//             permissionPrefix="tracking_events"
//             service={trackingEventService}
//             fieldConfig={trackingEventFieldConfig}
//             displayColumns={trackingEventDisplayColumns}
//             requirePermission={false}
//         />
//     );
// };

// export default TrackingEventsPage;