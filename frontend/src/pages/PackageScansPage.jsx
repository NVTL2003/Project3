import React, {
    useCallback,
    useEffect,
    useMemo,
    useRef,
    useState
} from "react";

import { Html5Qrcode } from "html5-qrcode";

import { packageScanService } from "../services/packageScanService";
import { shipmentService } from "../services/shipmentService";
import { facilityService } from "../services/facilityService";
import { manifestItemService } from "../services/manifestItemService";
import { shipmentManifestService } from "../services/shipmentManifestService";
import { transportOrderService } from "../services/transportOrderService";


/* =========================================================
   Helpers
========================================================= */

const getId = (item) =>
    item?.id ??
    item?.Id ??
    null;


const sameId = (a, b) => {
    if (!a || !b) return false;

    return (
        String(a).toLowerCase() ===
        String(b).toLowerCase()
    );
};


const normalizeStatus = (value) =>
    String(value ?? "")
        .trim()
        .toLowerCase();


const getTrackingNumber = (shipment) =>
    shipment?.trackingNumber ??
    shipment?.TrackingNumber ??
    "";


const getShipmentStatus = (shipment) =>
    shipment?.currentStatus ??
    shipment?.CurrentStatus ??
    "";


const getManifestItemTransportOrderId = (item) =>
    item?.transportOrderId ??
    item?.TransportOrderId ??
    null;


const getTransportOrderShipmentId = (order) =>
    order?.shipmentId ??
    order?.ShipmentId ??
    null;


const getManifestItemStatus = (item) =>
    item?.status ??
    item?.Status ??
    "";


const getManifestItemManifestId = (item) =>
    item?.manifestId ??
    item?.ManifestId ??
    null;


const getManifestItemVehicleId = (item) =>
    item?.manifest?.vehicleId ??
    item?.Manifest?.VehicleId ??
    null;


const getManifestVehicleId = (manifest) =>
    manifest?.vehicleId ??
    manifest?.VehicleId ??
    null;


const getManifestDepartureFacilityId = (manifest) =>
    manifest?.departureFacilityId ??
    manifest?.DepartureFacilityId ??
    null;


const getManifestStatus = (manifest) =>
    manifest?.status ??
    manifest?.Status ??
    "";


const getManifestArrivalFacilityId = (manifest) =>
    manifest?.arrivalFacilityId ??
    manifest?.ArrivalFacilityId ??
    manifest?.destinationFacilityId ??
    manifest?.DestinationFacilityId ??
    null;


const getFacilityName = (facility) =>
    facility?.name ??
    facility?.Name ??
    facility?.facilityCode ??
    facility?.FacilityCode ??
    getId(facility);


/*
 * Extract paged response items regardless of
 * camelCase / PascalCase response format.
 */
const getResponseItems = (response) =>
    response?.data?.items ??
    response?.data?.Items ??
    response?.data ??
    [];


/*
 * Extract total pages if backend provides it.
 */
const getResponseTotalPages = (response) =>
    response?.data?.totalPages ??
    response?.data?.TotalPages ??
    null;


/*
 * Load every page from a CRUD service.
 */
const getAllPaged = async (service) => {

    const pageSize = 100;

    let page = 1;
    let allItems = [];

    while (true) {

        const response =
            await service.getPaged({
                page,
                pageSize
            });

        const items =
            getResponseItems(response);

        allItems = [
            ...allItems,
            ...items
        ];

        const totalPages =
            getResponseTotalPages(response);

        if (totalPages !== null) {

            if (page >= totalPages) {
                break;
            }

            page++;

            continue;
        }

        if (items.length < pageSize) {
            break;
        }

        page++;
    }

    return allItems;
};


/* =========================================================
   Scan labels
========================================================= */

const SCAN_LABELS = {

    pickup: "Pickup",

    load: "Load",

    depart: "Depart",

    arrive: "Arrive",

    unload: "Unload",

    out_for_delivery:
        "Out for Delivery",

    delivered:
        "Delivered"
};


/* =========================================================
   Location type
========================================================= */

const getLocationTypeForScan = (
    scanType
) => {

    switch (scanType) {

        case "load":
        case "arrive":
        case "unload":

            return "distribution_center";


        case "depart":

            return "vehicle";


        case "pickup":
        case "out_for_delivery":
        case "delivered":
        default:

            return "branch";
    }
};


/* =========================================================
   Scan configuration
========================================================= */

const getScanConfig = (
    scanType
) => {

    switch (scanType) {

        case "pickup":

            return {
                label: "Pickup",
                requiresManifestItem: false,
                requiresFacility: true,
                requiresVehicle: false,
                locationType: "branch"
            };


        case "load":

            return {
                label: "Load",
                requiresManifestItem: true,
                requiresFacility: true,
                requiresVehicle: false,
                locationType:
                    "distribution_center"
            };


        case "depart":

            return {
                label: "Depart",
                requiresManifestItem: true,
                requiresFacility: true,
                requiresVehicle: true,
                locationType: "vehicle"
            };


        case "arrive":

            return {
                label: "Arrive",
                requiresManifestItem: true,
                requiresFacility: true,
                requiresVehicle: true,
                locationType:
                    "distribution_center"
            };


        case "unload":

            return {
                label: "Unload",
                requiresManifestItem: true,
                requiresFacility: true,
                requiresVehicle: false,
                locationType:
                    "distribution_center"
            };


        case "out_for_delivery":

            return {
                label: "Out for Delivery",
                requiresManifestItem: false,
                requiresFacility: true,
                requiresVehicle: false,
                locationType: "branch"
            };


        case "delivered":

            return {
                label: "Delivered",
                requiresManifestItem: false,
                requiresFacility: false,
                requiresVehicle: false,
                locationType: "branch"
            };


        default:

            return {
                label: scanType || "Scan",
                requiresManifestItem: false,
                requiresFacility: false,
                requiresVehicle: false,
                locationType: "branch"
            };
    }
};


/* =========================================================
   Page
========================================================= */

const PackageScansPage = () => {

    /* -----------------------------------------------------
       Data
    ----------------------------------------------------- */

    const [shipments, setShipments] =
        useState([]);

    const [facilities, setFacilities] =
        useState([]);

    const [manifestItems, setManifestItems] =
        useState([]);

    const [manifests, setManifests] =
        useState([]);

    const [transportOrders, setTransportOrders] =
        useState([]);


    /* -----------------------------------------------------
       UI state
    ----------------------------------------------------- */

    const [loading, setLoading] =
        useState(true);

    const [scannerRunning, setScannerRunning] =
        useState(false);

    const [submitting, setSubmitting] =
        useState(false);

    const [scannerError, setScannerError] =
        useState(null);

    const [error, setError] =
        useState(null);

    const [result, setResult] =
        useState(null);

    const [
        manualTrackingNumber,
        setManualTrackingNumber
    ] = useState("");

    const [shipment, setShipment] =
        useState(null);


    /* -----------------------------------------------------
       Form
    ----------------------------------------------------- */

    const [form, setForm] = useState({

        scanType: "",

        manifestItemId: "",

        facilityId: "",

        vehicleId: "",

        locationType: "branch",

        notes: ""
    });


    const scannerRef =
        useRef(null);


    /* =====================================================
       Load data
    ===================================================== */

    const loadData =
        useCallback(async () => {

            setLoading(true);

            setError(null);

            try {

                const [
                    shipmentData,
                    facilityData,
                    manifestItemsData,
                    manifestsData,
                    transportOrdersData
                ] = await Promise.all([

                    getAllPaged(
                        shipmentService
                    ),

                    getAllPaged(
                        facilityService
                    ),

                    getAllPaged(
                        manifestItemService
                    ),

                    getAllPaged(
                        shipmentManifestService
                    ),

                    getAllPaged(
                        transportOrderService
                    )
                ]);


                setShipments(
                    shipmentData
                );

                setFacilities(
                    facilityData
                );

                setManifestItems(
                    manifestItemsData
                );

                setManifests(
                    manifestsData
                );

                setTransportOrders(
                    transportOrdersData
                );


                return {

                    shipments:
                        shipmentData,

                    facilities:
                        facilityData,

                    manifestItems:
                        manifestItemsData,

                    manifests:
                        manifestsData,

                    transportOrders:
                        transportOrdersData
                };

            } catch (err) {

                console.error(
                    "Failed to load package scan data:",
                    err
                );


                setError(

                    err?.response?.data?.message ??
                    err?.response?.data?.title ??
                    "Failed to load package scan data."

                );


                return null;

            } finally {

                setLoading(false);
            }

        }, []);


    useEffect(() => {

        loadData();

    }, [loadData]);


    /* =====================================================
       Resolve ManifestItem -> TransportOrder -> Shipment
    ===================================================== */

    const getManifestItemShipmentId =
        useCallback(

            (item) => {

                if (!item) {
                    return null;
                }


                /*
                 * Direct shipmentId
                 */

                const directShipmentId =
                    item?.shipmentId ??
                    item?.ShipmentId;

                if (directShipmentId) {

                    return directShipmentId;
                }


                /*
                 * Nested TransportOrder
                 */

                const nestedShipmentId =
                    item?.transportOrder?.shipmentId ??
                    item?.transportOrder?.ShipmentId ??
                    item?.TransportOrder?.shipmentId ??
                    item?.TransportOrder?.ShipmentId;

                if (nestedShipmentId) {

                    return nestedShipmentId;
                }


                /*
                 * TransportOrderId lookup
                 */

                const transportOrderId =
                    getManifestItemTransportOrderId(
                        item
                    );

                if (!transportOrderId) {

                    return null;
                }


                const transportOrder =
                    transportOrders.find(
                        (order) =>
                            sameId(
                                getId(order),
                                transportOrderId
                            )
                    );


                if (!transportOrder) {

                    return null;
                }


                return getTransportOrderShipmentId(
                    transportOrder
                );
            },

            [transportOrders]
        );


    /* =====================================================
       Manifest for item
    ===================================================== */

    const getManifestForItem =
        useCallback(

            (item) => {

                if (!item) {
                    return null;
                }


                const manifestId =
                    getManifestItemManifestId(
                        item
                    );

                if (!manifestId) {
                    return null;
                }


                return (
                    manifests.find(
                        (manifest) =>
                            sameId(
                                getId(manifest),
                                manifestId
                            )
                    ) ?? null
                );
            },

            [manifests]
        );


    /* =====================================================
       Manifest items belonging to shipment
    ===================================================== */

    const availableManifestItems =
        useMemo(() => {

            if (!shipment) {

                return [];
            }


            const shipmentId =
                getId(shipment);

            if (!shipmentId) {

                return [];
            }


            return manifestItems.filter(
                (item) => {

                    const itemShipmentId =
                        getManifestItemShipmentId(
                            item
                        );

                    return (
                        itemShipmentId &&
                        sameId(
                            itemShipmentId,
                            shipmentId
                        )
                    );
                }
            );

        }, [

            shipment,

            manifestItems,

            getManifestItemShipmentId
        ]);


    /* =====================================================
       Valid ManifestItems for CURRENT operation
    ===================================================== */

    const validManifestItems =
        useMemo(() => {

            if (!shipment) {

                return [];
            }


            switch (form.scanType) {

                case "load":

                    return availableManifestItems
                        .filter((item) => {

                            const itemStatus =
                                normalizeStatus(
                                    getManifestItemStatus(
                                        item
                                    )
                                );

                            const manifest =
                                getManifestForItem(
                                    item
                                );

                            const manifestStatus =
                                normalizeStatus(
                                    getManifestStatus(
                                        manifest
                                    )
                                );

                            return (

                                itemStatus ===
                                "planned"

                                &&

                                manifestStatus ===
                                "planned"

                            );
                        });


                case "depart":

                    return availableManifestItems
                        .filter((item) => {

                            const itemStatus =
                                normalizeStatus(
                                    getManifestItemStatus(
                                        item
                                    )
                                );

                            const manifest =
                                getManifestForItem(
                                    item
                                );

                            const manifestStatus =
                                normalizeStatus(
                                    getManifestStatus(
                                        manifest
                                    )
                                );

                            return (

                                itemStatus ===
                                "loaded"

                                &&

                                manifestStatus ===
                                "planned"

                            );
                        });


                case "arrive":

                case "unload":

                    return availableManifestItems
                        .filter((item) => {

                            const itemStatus =
                                normalizeStatus(
                                    getManifestItemStatus(
                                        item
                                    )
                                );

                            const manifest =
                                getManifestForItem(
                                    item
                                );

                            const manifestStatus =
                                normalizeStatus(
                                    getManifestStatus(
                                        manifest
                                    )
                                );

                            return (

                                itemStatus ===
                                "loaded"

                                &&

                                manifestStatus ===
                                "in_progress"

                            );
                        });


                default:

                    return [];
            }

        }, [

            shipment,

            form.scanType,

            availableManifestItems,

            getManifestForItem
        ]);


    /* =====================================================
       Determine available scan types
    ===================================================== */

    const availableScanTypes =
        useMemo(() => {

            if (!shipment) {

                return [];
            }


            const shipmentStatus =
                normalizeStatus(
                    getShipmentStatus(
                        shipment
                    )
                );


            const available = [];


            /*
             * -------------------------------------------------
             * PICKUP
             * -------------------------------------------------
             */

            if (

                shipmentStatus ===
                "created"

                ||

                shipmentStatus ===
                "pickup_scheduled"

            ) {

                available.push(
                    "pickup"
                );
            }


            /*
             * -------------------------------------------------
             * LOAD
             * -------------------------------------------------
             */

            const canLoad =
                validManifestItems.some(
                    (item) => {

                        const itemStatus =
                            normalizeStatus(
                                getManifestItemStatus(
                                    item
                                )
                            );

                        const manifest =
                            getManifestForItem(
                                item
                            );

                        const manifestStatus =
                            normalizeStatus(
                                getManifestStatus(
                                    manifest
                                )
                            );

                        return (

                            itemStatus ===
                            "planned"

                            &&

                            manifestStatus ===
                            "planned"

                        );
                    }
                );


            if (

                shipmentStatus ===
                "in_sorting"

                &&

                canLoad

            ) {

                available.push(
                    "load"
                );
            }


            /*
             * -------------------------------------------------
             * DEPART
             * -------------------------------------------------
             */

            const canDepart =
                validManifestItems.some(
                    (item) => {

                        const itemStatus =
                            normalizeStatus(
                                getManifestItemStatus(
                                    item
                                )
                            );

                        const manifest =
                            getManifestForItem(
                                item
                            );

                        const manifestStatus =
                            normalizeStatus(
                                getManifestStatus(
                                    manifest
                                )
                            );

                        return (

                            itemStatus ===
                            "loaded"

                            &&

                            manifestStatus ===
                            "planned"

                        );
                    }
                );


            if (

                shipmentStatus ===
                "loaded"

                &&

                canDepart

            ) {

                available.push(
                    "depart"
                );
            }


            /*
             * -------------------------------------------------
             * ARRIVE
             * -------------------------------------------------
             */

            const canArrive =
                validManifestItems.some(
                    (item) => {

                        const itemStatus =
                            normalizeStatus(
                                getManifestItemStatus(
                                    item
                                )
                            );

                        const manifest =
                            getManifestForItem(
                                item
                            );

                        const manifestStatus =
                            normalizeStatus(
                                getManifestStatus(
                                    manifest
                                )
                            );

                        return (

                            itemStatus ===
                            "loaded"

                            &&

                            manifestStatus ===
                            "in_progress"

                        );
                    }
                );


            if (

                shipmentStatus ===
                "in_transit"

                &&

                canArrive

            ) {

                available.push(
                    "arrive"
                );
            }


            /*
             * -------------------------------------------------
             * UNLOAD
             * -------------------------------------------------
             */

            const canUnload =
                validManifestItems.some(
                    (item) => {

                        const itemStatus =
                            normalizeStatus(
                                getManifestItemStatus(
                                    item
                                )
                            );

                        const manifest =
                            getManifestForItem(
                                item
                            );

                        const manifestStatus =
                            normalizeStatus(
                                getManifestStatus(
                                    manifest
                                )
                            );

                        return (

                            itemStatus ===
                            "loaded"

                            &&

                            manifestStatus ===
                            "in_progress"

                        );
                    }
                );


            if (

                shipmentStatus ===
                "in_sorting"

                &&

                canUnload

            ) {

                available.push(
                    "unload"
                );
            }


            /*
             * -------------------------------------------------
             * OUT FOR DELIVERY
             *
             * For the current implementation,
             * the shipment must have completed line-haul.
             * -------------------------------------------------
             */

            const hasCompletedLineHaul =
                availableManifestItems.some(
                    (item) => {

                        const itemStatus =
                            normalizeStatus(
                                getManifestItemStatus(
                                    item
                                )
                            );

                        const manifest =
                            getManifestForItem(
                                item
                            );

                        const manifestStatus =
                            normalizeStatus(
                                getManifestStatus(
                                    manifest
                                )
                            );

                        return (

                            itemStatus ===
                            "unloaded"

                            &&

                            manifestStatus ===
                            "completed"

                        );
                    }
                );


            if (

                shipmentStatus ===
                "in_sorting"

                &&

                hasCompletedLineHaul

            ) {

                available.push(
                    "out_for_delivery"
                );
            }


            /*
             * -------------------------------------------------
             * DELIVERED
             * -------------------------------------------------
             */

            if (

                shipmentStatus ===
                "out_for_delivery"

            ) {

                available.push(
                    "delivered"
                );
            }


            return available;

        }, [

            shipment,

            validManifestItems,

            availableManifestItems,

            getManifestForItem
        ]);


    /* =====================================================
       Automatically select valid scan type
    ===================================================== */

    useEffect(() => {

        if (!shipment) {

            return;
        }


        /*
         * No valid operations.
         */

        if (
            availableScanTypes.length === 0
        ) {

            setForm((prev) => ({

                ...prev,

                scanType: "",

                manifestItemId: "",

                vehicleId: "",

                facilityId: "",

                locationType: "branch"

            }));

            return;
        }


        /*
         * Current scan type is still valid.
         */

        if (
            availableScanTypes.includes(
                form.scanType
            )
        ) {

            return;
        }


        /*
         * Otherwise automatically select
         * the first valid operation.
         */

        const nextScanType =
            availableScanTypes[0];


        setForm((prev) => ({

            ...prev,

            scanType:
                nextScanType,

            manifestItemId: "",

            vehicleId: "",

            facilityId: "",

            locationType:
                getLocationTypeForScan(
                    nextScanType
                )

        }));

    }, [

        shipment,

        availableScanTypes,

        form.scanType
    ]);


    /* =====================================================
       Current selected ManifestItem
    ===================================================== */

    const selectedManifestItem =
        useMemo(() => {

            if (
                !form.manifestItemId
            ) {

                return null;
            }


            return (

                validManifestItems.find(
                    (item) =>
                        sameId(
                            getId(item),
                            form.manifestItemId
                        )
                )

                ??

                null

            );

        }, [

            form.manifestItemId,

            validManifestItems
        ]);


    /* =====================================================
       Current selected Manifest
    ===================================================== */

    const selectedManifest =
        useMemo(() => {

            return getManifestForItem(
                selectedManifestItem
            );

        }, [

            selectedManifestItem,

            getManifestForItem
        ]);


    /* =====================================================
       Automatically select ManifestItem
    ===================================================== */

    useEffect(() => {

        if (!shipment) {

            return;
        }


        const scanType =
            form.scanType;


        /*
         * Standalone operations don't use
         * ManifestItem.
         */

        if (

            scanType === "pickup" ||

            scanType ===
            "out_for_delivery" ||

            scanType ===
            "delivered"

        ) {

            if (

                form.manifestItemId ||
                form.vehicleId

            ) {

                setForm((prev) => ({

                    ...prev,

                    manifestItemId: "",

                    vehicleId: ""

                }));
            }

            return;
        }


        /*
         * No valid ManifestItems.
         */

        if (
            validManifestItems.length === 0
        ) {

            setForm((prev) => ({

                ...prev,

                manifestItemId: "",

                vehicleId: "",

                facilityId:
                    scanType === "load"
                        ? ""
                        : prev.facilityId

            }));

            return;
        }


        /*
         * Exactly one valid ManifestItem.
         */

        if (
            validManifestItems.length === 1
        ) {

            const item =
                validManifestItems[0];


            const itemId =
                getId(item);


            if (!itemId) {

                return;
            }


            const manifest =
                getManifestForItem(
                    item
                );


            const vehicleId =
                getManifestVehicleId(
                    manifest
                )

                ??

                getManifestItemVehicleId(
                    item
                )

                ??

                "";


            const departureFacilityId =
                getManifestDepartureFacilityId(
                    manifest
                );


            setForm((prev) => ({

                ...prev,

                manifestItemId:
                    itemId,

                vehicleId:
                    vehicleId,

                facilityId:
                    scanType === "load"

                        ? (
                            departureFacilityId ??
                            prev.facilityId
                        )

                        : prev.facilityId

            }));

            return;
        }


        /*
         * Multiple valid ManifestItems.
         *
         * Keep existing selection only if
         * it is still valid.
         */

        const stillValid =
            validManifestItems.some(
                (item) =>
                    sameId(
                        getId(item),
                        form.manifestItemId
                    )
            );


        if (!stillValid) {

            setForm((prev) => ({

                ...prev,

                manifestItemId: "",

                vehicleId: ""

            }));
        }

    }, [

        shipment,

        form.scanType,

        form.manifestItemId,

        validManifestItems,

        getManifestForItem
    ]);


    /* =====================================================
       Facility options
    ===================================================== */

    const availableFacilities =
        useMemo(() => {

            if (!shipment) {

                return [];
            }


            /*
             * LOAD
             *
             * Only departure facility.
             */

            if (
                form.scanType === "load"
                &&
                selectedManifest
            ) {

                const departureId =
                    getManifestDepartureFacilityId(
                        selectedManifest
                    );


                if (departureId) {

                    const departureFacility =
                        facilities.find(
                            (facility) =>
                                sameId(
                                    getId(facility),
                                    departureId
                                )
                        );


                    return departureFacility
                        ? [departureFacility]
                        : [];
                }
            }


            /*
             * OUT FOR DELIVERY
             *
             * Shipment is currently at the
             * destination branch/facility.
             *
             * If we know the latest facility,
             * preferably show that facility.
             *
             * Otherwise show all facilities.
             */

            if (
                form.scanType ===
                "out_for_delivery"
            ) {

                return facilities;
            }


            /*
             * ARRIVE
             *
             * Ideally the next route stop should
             * be selected. The backend remains
             * authoritative here.
             *
             * Without RouteStop data in this page,
             * leave all facilities available.
             */

            return facilities;

        }, [

            shipment,

            form.scanType,

            facilities,

            selectedManifest
        ]);


    /* =====================================================
       Select shipment
    ===================================================== */

    const selectShipment =
        useCallback(
            (selectedShipment) => {

                setShipment(
                    selectedShipment
                );


                setResult(null);

                setError(null);

                setScannerError(null);


                /*
                 * Reset dependent fields.
                 *
                 * scanType is reset too.
                 * The available-operation effect
                 * will choose the correct operation.
                 */

                setForm({

                    scanType: "",

                    manifestItemId: "",

                    facilityId: "",

                    vehicleId: "",

                    locationType: "branch",

                    notes: ""

                });

            },
            []
        );


    /* =====================================================
       Find shipment
    ===================================================== */

    const findShipment =
        useCallback(

            (value) => {

                const searchValue =
                    String(
                        value ?? ""
                    ).trim();


                if (!searchValue) {

                    return null;
                }


                /*
                 * Search by Shipment ID.
                 */

                const byId =
                    shipments.find(
                        (item) =>
                            sameId(
                                getId(item),
                                searchValue
                            )
                    );


                if (byId) {

                    return byId;
                }


                /*
                 * Search by Tracking Number.
                 */

                const lowerSearch =
                    searchValue.toLowerCase();


                return (

                    shipments.find(
                        (item) =>
                            String(
                                getTrackingNumber(
                                    item
                                )
                            ).toLowerCase() ===
                            lowerSearch
                    )

                    ??

                    null
                );

            },

            [shipments]
        );


    /* =====================================================
       Manual shipment search
    ===================================================== */

    const handleManualSearch =
        () => {

            setError(null);

            setResult(null);


            const foundShipment =
                findShipment(
                    manualTrackingNumber
                );


            if (!foundShipment) {

                setShipment(null);

                setForm({

                    scanType: "",

                    manifestItemId: "",

                    facilityId: "",

                    vehicleId: "",

                    locationType: "branch",

                    notes: ""

                });


                setError(
                    "Shipment was not found. Make sure the tracking number is correct."
                );

                return;
            }


            selectShipment(
                foundShipment
            );


            setManualTrackingNumber(
                getTrackingNumber(
                    foundShipment
                )
            );
        };


    /* =====================================================
       QR scanner
    ===================================================== */

    const stopScanner =
        useCallback(
            async () => {

                const scanner =
                    scannerRef.current;


                if (!scanner) {

                    setScannerRunning(
                        false
                    );

                    return;
                }


                try {

                    if (
                        scanner.isScanning
                    ) {

                        await scanner.stop();
                    }

                } catch (err) {

                    console.warn(
                        "Failed to stop QR scanner:",
                        err
                    );
                }


                try {

                    await scanner.clear();

                } catch (err) {

                    console.warn(
                        "Failed to clear QR scanner:",
                        err
                    );
                }


                scannerRef.current =
                    null;


                setScannerRunning(
                    false
                );

            },
            []
        );


    const handleScannedCode =
        useCallback(

            async (decodedText) => {

                const value =
                    String(
                        decodedText ?? ""
                    ).trim();


                if (!value) {

                    return;
                }


                const foundShipment =
                    findShipment(
                        value
                    );


                if (!foundShipment) {

                    setScannerError(
                        `QR scanned "${value}", but no shipment was found.`
                    );

                    return;
                }


                setScannerError(null);


                selectShipment(
                    foundShipment
                );


                setManualTrackingNumber(
                    getTrackingNumber(
                        foundShipment
                    )
                );


                await stopScanner();

            },

            [

                findShipment,

                selectShipment,

                stopScanner
            ]
        );


    const startScanner =
        async () => {

            setScannerError(null);


            if (
                scannerRef.current
            ) {

                return;
            }


            try {

                const scanner =
                    new Html5Qrcode(
                        "package-scanner"
                    );


                scannerRef.current =
                    scanner;


                await scanner.start(

                    {
                        facingMode:
                            "environment"
                    },

                    {
                        fps: 10,

                        qrbox: {
                            width: 280,
                            height: 180
                        }
                    },

                    async (decodedText) => {

                        await handleScannedCode(
                            decodedText
                        );

                    },

                    () => {

                        /*
                         * Ignore continuous
                         * QR decode failures.
                         */

                    }
                );


                setScannerRunning(
                    true
                );

            } catch (err) {

                console.error(
                    "Unable to start QR scanner:",
                    err
                );


                scannerRef.current =
                    null;


                setScannerRunning(
                    false
                );


                setScannerError(
                    "Unable to access the camera. Please allow camera permission, use HTTPS/localhost, or enter the tracking number manually."
                );
            }
        };


    useEffect(() => {

        return () => {

            stopScanner();

        };

    }, [stopScanner]);


    /* =====================================================
       Scan type change
    ===================================================== */

    const handleScanTypeChange =
        (event) => {

            const scanType =
                event.target.value;


            /*
             * Don't allow selecting
             * an operation that the frontend
             * considers invalid.
             */

            if (
                !availableScanTypes.includes(
                    scanType
                )
            ) {

                return;
            }


            setForm((prev) => ({

                ...prev,

                scanType,

                manifestItemId: "",

                vehicleId: "",

                facilityId: "",

                locationType:
                    getLocationTypeForScan(
                        scanType
                    )

            }));


            setResult(null);

            setError(null);
        };


    /* =====================================================
       Manifest item change
    ===================================================== */

    const handleManifestItemChange =
        (event) => {

            const manifestItemId =
                event.target.value;


            const item =
                validManifestItems.find(
                    (candidate) =>
                        sameId(
                            getId(candidate),
                            manifestItemId
                        )
                );


            if (!item) {

                setForm((prev) => ({

                    ...prev,

                    manifestItemId: "",

                    vehicleId: ""

                }));

                return;
            }


            const manifest =
                getManifestForItem(
                    item
                );


            const vehicleId =
                getManifestVehicleId(
                    manifest
                )

                ??

                getManifestItemVehicleId(
                    item
                )

                ??

                "";


            const departureFacilityId =
                getManifestDepartureFacilityId(
                    manifest
                );


            setForm((prev) => ({

                ...prev,

                manifestItemId,

                vehicleId,

                facilityId:
                    form.scanType === "load"

                        ? (
                            departureFacilityId ??
                            prev.facilityId
                        )

                        : prev.facilityId

            }));
        };


    /* =====================================================
       Generic field changes
    ===================================================== */

    const handleFieldChange =
        (event) => {

            const {
                name,
                value
            } = event.target;


            /*
             * Vehicle and location type are
             * controlled by the operation.
             */

            if (
                name === "vehicleId" ||
                name === "locationType"
            ) {

                return;
            }


            setForm((prev) => ({

                ...prev,

                [name]: value

            }));
        };


    /* =====================================================
       Submit scan
    ===================================================== */

    const handleSubmit =
        async (event) => {

            event.preventDefault();


            setError(null);

            setResult(null);


            if (!shipment) {

                setError(
                    "Please scan a shipment QR code or enter a tracking number first."
                );

                return;
            }


            /*
             * Scan type must be currently valid.
             */

            if (
                !form.scanType
            ) {

                setError(
                    "There is currently no available scan operation for this shipment."
                );

                return;
            }


            if (
                !availableScanTypes.includes(
                    form.scanType
                )
            ) {

                setError(
                    "This scan operation is no longer valid for the current shipment state. Please refresh the shipment."
                );

                return;
            }


            const scanConfig =
                getScanConfig(
                    form.scanType
                );


            /*
             * ManifestItem
             */

            if (

                scanConfig.requiresManifestItem

                &&

                !form.manifestItemId

            ) {

                setError(
                    "A valid manifest item is required for this operation."
                );

                return;
            }


            /*
             * Required facility
             */

            if (

                scanConfig.requiresFacility

                &&

                !form.facilityId

            ) {

                setError(
                    "Please select a facility."
                );

                return;
            }


            /*
             * Required vehicle
             */

            if (

                scanConfig.requiresVehicle

                &&

                !form.vehicleId

            ) {

                setError(
                    "A vehicle assigned to the manifest is required."
                );

                return;
            }


            /*
             * Verify ManifestItem is valid
             * for this shipment AND operation.
             */

            if (
                scanConfig.requiresManifestItem
            ) {

                const validManifestItem =
                    validManifestItems.some(
                        (item) =>
                            sameId(
                                getId(item),
                                form.manifestItemId
                            )
                    );


                if (!validManifestItem) {

                    setError(
                        "The selected manifest item is not valid for this shipment's current operation."
                    );

                    return;
                }
            }


            /*
             * Verify vehicle against selected manifest.
             */

            if (
                scanConfig.requiresVehicle
            ) {

                const expectedVehicleId =
                    getManifestVehicleId(
                        selectedManifest
                    )

                    ??

                    getManifestItemVehicleId(
                        selectedManifestItem
                    );


                if (

                    expectedVehicleId

                    &&

                    !sameId(
                        expectedVehicleId,
                        form.vehicleId
                    )

                ) {

                    setError(
                        "The selected vehicle does not match the vehicle assigned to the manifest."
                    );

                    return;
                }
            }


            /*
             * LOAD must use departure facility.
             */

            if (

                form.scanType === "load"

                &&

                selectedManifest

            ) {

                const expectedFacilityId =
                    getManifestDepartureFacilityId(
                        selectedManifest
                    );


                if (

                    expectedFacilityId

                    &&

                    !sameId(
                        expectedFacilityId,
                        form.facilityId
                    )

                ) {

                    setError(
                        "The load facility must be the manifest's departure facility."
                    );

                    return;
                }
            }


            /* -------------------------------------------------
               Build request
            ------------------------------------------------- */

            const payload = {

                shipmentId:
                    getId(shipment),


                manifestItemId:
                    scanConfig.requiresManifestItem

                        ? form.manifestItemId

                        : null,


                facilityId:
                    form.facilityId
                        ? form.facilityId
                        : null,


                vehicleId:
                    form.vehicleId
                        ? form.vehicleId
                        : null,


                locationType:
                    form.locationType,


                scanType:
                    form.scanType,


                latitude:
                    null,


                longitude:
                    null,


                notes:
                    form.notes.trim()
                        ? form.notes.trim()
                        : null
            };


            setSubmitting(true);


            try {

                const response =
                    await packageScanService.scan(
                        payload
                    );


                setResult(

                    response?.data

                    ??

                    {
                        message:
                            "Package scan created successfully."
                    }

                );


                /*
                 * Reload data.
                 */

                const refreshedData =
                    await loadData();


                /*
                 * Find fresh shipment.
                 */

                if (
                    refreshedData
                ) {

                    const refreshedShipment =
                        refreshedData.shipments.find(
                            (item) =>
                                sameId(
                                    getId(item),
                                    getId(shipment)
                                )
                        );


                    if (
                        refreshedShipment
                    ) {

                        setShipment(
                            refreshedShipment
                        );


                        setManualTrackingNumber(
                            getTrackingNumber(
                                refreshedShipment
                            )
                        );
                    }
                }


                /*
                 * Clear notes only.
                 *
                 * The effects above will automatically
                 * determine the next valid operation.
                 */

                setForm((prev) => ({

                    ...prev,

                    notes: ""

                }));

            } catch (err) {

                console.error(
                    "Package scan failed:",
                    err
                );


                const backendMessage =

                    err?.response?.data?.message

                    ??

                    err?.response?.data?.title

                    ??

                    err?.response?.data?.error

                    ??

                    (

                        typeof
                            err?.response?.data
                            ===
                            "string"

                            ? err.response.data

                            : null

                    );


                setError(

                    backendMessage

                    ??

                    "Failed to create package scan."

                );

            } finally {

                setSubmitting(false);
            }
        };


    /* =====================================================
       Current shipment information
    ===================================================== */

    const selectedShipmentId =
        shipment
            ? getId(shipment)
            : null;


    const shipmentStatus =
        shipment
            ? normalizeStatus(
                getShipmentStatus(
                    shipment
                )
            )
            : "";


    /* =====================================================
       Current operation description
    ===================================================== */

    const operationDescription =
        useMemo(() => {

            switch (
            form.scanType
            ) {

                case "pickup":

                    return "Package is being picked up from the customer.";


                case "load":

                    return "Package is being loaded onto the assigned line-haul manifest.";


                case "depart":

                    return "The assigned vehicle is departing the origin facility.";


                case "arrive":

                    return "The assigned vehicle has arrived at the next route facility.";


                case "unload":

                    return "Package is being unloaded from the line-haul vehicle.";


                case "out_for_delivery":

                    return "Package has completed line-haul and is being taken for final delivery.";


                case "delivered":

                    return "Package has been successfully delivered to the customer.";


                default:

                    return "Select a valid operation for the current shipment.";

            }

        }, [

            form.scanType

        ]);


    /* =====================================================
       Render loading
    ===================================================== */

    if (loading) {

        return (

            <div className="crud-page">

                <div className="crud-container">

                    <div className="crud-table-card">

                        Loading package scan data...

                    </div>

                </div>

            </div>

        );
    }


    /* =====================================================
       Render
    ===================================================== */

    return (

        <div className="crud-page">

            <div className="crud-container">


                {/* =================================================
                    Header
                ================================================= */}

                <div className="crud-header">

                    <div>

                        <h1 className="crud-title">
                            Package Scans
                        </h1>


                        <p className="crud-subtitle">

                            Scan or manually enter a
                            shipment to record its movement
                            through the delivery process.

                        </p>

                    </div>

                </div>


                {/* =================================================
                    Error
                ================================================= */}

                {error && (

                    <div
                        className="crud-table-card"
                        style={{
                            marginBottom: "16px",
                            padding: "16px",
                            color: "#b42318",
                            background: "#fef3f2",
                            border:
                                "1px solid #fecdca",
                            borderRadius: "8px"
                        }}
                    >

                        {error}

                    </div>

                )}


                {/* =================================================
                    Success
                ================================================= */}

                {result && (

                    <div
                        className="crud-table-card"
                        style={{
                            marginBottom: "16px",
                            padding: "16px",
                            color: "#067647",
                            background: "#ecfdf3",
                            border:
                                "1px solid #abefc6",
                            borderRadius: "8px"
                        }}
                    >

                        <strong>
                            Scan successful.
                        </strong>


                        {typeof result === "string"

                            ? ` ${result}`

                            : result?.message

                                ? ` ${result.message}`

                                : null}

                    </div>

                )}


                {/* =================================================
                    Shipment scanner
                ================================================= */}

                <div
                    className="crud-table-card"
                    style={{
                        marginBottom: "20px"
                    }}
                >

                    <div
                        style={{
                            padding: "20px"
                        }}
                    >

                        <h2
                            style={{
                                marginTop: 0,
                                marginBottom: "8px"
                            }}
                        >
                            1. Identify Shipment
                        </h2>


                        <p
                            style={{
                                marginTop: 0,
                                color: "#667085"
                            }}
                        >

                            Scan the shipment QR code or
                            enter its tracking number manually.

                        </p>


                        {/* Camera */}

                        <div
                            id="package-scanner"
                            style={{
                                width: "100%",
                                maxWidth: "500px",
                                minHeight:
                                    scannerRunning
                                        ? "300px"
                                        : "0",
                                margin:
                                    scannerRunning
                                        ? "20px auto"
                                        : "0 auto"
                            }}
                        />


                        {scannerError && (

                            <div
                                style={{
                                    marginTop: "12px",
                                    marginBottom: "12px",
                                    padding: "12px",
                                    color: "#b54708",
                                    background:
                                        "#fffaeb",
                                    border:
                                        "1px solid #fedf89",
                                    borderRadius: "6px"
                                }}
                            >

                                {scannerError}

                            </div>

                        )}


                        <div
                            style={{
                                display: "flex",
                                gap: "10px",
                                flexWrap: "wrap",
                                marginBottom: "16px"
                            }}
                        >

                            {!scannerRunning ? (

                                <button
                                    type="button"
                                    className="crud-button crud-button-primary"
                                    onClick={
                                        startScanner
                                    }
                                >

                                    Scan QR Code

                                </button>

                            ) : (

                                <button
                                    type="button"
                                    className="crud-button"
                                    onClick={
                                        stopScanner
                                    }
                                >

                                    Stop Scanner

                                </button>

                            )}

                        </div>


                        {/* Manual search */}

                        <div
                            style={{
                                display: "flex",
                                gap: "10px",
                                flexWrap: "wrap",
                                alignItems: "center"
                            }}
                        >

                            <input
                                type="text"
                                value={
                                    manualTrackingNumber
                                }
                                onChange={(event) =>
                                    setManualTrackingNumber(
                                        event.target.value
                                    )
                                }
                                onKeyDown={(event) => {

                                    if (
                                        event.key ===
                                        "Enter"
                                    ) {

                                        event.preventDefault();

                                        handleManualSearch();
                                    }

                                }}
                                placeholder="Tracking number"
                                style={{
                                    flex:
                                        "1 1 300px",
                                    maxWidth:
                                        "500px",
                                    padding:
                                        "10px 12px",
                                    border:
                                        "1px solid #d0d5dd",
                                    borderRadius:
                                        "6px"
                                }}
                            />


                            <button
                                type="button"
                                className="crud-button"
                                onClick={
                                    handleManualSearch
                                }
                            >

                                Find Shipment

                            </button>

                        </div>


                        {/* Selected shipment */}

                        {shipment && (

                            <div
                                style={{
                                    marginTop: "20px",
                                    padding: "16px",
                                    background:
                                        "#f9fafb",
                                    border:
                                        "1px solid #eaecf0",
                                    borderRadius:
                                        "8px"
                                }}
                            >

                                <div
                                    style={{
                                        display:
                                            "grid",
                                        gridTemplateColumns:
                                            "repeat(auto-fit, minmax(180px, 1fr))",
                                        gap: "12px"
                                    }}
                                >

                                    <div>

                                        <strong>
                                            Tracking #
                                        </strong>

                                        <div>

                                            {
                                                getTrackingNumber(
                                                    shipment
                                                )
                                            }

                                        </div>

                                    </div>


                                    <div>

                                        <strong>
                                            Status
                                        </strong>

                                        <div
                                            style={{
                                                textTransform:
                                                    "capitalize"
                                            }}
                                        >

                                            {
                                                getShipmentStatus(
                                                    shipment
                                                )
                                            }

                                        </div>

                                    </div>


                                    <div>

                                        <strong>
                                            Shipment ID
                                        </strong>

                                        <div
                                            style={{
                                                wordBreak:
                                                    "break-all"
                                            }}
                                        >

                                            {
                                                selectedShipmentId
                                            }

                                        </div>

                                    </div>


                                    <div>

                                        <strong>
                                            Manifest Items
                                        </strong>

                                        <div>

                                            {
                                                availableManifestItems.length
                                            }

                                        </div>

                                    </div>

                                </div>


                                {/* Current workflow state */}

                                <div
                                    style={{
                                        marginTop:
                                            "16px",
                                        paddingTop:
                                            "16px",
                                        borderTop:
                                            "1px solid #eaecf0"
                                    }}
                                >

                                    <strong>
                                        Available operations
                                    </strong>


                                    {availableScanTypes.length >
                                        0 ? (

                                        <div
                                            style={{
                                                display:
                                                    "flex",
                                                gap:
                                                    "8px",
                                                flexWrap:
                                                    "wrap",
                                                marginTop:
                                                    "8px"
                                            }}
                                        >

                                            {availableScanTypes.map(
                                                (scanType) => (

                                                    <span
                                                        key={
                                                            scanType
                                                        }
                                                        style={{
                                                            padding:
                                                                "6px 10px",
                                                            background:
                                                                "#ecfdf3",
                                                            color:
                                                                "#067647",
                                                            border:
                                                                "1px solid #abefc6",
                                                            borderRadius:
                                                                "999px",
                                                            fontSize:
                                                                "13px",
                                                            fontWeight:
                                                                600
                                                        }}
                                                    >

                                                        {
                                                            SCAN_LABELS[
                                                            scanType
                                                            ]
                                                        }

                                                    </span>

                                                )
                                            )}

                                        </div>

                                    ) : (

                                        <div
                                            style={{
                                                marginTop:
                                                    "8px",
                                                padding:
                                                    "10px 12px",
                                                background:
                                                    "#fffaeb",
                                                color:
                                                    "#b54708",
                                                border:
                                                    "1px solid #fedf89",
                                                borderRadius:
                                                    "6px"
                                            }}
                                        >

                                            No scan operations
                                            are currently
                                            available for
                                            this shipment.

                                        </div>

                                    )}

                                </div>


                                {/* Manifest information */}

                                {availableManifestItems.length >
                                    0 && (

                                        <div
                                            style={{
                                                marginTop:
                                                    "16px",
                                                paddingTop:
                                                    "16px",
                                                borderTop:
                                                    "1px solid #eaecf0"
                                            }}
                                        >

                                            <strong>
                                                Transport Assignment
                                            </strong>


                                            <div
                                                style={{
                                                    marginTop:
                                                        "6px",
                                                    color:
                                                        "#667085"
                                                }}
                                            >

                                                This shipment has{" "}

                                                {
                                                    availableManifestItems.length
                                                }

                                                {" "}

                                                manifest item
                                                {
                                                    availableManifestItems.length !==
                                                        1
                                                        ? "s"
                                                        : ""
                                                }.

                                            </div>

                                        </div>

                                    )}

                            </div>

                        )}

                    </div>

                </div>


                {/* =================================================
                    Scan operation
                ================================================= */}

                <div
                    className="crud-table-card"
                    style={{
                        marginBottom: "20px"
                    }}
                >

                    <div
                        style={{
                            padding: "20px"
                        }}
                    >

                        <h2
                            style={{
                                marginTop: 0,
                                marginBottom: "8px"
                            }}
                        >
                            2. Record Package Scan
                        </h2>


                        <p
                            style={{
                                marginTop: 0,
                                color: "#667085"
                            }}
                        >

                            The available operation is
                            determined by the shipment's
                            current workflow state.

                        </p>


                        <form
                            onSubmit={
                                handleSubmit
                            }
                        >


                            {/* -------------------------------------------------
                                Scan type
                            ------------------------------------------------- */}

                            <div
                                style={{
                                    marginBottom:
                                        "16px"
                                }}
                            >

                                <label
                                    style={{
                                        display:
                                            "block",
                                        marginBottom:
                                            "6px",
                                        fontWeight:
                                            600
                                    }}
                                >

                                    Scan Type

                                </label>


                                <select
                                    name="scanType"
                                    value={
                                        form.scanType
                                    }
                                    onChange={
                                        handleScanTypeChange
                                    }
                                    disabled={
                                        !shipment ||
                                        availableScanTypes.length ===
                                        0
                                    }
                                    style={{
                                        width:
                                            "100%",
                                        maxWidth:
                                            "500px",
                                        padding:
                                            "10px 12px",
                                        border:
                                            "1px solid #d0d5dd",
                                        borderRadius:
                                            "6px",
                                        background:
                                            !shipment ||
                                                availableScanTypes.length ===
                                                0
                                                ? "#f2f4f7"
                                                : "#fff"
                                    }}
                                >

                                    {!shipment && (

                                        <option value="">
                                            Select a shipment first
                                        </option>

                                    )}


                                    {shipment &&
                                        availableScanTypes.length ===
                                        0 && (

                                            <option value="">
                                                No operations available
                                            </option>

                                        )}


                                    {availableScanTypes.map(
                                        (scanType) => (

                                            <option
                                                key={
                                                    scanType
                                                }
                                                value={
                                                    scanType
                                                }
                                            >

                                                {
                                                    SCAN_LABELS[
                                                    scanType
                                                    ]
                                                }

                                            </option>

                                        )
                                    )}

                                </select>


                                {shipment && (

                                    <div
                                        style={{
                                            marginTop:
                                                "8px",
                                            fontSize:
                                                "13px",
                                            color:
                                                "#667085"
                                        }}
                                    >

                                        Current shipment
                                        status:{" "}

                                        <strong>
                                            {
                                                getShipmentStatus(
                                                    shipment
                                                )
                                            }
                                        </strong>

                                    </div>

                                )}

                            </div>


                            {/* -------------------------------------------------
                                Operation explanation
                            ------------------------------------------------- */}

                            {shipment &&
                                form.scanType && (

                                    <div
                                        style={{
                                            marginBottom:
                                                "16px",
                                            padding:
                                                "12px",
                                            background:
                                                "#f9fafb",
                                            border:
                                                "1px solid #eaecf0",
                                            borderRadius:
                                                "6px",
                                            color:
                                                "#475467"
                                        }}
                                    >

                                        {
                                            operationDescription
                                        }

                                    </div>

                                )}


                            {/* -------------------------------------------------
                                Manifest item
                            ------------------------------------------------- */}

                            {getScanConfig(
                                form.scanType
                            ).requiresManifestItem && (

                                    <div
                                        style={{
                                            marginBottom:
                                                "16px"
                                        }}
                                    >

                                        <label
                                            style={{
                                                display:
                                                    "block",
                                                marginBottom:
                                                    "6px",
                                                fontWeight:
                                                    600
                                            }}
                                        >

                                            Manifest Item

                                        </label>


                                        {validManifestItems.length ===
                                            0 ? (

                                            <div
                                                style={{
                                                    padding:
                                                        "12px",
                                                    color:
                                                        "#b42318",
                                                    background:
                                                        "#fef3f2",
                                                    border:
                                                        "1px solid #fecdca",
                                                    borderRadius:
                                                        "6px",
                                                    maxWidth:
                                                        "700px"
                                                }}
                                            >

                                                <strong>

                                                    No valid manifest
                                                    item is available
                                                    for this operation.

                                                </strong>


                                                <div
                                                    style={{
                                                        marginTop:
                                                            "6px",
                                                        fontSize:
                                                            "13px"
                                                    }}
                                                >

                                                    The shipment may
                                                    have already completed
                                                    this stage, or its
                                                    manifest is not in the
                                                    required status.

                                                </div>

                                            </div>

                                        ) : validManifestItems.length ===
                                            1 ? (

                                            <div
                                                style={{
                                                    maxWidth:
                                                        "700px",
                                                    padding:
                                                        "12px",
                                                    background:
                                                        "#f9fafb",
                                                    border:
                                                        "1px solid #eaecf0",
                                                    borderRadius:
                                                        "6px"
                                                }}
                                            >

                                                <strong>

                                                    Manifest item
                                                    automatically
                                                    selected

                                                </strong>


                                                <div
                                                    style={{
                                                        marginTop:
                                                            "6px",
                                                        fontSize:
                                                            "14px"
                                                    }}
                                                >

                                                    ID:{" "}

                                                    {
                                                        getId(
                                                            validManifestItems[0]
                                                        )
                                                    }

                                                </div>


                                                <div
                                                    style={{
                                                        marginTop:
                                                            "4px",
                                                        fontSize:
                                                            "14px"
                                                    }}
                                                >

                                                    Status:{" "}

                                                    {
                                                        getManifestItemStatus(
                                                            validManifestItems[0]
                                                        )
                                                    }

                                                </div>


                                                {selectedManifest && (

                                                    <div
                                                        style={{
                                                            marginTop:
                                                                "4px",
                                                            fontSize:
                                                                "14px"
                                                        }}
                                                    >

                                                        Manifest:{" "}

                                                        {
                                                            getId(
                                                                selectedManifest
                                                            )
                                                        }

                                                        {" — "}

                                                        {
                                                            getManifestStatus(
                                                                selectedManifest
                                                            )
                                                        }

                                                    </div>

                                                )}

                                            </div>

                                        ) : (

                                            <select
                                                name="manifestItemId"
                                                value={
                                                    form.manifestItemId
                                                }
                                                onChange={
                                                    handleManifestItemChange
                                                }
                                                style={{
                                                    width:
                                                        "100%",
                                                    maxWidth:
                                                        "700px",
                                                    padding:
                                                        "10px 12px",
                                                    border:
                                                        "1px solid #d0d5dd",
                                                    borderRadius:
                                                        "6px"
                                                }}
                                            >

                                                <option value="">
                                                    Select manifest item
                                                </option>


                                                {validManifestItems.map(
                                                    (item) => {

                                                        const manifest =
                                                            getManifestForItem(
                                                                item
                                                            );


                                                        return (

                                                            <option
                                                                key={
                                                                    getId(
                                                                        item
                                                                    )
                                                                }
                                                                value={
                                                                    getId(
                                                                        item
                                                                    )
                                                                }
                                                            >

                                                                {
                                                                    getId(
                                                                        item
                                                                    )
                                                                }

                                                                {" — "}

                                                                {
                                                                    getManifestItemStatus(
                                                                        item
                                                                    )
                                                                }

                                                                {manifest
                                                                    ? ` — Manifest ${getId(manifest)}`
                                                                    : ""
                                                                }

                                                            </option>

                                                        );

                                                    }
                                                )}

                                            </select>

                                        )}

                                    </div>

                                )}


                            {/* -------------------------------------------------
                                Facility
                            ------------------------------------------------- */}

                            {getScanConfig(
                                form.scanType
                            ).requiresFacility && (

                                    <div
                                        style={{
                                            marginBottom:
                                                "16px"
                                        }}
                                    >

                                        <label
                                            style={{
                                                display:
                                                    "block",
                                                marginBottom:
                                                    "6px",
                                                fontWeight:
                                                    600
                                            }}
                                        >

                                            Facility

                                        </label>


                                        <select
                                            name="facilityId"
                                            value={
                                                form.facilityId
                                            }
                                            onChange={
                                                handleFieldChange
                                            }
                                            disabled={
                                                form.scanType ===
                                                "load" &&
                                                availableFacilities.length ===
                                                1
                                            }
                                            style={{
                                                width:
                                                    "100%",
                                                maxWidth:
                                                    "700px",
                                                padding:
                                                    "10px 12px",
                                                border:
                                                    "1px solid #d0d5dd",
                                                borderRadius:
                                                    "6px",
                                                background:
                                                    form.scanType ===
                                                        "load" &&
                                                        availableFacilities.length ===
                                                        1
                                                        ? "#f2f4f7"
                                                        : "#fff"
                                            }}
                                        >

                                            <option value="">
                                                Select facility
                                            </option>


                                            {availableFacilities.map(
                                                (facility) => (

                                                    <option
                                                        key={
                                                            getId(
                                                                facility
                                                            )
                                                        }
                                                        value={
                                                            getId(
                                                                facility
                                                            )
                                                        }
                                                    >

                                                        {
                                                            getFacilityName(
                                                                facility
                                                            )
                                                        }

                                                    </option>

                                                )
                                            )}

                                        </select>


                                        {form.scanType ===
                                            "load" &&
                                            selectedManifest && (

                                                <div
                                                    style={{
                                                        marginTop:
                                                            "6px",
                                                        fontSize:
                                                            "13px",
                                                        color:
                                                            "#667085"
                                                    }}
                                                >

                                                    Load facility is
                                                    automatically
                                                    restricted to the
                                                    manifest's departure
                                                    facility.

                                                </div>

                                            )}

                                    </div>

                                )}


                            {/* -------------------------------------------------
                                Vehicle
                            ------------------------------------------------- */}

                            {getScanConfig(
                                form.scanType
                            ).requiresVehicle && (

                                    <div
                                        style={{
                                            marginBottom:
                                                "16px"
                                        }}
                                    >

                                        <label
                                            style={{
                                                display:
                                                    "block",
                                                marginBottom:
                                                    "6px",
                                                fontWeight:
                                                    600
                                            }}
                                        >

                                            Vehicle

                                        </label>


                                        <input
                                            type="text"
                                            value={
                                                form.vehicleId
                                            }
                                            readOnly
                                            placeholder="Vehicle assigned by manifest"
                                            style={{
                                                width:
                                                    "100%",
                                                maxWidth:
                                                    "700px",
                                                padding:
                                                    "10px 12px",
                                                border:
                                                    "1px solid #d0d5dd",
                                                borderRadius:
                                                    "6px",
                                                background:
                                                    "#f2f4f7",
                                                color:
                                                    "#475467"
                                            }}
                                        />


                                        <div
                                            style={{
                                                marginTop:
                                                    "6px",
                                                fontSize:
                                                    "13px",
                                                color:
                                                    "#667085"
                                            }}
                                        >

                                            Vehicle is automatically
                                            populated from the selected
                                            manifest and cannot be changed
                                            here.

                                        </div>

                                    </div>

                                )}


                            {/* -------------------------------------------------
                                Location type
                            ------------------------------------------------- */}

                            <div
                                style={{
                                    marginBottom:
                                        "16px"
                                }}
                            >

                                <label
                                    style={{
                                        display:
                                            "block",
                                        marginBottom:
                                            "6px",
                                        fontWeight:
                                            600
                                    }}
                                >

                                    Location Type

                                </label>


                                <input
                                    type="text"
                                    value={
                                        form.locationType
                                    }
                                    readOnly
                                    style={{
                                        width:
                                            "100%",
                                        maxWidth:
                                            "700px",
                                        padding:
                                            "10px 12px",
                                        border:
                                            "1px solid #d0d5dd",
                                        borderRadius:
                                            "6px",
                                        background:
                                            "#f2f4f7",
                                        color:
                                            "#475467"
                                    }}
                                />


                                <div
                                    style={{
                                        marginTop:
                                            "6px",
                                        fontSize:
                                            "13px",
                                        color:
                                            "#667085"
                                    }}
                                >

                                    Location type is automatically
                                    determined by the scan operation.

                                </div>

                            </div>


                            {/* -------------------------------------------------
                                Notes
                            ------------------------------------------------- */}

                            <div
                                style={{
                                    marginBottom:
                                        "20px"
                                }}
                            >

                                <label
                                    style={{
                                        display:
                                            "block",
                                        marginBottom:
                                            "6px",
                                        fontWeight:
                                            600
                                    }}
                                >

                                    Notes

                                </label>


                                <textarea
                                    name="notes"
                                    value={
                                        form.notes
                                    }
                                    onChange={
                                        handleFieldChange
                                    }
                                    rows={3}
                                    placeholder="Optional scan notes"
                                    style={{
                                        width:
                                            "100%",
                                        maxWidth:
                                            "700px",
                                        padding:
                                            "10px 12px",
                                        border:
                                            "1px solid #d0d5dd",
                                        borderRadius:
                                            "6px",
                                        resize:
                                            "vertical"
                                    }}
                                />

                            </div>


                            {/* -------------------------------------------------
                                Submit
                            ------------------------------------------------- */}

                            <button
                                type="submit"
                                className="crud-button crud-button-primary"
                                disabled={

                                    submitting

                                    ||

                                    !shipment

                                    ||

                                    !form.scanType

                                    ||

                                    availableScanTypes.length ===
                                    0

                                    ||

                                    (
                                        getScanConfig(
                                            form.scanType
                                        ).requiresManifestItem

                                        &&

                                        validManifestItems.length ===
                                        0
                                    )

                                }
                            >

                                {submitting

                                    ? "Recording..."

                                    : form.scanType

                                        ? `Record ${SCAN_LABELS[
                                        form.scanType
                                        ]
                                        } Scan`

                                        : "Record Scan"

                                }

                            </button>


                        </form>

                    </div>

                </div>


                {/* =================================================
                    Demo workflow
                ================================================= */}

                <div
                    className="crud-table-card"
                    style={{
                        marginBottom:
                            "20px"
                    }}
                >

                    <div
                        style={{
                            padding:
                                "20px"
                        }}
                    >

                        <h2
                            style={{
                                marginTop:
                                    0,
                                marginBottom:
                                    "12px"
                            }}
                        >

                            Demo Workflow

                        </h2>


                        <div
                            style={{
                                display:
                                    "flex",
                                gap:
                                    "8px",
                                flexWrap:
                                    "wrap",
                                alignItems:
                                    "center"
                            }}
                        >

                            <span>
                                Created
                            </span>

                            <span>
                                →
                            </span>

                            <strong>
                                Pickup
                            </strong>

                            <span>
                                →
                            </span>

                            <strong>
                                Load
                            </strong>

                            <span>
                                →
                            </span>

                            <strong>
                                Depart
                            </strong>

                            <span>
                                →
                            </span>

                            <strong>
                                Arrive
                            </strong>

                            <span>
                                →
                            </span>

                            <strong>
                                Unload
                            </strong>

                            <span>
                                →
                            </span>

                            <strong>
                                Out for Delivery
                            </strong>

                            <span>
                                →
                            </span>

                            <strong>
                                Delivered
                            </strong>

                        </div>


                        <p
                            style={{
                                marginBottom:
                                    0,
                                marginTop:
                                    "12px",
                                color:
                                    "#667085"
                            }}
                        >

                            The available scan operation is
                            automatically determined from the
                            shipment, manifest item, and manifest
                            status. Invalid operations are hidden
                            from the user.

                        </p>

                    </div>

                </div>


            </div>

        </div>
    );
};


export default PackageScansPage;