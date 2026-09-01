import React from "react";
import GenericEntityPage from "./GenericEntityPage";
import shipmentRequestService from "../services/shipmentRequestService";
import customerAddressService from "../services/customerAddressService"
import customerService from "../services/customerService"
import serviceService from "../services/serviceService";
import insurancePlanService from "../services/insurancePlanService";

const buildShipmentRequestFieldConfig = (isMine) => [
    {
        name: "id",
        type: "hidden"
    },

    // =========================================================
    // CUSTOMER
    // GLOBAL ONLY
    // =========================================================

    ...(!isMine
        ? [
            {
                name: "customerId",
                label: "Customer",
                type: "relation",
                required: true,

                displayField: "customerName",

                service: customerService,
                fetchMode: "all",

                valueField: "id",

                getOptionLabel: customer =>
                    `${customer.companyName} (${customer.accountNumber})`
            }
        ]
        : []
    ),


    // =========================================================
    // SENDER ADDRESS
    // BOTH GLOBAL + MINE
    // =========================================================

    {
        name: "senderAddressId",
        label: "Sender Address",
        type: "relation",
        required: true,

        displayField: "senderAddress",

        service: customerAddressService,

        fetchMode: isMine
            ? "mine"
            : "all",

        valueField: "id",

        getOptionLabel: address =>
            `${address.addressType || "Address"} - ${address.addressLine1}, ${address.city}`
    },


    // =========================================================
    // RECEIVER ADDRESS
    // BOTH GLOBAL + MINE
    // =========================================================

    {
        name: "receiverAddressId",
        label: "Receiver Address",
        type: "relation",
        required: true,

        displayField: "receiverAddress",

        service: customerAddressService,

        fetchMode: isMine
            ? "mine"
            : "all",

        valueField: "id",

        getOptionLabel: address =>
            `${address.addressType || "Address"} - ${address.addressLine1}, ${address.city}`
    },


    // =========================================================
    // SERVICE
    // =========================================================

    {
        name: "serviceId",
        label: "Service",
        type: "relation",
        required: true,

        service: serviceService,
        fetchMode: "all",

        valueField: "id",

        getOptionLabel: service =>
            service.name
    },


    // =========================================================
    // PACKAGE
    // =========================================================

    {
        name: "packageType",
        label: "Package Type",
        required: true
    },


    {
        name: "weight",
        label: "Weight (kg)",
        required: true,
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


    // =========================================================
    // INSURANCE
    // =========================================================

    {
        name: "insurancePlanId",
        label: "Insurance Plan",
        type: "relation",
        required: false,

        service: insurancePlanService,
        fetchMode: "all",

        valueField: "id",

        getOptionLabel: plan =>
            plan.name
    },


    // =========================================================
    // SPECIAL INSTRUCTIONS
    // =========================================================

    {
        name: "specialInstructions",
        label: "Special Instructions",
        type: "textarea",
        required: false
    },


    // =========================================================
    // FLAGS
    // =========================================================

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

const shipmentRequestDisplayColumns = [
    {
        key: "requestNumber",
        label: "Request #"
    },
    {
        key: "status",
        label: "Status"
    },
    {
        key: "customerId",
        label: "Customer"
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
        key: "createdAt",
        label: "Created"
    }
];

const ShipmentRequestsPage = ({
    scope = "global"
}) => {

    const isMine =
        scope === "me";

    const service =
        isMine
            ? shipmentRequestService.me
            : shipmentRequestService;

    const fieldConfig =
        buildShipmentRequestFieldConfig(isMine);

    const handleApprove = async (item) => {

        const confirmed =
            window.confirm(
                `Approve request ${item.requestNumber}?`
            );

        if (!confirmed) {
            return;
        }

        try {

            const response =
                await shipmentRequestService.approve(
                    item.id
                );

            alert(
                `Shipment created! Tracking #: ${response.data.trackingNumber
                }`
            );

            window.location.reload();

        } catch (err) {

            alert(
                `Approval failed: ${err.response?.data?.message ||
                err.message
                }`
            );
        }
    };

    return (
        <GenericEntityPage
            entityName={
                isMine
                    ? "My Shipment Requests"
                    : "Shipment Requests"
            }

            permissionPrefix="shipment_requests"

            requirePermission={
                !isMine
            }

            service={service}

            fieldConfig={fieldConfig}

            displayColumns={
                shipmentRequestDisplayColumns
            }

            extraActions={
                !isMine
                    ? (item) =>
                        item.status === "pending" ? (
                            <button
                                className="crud-action-button"
                                onClick={() =>
                                    handleApprove(item)
                                }
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
                    : undefined
            }
        />
    );
};

export default ShipmentRequestsPage;