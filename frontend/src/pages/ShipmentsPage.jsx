import React from "react";
import GenericEntityPage from "./GenericEntityPage";
import { shipmentService } from "../services/shipmentService";

const shipmentFieldConfig = [
    {
        name: "id",
        type: "hidden"
    },

    {
        name: "shipmentRequestId",
        label: "Shipment Request ID",
        required: false
    },

    {
        name: "trackingNumber",
        label: "Tracking Number",
        required: false
    },

    {
        name: "customerId",
        label: "Customer",
        required: true,
        type: "relation",
        service: {
            getPaged: (params) =>
                import("../services/customerService")
                    .then(({ customerService }) =>
                        customerService.getPaged(params)
                    )
        },
        valueField: "id",
        labelField: "id"
    },

    {
        name: "serviceId",
        label: "Service",
        required: true,
        type: "relation",
        service: {
            getPaged: (params) =>
                import("../services/serviceService")
                    .then(({ serviceService }) =>
                        serviceService.getPaged(params)
                    )
        },
        valueField: "id",
        labelField: "name"
    },

    {
        name: "senderAddressId",
        label: "Sender Address",
        required: true
    },

    {
        name: "receiverAddressId",
        label: "Receiver Address",
        required: true
    },

    {
        name: "weight",
        label: "Weight (kg)",
        type: "number",
        required: true
    },

    {
        name: "packageType",
        label: "Package Type",
        required: true
    },

    {
        name: "currentStatus",
        label: "Status",
        required: false
    },

    {
        name: "declaredValue",
        label: "Declared Value",
        type: "number",
        required: false
    },

    {
        name: "specialInstructions",
        label: "Special Instructions",
        type: "textarea",
        required: false
    },

    {
        name: "isFragile",
        label: "Fragile",
        type: "checkbox",
        required: false
    },

    {
        name: "isLarge",
        label: "Large",
        type: "checkbox",
        required: false
    }
];

const shipmentDisplayColumns = [
    {
        key: "trackingNumber",
        label: "Tracking #"
    },
    {
        key: "currentStatus",
        label: "Status"
    },
    {
        key: "packageType",
        label: "Package"
    },
    {
        key: "weight",
        label: "Weight"
    },
    {
        key: "customerId",
        label: "Customer ID"
    },
    {
        key: "createdAt",
        label: "Created"
    }
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