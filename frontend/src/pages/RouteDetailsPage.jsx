import React, {
    useEffect,
    useMemo,
    useState
} from "react";

import {
    useNavigate,
    useParams
} from "react-router-dom";

import { routeService }
    from "../services/routeService";

import { routeStopService }
    from "../services/routeStopService";

import { facilityService }
    from "../services/facilityService";

import {
    getPermissions,
    hasPermission
} from "../utils/permissionUtils";


const RouteDetailsPage = () => {

    const {
        id
    } = useParams();

    const navigate =
        useNavigate();


    // =========================================================
    // STATE
    // =========================================================

    const [route, setRoute] =
        useState(null);

    const [stops, setStops] =
        useState([]);

    const [facilities, setFacilities] =
        useState([]);

    const [loading, setLoading] =
        useState(true);

    const [error, setError] =
        useState(null);

    const [editingStopId, setEditingStopId] =
        useState(null);

    const [savingStop, setSavingStop] =
        useState(false);

    const [deletingStopId, setDeletingStopId] =
        useState(null);


    // =========================================================
    // STOP FORM
    // =========================================================

    const emptyStopForm = {
        facilityId: "",
        stopSequence: "",
        latitude: "",
        longitude: "",
        estimatedArrival: "",
        estimatedDeparture: "",
        isActive: true
    };


    const [stopForm, setStopForm] =
        useState(emptyStopForm);


    // =========================================================
    // PERMISSIONS
    // =========================================================

    const permissions =
        getPermissions();


    /*
     * These prefixes should match the same permission
     * resources used by your backend PermissionResourceMap.
     */

    const canReadRoute =
        hasPermission(
            permissions,
            "routes",
            "read",
            "all"
        );


    const canUpdateRoute =
        hasPermission(
            permissions,
            "routes",
            "update",
            "all"
        );


    const canCreateRouteStop =
        hasPermission(
            permissions,
            "route_stops",
            "create",
            "all"
        );


    const canUpdateRouteStop =
        hasPermission(
            permissions,
            "route_stops",
            "update",
            "all"
        );


    const canDeleteRouteStop =
        hasPermission(
            permissions,
            "route_stops",
            "delete",
            "all"
        );


    // =========================================================
    // LOAD ROUTE
    // =========================================================

    const loadRoute = async () => {

        try {

            const response =
                await routeService.getById(id);

            setRoute(
                response.data
            );

        } catch (err) {

            console.error(
                "Failed to load route:",
                err
            );

            setError(
                err.response?.data?.message ||
                "Failed to load route."
            );
        }
    };


    // =========================================================
    // LOAD STOPS
    // =========================================================

    const loadStops = async () => {

        try {

            const response =
                await routeService.getStops(id);

            const data =
                response.data;


            setStops(
                Array.isArray(data)
                    ? data
                    : data?.items ||
                      data?.Items ||
                      []
            );

        } catch (err) {

            console.error(
                "Failed to load route stops:",
                err
            );

            setError(
                err.response?.data?.message ||
                "Failed to load route stops."
            );
        }
    };


    // =========================================================
    // LOAD FACILITIES
    // =========================================================

    const loadFacilities = async () => {

        try {

            const response =
                await facilityService.getPaged({
                    page: 1,
                    pageSize: 1000
                });


            const data =
                response.data;


            setFacilities(
                Array.isArray(data)
                    ? data
                    : data?.items ||
                      data?.Items ||
                      []
            );

        } catch (err) {

            console.error(
                "Failed to load facilities:",
                err
            );

            setError(
                err.response?.data?.message ||
                "Failed to load facilities."
            );
        }
    };


    // =========================================================
    // LOAD DATA
    // =========================================================

    useEffect(() => {

        const loadData = async () => {

            setLoading(true);
            setError(null);


            try {

                /*
                 * Do not call the API if the user cannot
                 * read routes.
                 */

                if (!canReadRoute) {
                    return;
                }


                await Promise.all([
                    loadRoute(),
                    loadStops(),
                    loadFacilities()
                ]);

            } finally {

                setLoading(false);
            }
        };


        loadData();

    }, [
        id,
        canReadRoute
    ]);


    // =========================================================
    // AVAILABLE FACILITIES
    // =========================================================

    const availableFacilities =
        useMemo(() => {

            if (!Array.isArray(facilities)) {
                return [];
            }


            const originId =
                route?.originFacilityId ??
                route?.OriginFacilityId;

            const destinationId =
                route?.destinationFacilityId ??
                route?.DestinationFacilityId;


            return facilities.filter(
                facility => {

                    const facilityId =
                        facility.id ??
                        facility.Id;


                    /*
                     * Origin cannot be an intermediate stop.
                     */

                    if (
                        originId &&
                        String(facilityId).toLowerCase() ===
                        String(originId).toLowerCase()
                    ) {
                        return false;
                    }


                    /*
                     * Destination cannot be an intermediate stop.
                     */

                    if (
                        destinationId &&
                        String(facilityId).toLowerCase() ===
                        String(destinationId).toLowerCase()
                    ) {
                        return false;
                    }


                    /*
                     * When editing, allow the current
                     * facility to remain selected.
                     */

                    const isCurrentEditingFacility =
                        editingStopId &&
                        stops.some(stop => {

                            const stopId =
                                stop.id ??
                                stop.Id;

                            const stopFacilityId =
                                stop.facilityId ??
                                stop.FacilityId;


                            return (
                                String(stopId).toLowerCase() ===
                                String(editingStopId).toLowerCase() &&

                                String(stopFacilityId).toLowerCase() ===
                                String(facilityId).toLowerCase()
                            );
                        });


                    if (isCurrentEditingFacility) {
                        return true;
                    }


                    /*
                     * Do not allow duplicate facilities.
                     */

                    const alreadyUsed =
                        stops.some(stop => {

                            const stopId =
                                stop.id ??
                                stop.Id;

                            const stopFacilityId =
                                stop.facilityId ??
                                stop.FacilityId;


                            if (
                                editingStopId &&
                                String(stopId).toLowerCase() ===
                                String(editingStopId).toLowerCase()
                            ) {
                                return false;
                            }


                            return (
                                String(stopFacilityId).toLowerCase() ===
                                String(facilityId).toLowerCase()
                            );
                        });


                    return !alreadyUsed;
                }
            );

        }, [
            facilities,
            route,
            stops,
            editingStopId
        ]);


    // =========================================================
    // HANDLE STOP FORM CHANGE
    // =========================================================

    const handleStopChange = (
        event
    ) => {

        const {
            name,
            value,
            type,
            checked
        } = event.target;


        setStopForm(
            previous => ({
                ...previous,

                [name]:
                    type === "checkbox"
                        ? checked
                        : value
            })
        );
    };


    // =========================================================
    // RESET STOP FORM
    // =========================================================

    const resetStopForm = () => {

        setStopForm(
            emptyStopForm
        );

        setEditingStopId(
            null
        );
    };


    // =========================================================
    // EDIT STOP
    // =========================================================

    const handleEditStop = (
        stop
    ) => {

        if (!canUpdateRouteStop) {

            setError(
                "You do not have permission to update route stops."
            );

            return;
        }


        const stopId =
            stop.id ??
            stop.Id;


        setEditingStopId(
            stopId
        );


        setStopForm({

            facilityId:
                stop.facilityId ??
                stop.FacilityId ??
                "",

            stopSequence:
                stop.stopSequence ??
                stop.StopSequence ??
                "",

            latitude:
                stop.latitude ??
                stop.Latitude ??
                "",

            longitude:
                stop.longitude ??
                stop.Longitude ??
                "",

            estimatedArrival:
                stop.estimatedArrival ??
                stop.EstimatedArrival ??
                "",

            estimatedDeparture:
                stop.estimatedDeparture ??
                stop.EstimatedDeparture ??
                "",

            isActive:
                stop.isActive ??
                stop.IsActive ??
                true
        });


        window.scrollTo({
            top: 0,
            behavior: "smooth"
        });
    };


    // =========================================================
    // SAVE STOP
    // =========================================================

    const handleSaveStop = async (
        event
    ) => {

        event.preventDefault();


        /*
         * Permission check
         */

        if (
            editingStopId &&
            !canUpdateRouteStop
        ) {

            setError(
                "You do not have permission to update route stops."
            );

            return;
        }


        if (
            !editingStopId &&
            !canCreateRouteStop
        ) {

            setError(
                "You do not have permission to create route stops."
            );

            return;
        }


        /*
         * Validation
         */

        if (!stopForm.facilityId) {

            setError(
                "Please select a facility."
            );

            return;
        }


        if (
            stopForm.stopSequence === "" ||
            Number(stopForm.stopSequence) < 1
        ) {

            setError(
                "Stop sequence must be at least 1."
            );

            return;
        }


        if (
            stopForm.estimatedArrival !== "" &&
            Number(stopForm.estimatedArrival) < 0
        ) {

            setError(
                "Estimated arrival cannot be negative."
            );

            return;
        }


        if (
            stopForm.estimatedDeparture !== "" &&
            Number(stopForm.estimatedDeparture) < 0
        ) {

            setError(
                "Estimated departure cannot be negative."
            );

            return;
        }


        if (
            stopForm.estimatedArrival !== "" &&
            stopForm.estimatedDeparture !== "" &&
            Number(stopForm.estimatedDeparture) <
            Number(stopForm.estimatedArrival)
        ) {

            setError(
                "Estimated departure cannot be earlier than estimated arrival."
            );

            return;
        }


        setSavingStop(true);
        setError(null);


        try {

            const payload = {

                routeId:
                    id,

                stopSequence:
                    Number(
                        stopForm.stopSequence
                    ),

                facilityId:
                    stopForm.facilityId,

                latitude:
                    stopForm.latitude !== ""
                        ? Number(
                            stopForm.latitude
                        )
                        : null,

                longitude:
                    stopForm.longitude !== ""
                        ? Number(
                            stopForm.longitude
                        )
                        : null,

                estimatedArrival:
                    stopForm.estimatedArrival !== ""
                        ? Number(
                            stopForm.estimatedArrival
                        )
                        : null,

                estimatedDeparture:
                    stopForm.estimatedDeparture !== ""
                        ? Number(
                            stopForm.estimatedDeparture
                        )
                        : null,

                isActive:
                    stopForm.isActive
            };


            if (editingStopId) {

                await routeStopService.update(
                    editingStopId,
                    payload
                );

            } else {

                await routeStopService.create(
                    payload
                );
            }


            await loadStops();

            resetStopForm();

        } catch (err) {

            console.error(
                "Failed to save route stop:",
                err
            );

            setError(
                err.response?.data?.message ||
                err.response?.data?.title ||
                "Failed to save route stop."
            );

        } finally {

            setSavingStop(false);
        }
    };


    // =========================================================
    // DELETE STOP
    // =========================================================

    const handleDeleteStop = async (
        stop
    ) => {

        if (!canDeleteRouteStop) {

            setError(
                "You do not have permission to delete route stops."
            );

            return;
        }


        const stopId =
            stop.id ??
            stop.Id;


        if (!stopId) {

            setError(
                "Cannot delete route stop: invalid ID."
            );

            return;
        }


        const stopName =
            stop.stopName ??
            stop.StopName ??
            "this route stop";


        const confirmed =
            window.confirm(
                `Are you sure you want to delete "${stopName}" ? `
            );


        if (!confirmed) {
            return;
        }


        setDeletingStopId(
            stopId
        );

        setError(null);


        try {

            await routeStopService.delete(
                stopId
            );


            await loadStops();


            if (
                editingStopId &&
                String(editingStopId).toLowerCase() ===
                String(stopId).toLowerCase()
            ) {

                resetStopForm();
            }

        } catch (err) {

            console.error(
                "Failed to delete route stop:",
                err
            );

            setError(
                err.response?.data?.message ||
                err.response?.data?.title ||
                "Failed to delete route stop."
            );

        } finally {

            setDeletingStopId(
                null
            );
        }
    };


    // =========================================================
    // ACTIVATE
    // =========================================================

    const handleActivate = async () => {

        if (!canUpdateRoute) {

            setError(
                "You do not have permission to update routes."
            );

            return;
        }


        try {

            setError(null);

            await routeService.activate(
                id
            );

            await loadRoute();

        } catch (err) {

            console.error(
                "Failed to activate route:",
                err
            );

            setError(
                err.response?.data?.message ||
                "Failed to activate route."
            );
        }
    };


    // =========================================================
    // DEACTIVATE
    // =========================================================

    const handleDeactivate = async () => {

        if (!canUpdateRoute) {

            setError(
                "You do not have permission to update routes."
            );

            return;
        }


        try {

            setError(null);

            await routeService.deactivate(
                id
            );

            await loadRoute();

        } catch (err) {

            console.error(
                "Failed to deactivate route:",
                err
            );

            setError(
                err.response?.data?.message ||
                "Failed to deactivate route."
            );
        }
    };


    // =========================================================
    // LOADING
    // =========================================================

    if (loading) {

        return (

            <div className="crud-page">

                <div className="crud-container">

                    <h1>
                        Route Details
                    </h1>

                    <p>
                        Loading route...
                    </p>

                </div>

            </div>
        );
    }


    // =========================================================
    // READ PERMISSION
    // =========================================================

    if (!canReadRoute) {

        return (

            <div className="crud-page">

                <div className="crud-container">

                    <h1>
                        Access Denied
                    </h1>

                    <p>
                        You do not have permission
                        to view routes.
                    </p>

                    <button
                        className="crud-button"
                        onClick={() =>
                            navigate("/routes")
                        }
                    >
                        Back to Routes
                    </button>

                </div>

            </div>
        );
    }


    // =========================================================
    // NOT FOUND
    // =========================================================

    if (!route) {

        return (

            <div className="crud-page">

                <div className="crud-container">

                    <h1>
                        Route Not Found
                    </h1>

                    <button
                        onClick={() =>
                            navigate("/routes")
                        }
                    >
                        Back to Routes
                    </button>

                </div>

            </div>
        );
    }


    // =========================================================
    // UI
    // =========================================================

    return (

        <div className="crud-page">

            <div className="crud-container">


                {/* ================================================= */}
                {/* HEADER */}
                {/* ================================================= */}

                <div className="crud-header">

                    <div>

                        <button
                            onClick={() =>
                                navigate("/routes")
                            }
                        >
                            ← Back to Routes
                        </button>

                        <h1 className="crud-title">

                            {route.routeCode}

                        </h1>

                        <p className="crud-subtitle">

                            {route.name}

                        </p>

                    </div>


                    <div>

                        {canUpdateRoute && (

                            route.isActive ? (

                                <button
                                    className="crud-button"
                                    onClick={
                                        handleDeactivate
                                    }
                                >
                                    Deactivate
                                </button>

                            ) : (

                                <button
                                    className="crud-button crud-button-primary"
                                    onClick={
                                        handleActivate
                                    }
                                >
                                    Activate
                                </button>

                            )

                        )}

                    </div>

                </div>


                {/* ================================================= */}
                {/* ERROR */}
                {/* ================================================= */}

                {error && (

                    <div
                        style={{
                            marginBottom: "20px",
                            padding: "12px",
                            background: "#ffebee",
                            color: "#c62828",
                            borderRadius: "6px"
                        }}
                    >
                        {error}
                    </div>

                )}


                {/* ================================================= */}
                {/* ROUTE INFORMATION */}
                {/* ================================================= */}

                <div className="crud-table-card">

                    <div
                        style={{
                            padding: "24px"
                        }}
                    >

                        <h2>
                            Route Information
                        </h2>

                        <p>
                            <strong>
                                Route Code:
                            </strong>{" "}
                            {route.routeCode}
                        </p>

                        <p>
                            <strong>
                                Name:
                            </strong>{" "}
                            {route.name}
                        </p>

                        <p>
                            <strong>
                                Origin:
                            </strong>{" "}
                            {route.originFacilityName ||
                                route.originFacilityId}
                        </p>

                        <p>
                            <strong>
                                Destination:
                            </strong>{" "}
                            {route.destinationFacilityName ||
                                route.destinationFacilityId}
                        </p>

                        <p>
                            <strong>
                                Distance:
                            </strong>{" "}
                            {route.distance}
                        </p>

                        <p>
                            <strong>
                                Estimated Duration:
                            </strong>{" "}
                            {route.estimatedDuration ??
                                "N/A"}{" "}
                            minutes
                        </p>

                        <p>
                            <strong>
                                Status:
                            </strong>{" "}
                            {route.isActive
                                ? "Active"
                                : "Inactive"}
                        </p>

                    </div>

                </div>


                {/* ================================================= */}
                {/* ADD / EDIT ROUTE STOP */}
                {/* ================================================= */}

                {(canCreateRouteStop ||
                    (
                        editingStopId &&
                        canUpdateRouteStop
                    )) && (

                    <div
                        className="crud-table-card"
                        style={{
                            marginTop: "20px"
                        }}
                    >

                        <div
                            style={{
                                padding: "24px"
                            }}
                        >

                            <h2>

                                {editingStopId
                                    ? "Edit Route Stop"
                                    : "Add Route Stop"}

                            </h2>


                            <form
                                onSubmit={
                                    handleSaveStop
                                }
                            >

                                <div
                                    style={{
                                        display: "grid",
                                        gridTemplateColumns:
                                            "repeat(auto-fit, minmax(220px, 1fr))",
                                        gap: "16px"
                                    }}
                                >


                                    {/* FACILITY */}

                                    <div>

                                        <label>
                                            Facility
                                        </label>

                                        <select
                                            name="facilityId"
                                            value={
                                                stopForm.facilityId
                                            }
                                            onChange={
                                                handleStopChange
                                            }
                                            required
                                            style={{
                                                width: "100%",
                                                padding: "8px"
                                            }}
                                        >

                                            <option value="">
                                                Select facility
                                            </option>


                                            {availableFacilities.map(
                                                facility => {

                                                    const facilityId =
                                                        facility.id ??
                                                        facility.Id;

                                                    const facilityName =
                                                        facility.name ??
                                                        facility.Name ??
                                                        facility.code ??
                                                        facility.Code ??
                                                        facilityId;


                                                    return (

                                                        <option
                                                            key={
                                                                facilityId
                                                            }
                                                            value={
                                                                facilityId
                                                            }
                                                        >
                                                            {facilityName}
                                                        </option>

                                                    );

                                                }
                                            )}

                                        </select>

                                    </div>


                                    {/* SEQUENCE */}

                                    <div>

                                        <label>
                                            Stop Sequence
                                        </label>

                                        <input
                                            type="number"
                                            name="stopSequence"
                                            min="1"
                                            value={
                                                stopForm.stopSequence
                                            }
                                            onChange={
                                                handleStopChange
                                            }
                                            required
                                            style={{
                                                width: "100%",
                                                padding: "8px"
                                            }}
                                        />

                                    </div>


                                    {/* LATITUDE */}

                                    <div>

                                        <label>
                                            Latitude
                                        </label>

                                        <input
                                            type="number"
                                            step="any"
                                            name="latitude"
                                            value={
                                                stopForm.latitude
                                            }
                                            onChange={
                                                handleStopChange
                                            }
                                            style={{
                                                width: "100%",
                                                padding: "8px"
                                            }}
                                        />

                                    </div>


                                    {/* LONGITUDE */}

                                    <div>

                                        <label>
                                            Longitude
                                        </label>

                                        <input
                                            type="number"
                                            step="any"
                                            name="longitude"
                                            value={
                                                stopForm.longitude
                                            }
                                            onChange={
                                                handleStopChange
                                            }
                                            style={{
                                                width: "100%",
                                                padding: "8px"
                                            }}
                                        />

                                    </div>


                                    {/* ARRIVAL */}

                                    <div>

                                        <label>
                                            Estimated Arrival
                                        </label>

                                        <input
                                            type="number"
                                            min="0"
                                            name="estimatedArrival"
                                            value={
                                                stopForm.estimatedArrival
                                            }
                                            onChange={
                                                handleStopChange
                                            }
                                            placeholder="Minutes"
                                            style={{
                                                width: "100%",
                                                padding: "8px"
                                            }}
                                        />

                                    </div>


                                    {/* DEPARTURE */}

                                    <div>

                                        <label>
                                            Estimated Departure
                                        </label>

                                        <input
                                            type="number"
                                            min="0"
                                            name="estimatedDeparture"
                                            value={
                                                stopForm.estimatedDeparture
                                            }
                                            onChange={
                                                handleStopChange
                                            }
                                            placeholder="Minutes"
                                            style={{
                                                width: "100%",
                                                padding: "8px"
                                            }}
                                        />

                                    </div>


                                    {/* ACTIVE */}

                                    {editingStopId && (

                                        <div>

                                            <label>

                                                <input
                                                    type="checkbox"
                                                    name="isActive"
                                                    checked={
                                                        stopForm.isActive
                                                    }
                                                    onChange={
                                                        handleStopChange
                                                    }
                                                />

                                                {" "}
                                                Active

                                            </label>

                                        </div>

                                    )}

                                </div>


                                {/* FORM BUTTONS */}

                                <div
                                    style={{
                                        marginTop: "20px",
                                        display: "flex",
                                        gap: "10px"
                                    }}
                                >

                                    <button
                                        type="submit"
                                        className="crud-button crud-button-primary"
                                        disabled={
                                            savingStop
                                        }
                                    >

                                        {savingStop
                                            ? "Saving..."
                                            : editingStopId
                                                ? "Update Stop"
                                                : "Add Stop"}

                                    </button>


                                    {editingStopId && (

                                        <button
                                            type="button"
                                            className="crud-button"
                                            onClick={
                                                resetStopForm
                                            }
                                            disabled={
                                                savingStop
                                            }
                                        >
                                            Cancel
                                        </button>

                                    )}

                                </div>

                            </form>

                        </div>

                    </div>

                )}


                {/* ================================================= */}
                {/* ROUTE PATH */}
                {/* ================================================= */}

                <div
                    className="crud-table-card"
                    style={{
                        marginTop: "20px"
                    }}
                >

                    <div
                        style={{
                            padding: "24px"
                        }}
                    >

                        <h2>
                            Route Stops
                        </h2>


                        {stops.length === 0 ? (

                            <p>
                                No intermediate stops configured.
                            </p>

                        ) : (

                            <div>

                                {/* ================================================= */}
                                {/* ORIGIN */}
                                {/* ================================================= */}

                                <div>

                                    <strong>
                                        Origin
                                    </strong>

                                    <div>

                                        {route.originFacilityName ||
                                            route.originFacilityId}

                                    </div>

                                </div>


                                {/* ================================================= */}
                                {/* STOPS */}
                                {/* ================================================= */}

                                {stops
                                    .slice()
                                    .sort(
                                        (a, b) =>
                                            Number(
                                                a.stopSequence ??
                                                a.StopSequence ??
                                                0
                                            ) -
                                            Number(
                                                b.stopSequence ??
                                                b.StopSequence ??
                                                0
                                            )
                                    )
                                    .map(
                                        stop => {

                                            const stopId =
                                                stop.id ??
                                                stop.Id;

                                            const stopSequence =
                                                stop.stopSequence ??
                                                stop.StopSequence;

                                            const stopName =
                                                stop.stopName ??
                                                stop.StopName;

                                            const pincode =
                                                stop.pincode ??
                                                stop.Pincode;

                                            const arrival =
                                                stop.estimatedArrival ??
                                                stop.EstimatedArrival;

                                            const departure =
                                                stop.estimatedDeparture ??
                                                stop.EstimatedDeparture;


                                            return (

                                                <div
                                                    key={
                                                        stopId
                                                    }
                                                    style={{
                                                        marginTop: "20px",
                                                        padding: "16px",
                                                        border: "1px solid #ddd",
                                                        borderRadius: "6px"
                                                    }}
                                                >

                                                    <strong>
                                                        Stop{" "}
                                                        {stopSequence}
                                                    </strong>


                                                    <div>
                                                        {stopName}
                                                    </div>


                                                    <div>
                                                        {pincode ||
                                                            "No pincode"}
                                                    </div>


                                                    {arrival != null && (

                                                        <div>

                                                            Arrival:{" "}
                                                            {arrival}

                                                        </div>

                                                    )}


                                                    {departure != null && (

                                                        <div>

                                                            Departure:{" "}
                                                            {departure}

                                                        </div>

                                                    )}


                                                    {/* ================================================= */}
                                                    {/* STOP ACTIONS */}
                                                    {/* ================================================= */}

                                                    {(canUpdateRouteStop ||
                                                        canDeleteRouteStop) && (

                                                        <div
                                                            style={{
                                                                marginTop: "12px",
                                                                display: "flex",
                                                                gap: "8px"
                                                            }}
                                                        >

                                                            {canUpdateRouteStop && (

                                                                <button
                                                                    className="crud-button"
                                                                    onClick={() =>
                                                                        handleEditStop(
                                                                            stop
                                                                        )
                                                                    }
                                                                >
                                                                    Edit
                                                                </button>

                                                            )}


                                                            {canDeleteRouteStop && (

                                                                <button
                                                                    className="crud-button"
                                                                    onClick={() =>
                                                                        handleDeleteStop(
                                                                            stop
                                                                        )
                                                                    }
                                                                    disabled={
                                                                        deletingStopId ===
                                                                        stopId
                                                                    }
                                                                >

                                                                    {deletingStopId ===
                                                                    stopId
                                                                        ? "Deleting..."
                                                                        : "Delete"}

                                                                </button>

                                                            )}

                                                        </div>

                                                    )}

                                                </div>

                                            );

                                        }
                                    )}


                                {/* ================================================= */}
                                {/* DESTINATION */}
                                {/* ================================================= */}

                                <div
                                    style={{
                                        marginTop: "20px"
                                    }}
                                >

                                    <strong>
                                        Destination
                                    </strong>

                                    <div>

                                        {route.destinationFacilityName ||
                                            route.destinationFacilityId}

                                    </div>

                                </div>

                            </div>

                        )}

                    </div>

                </div>

            </div>

        </div>
    );
};


export default RouteDetailsPage;