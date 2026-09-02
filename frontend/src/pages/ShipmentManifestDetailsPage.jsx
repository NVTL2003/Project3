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


const ShipmentManifestDetailsPage = () => {

    const {
        id
    } = useParams();

    const navigate =
        useNavigate();


    const [manifest, setManifest] =
        useState(null);

    const [items, setItems] =
        useState([]);

    const [transportOrders, setTransportOrders] =
        useState([]);

    const [loading, setLoading] =
        useState(true);

    const [addingItem, setAddingItem] =
        useState(false);

    const [selectedTransportOrder, setSelectedTransportOrder] =
        useState("");

    const [loadingSequence, setLoadingSequence] =
        useState("");

    const [error, setError] =
        useState(null);


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
                "Failed to load manifest."
            );

        }
    };


    // =========================================================
    // LOAD MANIFEST ITEMS
    // =========================================================

    const loadItems = async () => {

        try {

            const response =
                await manifestItemService.getPaged({

                    page: 1,

                    pageSize: 100

                });


            const data =
                response.data;


            const allItems =
                data?.items ||
                data?.data ||
                [];


            setItems(
                allItems.filter(
                    item =>
                        item.manifestId === id
                )
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

                    pageSize: 100

                });


            const data =
                response.data;


            setTransportOrders(
                data?.items ||
                data?.data ||
                []
            );

        } catch (err) {

            console.error(
                "Failed to load transport orders:",
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

                    loadItems(),

                    loadTransportOrders()

                ]);

            } finally {

                setLoading(false);

            }

        };


        loadData();

    }, [id]);


    // =========================================================
    // ADD TRANSPORT ORDER
    // =========================================================

    const handleAddItem = async (e) => {

        e.preventDefault();

        if (!selectedTransportOrder) {

            setError(
                "Please select a transport order."
            );

            return;

        }


        try {

            setAddingItem(true);

            setError(null);


            const payload = {

                manifestId: id,

                transportOrderId:
                    selectedTransportOrder,

                loadingSequence:
                    loadingSequence
                        ? Number(loadingSequence)
                        : null,

                notes: null

            };


            await manifestItemService.create(
                payload
            );


            setSelectedTransportOrder("");

            setLoadingSequence("");


            await loadItems();

            await loadManifest();


        } catch (err) {

            console.error(
                "Failed to add manifest item:",
                err
            );

            setError(
                err.response?.data?.message ||
                err.response?.data ||
                "Failed to add transport order to manifest."
            );

        } finally {

            setAddingItem(false);

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
                        Shipment Manifest
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
                        Back to Manifests
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
                            ← Back to Manifests
                        </button>


                        <h1 className="crud-title">

                            {manifest.manifestNumber}

                        </h1>


                        <p className="crud-subtitle">

                            Shipment Manifest

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
                                Manifest:
                            </strong>{" "}
                            {manifest.manifestNumber}
                        </p>


                        <p>
                            <strong>
                                Status:
                            </strong>{" "}
                            {manifest.status || "N/A"}
                        </p>


                        <p>
                            <strong>
                                Vehicle:
                            </strong>{" "}
                            {manifest.vehicleId}
                        </p>


                        <p>
                            <strong>
                                Driver:
                            </strong>{" "}
                            {manifest.driverId}
                        </p>


                        <p>
                            <strong>
                                Route:
                            </strong>{" "}
                            {manifest.routeId}
                        </p>


                        <p>
                            <strong>
                                Departure Facility:
                            </strong>{" "}
                            {manifest.departureFacilityId}
                        </p>


                        <p>
                            <strong>
                                Departure Time:
                            </strong>{" "}
                            {manifest.departureTime}
                        </p>


                        <p>
                            <strong>
                                Arrival Time:
                            </strong>{" "}
                            {manifest.arrivalTime || "N/A"}
                        </p>


                        <p>
                            <strong>
                                Total Packages:
                            </strong>{" "}
                            {manifest.totalPackages ?? 0}
                        </p>


                        <p>
                            <strong>
                                Total Weight:
                            </strong>{" "}
                            {manifest.totalWeight ?? 0}
                        </p>


                        {manifest.notes && (

                            <p>
                                <strong>
                                    Notes:
                                </strong>{" "}
                                {manifest.notes}
                            </p>

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
                            onSubmit={handleAddItem}
                        >

                            <div
                                style={{
                                    marginBottom: "16px"
                                }}
                            >

                                <label>
                                    Transport Order
                                </label>


                                <select
                                    value={
                                        selectedTransportOrder
                                    }
                                    onChange={e =>
                                        setSelectedTransportOrder(
                                            e.target.value
                                        )
                                    }
                                    required
                                    style={{
                                        display: "block",
                                        width: "100%",
                                        padding: "10px",
                                        marginTop: "6px"
                                    }}
                                >

                                    <option value="">
                                        Select transport order
                                    </option>


                                    {transportOrders.map(
                                        order => (

                                            <option
                                                key={order.id}
                                                value={order.id}
                                            >

                                                {order.orderNumber}

                                                {" — "}

                                                {order.status}

                                            </option>

                                        )
                                    )}

                                </select>

                            </div>


                            <div
                                style={{
                                    marginBottom: "16px"
                                }}
                            >

                                <label>
                                    Loading Sequence
                                </label>


                                <input
                                    type="number"
                                    min="1"
                                    value={
                                        loadingSequence
                                    }
                                    onChange={e =>
                                        setLoadingSequence(
                                            e.target.value
                                        )
                                    }
                                    style={{
                                        display: "block",
                                        width: "100%",
                                        padding: "10px",
                                        marginTop: "6px"
                                    }}
                                />

                            </div>


                            <button
                                type="submit"
                                className="crud-button crud-button-primary"
                                disabled={addingItem}
                            >

                                {addingItem
                                    ? "Adding..."
                                    : "Add Transport Order"
                                }

                            </button>

                        </form>

                    </div>

                </div>


                {/* ================================================= */}
                {/* MANIFEST ITEMS */}
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
                            Manifest Items
                        </h2>


                        {items.length === 0 ? (

                            <p>
                                No transport orders have
                                been added to this manifest.
                            </p>

                        ) : (

                            <div
                                style={{
                                    overflowX: "auto"
                                }}
                            >

                                <table
                                    style={{
                                        width: "100%",
                                        borderCollapse: "collapse"
                                    }}
                                >

                                    <thead>

                                        <tr>

                                            <th>
                                                Sequence
                                            </th>

                                            <th>
                                                Transport Order
                                            </th>

                                            <th>
                                                Status
                                            </th>

                                            <th>
                                                Loaded At
                                            </th>

                                            <th>
                                                Unloaded At
                                            </th>

                                            <th>
                                                Notes
                                            </th>

                                        </tr>

                                    </thead>


                                    <tbody>

                                        {items
                                            .sort(
                                                (a, b) =>
                                                    (a.loadingSequence ?? 999999) -
                                                    (b.loadingSequence ?? 999999)
                                            )
                                            .map(item => (

                                                <tr
                                                    key={item.id}
                                                >

                                                    <td>
                                                        {item.loadingSequence ?? "-"}
                                                    </td>

                                                    <td>
                                                        {item.transportOrderId}
                                                    </td>

                                                    <td>
                                                        {item.status || "N/A"}
                                                    </td>

                                                    <td>
                                                        {item.loadedAt || "-"}
                                                    </td>

                                                    <td>
                                                        {item.unloadedAt || "-"}
                                                    </td>

                                                    <td>
                                                        {item.notes || "-"}
                                                    </td>

                                                </tr>

                                            ))}

                                    </tbody>

                                </table>

                            </div>

                        )}

                    </div>

                </div>

            </div>

        </div>

    );

};


export default ShipmentManifestDetailsPage;