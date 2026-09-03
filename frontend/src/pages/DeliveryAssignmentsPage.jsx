import React from "react";

import GenericEntityPage
    from "./GenericEntityPage";

import deliveryAssignmentService
    from "../services/deliveryAssignmentService";

import shipmentManifestService
    from "../services/shipmentManifestService";

import employeeService
    from "../services/employeeService";

import vehicleService
    from "../services/vehicleService";

import routeStopService
    from "../services/routeStopService";


const DeliveryAssignmentsPage = () => {

    const fieldConfig = [

        {
            name: "manifestId",
            label: "Manifest",
            type: "relation",
            required: true,
            relation: {
                service: shipmentManifestService,
                valueField: "id",
                labelField: "manifestNumber"
            }
        },

        {
            name: "driverId",
            label: "Driver",
            type: "relation",
            required: true,
            relation: {
                service: employeeService,
                valueField: "id",
                labelFormatter: (employee) =>
                    `${employee.employeeCode ?? ""} — ${employee.firstName ?? ""} ${employee.lastName ?? ""}`.trim()
            }
        },

        {
            name: "vehicleId",
            label: "Vehicle",
            type: "relation",
            required: true,
            relation: {
                service: vehicleService,
                valueField: "id",
                labelFormatter: (vehicle) =>
                    `${vehicle.vehicleCode ?? vehicle.registrationNumber ?? vehicle.licensePlate ?? ""}`
            }
        },

        {
            name: "routeStopId",
            label: "Route Stop",
            type: "relation",
            required: true,
            relation: {
                service: routeStopService,
                valueField: "id",
                labelFormatter: (stop) =>
                    `${stop.stopSequence ?? ""} — ${stop.stopName ?? ""}`
            }
        },

        {
            name: "sequenceNumber",
            label: "Sequence Number",
            type: "number"
        },

        {
            name: "estimatedDeliveryTime",
            label: "Estimated Delivery Time",
            type: "datetime-local"
        },

        {
            name: "notes",
            label: "Notes",
            type: "textarea"
        }
    ];


    const displayColumns = [

        {
            key: "assignmentNumber",
            label: "Assignment Number"
        },

        {
            key: "manifestId",
            label: "Manifest"
        },

        {
            key: "driverId",
            label: "Driver"
        },

        {
            key: "vehicleId",
            label: "Vehicle"
        },

        {
            key: "routeStopId",
            label: "Route Stop"
        },

        {
            key: "sequenceNumber",
            label: "Sequence"
        },

        {
            key: "status",
            label: "Status"
        },

        {
            key: "estimatedDeliveryTime",
            label: "Estimated Delivery"
        },

        {
            key: "assignedAt",
            label: "Assigned At"
        }
    ];


    const sortOptions = [

        {
            value: "assignmentNumber",
            label: "Assignment Number"
        },

        {
            value: "status",
            label: "Status"
        },

        {
            value: "sequenceNumber",
            label: "Sequence"
        },

        {
            value: "assignedAt",
            label: "Assigned At"
        }
    ];


    return (
        <GenericEntityPage

            entityName="Delivery Assignments"

            permissionPrefix="delivery_assignments"

            permissionScope="all"

            service={deliveryAssignmentService}

            fieldConfig={fieldConfig}

            displayColumns={displayColumns}

            sortOptions={sortOptions}

            showCreate={true}

            showEdit={true}

            showDelete={true}
        />
    );
};


export default DeliveryAssignmentsPage;