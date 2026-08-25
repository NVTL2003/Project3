import React from "react";

import GenericEntityPage
    from "./GenericEntityPage";

import { transportOrderService }
    from "../services/transportOrderService";

import { shipmentService }
    from "../services/shipmentService";

import { vehicleService }
    from "../services/vehicleService";

import { employeeService }
    from "../services/employeeService";


const TransportOrdersPage = () => {

    const fieldConfig = [

        // =====================================================
        // SHIPMENT
        // =====================================================

        {
            name: "shipmentId",

            label: "Shipment",

            type: "relation",

            required: true,

            service: shipmentService,

            valueField: "id",

            getOptionLabel: (shipment) =>
                `${shipment.trackingNumber || shipment.id} — ${shipment.currentStatus || ""}`,

            sortBy: "trackingNumber"
        },


        // =====================================================
        // PRIORITY
        // =====================================================

        {
            name: "priority",

            label: "Priority",

            type: "number",

            required: false,

            defaultValue: 5
        },


        // =====================================================
        // WEIGHT
        // =====================================================

        {
            name: "weight",

            label: "Weight",

            type: "number",

            required: true
        },


        // =====================================================
        // VOLUME
        // =====================================================

        {
            name: "volume",

            label: "Volume",

            type: "number",

            required: false
        },


        // =====================================================
        // SPECIAL INSTRUCTIONS
        // =====================================================

        {
            name: "specialInstructions",

            label: "Special Instructions",

            type: "textarea",

            required: false
        },


        // =====================================================
        // VEHICLE
        // =====================================================

        {
            name: "assignedVehicleId",

            label: "Vehicle",

            type: "relation",

            required: false,

            service: vehicleService,

            valueField: "id",

            getOptionLabel: (vehicle) =>
                `${vehicle.vehicleNumber ||
                vehicle.registrationNumber ||
                vehicle.id} — ${vehicle.vehicleType || ""}`,

            sortBy: "vehicleNumber"
        },


        // =====================================================
        // DRIVER
        // =====================================================

        {
            name: "assignedDriverId",

            label: "Driver",

            type: "relation",

            required: false,

            service: employeeService,

            valueField: "id",

            getOptionLabel: (employee) => {

                const name =
                    `${employee.firstName || ""} ${employee.lastName || ""}`
                        .trim();

                return (
                    employee.employeeCode
                        ? `${employee.employeeCode} — ${name}`
                        : name || employee.id
                );
            },

            sortBy: "employeeCode"
        },


        // =====================================================
        // PLANNED DEPARTURE
        // =====================================================

        {
            name: "plannedDeparture",

            label: "Planned Departure",

            type: "datetime-local",

            required: false
        },


        // =====================================================
        // PLANNED ARRIVAL
        // =====================================================

        {
            name: "plannedArrival",

            label: "Planned Arrival",

            type: "datetime-local",

            required: false
        }

    ];


    const displayColumns = [

        {
            key: "orderNumber",
            label: "Order Number"
        },

        {
            key: "shipmentId",
            label: "Shipment"
        },

        {
            key: "status",
            label: "Status"
        },

        {
            key: "priority",
            label: "Priority"
        },

        {
            key: "weight",
            label: "Weight"
        },

        {
            key: "volume",
            label: "Volume"
        },

        {
            key: "assignedVehicleId",
            label: "Vehicle"
        },

        {
            key: "assignedDriverId",
            label: "Driver"
        },

        {
            key: "plannedDeparture",
            label: "Planned Departure"
        },

        {
            key: "plannedArrival",
            label: "Planned Arrival"
        },

        {
            key: "createdAt",
            label: "Created At"
        }

    ];


    const sortOptions = [

        {
            value: "orderNumber",
            label: "Order Number"
        },

        {
            value: "priority",
            label: "Priority"
        },

        {
            value: "status",
            label: "Status"
        },

        {
            value: "plannedDeparture",
            label: "Planned Departure"
        },

        {
            value: "createdAt",
            label: "Created At"
        }

    ];


    const filterOptions = [

        {
            field: "status",

            label: "Status",

            options: [
                {
                    value: "planned",
                    label: "Planned"
                },
                {
                    value: "in_transit",
                    label: "In Transit"
                },
                {
                    value: "completed",
                    label: "Completed"
                },
                {
                    value: "cancelled",
                    label: "Cancelled"
                }
            ]
        }

    ];


    return (

        <GenericEntityPage

            entityName="Transport Orders"

            permissionPrefix="transport_orders"

            service={transportOrderService}

            fieldConfig={fieldConfig}

            displayColumns={displayColumns}

            sortOptions={sortOptions}

            filterOptions={filterOptions}

        />

    );
};


export default TransportOrdersPage;