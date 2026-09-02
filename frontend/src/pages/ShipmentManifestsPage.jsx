import React from "react";
import { useNavigate } from "react-router-dom";

import GenericEntityPage
    from "./GenericEntityPage";

import { shipmentManifestService }
    from "../services/shipmentManifestService";

import { vehicleService }
    from "../services/vehicleService";

import { employeeService }
    from "../services/employeeService";

import { routeService }
    from "../services/routeService";

import { facilityService }
    from "../services/facilityService";


const ShipmentManifestsPage = () => {

    const navigate = useNavigate();


    // =========================================================
    // FORM
    // =========================================================

    const fieldConfig = [

        {
            name: "vehicleId",
            label: "Vehicle",
            type: "relation",
            required: true,

            service: vehicleService,

            valueField: "id",

            sortBy: "vehicleNumber",

            getOptionLabel: vehicle =>
                vehicle.vehicleNumber ||
                vehicle.registrationNumber ||
                vehicle.code ||
                vehicle.name ||
                vehicle.id
        },

        {
            name: "driverId",
            label: "Driver",
            type: "relation",
            required: true,

            service: employeeService,

            valueField: "id",

            sortBy: "firstName",

            getOptionLabel: employee =>
                `${employee.firstName || ""} ${employee.lastName || ""}`.trim() ||
                employee.employeeCode ||
                employee.id
        },

        {
            name: "routeId",
            label: "Route",
            type: "relation",
            required: true,

            service: routeService,

            valueField: "id",

            sortBy: "routeCode",

            getOptionLabel: route =>
                `${route.routeCode || ""} — ${route.name || ""}`
        },

        {
            name: "departureFacilityId",
            label: "Departure Facility",
            type: "relation",
            required: true,

            service: facilityService,

            valueField: "id",

            sortBy: "name",

            getOptionLabel: facility =>
                `${facility.code || ""} — ${facility.name || ""}`
        },

        {
            name: "departureTime",
            label: "Departure Time",
            type: "datetime-local",
            required: true
        },

        {
            name: "notes",
            label: "Notes",
            type: "textarea"
        }

    ];


    // =========================================================
    // TABLE
    // =========================================================

    const displayColumns = [

        {
            key: "manifestNumber",
            label: "Manifest #"
        },

        {
            key: "status",
            label: "Status"
        },

        {
            key: "vehicleId",
            label: "Vehicle"
        },

        {
            key: "driverId",
            label: "Driver"
        },

        {
            key: "routeId",
            label: "Route"
        },

        {
            key: "departureTime",
            label: "Departure"
        },

        {
            key: "totalPackages",
            label: "Packages"
        },

        {
            key: "totalWeight",
            label: "Weight"
        }

    ];


    // =========================================================
    // SORT
    // =========================================================

    const sortOptions = [

        {
            value: "manifestNumber",
            label: "Manifest Number"
        },

        {
            value: "departureTime",
            label: "Departure Time"
        },

        {
            value: "status",
            label: "Status"
        },

        {
            value: "createdAt",
            label: "Created Date"
        }

    ];


    // =========================================================
    // EXTRA ACTIONS
    // =========================================================

    const extraActions = (manifest) => {

        return (

            <button
                className="crud-action-button"
                onClick={() =>
                    navigate(
                        `/shipment-manifests/${manifest.id}`
                    )
                }
            >
                Details
            </button>

        );

    };


    // =========================================================
    // PAGE
    // =========================================================


    return (
        <GenericEntityPage
            entityName="Shipment Manifests"

            permissionPrefix="shipment_manifests"
            permissionScope="all"

            service={shipmentManifestService}

            fieldConfig={fieldConfig}

            displayColumns={displayColumns}

            sortOptions={sortOptions}

            extraActions={extraActions}
        />
    );



};


export default ShipmentManifestsPage;