import React from "react";
import GenericEntityPage from "./GenericEntityPage";
import { meShipmentRequestService } from "../services/shipmentService";

const shipmentRequestFieldConfig = [
    { name: "id", type: "hidden" },
    { name: "senderAddressId", label: "Sender Address ID", required: true },
    { name: "receiverAddressId", label: "Receiver Address ID", required: true },
    { name: "serviceId", label: "Service ID", required: false },
    { name: "packageType", label: "Package Type", required: true },
    { name: "weight", label: "Weight (kg)", required: true },
    { name: "length", label: "Length (cm)", required: false },
    { name: "width", label: "Width (cm)", required: false },
    { name: "height", label: "Height (cm)", required: false },
    { name: "declaredValue", label: "Declared Value", required: false },
    { name: "insurancePlanId", label: "Insurance Plan ID", required: false },
    { name: "specialInstructions", label: "Special Instructions", type: "textarea", required: false },
    { name: "isFragile", label: "Fragile", type: "checkbox", required: false, defaultValue: false },
    { name: "isLarge", label: "Large", type: "checkbox", required: false, defaultValue: false },
];

const shipmentRequestDisplayColumns = [
    { key: "requestNumber", label: "Request #" },
    { key: "status", label: "Status" },
    { key: "packageType", label: "Package" },
    { key: "weight", label: "Weight" },
    { key: "createdAt", label: "Created" },
];

const MyShipmentRequestsPage = () => {
    return (
        <GenericEntityPage
            entityName="My Shipment Requests"
            permissionPrefix="shipment_requests"
            service={meShipmentRequestService}
            fieldConfig={shipmentRequestFieldConfig}
            displayColumns={shipmentRequestDisplayColumns}
        />
    );
};

export default MyShipmentRequestsPage;