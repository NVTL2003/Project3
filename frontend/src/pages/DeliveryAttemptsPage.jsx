import React, { useEffect, useState } from "react";

import deliveryAttemptService
    from "../services/deliveryAttemptService";

import deliveryAssignmentService
    from "../services/deliveryAssignmentService";

import shipmentService
    from "../services/shipmentService";


const DeliveryAttemptsPage = () => {

    const [attempts, setAttempts] = useState([]);

    const [assignments, setAssignments] = useState([]);

    const [shipments, setShipments] = useState([]);

    const [loading, setLoading] = useState(true);

    const [submitting, setSubmitting] = useState(false);

    const [error, setError] = useState("");

    const [success, setSuccess] = useState("");

    const [form, setForm] = useState({

        shipmentId: "",

        deliveryAssignmentId: "",

        status: "attempted",

        reason: "",

        notes: "",

        latitude: "",

        longitude: "",

        receiverName: "",

        receiverSignature: "",

        receiverRelation: "",

        deliveryPhoto: "",

        gpsAccuracy: "",

        proofNotes: ""
    });


    const loadData = async () => {

        try {

            setLoading(true);

            setError("");

            const [
                attemptsResponse,
                assignmentsResponse,
                shipmentsResponse
            ] = await Promise.all([

                deliveryAttemptService.getPaged({
                    page: 1,
                    pageSize: 100
                }),

                deliveryAssignmentService.getPaged({
                    page: 1,
                    pageSize: 100
                }),

                shipmentService.getPaged({
                    page: 1,
                    pageSize: 100
                })
            ]);


            const attemptsData =
                attemptsResponse.data;

            const assignmentsData =
                assignmentsResponse.data;

            const shipmentsData =
                shipmentsResponse.data;


            setAttempts(
                attemptsData?.items ??
                attemptsData?.data ??
                attemptsData ??
                []
            );

            setAssignments(
                assignmentsData?.items ??
                assignmentsData?.data ??
                assignmentsData ??
                []
            );

            setShipments(
                shipmentsData?.items ??
                shipmentsData?.data ??
                shipmentsData ??
                []
            );

        } catch (err) {

            console.error(err);

            setError(
                err.response?.data?.message ??
                "Failed to load delivery attempt data."
            );

        } finally {

            setLoading(false);
        }
    };


    useEffect(() => {

        loadData();

    }, []);


    const handleChange = (event) => {

        const {
            name,
            value
        } = event.target;


        setForm(previous => ({

            ...previous,

            [name]: value

        }));
    };


    const handleSubmit = async (event) => {

        event.preventDefault();

        setError("");

        setSuccess("");

        setSubmitting(true);


        try {

            if (!form.shipmentId) {

                throw new Error(
                    "Please select a shipment."
                );
            }


            if (!form.deliveryAssignmentId) {

                throw new Error(
                    "Please select a delivery assignment."
                );
            }


            if (
                form.status === "delivered" &&
                !form.receiverName.trim()
            ) {

                throw new Error(
                    "Receiver name is required when the shipment is delivered."
                );
            }


            const payload = {

                shipmentId:
                    form.shipmentId,

                deliveryAssignmentId:
                    form.deliveryAssignmentId,

                status:
                    form.status,

                reason:
                    form.reason.trim() || null,

                notes:
                    form.notes.trim() || null,

                latitude:
                    form.latitude === ""
                        ? null
                        : Number(form.latitude),

                longitude:
                    form.longitude === ""
                        ? null
                        : Number(form.longitude),

                proofOfDelivery:
                    form.status === "delivered"
                        ? {

                            receiverName:
                                form.receiverName.trim(),

                            receiverSignature:
                                form.receiverSignature.trim() || null,

                            receiverRelation:
                                form.receiverRelation.trim() || null,

                            deliveryPhoto:
                                form.deliveryPhoto.trim() || null,

                            gpsAccuracy:
                                form.gpsAccuracy === ""
                                    ? null
                                    : Number(form.gpsAccuracy),

                            notes:
                                form.proofNotes.trim() || null

                        }
                        : null
            };


            await deliveryAttemptService.create(
                payload
            );


            setSuccess(
                form.status === "delivered"
                    ? "Delivery completed successfully. Proof of delivery was created."
                    : "Delivery attempt recorded successfully."
            );


            setForm({

                shipmentId: "",

                deliveryAssignmentId: "",

                status: "attempted",

                reason: "",

                notes: "",

                latitude: "",

                longitude: "",

                receiverName: "",

                receiverSignature: "",

                receiverRelation: "",

                deliveryPhoto: "",

                gpsAccuracy: "",

                proofNotes: ""
            });


            await loadData();

        } catch (err) {

            console.error(err);

            setError(
                err.response?.data?.message ??
                err.message ??
                "Failed to create delivery attempt."
            );

        } finally {

            setSubmitting(false);
        }
    };


    const getShipmentLabel = (shipment) => {

        return (
            shipment.trackingNumber ??
            shipment.shipmentNumber ??
            shipment.id
        );
    };


    const getAssignmentLabel = (assignment) => {

        return (
            assignment.assignmentNumber ??
            assignment.id
        );
    };


    const isDelivered =
        form.status === "delivered";


    if (loading) {

        return (
            <div className="page-container">
                <h1>Delivery Attempts</h1>
                <p>Loading...</p>
            </div>
        );
    }


    return (
        <div className="page-container">

            <h1>Delivery Attempts</h1>


            {error && (
                <div className="error-message">
                    {error}
                </div>
            )}


            {success && (
                <div className="success-message">
                    {success}
                </div>
            )}


            <section className="crud-section">

                <h2>Record Delivery Attempt</h2>


                <form
                    onSubmit={handleSubmit}
                    className="crud-form"
                >

                    <div className="form-group">

                        <label>
                            Delivery Assignment
                        </label>

                        <select
                            name="deliveryAssignmentId"
                            value={form.deliveryAssignmentId}
                            onChange={handleChange}
                            required
                        >

                            <option value="">
                                Select assignment
                            </option>

                            {assignments
                                .filter(
                                    assignment =>
                                        assignment.status !== "Completed" &&
                                        assignment.status !== "completed" &&
                                        assignment.status !== "Cancelled" &&
                                        assignment.status !== "cancelled"
                                )
                                .map(assignment => (

                                    <option
                                        key={assignment.id}
                                        value={assignment.id}
                                    >
                                        {getAssignmentLabel(assignment)}
                                    </option>

                                ))}

                        </select>

                    </div>


                    <div className="form-group">

                        <label>
                            Shipment
                        </label>

                        <select
                            name="shipmentId"
                            value={form.shipmentId}
                            onChange={handleChange}
                            required
                        >

                            <option value="">
                                Select shipment
                            </option>

                            {shipments.map(shipment => (

                                <option
                                    key={shipment.id}
                                    value={shipment.id}
                                >
                                    {getShipmentLabel(shipment)}
                                </option>

                            ))}

                        </select>

                    </div>


                    <div className="form-group">

                        <label>
                            Status
                        </label>

                        <select
                            name="status"
                            value={form.status}
                            onChange={handleChange}
                            required
                        >

                            <option value="attempted">
                                Attempted
                            </option>

                            <option value="failed">
                                Failed
                            </option>

                            <option value="delivered">
                                Delivered
                            </option>

                        </select>

                    </div>


                    {(form.status === "failed" ||
                      form.status === "attempted") && (

                        <div className="form-group">

                            <label>
                                Reason
                            </label>

                            <input
                                type="text"
                                name="reason"
                                value={form.reason}
                                onChange={handleChange}
                                placeholder="Reason for the attempt/failure"
                            />

                        </div>

                    )}


                    <div className="form-group">

                        <label>
                            Notes
                        </label>

                        <textarea
                            name="notes"
                            value={form.notes}
                            onChange={handleChange}
                            rows={3}
                        />

                    </div>


                    <div className="form-row">

                        <div className="form-group">

                            <label>
                                Latitude
                            </label>

                            <input
                                type="number"
                                step="any"
                                name="latitude"
                                value={form.latitude}
                                onChange={handleChange}
                            />

                        </div>


                        <div className="form-group">

                            <label>
                                Longitude
                            </label>

                            <input
                                type="number"
                                step="any"
                                name="longitude"
                                value={form.longitude}
                                onChange={handleChange}
                            />

                        </div>

                    </div>


                    {isDelivered && (

                        <section className="crud-section">

                            <h3>
                                Proof of Delivery
                            </h3>


                            <div className="form-group">

                                <label>
                                    Receiver Name *
                                </label>

                                <input
                                    type="text"
                                    name="receiverName"
                                    value={form.receiverName}
                                    onChange={handleChange}
                                    required
                                />

                            </div>


                            <div className="form-group">

                                <label>
                                    Receiver Relation
                                </label>

                                <input
                                    type="text"
                                    name="receiverRelation"
                                    value={form.receiverRelation}
                                    onChange={handleChange}
                                    placeholder="Customer, family member, colleague..."
                                />

                            </div>


                            <div className="form-group">

                                <label>
                                    Receiver Signature
                                </label>

                                <textarea
                                    name="receiverSignature"
                                    value={form.receiverSignature}
                                    onChange={handleChange}
                                    rows={3}
                                    placeholder="Signature data"
                                />

                            </div>


                            <div className="form-group">

                                <label>
                                    Delivery Photo
                                </label>

                                <input
                                    type="text"
                                    name="deliveryPhoto"
                                    value={form.deliveryPhoto}
                                    onChange={handleChange}
                                    placeholder="Photo reference/path"
                                />

                            </div>


                            <div className="form-group">

                                <label>
                                    GPS Accuracy
                                </label>

                                <input
                                    type="number"
                                    step="any"
                                    name="gpsAccuracy"
                                    value={form.gpsAccuracy}
                                    onChange={handleChange}
                                />

                            </div>


                            <div className="form-group">

                                <label>
                                    POD Notes
                                </label>

                                <textarea
                                    name="proofNotes"
                                    value={form.proofNotes}
                                    onChange={handleChange}
                                    rows={3}
                                />

                            </div>

                        </section>
                    )}


                    <button
                        type="submit"
                        disabled={submitting}
                    >
                        {submitting
                            ? "Saving..."
                            : "Record Attempt"}
                    </button>

                </form>

            </section>


            <section className="crud-section">

                <h2>
                    Delivery Attempt History
                </h2>


                {attempts.length === 0 ? (

                    <p>
                        No delivery attempts found.
                    </p>

                ) : (

                    <div className="table-container">

                        <table>

                            <thead>

                                <tr>

                                    <th>
                                        Attempt #
                                    </th>

                                    <th>
                                        Shipment
                                    </th>

                                    <th>
                                        Assignment
                                    </th>

                                    <th>
                                        Status
                                    </th>

                                    <th>
                                        Attempt Time
                                    </th>

                                    <th>
                                        Reason
                                    </th>

                                    <th>
                                        Delivered
                                    </th>

                                </tr>

                            </thead>


                            <tbody>

                                {attempts.map(attempt => (

                                    <tr key={attempt.id}>

                                        <td>
                                            {attempt.attemptNumber}
                                        </td>

                                        <td>
                                            {getShipmentLabel(
                                                shipments.find(
                                                    shipment =>
                                                        shipment.id === attempt.shipmentId
                                                ) ?? {
                                                    id: attempt.shipmentId
                                                }
                                            )}
                                        </td>

                                        <td>
                                            {getAssignmentLabel(
                                                assignments.find(
                                                    assignment =>
                                                        assignment.id === attempt.deliveryAssignmentId
                                                ) ?? {
                                                    id: attempt.deliveryAssignmentId
                                                }
                                            )}
                                        </td>

                                        <td>
                                            {attempt.status}
                                        </td>

                                        <td>
                                            {attempt.attemptTime
                                                ? new Date(
                                                    attempt.attemptTime
                                                ).toLocaleString()
                                                : "-"}
                                        </td>

                                        <td>
                                            {attempt.reason ?? "-"}
                                        </td>

                                        <td>
                                            {attempt.isDelivered
                                                ? "Yes"
                                                : "No"}
                                        </td>

                                    </tr>

                                ))}

                            </tbody>

                        </table>

                    </div>

                )}

            </section>

        </div>
    );
};


export default DeliveryAttemptsPage;