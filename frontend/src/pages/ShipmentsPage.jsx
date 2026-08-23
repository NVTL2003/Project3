import React from "react";
import GenericEntityPage from "./GenericEntityPage";
import shipmentService from "../services/shipmentService";

const shipmentFieldConfig = [
    {
        name: "id",
        type: "hidden"
    },

    {
        name: "trackingNumber",
        label: "Tracking Number",
        required: false
    },

    {
        name: "shipmentRequestId",
        label: "Shipment Request ID",
        required: false
    },

    {
        name: "customerId",
        label: "Customer ID",
        required: false
    },

    {
        name: "serviceId",
        label: "Service ID",
        required: false
    },

    {
        name: "senderAddressId",
        label: "Sender Address ID",
        required: false
    },

    {
        name: "receiverAddressId",
        label: "Receiver Address ID",
        required: false
    },

    {
        name: "packageType",
        label: "Package Type",
        required: false
    },

    {
        name: "weight",
        label: "Weight (kg)",
        required: false,
        type: "number"
    },

    {
        name: "length",
        label: "Length (cm)",
        required: false,
        type: "number"
    },

    {
        name: "width",
        label: "Width (cm)",
        required: false,
        type: "number"
    },

    {
        name: "height",
        label: "Height (cm)",
        required: false,
        type: "number"
    },

    {
        name: "declaredValue",
        label: "Declared Value",
        required: false,
        type: "number"
    },

    {
        name: "insurancePlanId",
        label: "Insurance Plan ID",
        required: false
    },

    {
        name: "currentStatus",
        label: "Status",
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
        required: false,
        defaultValue: false
    },

    {
        name: "isLarge",
        label: "Large",
        type: "checkbox",
        required: false,
        defaultValue: false
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
        key: "declaredValue",
        label: "Declared Value"
    },

    {
        key: "createdAt",
        label: "Created"
    }
];


const shipmentSortOptions = [
    {
        value: "trackingNumber",
        label: "Tracking Number"
    },

    {
        value: "currentStatus",
        label: "Status"
    },

    {
        value: "packageType",
        label: "Package Type"
    },

    {
        value: "weight",
        label: "Weight"
    },

    {
        value: "createdAt",
        label: "Created Date"
    }
];


const ShipmentsPage = ({
    scope = "global"
}) => {

    const isMine =
        scope === "me";


    const service =
        isMine
            ? shipmentService.me
            : shipmentService;


    return (
        <GenericEntityPage
            entityName="Shipments"
            permissionPrefix="shipments"
            service={shipmentService}
            fieldConfig={shipmentFieldConfig}
            displayColumns={shipmentDisplayColumns}
            sortOptions={shipmentSortOptions}
            filterOptions={[]}
            showCreate={false}
        />
    );
};


export default ShipmentsPage;