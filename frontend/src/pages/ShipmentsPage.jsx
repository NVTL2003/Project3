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


    const handlePrintQr = async (shipment) => {

        try {

            const id =
                shipment.id ?? shipment.Id;

            if (!id) {
                alert("Shipment ID is missing.");
                return;
            }

            const response =
                await shipmentService.getQrCode(id);

            const blob =
                new Blob(
                    [response.data],
                    { type: "image/png" }
                );

            const url =
                window.URL.createObjectURL(blob);

            const image =
                new Image();

            image.onload = () => {

                const printWindow =
                    window.open(
                        "",
                        "_blank",
                        "width=500,height=600"
                    );

                if (!printWindow) {
                    window.URL.revokeObjectURL(url);
                    alert(
                        "Please allow pop-ups to print the QR code."
                    );
                    return;
                }

                printWindow.document.write(`
                    <!DOCTYPE html>
                    <html>
                    <head>
                        <title>
                            ${shipment.trackingNumber || "Shipment"} QR
                        </title>

                        <style>
                            body {
                                margin: 0;
                                padding: 40px;
                                font-family: Arial, sans-serif;
                                text-align: center;
                            }

                            img {
                                width: 300px;
                                height: 300px;
                            }

                            .tracking {
                                margin-top: 20px;
                                font-size: 22px;
                                font-weight: 600;
                                letter-spacing: 1px;
                            }

                            .instruction {
                                margin-top: 10px;
                                font-size: 14px;
                                color: #555;
                            }

                            @media print {
                                body {
                                    padding: 20px;
                                }
                            }
                        </style>
                    </head>

                    <body>

                        <img
                            src="${url}"
                            alt="Shipment QR Code"
                        />

                        <div class="tracking">
                            ${shipment.trackingNumber || ""}
                        </div>

                        <div class="instruction">
                            Scan this QR code to identify the shipment.
                        </div>

                    </body>
                    </html>
                `);

                printWindow.document.close();

                printWindow.focus();

                setTimeout(() => {
                    printWindow.print();

                    printWindow.close();

                    window.URL.revokeObjectURL(url);
                }, 300);
            };

            image.src = url;

        } catch (error) {

            console.error(
                "Failed to generate shipment QR:",
                error
            );

            alert(
                "Unable to generate the shipment QR code."
            );
        }
    };


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

            extraActions={(shipment) => (
                <button
                    type="button"
                    className="crud-action-button"
                    onClick={() => handlePrintQr(shipment)}
                >
                    Print QR
                </button>
            )}
        />
    );
};

export default ShipmentsPage;