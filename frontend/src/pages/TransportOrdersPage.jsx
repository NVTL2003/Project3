import React, {
    useCallback,
    useEffect,
    useMemo,
    useState
} from "react";

import GenericEntityPage
    from "./GenericEntityPage";

import {
    transportOrderService
} from "../services/transportOrderService";

import {
    shipmentService
} from "../services/shipmentService";

import {
    facilityService
} from "../services/facilityService";


const normalizeItems = (response) => {

    const data = response?.data;

    if (Array.isArray(data)) {
        return data;
    }

    if (Array.isArray(data?.items)) {
        return data.items;
    }

    return [];
};


const getShipmentLabel = (shipment) => {

    if (!shipment) {
        return "Unknown Shipment";
    }

    const tracking =
        shipment.trackingNumber ||
        shipment.TrackingNumber ||
        shipment.id ||
        shipment.Id;

    const status =
        shipment.currentStatus ||
        shipment.CurrentStatus ||
        "";

    return status
        ? `${ tracking } — ${ status } `
        : String(tracking);
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


const TransportOrdersPage = () => {

    const [
        shipments,
        setShipments
    ] = useState([]);

    const [
        transportOrders,
        setTransportOrders
    ] = useState([]);

    const [
        facilities,
        setFacilities
    ] = useState([]);

    const [
        relationLoading,
        setRelationLoading
    ] = useState(true);


    // =========================================================
    // LOAD RELATIONS
    // =========================================================

    const loadRelations = useCallback(
        async () => {

            try {

                setRelationLoading(true);

                const [
                    shipmentResponse,
                    transportOrderResponse,
                    facilityResponse
                ] = await Promise.all([

                    shipmentService.getPaged({
                        page: 1,
                        pageSize: 1000
                    }),

                    transportOrderService.getPaged({
                        page: 1,
                        pageSize: 1000
                    }),

                    facilityService.getPaged({
                        page: 1,
                        pageSize: 1000
                    })

                ]);


                setShipments(
                    normalizeItems(
                        shipmentResponse
                    )
                );

                setTransportOrders(
                    normalizeItems(
                        transportOrderResponse
                    )
                );

                setFacilities(
                    normalizeItems(
                        facilityResponse
                    )
                );

            } catch (error) {

                console.error(
                    "Failed to load Transport Order relations:",
                    error
                );

                setShipments([]);
                setTransportOrders([]);
                setFacilities([]);

            } finally {

                setRelationLoading(false);
            }

        },
        []
    );


    // =========================================================
    // INITIAL RELATION LOAD
    // =========================================================

    useEffect(() => {

        loadRelations();

    }, [
        loadRelations
    ]);


    // =========================================================
    // SHIPMENTS THAT ALREADY HAVE A TRANSPORT ORDER
    // =========================================================

    const shipmentIdsWithTransportOrder = useMemo(() => {

        return new Set(

            transportOrders
                .map(order => {

                    const shipmentId =
                        order.shipmentId ??
                        order.ShipmentId;

                    if (!shipmentId) {
                        return null;
                    }

                    return String(
                        shipmentId
                    )
                        .trim()
                        .toLowerCase();
                })
                .filter(Boolean)

        );

    }, [
        transportOrders
    ]);


    // =========================================================
    // SHIPMENTS AVAILABLE FOR NEW TRANSPORT ORDER
    // =========================================================

    const availableShipments = useMemo(() => {

        return shipments.filter(
            shipment => {

                const shipmentId =
                    shipment.id ??
                    shipment.Id;

                if (!shipmentId) {
                    return false;
                }

                const normalizedId =
                    String(
                        shipmentId
                    )
                        .trim()
                        .toLowerCase();

                return !shipmentIdsWithTransportOrder.has(
                    normalizedId
                );
            }
        );

    }, [
        shipments,
        shipmentIdsWithTransportOrder
    ]);


    // =========================================================
    // FORM
    // =========================================================

    const fieldConfig = [

        {
            name: "shipmentId",
            label: "Shipment",
            type: "relation",
            required: true,

            options: availableShipments,

            valueField: "id",

            getOptionLabel:
                getShipmentLabel,

            disabled:
                relationLoading ||
                availableShipments.length === 0
        },


        {
            name: "originFacilityId",
            label: "Origin Facility",
            type: "relation",
            required: true,

            service: facilityService,

            valueField: "id",

            sortBy: "name",

            getOptionLabel:
                getFacilityLabel
        },


        {
            name: "destinationFacilityId",
            label: "Destination Facility",
            type: "relation",
            required: true,

            dependsOn: "originFacilityId",

            dependentFetch: async (
                originFacilityId
            ) => {

                const response =
                    await facilityService.getPaged({
                        page: 1,
                        pageSize: 1000
                    });

                const allFacilities =
                    normalizeItems(response);

                const filteredFacilities =
                    allFacilities.filter(
                        facility => {

                            const facilityId =
                                facility.id ||
                                facility.Id;

                            return (
                                String(
                                    facilityId
                                )
                                    .trim()
                                    .toLowerCase() !==
                                String(
                                    originFacilityId
                                )
                                    .trim()
                                    .toLowerCase()
                            );
                        }
                    );

                return {
                    data: filteredFacilities
                };
            },

            valueField: "id",

            getOptionLabel:
                getFacilityLabel
        },


        {
            name: "priority",
            label: "Priority",
            type: "number",
            defaultValue: 5
        },


        {
            name: "weight",
            label: "Weight (kg)",
            type: "number",
            required: true
        },


        {
            name: "volume",
            label: "Volume"
        },


        {
            name: "plannedDeparture",
            label: "Planned Departure",
            type: "datetime-local"
        },


        {
            name: "plannedArrival",
            label: "Planned Arrival",
            type: "datetime-local"
        },


        {
            name: "specialInstructions",
            label: "Special Instructions",
            type: "textarea"
        }

    ];


    // =========================================================
    // DISPLAY
    // =========================================================

    const displayColumns = [

        {
            key: "orderNumber",
            label: "Order #"
        },


        {
            key: "shipmentId",
            label: "Shipment",

            render: (order) => {

                const shipmentId =
                    order.shipmentId ||
                    order.ShipmentId;

                const shipment =
                    shipments.find(
                        item =>
                            String(
                                item.id ||
                                item.Id
                            )
                                .trim()
                                .toLowerCase() ===
                            String(
                                shipmentId
                            )
                                .trim()
                                .toLowerCase()
                    );

                return (
                    <>
                        <div className="crud-list-label">
                            Shipment
                        </div>

                        <div className="crud-list-value">
                            {getShipmentLabel(
                                shipment
                            )}
                        </div>
                    </>
                );
            }
        },


        {
            key: "status",
            label: "Status"
        },


        {
            key: "priority",
            label: "Priority"
        },


        {
            key: "weight",
            label: "Weight"
        },


        {
            key: "plannedDeparture",
            label: "Planned Departure"
        },


        {
            key: "plannedArrival",
            label: "Planned Arrival"
        },


        {
            key: "createdAt",
            label: "Created"
        }

    ];


    // =========================================================
    // SORT
    // =========================================================

    const sortOptions = [

        {
            value: "orderNumber",
            label: "Order Number"
        },

        {
            value: "status",
            label: "Status"
        },

        {
            value: "priority",
            label: "Priority"
        },

        {
            value: "plannedDeparture",
            label: "Planned Departure"
        },

        {
            value: "createdAt",
            label: "Created"
        }

    ];


    // =========================================================
    // FILTER
    // =========================================================

    const filterOptions = [

        {
            field: "status",

            label: "Status",

            options: [

                {
                    value: "created",
                    label: "Created"
                },

                {
                    value: "planned",
                    label: "Planned"
                },

                {
                    value: "assigned",
                    label: "Assigned"
                },

                {
                    value: "in_transit",
                    label: "In Transit"
                },

                {
                    value: "delivered",
                    label: "Delivered"
                },

                {
                    value: "cancelled",
                    label: "Cancelled"
                }

            ]
        }

    ];


    // =========================================================
    // PAGE
    // =========================================================

    return (

        <GenericEntityPage

            entityName="Transport Orders"

            permissionPrefix="transport_orders"

            permissionScope="all"

            requirePermission={true}

            service={transportOrderService}

            fieldConfig={fieldConfig}

            displayColumns={displayColumns}

            sortOptions={sortOptions}

            filterOptions={filterOptions}

            onSuccess={loadRelations}

        />

    );
};


export default TransportOrdersPage;