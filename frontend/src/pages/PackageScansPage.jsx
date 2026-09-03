import React, { useEffect, useState } from "react";

import { packageScanService } from "../services/packageScanService";
import { shipmentService } from "../services/shipmentService";
import { facilityService } from "../services/facilityService";
import { vehicleService } from "../services/vehicleService";


const PackageScansPage = () => {

    const [shipments, setShipments] = useState([]);
    const [facilities, setFacilities] = useState([]);
    const [vehicles, setVehicles] = useState([]);

    const [loading, setLoading] = useState(true);
    const [submitting, setSubmitting] = useState(false);

    const [result, setResult] = useState(null);
    const [error, setError] = useState(null);

    const [form, setForm] = useState({
        shipmentId: "",
        scanType: "pickup",
        facilityId: "",
        vehicleId: "",
        notes: ""
    });


    // ============================================================
    // LOAD DATA
    // ============================================================

    useEffect(() => {

        const loadData = async () => {

            try {

                setLoading(true);
                setError(null);

                const [
                    shipmentResponse,
                    facilityResponse,
                    vehicleResponse
                ] = await Promise.all([
                    shipmentService.getPaged({
                        page: 1,
                        pageSize: 100
                    }),

                    facilityService.getPaged({
                        page: 1,
                        pageSize: 100
                    }),

                    vehicleService.getPaged({
                        page: 1,
                        pageSize: 100
                    })
                ]);

                setShipments(
                    shipmentResponse.data?.items ||
                    shipmentResponse.data?.data ||
                    []
                );

                setFacilities(
                    facilityResponse.data?.items ||
                    facilityResponse.data?.data ||
                    []
                );

                setVehicles(
                    vehicleResponse.data?.items ||
                    vehicleResponse.data?.data ||
                    []
                );

            } catch (err) {

                console.error(
                    "Failed to load package scan data:",
                    err
                );

                setError(
                    err.response?.data?.message ||
                    "Failed to load shipments, facilities, or vehicles."
                );

            } finally {

                setLoading(false);

            }
        };

        loadData();

    }, []);


    // ============================================================
    // FORM CHANGE
    // ============================================================

    const handleChange = (e) => {

        const {
            name,
            value
        } = e.target;

        setForm(prev => ({
            ...prev,
            [name]: value
        }));

        setError(null);
        setResult(null);
    };


    // ============================================================
    // SCAN TYPE HELPERS
    // ============================================================

    const requiresFacility = [
        "pickup",
        "load",
        "arrive",
        "unload"
    ].includes(form.scanType);

    const requiresVehicle =
        form.scanType === "depart";


    // ============================================================
    // SUBMIT
    // ============================================================

    const handleSubmit = async (e) => {

        e.preventDefault();

        setError(null);
        setResult(null);

        if (!form.shipmentId) {

            setError(
                "Please select a shipment."
            );

            return;
        }

        if (requiresFacility && !form.facilityId) {

            setError(
                "Please select a facility."
            );

            return;
        }

        if (requiresVehicle && !form.vehicleId) {

            setError(
                "Please select a vehicle."
            );

            return;
        }

        try {

            setSubmitting(true);

            const payload = {
                shipmentId: form.shipmentId,

                scanType: form.scanType,

                facilityId:
                    form.facilityId
                        ? form.facilityId
                        : null,

                vehicleId:
                    form.vehicleId
                        ? form.vehicleId
                        : null,

                notes:
                    form.notes.trim()
                        ? form.notes.trim()
                        : null
            };

            console.log(
                "Scanning package:",
                payload
            );

            const response =
                await packageScanService.scan(
                    payload
                );

            setResult(
                response.data
            );

            // Reset form
            setForm({
                shipmentId: "",
                scanType: "pickup",
                facilityId: "",
                vehicleId: "",
                notes: ""
            });

        } catch (err) {

            console.error(
                "Package scan failed:",
                err
            );

            const message =
                err.response?.data?.message ||
                err.response?.data?.title ||
                err.response?.data ||
                "Failed to scan package.";

            setError(message);

        } finally {

            setSubmitting(false);

        }
    };


    // ============================================================
    // LOADING
    // ============================================================

    if (loading) {

        return (
            <div className="crud-page">

                <div className="crud-container">

                    <h1 className="crud-title">
                        Package Scanning
                    </h1>

                    <p>
                        Loading shipments, facilities, and vehicles...
                    </p>

                </div>

            </div>
        );
    }


    // ============================================================
    // UI
    // ============================================================

    return (
        <div className="crud-page">

            <div className="crud-container">

                <div className="crud-header">

                    <div className="crud-header-content">

                        <h1 className="crud-title">
                            Package Scanning
                        </h1>

                        <p className="crud-subtitle">
                            Record a physical shipment movement.
                        </p>

                    </div>

                </div>


                {/* ERROR */}

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
                        {typeof error === "string"
                            ? error
                            : "Package scan failed."}
                    </div>

                )}


                {/* SUCCESS */}

                {result && (

                    <div
                        style={{
                            marginBottom: "20px",
                            padding: "16px",
                            background: "#e8f5e9",
                            color: "#2e7d32",
                            borderRadius: "6px"
                        }}
                    >

                        <strong>
                            Package scanned successfully.
                        </strong>

                        {result.scanNumber && (
                            <div style={{ marginTop: "8px" }}>
                                Scan Number: {result.scanNumber}
                            </div>
                        )}

                        {result.trackingStatus && (
                            <div>
                                Tracking Status: {result.trackingStatus}
                            </div>
                        )}

                        {result.message && (
                            <div>
                                {result.message}
                            </div>
                        )}

                    </div>

                )}


                <div className="crud-table-card">

                    <form
                        onSubmit={handleSubmit}
                        style={{
                            padding: "24px"
                        }}
                    >

                        {/* ====================================================
                            SHIPMENT
                        ==================================================== */}

                        <div
                            style={{
                                marginBottom: "20px"
                            }}
                        >

                            <label>
                                Shipment
                            </label>

                            <select
                                name="shipmentId"
                                value={form.shipmentId}
                                onChange={handleChange}
                                required
                                style={{
                                    display: "block",
                                    width: "100%",
                                    padding: "10px",
                                    marginTop: "6px"
                                }}
                            >

                                <option value="">
                                    Select shipment
                                </option>

                                {shipments.map(shipment => (

                                    <option
                                        key={shipment.id}
                                        value={shipment.id}
                                    >

                                        {shipment.trackingNumber ||
                                            shipment.id}

                                        {" — "}

                                        {shipment.currentStatus ||
                                            "Unknown"}

                                    </option>

                                ))}

                            </select>

                        </div>


                        {/* ====================================================
                            SCAN TYPE
                        ==================================================== */}

                        <div
                            style={{
                                marginBottom: "20px"
                            }}
                        >

                            <label>
                                Scan Type
                            </label>

                            <select
                                name="scanType"
                                value={form.scanType}
                                onChange={handleChange}
                                required
                                style={{
                                    display: "block",
                                    width: "100%",
                                    padding: "10px",
                                    marginTop: "6px"
                                }}
                            >

                                <option value="pickup">
                                    Pickup
                                </option>

                                <option value="load">
                                    Load
                                </option>

                                <option value="depart">
                                    Depart
                                </option>

                                <option value="arrive">
                                    Arrive
                                </option>

                                <option value="unload">
                                    Unload
                                </option>

                            </select>

                        </div>


                        {/* ====================================================
                            FACILITY
                        ==================================================== */}

                        {requiresFacility && (

                            <div
                                style={{
                                    marginBottom: "20px"
                                }}
                            >

                                <label>
                                    Facility
                                </label>

                                <select
                                    name="facilityId"
                                    value={form.facilityId}
                                    onChange={handleChange}
                                    required
                                    style={{
                                        display: "block",
                                        width: "100%",
                                        padding: "10px",
                                        marginTop: "6px"
                                    }}
                                >

                                    <option value="">
                                        Select facility
                                    </option>

                                    {facilities.map(facility => (

                                        <option
                                            key={facility.id}
                                            value={facility.id}
                                        >

                                            {facility.code
                                                ? `${ facility.code } — `
                                                : ""}

                                            {facility.name ||
                                                facility.id}

                                        </option>

                                    ))}

                                </select>

                            </div>

                        )}


                        {/* ====================================================
                            VEHICLE
                        ==================================================== */}

                        {requiresVehicle && (

                            <div
                                style={{
                                    marginBottom: "20px"
                                }}
                            >

                                <label>
                                    Vehicle
                                </label>

                                <select
                                    name="vehicleId"
                                    value={form.vehicleId}
                                    onChange={handleChange}
                                    required
                                    style={{
                                        display: "block",
                                        width: "100%",
                                        padding: "10px",
                                        marginTop: "6px"
                                    }}
                                >

                                    <option value="">
                                        Select vehicle
                                    </option>

                                    {vehicles.map(vehicle => (

                                        <option
                                            key={vehicle.id}
                                            value={vehicle.id}
                                        >

                                            {vehicle.vehicleNumber ||
                                                vehicle.registrationNumber ||
                                                vehicle.code ||
                                                vehicle.name ||
                                                vehicle.id}

                                        </option>

                                    ))}

                                </select>

                            </div>

                        )}


                        {/* ====================================================
                            NOTES
                        ==================================================== */}

                        <div
                            style={{
                                marginBottom: "20px"
                            }}
                        >

                            <label>
                                Notes
                            </label>

                            <textarea
                                name="notes"
                                value={form.notes}
                                onChange={handleChange}
                                placeholder="Optional notes"
                                rows="4"
                                style={{
                                    display: "block",
                                    width: "100%",
                                    padding: "10px",
                                    marginTop: "6px"
                                }}
                            />

                        </div>


                        {/* ====================================================
                            SUBMIT
                        ==================================================== */}

                        <button
                            type="submit"
                            className="crud-button crud-button-primary"
                            disabled={
                                submitting ||
                                !form.shipmentId
                            }
                        >

                            {submitting
                                ? "Scanning..."
                                : "Scan Package"}

                        </button>

                    </form>

                </div>

            </div>

        </div>
    );
};


export default PackageScansPage;