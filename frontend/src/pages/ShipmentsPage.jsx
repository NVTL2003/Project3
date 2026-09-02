import React from "react";

import GenericEntityPage
    from "./GenericEntityPage";

import { shipmentService }
    from "../services/shipmentService";


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
        label: "Weight (kg)"
    },

    {
        key: "declaredValue",
        label: "Declared Value"
    },

    {
        key: "isFragile",
        label: "Fragile"
    },

    {
        key: "isLarge",
        label: "Large"
    },

    {
        key: "createdAt",
        label: "Created"
    }

];


const ShipmentsPage = ({
    scope = "me"
}) => {

    const isMine =
        scope === "me";

    const service =
        isMine
            ? shipmentService.me
            : shipmentService;

    return (
        <GenericEntityPage

            entityName={
                isMine
                    ? "My Shipments"
                    : "Shipments"
            }

            permissionPrefix="shipments"

            permissionScope={
                isMine
                    ? "own"
                    : "all"
            }

            requirePermission={true}

            service={service}

            fieldConfig={[]}

            displayColumns={
                shipmentDisplayColumns
            }

            sortOptions={[
                {
                    value: "trackingNumber",
                    label: "Tracking Number"
                },
                {
                    value: "currentStatus",
                    label: "Status"
                },
                {
                    value: "createdAt",
                    label: "Created Date"
                }
            ]}

            filterOptions={[]}

            showCreate={false}

            showEdit={false}

            showDelete={false}

        />
    );
};

export default ShipmentsPage;