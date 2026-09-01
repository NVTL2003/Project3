import React, {
    useEffect,
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


const RouteDetailsPage = () => {

    const {
        id
    } = useParams();

    const navigate =
        useNavigate();


    const [route, setRoute] =
        useState(null);

    const [stops, setStops] =
        useState([]);

    const [loading, setLoading] =
        useState(true);

    const [error, setError] =
        useState(null);


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
                    : data?.items || []
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
    // LOAD DATA
    // =========================================================

    useEffect(() => {

        const loadData = async () => {

            setLoading(true);
            setError(null);

            try {

                await Promise.all([
                    loadRoute(),
                    loadStops()
                ]);

            } finally {

                setLoading(false);

            }

        };

        loadData();

    }, [id]);


    // =========================================================
    // ACTIVATE
    // =========================================================

    const handleActivate = async () => {

        try {

            await routeService.activate(id);

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

        try {

            await routeService.deactivate(id);

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

                        {route.isActive ? (

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

                                {/* ORIGIN */}

                                <div>

                                    <strong>
                                        Origin
                                    </strong>

                                    <div>
                                        {route.originFacilityName ||
                                            route.originFacilityId}
                                    </div>

                                </div>


                                {/* STOPS */}

                                {stops
                                    .sort(
                                        (a, b) =>
                                            a.stopSequence -
                                            b.stopSequence
                                    )
                                    .map(stop => (

                                        <div
                                            key={stop.id}
                                            style={{
                                                marginTop: "20px",
                                                padding: "16px",
                                                border: "1px solid #ddd",
                                                borderRadius: "6px"
                                            }}
                                        >

                                            <strong>
                                                Stop{" "}
                                                {stop.stopSequence}
                                            </strong>

                                            <div>
                                                {stop.stopName}
                                            </div>

                                            <div>
                                                {stop.pincode ||
                                                    "No pincode"}
                                            </div>

                                            {stop.estimatedArrival != null && (

                                                <div>
                                                    Arrival:{" "}
                                                    {
                                                        stop.estimatedArrival
                                                    }
                                                </div>

                                            )}

                                            {stop.estimatedDeparture != null && (

                                                <div>
                                                    Departure:{" "}
                                                    {
                                                        stop.estimatedDeparture
                                                    }
                                                </div>

                                            )}

                                        </div>

                                    ))}


                                {/* DESTINATION */}

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