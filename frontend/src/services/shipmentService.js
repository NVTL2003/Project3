import createResourceService from "./genericResourceService";
import client from "../api/client";

const shipmentService =
    createResourceService("/shipments");

// DEBUG: get shipment by ID
const originalGetById = shipmentService.getById;

shipmentService.getById = async (id, config = {}) => {
    console.log("==========================================");
    console.log("SHIPMENT SERVICE - GET BY ID");
    console.log("==========================================");
    console.log("Requested shipment ID:", id);

    try {
        const response = await originalGetById(id, config);

        console.log("Shipment API response:");
        console.log(response);

        console.log("Shipment data:");
        console.log(response?.data);

        console.log(
            "Shipment data JSON:",
            JSON.stringify(response?.data, null, 2)
        );

        console.log("Current status:", response?.data?.currentStatus);
        console.log("Status:", response?.data?.status);
        console.log("Manifest items:", response?.data?.manifestItems);

        console.log("==========================================");

        return response;
    } catch (error) {
        console.error("SHIPMENT GET BY ID ERROR");
        console.error(error);
        console.error("Response:", error?.response);
        console.error("Response data:", error?.response?.data);

        throw error;
    }
};

shipmentService.getQrCode = (id, config = {}) => {
    console.log("SHIPMENT QR REQUEST");
    console.log("Shipment ID:", id);

    return client.get(`/shipments/${id}/qr`, {
        ...config,
        responseType: "blob"
    });
};

export { shipmentService };