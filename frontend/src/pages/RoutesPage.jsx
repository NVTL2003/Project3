import React from "react";
import { useNavigate } from "react-router-dom";

import GenericEntityPage
    from "./GenericEntityPage";

import { routeService }
    from "../services/routeService";

import { facilityService }
    from "../services/facilityService";


const RoutesPage = () => {

    const navigate = useNavigate();


    const fieldConfig = [

        {
            name: "routeCode",
            label: "Route Code",
            type: "text",
            required: true
        },

        {
            name: "name",
            label: "Route Name",
            type: "text",
            required: true
        },

        {
            name: "originFacilityId",
            label: "Origin Facility",
            type: "relation",
            required: true,

            service: facilityService,

            valueField: "id",

            sortBy: "name",

            getOptionLabel: facility =>
                `${facility.code} — ${facility.name}`
        },

        {
            name: "destinationFacilityId",
            label: "Destination Facility",
            type: "relation",
            required: true,

            service: facilityService,

            valueField: "id",

            sortBy: "name",

            getOptionLabel: facility =>
                `${facility.code} — ${facility.name}`
        },

        {
            name: "distance",
            label: "Distance",
            type: "number",
            required: true
        },

        {
            name: "estimatedDuration",
            label: "Estimated Duration (minutes)",
            type: "number"
        },

        {
            name: "isActive",
            label: "Active",
            type: "checkbox",
            defaultValue: true
        }
    ];


    const displayColumns = [

        {
            key: "routeCode",
            label: "Route Code"
        },

        {
            key: "name",
            label: "Name"
        },

        {
            key: "originFacilityName",
            label: "Origin"
        },

        {
            key: "destinationFacilityName",
            label: "Destination"
        },

        {
            key: "distance",
            label: "Distance"
        },

        {
            key: "estimatedDuration",
            label: "Duration"
        },

        {
            key: "isActive",
            label: "Active"
        }

    ];


    const sortOptions = [

        {
            value: "routeCode",
            label: "Route Code"
        },

        {
            value: "name",
            label: "Name"
        },

        {
            value: "distance",
            label: "Distance"
        }

    ];


    // =========================================================
    // EXTRA ACTIONS
    // =========================================================

    const extraActions = (route) => {

        return (

            <button
                className="crud-action-button"
                onClick={() =>
                    navigate(`/routes/${route.id}`)
                }
            >
                Details
            </button>

        );

    };


    return (

        <GenericEntityPage

            entityName="Routes"

            permissionPrefix="routes"

            service={routeService}

            fieldConfig={fieldConfig}

            displayColumns={displayColumns}

            sortOptions={sortOptions}

            extraActions={extraActions}

        />

    );
};


export default RoutesPage;