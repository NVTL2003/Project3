import React from "react";
import GenericEntityPage from "./GenericEntityPage";
import { shipmentService } from "../services/shipmentService";

const shipmentFieldConfig = [
    { name: "id", type: "hidden" },
    { name: "shipmentRequestId", label: "Request ID", required: false },
    { name: "serviceId", label: "Service ID", required: true },
    { name: "customerId", label: "Customer ID", required: true },
    { name: "senderAddressId", label: "Sender Address ID", required: true },
    { name: "receiverAddressId", label: "Receiver Address ID", required: true },
    { name: "weight", label: "Weight (kg)", required: true },
    { name: "length", label: "Length (cm)", required: false },
    { name: "width", label: "Width (cm)", required: false },
    { name: "height", label: "Height (cm)", required: false },
    { name: "declaredValue", label: "Declared Value", required: false },
    { name: "insurancePlanId", label: "Insurance Plan ID", required: false },
    { name: "packageType", label: "Package Type", required: true },
    { name: "specialInstructions", label: "Special Instructions", type: "textarea", required: false },
    { name: "isFragile", label: "Fragile", type: "checkbox", required: false, defaultValue: false },
    { name: "isLarge", label: "Large", type: "checkbox", required: false, defaultValue: false },
];

const shipmentDisplayColumns = [
    { key: "trackingNumber", label: "Tracking #" },
    { key: "currentStatus", label: "Status" },
    { key: "packageType", label: "Package" },
    { key: "weight", label: "Weight" },
    { key: "createdAt", label: "Created" },
];

const ShipmentsPage = () => {
    return (
        <GenericEntityPage
            entityName="Shipments"
            permissionPrefix="shipments"
            service={shipmentService}
            fieldConfig={shipmentFieldConfig}
            displayColumns={shipmentDisplayColumns}
        />
    );
};

export default ShipmentsPage;