import React from "react";
import GenericEntityPage from "./GenericEntityPage";
import { shipmentRequestService } from "../services/shipmentService";

const shipmentRequestFieldConfig = [
    { name: "id", type: "hidden" },
    { name: "customerId", label: "Customer ID", required: true },
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
    { key: "customerId", label: "Customer" },
    { key: "packageType", label: "Package" },
    { key: "weight", label: "Weight" },
    { key: "createdAt", label: "Created" },
];

const ShipmentRequestsPage = () => {
    const handleApprove = async (item) => {
        const confirmed = window.confirm(`Approve request ${item.requestNumber}?`);
        if (!confirmed) return;

        try {
            const response = await shipmentRequestService.approve(item.id);
            alert(`Shipment created! Tracking #: ${response.data.trackingNumber}`);
            window.location.reload();
        } catch (err) {
            alert(`Approval failed: ${err.response?.data?.message || err.message}`);
        }
    };

    return (
        <GenericEntityPage
            entityName="Shipment Requests"
            permissionPrefix="shipment_requests"
            service={shipmentRequestService}
            fieldConfig={shipmentRequestFieldConfig}
            displayColumns={shipmentRequestDisplayColumns}
            extraActions={(item) =>
                item.status === "pending" ? (
                    <button
                        className="crud-action-button"
                        onClick={() => handleApprove(item)}
                        style={{
                            background: "#4caf50",
                            color: "white",
                            border: "none",
                            padding: "5px 10px",
                            borderRadius: "3px",
                            cursor: "pointer"
                        }}
                    >
                        Approve
                    </button>
                ) : null
            }
        />
    );
};

export default ShipmentRequestsPage;