// import createResourceService from "./genericResourceService";
// import api from "../api/client";

// export const shipmentRequestService = {
//     ...createResourceService("/shipment-requests"),
    
//     approve: (id) => 
//         api.post(`/shipment-requests/${id}/approve`)
// };

// export const meShipmentRequestService = createResourceService("/me/shipment-requests");

// export const shipmentService = createResourceService("/shipments");

// export const packageScanService = {
//     ...createResourceService("/package-scans"),
    
//     scan: (data) => 
//         api.post(`/package-scans/scan`, data)
// };

// export const trackingEventService = createResourceService("/tracking-events");

// export const transportOrderService = {
//     ...createResourceService("/transport-orders"),
    
//     assign: (data) => 
//         api.post(`/transport-orders/assign`, data)
// };

// export const deliveryAttemptService = {
//     ...createResourceService("/delivery-attempts"),
    
//     deliver: (data) => 
//         api.post(`/delivery-attempts/deliver`, data)
// };
// export const deliveryAssignmentService = createResourceService("/delivery-assignments");
// export const proofOfDeliveryService = createResourceService("/proof-of-deliveries");