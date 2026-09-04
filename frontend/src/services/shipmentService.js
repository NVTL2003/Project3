
import createResourceService from "./genericResourceService";
import client from "../api/client";

const shipmentService =
    createResourceService("/shipments");

shipmentService.getQrCode = (id, config = {}) =>
    client.get(`/shipments/ ${ id }/qr`, {
        ...config,
    responseType: "blob"
    });

export { shipmentService };

