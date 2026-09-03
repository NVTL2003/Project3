import React from "react";

import GenericEntityPage
    from "./GenericEntityPage";

import deliveryAssignmentService
    from "../services/deliveryAssignmentService";

import { shipmentManifestService }
    from "../services/shipmentManifestService";

import { employeeService }
    from "../services/employeeService";

import {vehicleService}
    from "../services/vehicleService";

import {routeStopService}
    from "../services/routeStopService";


const DeliveryAssignmentsPage = () => {

    // =============================================================
    // FIELD CONFIG
    // =============================================================

    const fieldConfig = [

        // =========================================================
        // MANIFEST
        // =========================================================

        {
            name: "manifestId",
            label: "Manifest",
            type: "relation",
            required: true,

            service: shipmentManifestService,

            valueField: "id",

            sortBy: "manifestNumber",

            getOptionLabel: manifest =>
                `${ manifest.manifestNumber || manifest.id } — ${
    manifest.status || "Unknown"
} `,

            // -----------------------------------------------------
            // WHEN MANIFEST CHANGES
            // -----------------------------------------------------

            onChange: async (
                manifestId,
                currentForm,
                setForm
            ) => {

                // -------------------------------------------------
                // User cleared Manifest
                // -------------------------------------------------

                if (!manifestId) {

                    setForm(prev => ({
                        ...prev,

                        driverId: "",
                        vehicleId: "",
                        routeStopId: ""
                    }));

                    return;
                }


                try {

                    console.log(
                        "🔗 Loading selected manifest:",
                        manifestId
                    );


                    const response =
                        await shipmentManifestService.getById(
                            manifestId
                        );

                    const manifest =
                        response?.data;


                    if (!manifest) {

                        console.warn(
                            "Selected manifest was not found."
                        );

                        setForm(prev => ({
                            ...prev,

                            driverId: "",
                            vehicleId: "",
                            routeStopId: ""
                        }));

                        return;
                    }


                    console.log(
                        "🔗 Selected manifest:",
                        manifest
                    );


                    // -------------------------------------------------
                    // Automatically populate Driver + Vehicle
                    // -------------------------------------------------

                    setForm(prev => ({
                        ...prev,

                        driverId:
                            manifest.driverId || "",

                        vehicleId:
                            manifest.vehicleId || "",

                        // Clear old Route Stop because the route
                        // may have changed with the new manifest.
                        routeStopId: ""
                    }));

                } catch (error) {

                    console.error(
                        "Failed to load selected manifest:",
                        error
                    );

                    setForm(prev => ({
                        ...prev,

                        driverId: "",
                        vehicleId: "",
                        routeStopId: ""
                    }));
                }
            }
        },


        // =========================================================
        // DRIVER
        // =========================================================

        {
            name: "driverId",
            label: "Driver",
            type: "relation",

            required: true,

            service: employeeService,

            valueField: "id",

            sortBy: "employeeCode",

            // Driver is controlled by Manifest.
            disabled: true,

            getOptionLabel: employee =>
                `${ employee.employeeCode || employee.id } — ${
    employee.firstName || ""
} ${
    employee.lastName || ""
} `.trim()
        },


        // =========================================================
        // VEHICLE
        // =========================================================

        {
            name: "vehicleId",
            label: "Vehicle",
            type: "relation",

            required: true,

            service: vehicleService,

            valueField: "id",

            sortBy: "vehicleNumber",

            // Vehicle is controlled by Manifest.
            disabled: true,

            getOptionLabel: vehicle =>
                vehicle.vehicleNumber ||
                vehicle.registrationNumber ||
                vehicle.licensePlate ||
                vehicle.code ||
                vehicle.name ||
                vehicle.id
        },


        // =========================================================
        // ROUTE STOP
        // =========================================================

        {
            name: "routeStopId",
            label: "Route Stop",
            type: "relation",

            required: true,

            service: routeStopService,

            valueField: "id",

            // -----------------------------------------------------
            // Depends on selected Manifest
            // -----------------------------------------------------

            dependsOn: "manifestId",

            dependentFetch: async (
                manifestId
            ) => {

                // -------------------------------------------------
                // Get manifest
                // -------------------------------------------------

                const response =
                    await shipmentManifestService.getById(
                        manifestId
                    );

                const manifest =
                    response?.data;


                if (!manifest?.routeId) {

                    console.warn(
                        "Selected manifest does not contain routeId:",
                        manifest
                    );

                    return {
                        data: []
                    };
                }


                console.log(
                    "🔗 Loading RouteStops for Route:",
                    manifest.routeId
                );


                // -------------------------------------------------
                // Get only stops belonging to this route
                // -------------------------------------------------

                return routeStopService.getByRoute(
                    manifest.routeId
                );
            },

            getOptionLabel: stop =>
                `${ stop.stopSequence ?? "" } — ${
    stop.facilityCode || ""
} — ${
    stop.facilityName ||
        stop.stopName ||
        "Unnamed Stop"
} `.replace(
                    /\s+—\s+—/g,
                    " —"
                )
        },


        // =========================================================
        // ESTIMATED DELIVERY TIME
        // =========================================================

        {
            name: "estimatedDeliveryTime",
            label: "Estimated Delivery Time",
            type: "datetime-local"
        },


        // =========================================================
        // NOTES
        // =========================================================

        {
            name: "notes",
            label: "Notes",
            type: "textarea"
        }
    ];


    // =============================================================
    // TABLE
    // =============================================================

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


    // =============================================================
    // SORT OPTIONS
    // =============================================================

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


    // =============================================================
    // PAGE
    // =============================================================

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