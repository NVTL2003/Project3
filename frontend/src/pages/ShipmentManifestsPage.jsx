import React, {
    useEffect,
    useState
} from "react";

import {
    useNavigate
} from "react-router-dom";

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

import { manifestItemService }
    from "../services/manifestItemService";

// =========================================================
// HELPERS
// =========================================================

const getId = (item) =>
    item?.id ??
    item?.Id ??
    null;

const normalizeItems = (response) => {
    const data = response?.data;

    if (Array.isArray(data)) {
        return data;
    }

    if (Array.isArray(data?.items)) {
        return data.items;
    }

    if (Array.isArray(data?.Items)) {
        return data.Items;
    }

    return [];
};

const getVehicleLabel = (vehicle) => {

    if (!vehicle) {
        return "Unknown Vehicle";
    }

    return (
        vehicle.vehicleNumber ||
        vehicle.VehicleNumber ||
        vehicle.registrationNumber ||
        vehicle.RegistrationNumber ||
        vehicle.code ||
        vehicle.Code ||
        vehicle.id ||
        vehicle.Id
    );

};


const getEmployeeLabel = (employee) => {

    if (!employee) {
        return "Unknown Driver";
    }


    const firstName =
        employee.firstName ||
        employee.FirstName ||
        "";


    const lastName =
        employee.lastName ||
        employee.LastName ||
        "";


    const name =
        `${ firstName } ${ lastName } `.trim();


    const employeeCode =
        employee.employeeCode ||
        employee.EmployeeCode ||
        "";


    if (employeeCode && name) {

        return `${ employeeCode } — ${ name } `;

    }


    return (
        name ||
        employeeCode ||
        employee.id ||
        employee.Id
    );

};


const getRouteLabel = (route) => {

    if (!route) {
        return "Unknown Route";
    }


    const code =
        route.routeCode ||
        route.RouteCode ||
        "";


    const name =
        route.name ||
        route.Name ||
        "";


    if (code && name) {

        return `${ code } — ${ name } `;

    }


    return (
        code ||
        name ||
        route.id ||
        route.Id
    );

};


const getFacilityLabel = (facility) => {

    if (!facility) {
        return "Unknown Facility";
    }


    const code =
        facility.code ||
        facility.Code ||
        "";


    const name =
        facility.name ||
        facility.Name ||
        "";


    if (code && name) {

        return `${ code } — ${ name } `;

    }


    return (
        code ||
        name ||
        facility.id ||
        facility.Id
    );

};


// =========================================================
// PAGE
// =========================================================

const ShipmentManifestsPage = () => {

    const navigate =
        useNavigate();


    // =====================================================
    // RELATION DATA
    // =====================================================

    const [vehicles, setVehicles] =
        useState([]);

    const [employees, setEmployees] =
        useState([]);

    const [routes, setRoutes] =
        useState([]);

    const [facilities, setFacilities] =
        useState([]);

    const [manifestItems, setManifestItems] =
        useState([]);

    // =====================================================
    // LOAD RELATIONS
    // =====================================================

    useEffect(() => {
        let cancelled = false;

        const loadRelationData = async () => {
            try {
                const [
                    vehicleResponse,
                    employeeResponse,
                    routeResponse,
                    facilityResponse,
                    manifestItemResponse
                ] = await Promise.all([
                    vehicleService.getPaged({
                        page: 1,
                        pageSize: 1000
                    }),
                    employeeService.getPaged({
                        page: 1,
                        pageSize: 1000
                    }),
                    routeService.getPaged({
                        page: 1,
                        pageSize: 1000
                    }),
                    facilityService.getPaged({
                        page: 1,
                        pageSize: 1000
                    }),
                    manifestItemService.getPaged({
                        page: 1,
                        pageSize: 1000
                    })
                ]);

                console.log(
                    "📦 RAW ManifestItems Axios response:",
                    manifestItemResponse
                );

                console.log(
                    "📦 ManifestItems response.data:",
                    manifestItemResponse?.data
                );

                const loadedManifestItems =
                    normalizeItems(manifestItemResponse);

                console.log(
                    "📦 NORMALIZED ManifestItems:",
                    loadedManifestItems
                );

                if (!cancelled) {
                    setVehicles(
                        normalizeItems(vehicleResponse)
                    );

                    setEmployees(
                        normalizeItems(employeeResponse)
                    );

                    setRoutes(
                        normalizeItems(routeResponse)
                    );

                    setFacilities(
                        normalizeItems(facilityResponse)
                    );

                    setManifestItems(
                        loadedManifestItems
                    );
                }
            } catch (error) {
                console.error(
                    "❌ Failed to load manifest relation data:",
                    error
                );

                console.error(
                    "❌ HTTP status:",
                    error?.response?.status
                );

                console.error(
                    "❌ Response data:",
                    error?.response?.data
                );

                /*
                 * Do NOT automatically wipe manifestItems here.
                 * This makes it easier to see whether the request
                 * actually succeeded.
                 */
            }
        };

        loadRelationData();

        return () => {
            cancelled = true;
        };
    }, []);

    // =====================================================
    // FIND RELATION
    // =====================================================

    const findById = (
        items,
        id
    ) => {

        if (!id) {
            return null;
        }


        return items.find(
            item =>
                String(
                    getId(item)
                ).toLowerCase() ===
                String(
                    id
                ).toLowerCase()
        );

    };


    // =====================================================
    // FORM FIELDS
    // =====================================================

    const fieldConfig = [

        {
            name: "vehicleId",

            label: "Vehicle",

            type: "relation",

            required: true,

            service: vehicleService,

            valueField: "id",

            sortBy: "vehicleNumber",

            getOptionLabel:
                getVehicleLabel
        },


        {
            name: "driverId",

            label: "Driver",

            type: "relation",

            required: true,

            service: employeeService,

            valueField: "id",

            sortBy: "firstName",

            getOptionLabel:
                getEmployeeLabel
        },


        {
            name: "routeId",

            label: "Route",

            type: "relation",

            required: true,

            service: routeService,

            valueField: "id",

            sortBy: "routeCode",

            getOptionLabel:
                getRouteLabel
        },


        {
            name: "departureFacilityId",

            label: "Departure Facility",

            type: "relation",

            required: true,

            service: facilityService,

            valueField: "id",

            sortBy: "name",

            getOptionLabel:
                getFacilityLabel
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

            type: "textarea",

            required: false
        }

    ];


    // =====================================================
    // DISPLAY COLUMNS
    // =====================================================

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

            label: "Vehicle",

            render: (
                manifest
            ) => {

                const vehicle =
                    findById(
                        vehicles,
                        manifest.vehicleId
                    );


                return (

                    <>

                        <div className="crud-list-label">
                            Vehicle
                        </div>

                        <div className="crud-list-value">
                            {getVehicleLabel(
                                vehicle
                            )}
                        </div>

                    </>

                );

            }

        },


        {
            key: "driverId",

            label: "Driver",

            render: (
                manifest
            ) => {

                const employee =
                    findById(
                        employees,
                        manifest.driverId
                    );


                return (

                    <>

                        <div className="crud-list-label">
                            Driver
                        </div>

                        <div className="crud-list-value">
                            {getEmployeeLabel(
                                employee
                            )}
                        </div>

                    </>

                );

            }

        },


        {
            key: "routeId",

            label: "Route",

            render: (
                manifest
            ) => {

                const route =
                    findById(
                        routes,
                        manifest.routeId
                    );


                return (

                    <>

                        <div className="crud-list-label">
                            Route
                        </div>

                        <div className="crud-list-value">
                            {getRouteLabel(
                                route
                            )}
                        </div>

                    </>

                );

            }

        },


        {
            key: "departureFacilityId",

            label: "Departure Facility",

            render: (
                manifest
            ) => {

                const facility =
                    findById(
                        facilities,
                        manifest.departureFacilityId
                    );


                return (

                    <>

                        <div className="crud-list-label">
                            Departure Facility
                        </div>

                        <div className="crud-list-value">
                            {getFacilityLabel(
                                facility
                            )}
                        </div>

                    </>

                );

            }

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

            label: "Weight",

            render: (manifest) => {

                const manifestId = getId(manifest);

                const items = manifestItems.filter(
                    item =>
                        String(
                            item.manifestId ??
                            item.ManifestId
                        ).toLowerCase() ===
                        String(manifestId).toLowerCase()
                );

                console.log(
                    "MANIFEST:",
                    manifest
                );

                console.log(
                    "MANIFEST ID:",
                    manifestId
                );

                console.log(
                    "ALL MANIFEST ITEMS:",
                    manifestItems
                );

                console.log(
                    "ITEMS FOR THIS MANIFEST:",
                    items
                );

                const totalWeight = items.reduce(
                    (sum, item) =>
                        sum +
                        Number(
                            item.weight ??
                            item.Weight ??
                            0
                        ),
                    0
                );

                console.log(
                    "TOTAL WEIGHT:",
                    totalWeight
                );

                return `${totalWeight} kg`;
            }
        }

    ];


    // =====================================================
    // SORT OPTIONS
    // =====================================================

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


    // =====================================================
    // FILTER OPTIONS
    // =====================================================

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
                    value: "in_progress",

                    label: "In Progress"
                },


                {
                    value: "completed",

                    label: "Completed"
                },


                {
                    value: "delayed",

                    label: "Delayed"
                },


                {
                    value: "cancelled",

                    label: "Cancelled"
                }

            ]

        }

    ];


    // =====================================================
    // DETAILS BUTTON
    // =====================================================

    const extraActions = (manifest) => (
        <button
            type="button"
            className="crud-action-button"
            onClick={() => navigate(`/shipment-manifests/${getId(manifest)}`)}
        >
            Details
        </button>
    );


    // =====================================================
    // RENDER
    // =====================================================

    return (

        <GenericEntityPage

            entityName="Shipment Manifests"

            permissionPrefix="shipment_manifests"

            permissionScope="all"

            requirePermission={true}

            service={
                shipmentManifestService
            }

            fieldConfig={
                fieldConfig
            }

            displayColumns={
                displayColumns
            }

            sortOptions={
                sortOptions
            }

            filterOptions={
                filterOptions
            }

            extraActions={
                extraActions
            }

        />

    );

};


export default ShipmentManifestsPage;