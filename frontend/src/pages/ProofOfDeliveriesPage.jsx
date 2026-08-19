import React from "react";
import GenericEntityPage from "./GenericEntityPage";
import { proofOfDeliveryService } from "../services/shipmentService";

const proofOfDeliveryFieldConfig = [
    { name: "id", type: "hidden" },
    { name: "shipmentId", label: "Shipment ID", required: true },
    { name: "deliveryAttemptId", label: "Delivery Attempt ID", required: true },
    { name: "receiverName", label: "Receiver Name", required: true },
    { name: "receiverRelation", label: "Receiver Relation", required: false },
    { name: "deliveryTime", label: "Delivery Time", required: true },
    { name: "notes", label: "Notes", type: "textarea", required: false },
];

const proofOfDeliveryDisplayColumns = [
    { key: "shipmentId", label: "Shipment ID" },
    { key: "receiverName", label: "Receiver" },
    { key: "deliveryTime", label: "Delivered At" },
];

const ProofOfDeliveriesPage = () => {
    return (
        <GenericEntityPage
            entityName="Proof of Deliveries"
            permissionPrefix="proof_of_delivery"
            service={proofOfDeliveryService}
            fieldConfig={proofOfDeliveryFieldConfig}
            displayColumns={proofOfDeliveryDisplayColumns}
            requirePermission={false}
        />
    );
};

export default ProofOfDeliveriesPage;