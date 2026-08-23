import createResourceService from "./genericResourceService";
import api from "../api/client";

const shipmentRequestService =
    createResourceService("/ShipmentRequests");

shipmentRequestService.approve = (id) =>
    api.post(`/ShipmentRequests/${id}/approve`);

export default shipmentRequestService;