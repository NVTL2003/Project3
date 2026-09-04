import React, {
    useEffect,
    useState
} from "react";

import {
    useNavigate,
    useParams
} from "react-router-dom";

import { shipmentManifestService }
    from "../services/shipmentManifestService";

import { manifestItemService }
    from "../services/manifestItemService";

import { transportOrderService }
    from "../services/transportOrderService";

import { shipmentService }
    from "../services/shipmentService";

import { vehicleService }
    from "../services/vehicleService";

import { employeeService }
    from "../services/employeeService";

import { routeService }
    from "../services/routeService";

import { facilityService }
    from "../services/facilityService";


const ShipmentManifestDetailsPage = () => {

    const {
        id
    } = useParams();

    const navigate =
        useNavigate();


    // =========================================================
    // STATE
    // =========================================================

    const [manifest, setManifest] =
        useState(null);

    const [manifestItems, setManifestItems] =
        useState([]);

    const [transportOrders, setTransportOrders] =
        useState([]);

    const [shipments, setShipments] =
        useState([]);

    const [vehicles, setVehicles] =
        useState([]);

    const [employees, setEmployees] =
        useState([]);

    const [routes, setRoutes] =
        useState([]);

    const [facilities, setFacilities] =
        useState([]);


    const [selectedTransportOrder, setSelectedTransportOrder] =
        useState("");

    const [weight, setWeight] =
        useState("");

    const [loadingSequence, setLoadingSequence] =
        useState("");

    const [notes, setNotes] =
        useState("");


    const [loading, setLoading] =
        useState(true);

    const [adding, setAdding] =
        useState(false);

    const [error, setError] =
        useState(null);


    // =========================================================
    // HELPERS
    // =========================================================

    const getId = (item) =>
        item?.id ??
        item?.Id;


    const getNumber = (item) =>
        item?.transportOrderNumber ??
        item?.TransportOrderNumber ??
        item?.orderNumber ??
        item?.OrderNumber ??
        item?.transportOrderCode ??
        item?.TransportOrderCode ??
        item?.code ??
        item?.Code ??
        "N/A";


    const getWeight = (item) =>
        Number(
            item?.weight ??
            item?.Weight ??
            item?.totalWeight ??
            item?.TotalWeight ??
            0
        );


    const getCapacity = (vehicle) =>
        Number(
            vehicle?.capacity ??
            vehicle?.Capacity ??
            vehicle?.capacityKg ??
            vehicle?.CapacityKg ??
            vehicle?.maxCapacity ??
            vehicle?.MaxCapacity ??
            0
        );


    const getShipment = (transportOrder) => {

        if (!transportOrder) {
            return null;
        }

        const shipmentId =
            transportOrder.shipmentId ??
            transportOrder.ShipmentId;

        return shipments.find(
            shipment =>
                String(getId(shipment)).toLowerCase() ===
                String(shipmentId).toLowerCase()
        );
    };


    const getTrackingNumber = (shipment) =>
        shipment?.trackingNumber ??
        shipment?.TrackingNumber ??
        "N/A";


    // =========================================================
    // LOAD MANIFEST
    // =========================================================

    const loadManifest = async () => {

        try {

            const response =
                await shipmentManifestService.getById(id);

            setManifest(
                response.data
            );

        } catch (err) {

            console.error(
                "Failed to load manifest:",
                err
            );

            setError(
                err.response?.data?.message ||
                "Failed to load shipment manifest."
            );

        }
    };


    // =========================================================
    // LOAD MANIFEST ITEMS
    // =========================================================

    const loadManifestItems = async () => {

        try {

            const response =
                await manifestItemService.getPaged({
                    page: 1,
                    pageSize: 1000
                });

            const data =
                response.data;

            const items =
                Array.isArray(data)
                    ? data
                    : data?.items ||
                      data?.Items ||
                      [];


            const filtered =
                items.filter(item => {

                    const manifestId =
                        item.manifestId ??
                        item.ManifestId;

                    return String(manifestId).toLowerCase() ===
                        String(id).toLowerCase();

                });


            setManifestItems(
                filtered
            );

        } catch (err) {

            console.error(
                "Failed to load manifest items:",
                err
            );

            setError(
                err.response?.data?.message ||
                "Failed to load manifest items."
            );

        }
    };


    // =========================================================
    // LOAD TRANSPORT ORDERS
    // =========================================================

    const loadTransportOrders = async () => {

        try {

            const response =
                await transportOrderService.getPaged({
                    page: 1,
                    pageSize: 1000
                });

            const data =
                response.data;

            setTransportOrders(
                Array.isArray(data)
                    ? data
                    : data?.items ||
                      data?.Items ||
                      []
            );

        } catch (err) {

            console.error(
                "Failed to load transport orders:",
                err
            );

            setError(
                err.response?.data?.message ||
                "Failed to load transport orders."
            );

        }
    };


    // =========================================================
    // LOAD SHIPMENTS
    // =========================================================

    const loadShipments = async () => {

        try {

            const response =
                await shipmentService.getPaged({
                    page: 1,
                    pageSize: 1000
                });

            const data =
                response.data;

            setShipments(
                Array.isArray(data)
                    ? data
                    : data?.items ||
                      data?.Items ||
                      []
            );

        } catch (err) {

            console.error(
                "Failed to load shipments:",
                err
            );

        }
    };


    // =========================================================
    // LOAD VEHICLES
    // =========================================================

    const loadVehicles = async () => {

        try {

            const response =
                await vehicleService.getPaged({
                    page: 1,
                    pageSize: 1000
                });

            const data =
                response.data;

            setVehicles(
                Array.isArray(data)
                    ? data
                    : data?.items ||
                      data?.Items ||
                      []
            );

        } catch (err) {

            console.error(
                "Failed to load vehicles:",
                err
            );

        }
    };


    // =========================================================
    // LOAD EMPLOYEES
    // =========================================================

    const loadEmployees = async () => {

        try {

            const response =
                await employeeService.getPaged({
                    page: 1,
                    pageSize: 1000
                });

            const data =
                response.data;

            setEmployees(
                Array.isArray(data)
                    ? data
                    : data?.items ||
                      data?.Items ||
                      []
            );

        } catch (err) {

            console.error(
                "Failed to load employees:",
                err
            );

        }
    };


    // =========================================================
    // LOAD ROUTES
    // =========================================================

    const loadRoutes = async () => {

        try {

            const response =
                await routeService.getPaged({
                    page: 1,
                    pageSize: 1000
                });

            const data =
                response.data;

            setRoutes(
                Array.isArray(data)
                    ? data
                    : data?.items ||
                      data?.Items ||
                      []
            );

        } catch (err) {

            console.error(
                "Failed to load routes:",
                err
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
                    loadManifest(),
                    loadManifestItems(),
                    loadTransportOrders(),
                    loadShipments(),
                    loadVehicles(),
                    loadEmployees(),
                    loadRoutes(),
                    loadFacilities()
                ]);

            } finally {

                setLoading(false);

            }

        };

        loadData();

    }, [id]);


    // =========================================================
    // RELATED DATA
    // =========================================================

    const vehicle =
        vehicles.find(
            item =>
                String(getId(item)).toLowerCase() ===
                String(
                    manifest?.vehicleId ??
                    manifest?.VehicleId
                ).toLowerCase()
        );


    const driver =
        employees.find(
            item =>
                String(getId(item)).toLowerCase() ===
                String(
                    manifest?.driverId ??
                    manifest?.DriverId
                ).toLowerCase()
        );


    const route =
        routes.find(
            item =>
                String(getId(item)).toLowerCase() ===
                String(
                    manifest?.routeId ??
                    manifest?.RouteId
                ).toLowerCase()
        );


    const departureFacility =
        facilities.find(
            item =>
                String(getId(item)).toLowerCase() ===
                String(
                    manifest?.departureFacilityId ??
                    manifest?.DepartureFacilityId
                ).toLowerCase()
        );


    // =========================================================
    // CAPACITY
    // =========================================================

    const vehicleCapacity =
        getCapacity(vehicle);


    const currentWeight =
        manifestItems.reduce(
            (total, item) =>
                total +
                Number(
                    item.weight ??
                    item.Weight ??
                    0
                ),
            0
        );


    const remainingCapacity =
        Math.max(
            0,
            vehicleCapacity -
            currentWeight
        );


    // =========================================================
    // DUPLICATE TRANSPORT ORDERS
    // =========================================================

    const addedTransportOrderIds =
        manifestItems.map(
            item =>
                String(
                    item.transportOrderId ??
                    item.TransportOrderId
                ).toLowerCase()
        );


    const availableTransportOrders =
        transportOrders.filter(order => {
            const orderId =
                String(getId(order)).toLowerCase();

            const orderWeight =
                getWeight(order);

            const alreadyAdded =
                addedTransportOrderIds.includes(
                    orderId
                );

            return (
                !alreadyAdded &&
                orderWeight > 0
            );
        });



    // =========================================================
    // SELECTED TRANSPORT ORDER
    // =========================================================

    const selectedOrder =
        transportOrders.find(
            order =>
                String(
                    getId(order)
                ).toLowerCase() ===
                String(
                    selectedTransportOrder
                ).toLowerCase()
        );


    const selectedShipment =
        getShipment(
            selectedOrder
        );


    const transportOrderWeight =
        selectedOrder
            ? getWeight(selectedOrder)
            : 0;


    // =========================================================
    // SELECT TRANSPORT ORDER
    // =========================================================

    const handleTransportOrderChange =
        (event) => {

            const value =
                event.target.value;

            setSelectedTransportOrder(
                value
            );


            const order =
                transportOrders.find(
                    item =>
                        String(
                            getId(item)
                        ).toLowerCase() ===
                        String(value).toLowerCase()
                );


            if (order) {

                const orderWeight =
                    getWeight(order);

                setWeight(
                    orderWeight > 0
                        ? orderWeight.toFixed(2)
                        : ""
                );

            } else {

                setWeight("");

            }

        };


    // =========================================================
    // ADD TRANSPORT ORDER
    // =========================================================

    const handleAddTransportOrder =
        async (event) => {

            event.preventDefault();

            setError(null);


            if (!selectedTransportOrder) {

                setError(
                    "Please select a transport order."
                );

                return;
            }


            if (
                addedTransportOrderIds.includes(
                    String(
                        selectedTransportOrder
                    ).toLowerCase()
                )
            ) {

                setError(
                    "This transport order is already assigned to this manifest."
                );

                return;
            }


            const weightValue =
                Number(weight);


            if (
                !weight ||
                weightValue <= 0
            ) {

                setError(
                    "Weight must be greater than 0."
                );

                return;
            }


            if (
                transportOrderWeight > 0 &&
                weightValue >
                    transportOrderWeight
            ) {

                setError(
                    `Weight cannot exceed the transport order weight of ${ transportOrderWeight } kg.`
                );

                return;
            }


            if (
                vehicleCapacity > 0 &&
                weightValue >
                    remainingCapacity
            ) {

                setError(
                    `Weight exceeds the remaining vehicle capacity of ${ remainingCapacity.toFixed(2) } kg.`
                );

                return;
            }


            const sequence =
                Number(
                    loadingSequence
                );


            if (
                !sequence ||
                sequence < 1
            ) {

                setError(
                    "Loading sequence must be greater than 0."
                );

                return;
            }


            try {

                setAdding(true);


                const payload = {

                    manifestId:
                        id,

                    transportOrderId:
                        selectedTransportOrder,

                    weight:
                        weightValue,

                    loadingSequence:
                        sequence,

                    notes:
                        notes.trim() ||
                        null

                };


                console.log(
                    "Creating ManifestItem:",
                    payload
                );


                await manifestItemService.create(
                    payload
                );


                // Reload items
                await loadManifestItems();


                // Reset form
                setSelectedTransportOrder("");
                setWeight("");
                setNotes("");


                const nextSequence =
                    manifestItems.length + 1;

                setLoadingSequence(
                    String(nextSequence)
                );


            } catch (err) {

                console.error(
                    "Failed to add transport order:",
                    err
                );


                const message =
                    err.response?.data?.message ||
                    err.response?.data?.title ||
                    "Failed to add transport order to manifest.";


                if (
                    message
                        .toLowerCase()
                        .includes("duplicate")
                ) {

                    setError(
                        "This transport order is already assigned to this manifest."
                    );

                } else {

                    setError(
                        message
                    );

                }

            } finally {

                setAdding(false);

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
                        Shipment Manifest Details
                    </h1>

                    <p>
                        Loading manifest...
                    </p>

                </div>

            </div>

        );

    }


    // =========================================================
    // NOT FOUND
    // =========================================================

    if (!manifest) {

        return (

            <div className="crud-page">

                <div className="crud-container">

                    <h1>
                        Manifest Not Found
                    </h1>

                    <button
                        onClick={() =>
                            navigate(
                                "/shipment-manifests"
                            )
                        }
                    >
                        Back to Shipment Manifests
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
                                navigate(
                                    "/shipment-manifests"
                                )
                            }
                        >
                            ← Back to Shipment Manifests
                        </button>


                        <h1 className="crud-title">

                            {
                                manifest.manifestNumber ??
                                manifest.ManifestNumber
                            }

                        </h1>


                        <p className="crud-subtitle">

                            Status:{" "}

                            {
                                manifest.status ??
                                manifest.Status ??
                                "Planned"
                            }

                        </p>

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
                {/* MANIFEST INFORMATION */}
                {/* ================================================= */}

                <div className="crud-table-card">

                    <div
                        style={{
                            padding: "24px"
                        }}
                    >

                        <h2>
                            Manifest Information
                        </h2>


                        <p>
                            <strong>
                                Manifest Number:
                            </strong>{" "}

                            {
                                manifest.manifestNumber ??
                                manifest.ManifestNumber
                            }

                        </p>


                        <p>
                            <strong>
                                Vehicle:
                            </strong>{" "}

                            {
                                vehicle?.vehicleNumber ??
                                vehicle?.VehicleNumber ??
                                vehicle?.vehicleCode ??
                                vehicle?.VehicleCode ??
                                manifest.vehicleId
                            }

                        </p>


                        <p>
                            <strong>Driver:</strong>{" "}
                            {(() => {
                                const driver = employees.find(
                                    (e) =>
                                        String(e.id ?? e.Id).toLowerCase() ===
                                        String(manifest.driverId).toLowerCase()
                                );

                                return (
                                    [driver?.firstName, driver?.lastName]
                                        .filter(Boolean)
                                        .join(" ") || manifest.driverId
                                );
                            })()}
                        </p>


                        <p>
                            <strong>
                                Route:
                            </strong>{" "}

                            {
                                route?.name ??
                                route?.Name ??
                                route?.routeCode ??
                                route?.RouteCode ??
                                manifest.routeId
                            }

                        </p>


                        <p>
                            <strong>
                                Departure Facility:
                            </strong>{" "}

                            {
                                departureFacility?.name ??
                                departureFacility?.Name ??
                                manifest.departureFacilityId
                            }

                        </p>


                        <p>
                            <strong>
                                Departure Time:
                            </strong>{" "}

                            {
                                manifest.departureTime ??
                                manifest.DepartureTime ??
                                "N/A"
                            }

                        </p>


                        <p>
                            <strong>
                                Arrival Time:
                            </strong>{" "}

                            {
                                manifest.arrivalTime ??
                                manifest.ArrivalTime ??
                                "N/A"
                            }

                        </p>


                        <p>
                            <strong>
                                Vehicle Capacity:
                            </strong>{" "}

                            {
                                vehicleCapacity > 0
                                    ? `${ vehicleCapacity } kg`
                                    : "N/A"
                            }

                        </p>


                        <p>
                            <strong>
                                Current Weight:
                            </strong>{" "}

                            {
                                currentWeight.toFixed(2)
                            }{" "}
                            kg

                        </p>


                        <p>
                            <strong>
                                Remaining Capacity:
                            </strong>{" "}

                            {
                                vehicleCapacity > 0
                                    ? `${ remainingCapacity.toFixed(2) } kg`
                                    : "N/A"
                            }

                        </p>


                        <p>
                            <strong>
                                Status:
                            </strong>{" "}

                            {
                                manifest.status ??
                                manifest.Status ??
                                "Planned"
                            }

                        </p>

                    </div>

                </div>


                {/* ================================================= */}
                {/* TRANSPORT ORDERS */}
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
                            Transport Orders on This Manifest
                        </h2>


                        {manifestItems.length === 0 ? (

                            <p>
                                No transport orders assigned.
                            </p>

                        ) : (

                            <table
                                style={{
                                    width: "100%",
                                    borderCollapse: "collapse"
                                }}
                            >

                                <thead>

                                    <tr>

                                        <th
                                            style={{
                                                textAlign: "left",
                                                padding: "12px",
                                                borderBottom:
                                                    "1px solid #ddd"
                                            }}
                                        >
                                            TO Number
                                        </th>


                                        <th
                                            style={{
                                                textAlign: "left",
                                                padding: "12px",
                                                borderBottom:
                                                    "1px solid #ddd"
                                            }}
                                        >
                                            Shipment
                                        </th>


                                        <th
                                            style={{
                                                textAlign: "left",
                                                padding: "12px",
                                                borderBottom:
                                                    "1px solid #ddd"
                                            }}
                                        >
                                            Weight
                                        </th>


                                        <th
                                            style={{
                                                textAlign: "left",
                                                padding: "12px",
                                                borderBottom:
                                                    "1px solid #ddd"
                                            }}
                                        >
                                            Status
                                        </th>

                                    </tr>

                                </thead>


                                <tbody>

                                    {manifestItems
                                        .slice()
                                        .sort(
                                            (a, b) =>
                                                Number(
                                                    a.loadingSequence ??
                                                    a.LoadingSequence ??
                                                    0
                                                ) -
                                                Number(
                                                    b.loadingSequence ??
                                                    b.LoadingSequence ??
                                                    0
                                                )
                                        )
                                        .map(
                                            item => {

                                                const transportOrderId =
                                                    item.transportOrderId ??
                                                    item.TransportOrderId;


                                                const transportOrder =
                                                    transportOrders.find(
                                                        order =>
                                                            String(
                                                                getId(order)
                                                            ).toLowerCase() ===
                                                            String(
                                                                transportOrderId
                                                            ).toLowerCase()
                                                    );


                                                const shipment =
                                                    getShipment(
                                                        transportOrder
                                                    );


                                                return (

                                                    <tr
                                                        key={
                                                            getId(item)
                                                        }
                                                    >

                                                        <td
                                                            style={{
                                                                padding: "12px",
                                                                borderBottom:
                                                                    "1px solid #eee"
                                                            }}
                                                        >

                                                            <strong>

                                                                {
                                                                    getNumber(
                                                                        transportOrder
                                                                    )
                                                                }

                                                            </strong>

                                                        </td>


                                                        <td
                                                            style={{
                                                                padding: "12px",
                                                                borderBottom:
                                                                    "1px solid #eee"
                                                            }}
                                                        >

                                                            {
                                                                getTrackingNumber(
                                                                    shipment
                                                                )
                                                            }

                                                        </td>


                                                        <td
                                                            style={{
                                                                padding: "12px",
                                                                borderBottom:
                                                                    "1px solid #eee"
                                                            }}
                                                        >

                                                            {
                                                                Number(
                                                                    item.weight ??
                                                                    item.Weight ??
                                                                    0
                                                                ).toFixed(2)
                                                            }{" "}
                                                            kg

                                                        </td>


                                                        <td
                                                            style={{
                                                                padding: "12px",
                                                                borderBottom:
                                                                    "1px solid #eee"
                                                            }}
                                                        >

                                                            {
                                                                item.status ??
                                                                item.Status ??
                                                                "Planned"
                                                            }

                                                        </td>

                                                    </tr>

                                                );

                                            }
                                        )}

                                </tbody>

                            </table>

                        )}

                    </div>

                </div>


                {/* ================================================= */}
                {/* ADD TRANSPORT ORDER */}
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
                            Add Transport Order
                        </h2>


                        <form
                            onSubmit={
                                handleAddTransportOrder
                            }
                        >


                            {/* TRANSPORT ORDER */}

                            <div
                                style={{
                                    marginBottom: "16px"
                                }}
                            >

                                <label>
                                    <strong>
                                        Transport Order
                                    </strong>
                                </label>


                                <select
                                    value={
                                        selectedTransportOrder
                                    }
                                    onChange={
                                        handleTransportOrderChange
                                    }
                                    disabled={
                                        adding
                                    }
                                    style={{
                                        display: "block",
                                        width: "100%",
                                        padding: "10px",
                                        marginTop: "6px"
                                    }}
                                >

                                    <option value="">
                                        Select Transport Order
                                    </option>


                                    {availableTransportOrders.map(
                                        order => (

                                            <option
                                                key={
                                                    getId(order)
                                                }
                                                value={
                                                    getId(order)
                                                }
                                            >

                                                {
                                                    getNumber(
                                                        order
                                                    )
                                                }

                                            </option>

                                        )
                                    )}

                                </select>

                            </div>


                            {/* SELECTED SHIPMENT */}

                            {selectedOrder && (

                                <div
                                    style={{
                                        marginBottom: "16px"
                                    }}
                                >

                                    <p>
                                        <strong>
                                            Shipment:
                                        </strong>{" "}

                                        {
                                            getTrackingNumber(
                                                selectedShipment
                                            )
                                        }

                                    </p>


                                    <p>
                                        <strong>
                                            Transport Order Weight:
                                        </strong>{" "}

                                        {
                                            transportOrderWeight
                                        }{" "}
                                        kg

                                    </p>

                                </div>

                            )}


                            {/* WEIGHT */}

                            <div
                                style={{
                                    marginBottom: "16px"
                                }}
                            >

                                <label>
                                    <strong>
                                        Weight on this trip
                                    </strong>
                                </label>


                                <input
                                    type="number"
                                    min="0.01"
                                    step="0.01"
                                    value={weight}
                                    onChange={event =>
                                        setWeight(
                                            event.target.value
                                        )
                                    }
                                    disabled={
                                        adding ||
                                        !selectedOrder
                                    }
                                    style={{
                                        display: "block",
                                        width: "100%",
                                        padding: "10px",
                                        marginTop: "6px"
                                    }}
                                />


                                <small>

                                    Maximum allowed:{" "}

                                    {
                                        Math.min(
                                            transportOrderWeight ||
                                                Infinity,

                                            remainingCapacity ||
                                                Infinity
                                        ) === Infinity
                                            ? "N/A"
                                            : `${
    Math.min(
        transportOrderWeight ||
        Infinity,

        remainingCapacity ||
        Infinity
    ).toFixed(2)
} kg`
                                    }

                                </small>

                            </div>


                            {/* LOADING SEQUENCE */}

                            <div
                                style={{
                                    marginBottom: "16px"
                                }}
                            >

                                <label>
                                    <strong>
                                        Loading Sequence
                                    </strong>
                                </label>


                                <input
                                    type="number"
                                    min="1"
                                    step="1"
                                    value={
                                        loadingSequence
                                    }
                                    onChange={event =>
                                        setLoadingSequence(
                                            event.target.value
                                        )
                                    }
                                    disabled={
                                        adding
                                    }
                                    style={{
                                        display: "block",
                                        width: "100%",
                                        padding: "10px",
                                        marginTop: "6px"
                                    }}
                                />

                            </div>


                            {/* NOTES */}

                            <div
                                style={{
                                    marginBottom: "16px"
                                }}
                            >

                                <label>
                                    <strong>
                                        Notes
                                    </strong>
                                </label>


                                <textarea
                                    rows="3"
                                    value={notes}
                                    onChange={event =>
                                        setNotes(
                                            event.target.value
                                        )
                                    }
                                    disabled={
                                        adding
                                    }
                                    style={{
                                        display: "block",
                                        width: "100%",
                                        padding: "10px",
                                        marginTop: "6px"
                                    }}
                                />

                            </div>


                            {/* SUBMIT */}

                            <button
                                type="submit"
                                className="crud-button crud-button-primary"
                                disabled={
                                    adding ||
                                    !selectedOrder
                                }
                            >

                                {adding
                                    ? "Adding..."
                                    : "Add to Manifest"}

                            </button>


                        </form>

                    </div>

                </div>

            </div>

        </div>

    );

};


export default ShipmentManifestDetailsPage;