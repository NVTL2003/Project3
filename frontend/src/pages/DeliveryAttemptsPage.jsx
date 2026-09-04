import React, { useEffect, useMemo, useState } from "react";
import { useNavigate } from "react-router-dom";

import GenericEntityPage from "./GenericEntityPage";

import deliveryAttemptService
    from "../services/deliveryAttemptService";

import deliveryAssignmentService
    from "../services/deliveryAssignmentService";

import { shipmentManifestService }
    from "../services/shipmentManifestService";

import {manifestItemService}
    from "../services/manifestItemService";

import { transportOrderService }
    from "../services/transportOrderService";

import {shipmentService}
    from "../services/shipmentService";


const DeliveryAttemptsPage = () => {

    const navigate = useNavigate();

    const [assignments, setAssignments] = useState([]);
    const [shipments, setShipments] = useState([]);

    const [selectedAssignment, setSelectedAssignment] =
        useState(null);

    const [loadingRelations, setLoadingRelations] =
        useState(false);


    // =========================================================
    // LOAD DELIVERY ASSIGNMENTS
    // =========================================================

    useEffect(() => {

        const loadAssignments = async () => {

            try {

                const response =
                    await deliveryAssignmentService.getPaged({
                        page: 1,
                        pageSize: 100
                    });

                setAssignments(
                    response?.data?.items ||
                    response?.data ||
                    []
                );

            } catch (error) {

                console.error(
                    "Failed to load delivery assignments:",
                    error
                );

                setAssignments([]);
            }
        };

        loadAssignments();

    }, []);


    // =========================================================
    // WHEN ASSIGNMENT CHANGES
    //
    // Resolve:
    //
    // Assignment
    //     ↓
    // Manifest
    //     ↓
    // ManifestItems
    //     ↓
    // TransportOrders
    //     ↓
    // Shipments
    // =========================================================

    useEffect(() => {

        if (!selectedAssignment?.manifestId) {

            setShipments([]);

            return;
        }


        const loadAssignmentShipments = async () => {

            setLoadingRelations(true);

            try {

                // -------------------------------------------------
                // 1. Load manifest
                // -------------------------------------------------

                const manifestResponse =
                    await shipmentManifestService.getById(
                        selectedAssignment.manifestId
                    );

                const manifest =
                    manifestResponse?.data;

                if (!manifest) {

                    setShipments([]);

                    return;
                }


                // -------------------------------------------------
                // 2. Load manifest items
                // -------------------------------------------------

                const itemsResponse =
                    await manifestItemService.getPaged({
                        page: 1,
                        pageSize: 100
                    });

                const allItems =
                    itemsResponse?.data?.items ||
                    itemsResponse?.data ||
                    [];


                const manifestItems =
                    allItems.filter(
                        item =>
                            item.manifestId ===
                            selectedAssignment.manifestId
                    );


                if (manifestItems.length === 0) {

                    setShipments([]);

                    return;
                }


                // -------------------------------------------------
                // 3. Load transport orders
                // -------------------------------------------------

                const transportOrdersResponse =
                    await transportOrderService.getPaged({
                        page: 1,
                        pageSize: 100
                    });

                const allTransportOrders =
                    transportOrdersResponse?.data?.items ||
                    transportOrdersResponse?.data ||
                    [];


                // -------------------------------------------------
                // 4. Resolve shipment IDs
                // -------------------------------------------------

                const transportOrderIds =
                    new Set(
                        manifestItems.map(
                            item => item.transportOrderId
                        )
                    );


                const manifestTransportOrders =
                    allTransportOrders.filter(
                        order =>
                            transportOrderIds.has(order.id)
                    );


                const shipmentIds =
                    [
                        ...new Set(
                            manifestTransportOrders
                                .map(order => order.shipmentId)
                                .filter(Boolean)
                        )
                    ];


                if (shipmentIds.length === 0) {

                    setShipments([]);

                    return;
                }


                // -------------------------------------------------
                // 5. Load shipment records
                // -------------------------------------------------

                const shipmentResponses =
                    await Promise.all(
                        shipmentIds.map(
                            shipmentId =>
                                shipmentService.getById(
                                    shipmentId
                                )
                        )
                    );


                const resolvedShipments =
                    shipmentResponses
                        .map(response => response?.data)
                        .filter(Boolean);


                setShipments(
                    resolvedShipments
                );

            } catch (error) {

                console.error(
                    "Failed to resolve assignment shipments:",
                    error
                );

                setShipments([]);

            } finally {

                setLoadingRelations(false);
            }
        };


        loadAssignmentShipments();

    }, [selectedAssignment]);


    // =========================================================
    // FIELD CONFIG
    // =========================================================

    const fieldConfig = useMemo(() => [

        // -----------------------------------------------------
        // DELIVERY ASSIGNMENT
        // -----------------------------------------------------

        {
            name: "deliveryAssignmentId",

            label: "Delivery Assignment",

            type: "relation",

            required: true,

            service: deliveryAssignmentService,

            valueField: "id",

            sortBy: "assignmentNumber",

            getOptionLabel: assignment =>
                `${ assignment.assignmentNumber || assignment.id }
                 — ${ assignment.status || "Unknown" } `,

            onChange: async (
                value,
                form,
                setForm
            ) => {

                const assignment =
                    assignments.find(
                        item =>
                            item.id === value
                    );

                setSelectedAssignment(
                    assignment || null
                );

                // Clear shipment when assignment changes.
                setForm(previous => ({
                    ...previous,

                    deliveryAssignmentId: value,

                    shipmentId: ""
                }));
            }
        },


        // -----------------------------------------------------
        // SHIPMENT
        // -----------------------------------------------------

        {
            name: "shipmentId",

            label: "Shipment",

            type: "select",

            required: true,

            disabled:
                loadingRelations ||
                !selectedAssignment,

            options:
                shipments.map(shipment => ({
                    value: shipment.id,

                    label:
                        `${ shipment.trackingNumber || shipment.id }
                         — ${ shipment.currentStatus || "Unknown" } `
                }))
        },


        // -----------------------------------------------------
        // STATUS
        // -----------------------------------------------------

        {
            name: "status",

            label: "Status",

            type: "select",

            required: true,

            defaultValue: "attempted",

            options: [
                {
                    value: "attempted",
                    label: "Attempted"
                },
                {
                    value: "failed",
                    label: "Failed"
                },
                {
                    value: "delivered",
                    label: "Delivered"
                }
            ]
        },


        // -----------------------------------------------------
        // REASON
        // -----------------------------------------------------

        {
            name: "reason",

            label: "Failure / Attempt Reason",

            type: "textarea"
        },


        // -----------------------------------------------------
        // NOTES
        // -----------------------------------------------------

        {
            name: "notes",

            label: "Notes",

            type: "textarea"
        },


        // -----------------------------------------------------
        // GPS
        // -----------------------------------------------------

        {
            name: "latitude",

            label: "Latitude",

            type: "number"
        },

        {
            name: "longitude",

            label: "Longitude",

            type: "number"
        },


        // =====================================================
        // PROOF OF DELIVERY
        // =====================================================

        {
            name: "receiverName",

            label: "Receiver Name",

            type: "text",

            required: true,

            showWhen: form =>
                form.status === "delivered"
        },

        {
            name: "receiverSignature",

            label: "Receiver Signature",

            type: "text",

            showWhen: form =>
                form.status === "delivered"
        },

        {
            name: "receiverRelation",

            label: "Receiver Relation",

            type: "text",

            showWhen: form =>
                form.status === "delivered"
        },

        {
            name: "deliveryPhoto",

            label: "Delivery Photo",

            type: "text",

            showWhen: form =>
                form.status === "delivered"
        },

        {
            name: "gpsAccuracy",

            label: "GPS Accuracy",

            type: "number",

            showWhen: form =>
                form.status === "delivered"
        },

        {
            name: "proofNotes",

            label: "Proof of Delivery Notes",

            type: "textarea",

            showWhen: form =>
                form.status === "delivered"
        }

    ], [
        assignments,
        selectedAssignment,
        shipments,
        loadingRelations
    ]);


    // =========================================================
    // TABLE COLUMNS
    // =========================================================

    const displayColumns = [

        {
            key: "attemptNumber",
            label: "Attempt"
        },

        {
            key: "shipmentId",
            label: "Shipment"
        },

        {
            key: "deliveryAssignmentId",
            label: "Assignment"
        },

        {
            key: "status",
            label: "Status"
        },

        {
            key: "attemptTime",
            label: "Attempt Time"
        },

        {
            key: "reason",
            label: "Reason"
        }
    ];


    // =========================================================
    // SORT OPTIONS
    // =========================================================

    const sortOptions = [

        {
            value: "attemptNumber",
            label: "Attempt Number"
        },

        {
            value: "attemptTime",
            label: "Attempt Time"
        },

        {
            value: "status",
            label: "Status"
        }

    ];


    // =========================================================
    // SUBMIT TRANSFORMATION
    //
    // Frontend fields:
    //
    // receiverName
    // receiverSignature
    // receiverRelation
    // deliveryPhoto
    // gpsAccuracy
    // proofNotes
    //
    // Backend expects:
    //
    // ProofOfDelivery: {
    //     receiverName,
    //     receiverSignature,
    //     receiverRelation,
    //     deliveryPhoto,
    //     gpsAccuracy,
    //     notes
    // }
    // =========================================================

    const handleCreate = async formData => {

        const status =
            formData.status ||
            "attempted";


        const payload = {

            shipmentId:
                formData.shipmentId,

            deliveryAssignmentId:
                formData.deliveryAssignmentId,

            status,

            reason:
                formData.reason || null,

            notes:
                formData.notes || null,

            latitude:
                formData.latitude === "" ||
                formData.latitude == null
                    ? null
                    : Number(formData.latitude),

            longitude:
                formData.longitude === "" ||
                formData.longitude == null
                    ? null
                    : Number(formData.longitude),

            proofOfDelivery:
                status === "delivered"
                    ? {
                        receiverName:
                            formData.receiverName || "",

                        receiverSignature:
                            formData.receiverSignature || null,

                        receiverRelation:
                            formData.receiverRelation || null,

                        deliveryPhoto:
                            formData.deliveryPhoto || null,

                        gpsAccuracy:
                            formData.gpsAccuracy === "" ||
                            formData.gpsAccuracy == null
                                ? null
                                : Number(formData.gpsAccuracy),

                        notes:
                            formData.proofNotes || null
                    }
                    : null
        };


        console.log(
            "Delivery attempt payload:",
            payload
        );


        return deliveryAttemptService.createAttempt(
            payload
        );
    };


    // =========================================================
    // EXTRA ACTIONS
    // =========================================================

    const extraActions = attempt => (

        <button
            type="button"
            className="crud-action-button"
            onClick={() =>
                navigate(
                    `/ delivery - attempts / ${ attempt.id } `
                )
            }
        >
            Details
        </button>
    );


    // =========================================================
    // PAGE
    // =========================================================

    return (

        <GenericEntityPage

            entityName="Delivery Attempts"

            permissionPrefix="delivery_attempts"

            service={deliveryAttemptService}

            fieldConfig={fieldConfig}

            displayColumns={displayColumns}

            sortOptions={sortOptions}

            extraActions={extraActions}

            showCreate={true}

            showEdit={false}

            showDelete={false}

            showCreate={true}

        />

    );
};


export default DeliveryAttemptsPage;