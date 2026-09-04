import React, {
    useEffect,
    useState
} from "react";

import GenericEntityPage from "./GenericEntityPage";

import shipmentRequestService from "../services/shipmentRequestService";
import customerAddressService from "../services/customerAddressService";
import customerService from "../services/customerService";
import serviceService from "../services/serviceService";
import insurancePlanService from "../services/insurancePlanService";


// =========================================================
// FIELD CONFIG
// =========================================================

const buildShipmentRequestFieldConfig = (isMine) => [
    {
        name: "id",
        type: "hidden"
    },

    // =========================================================
    // CUSTOMER
    // GLOBAL ONLY
    // =========================================================

    ...(!isMine
        ? [
            {
                name: "customerId",
                label: "Customer",
                type: "relation",
                required: true,

                displayField: "customerName",

                service: customerService,
                fetchMode: "all",

                valueField: "id",

                getOptionLabel: (customer) => {

                    const companyName =
                        customer.companyName ??
                        customer.CompanyName;

                    const accountNumber =
                        customer.accountNumber ??
                        customer.AccountNumber;

                    const firstName =
                        customer.firstName ??
                        customer.FirstName ??
                        "";

                    const lastName =
                        customer.lastName ??
                        customer.LastName ??
                        "";

                    const fullName =
                        `${ firstName } ${ lastName } `.trim();

                    if (companyName && accountNumber) {
                        return `${ companyName } (${ accountNumber })`;
                    }

                    if (companyName) {
                        return companyName;
                    }

                    if (fullName) {
                        return fullName;
                    }

                    if (accountNumber) {
                        return accountNumber;
                    }

                    return (
                        customer.id ??
                        customer.Id ??
                        "Unknown Customer"
                    );
                }
            }
        ]
        : []
    ),


    // =========================================================
    // SENDER ADDRESS
    // =========================================================

    {
        name: "senderAddressId",
        label: "Sender Address",
        type: "relation",
        required: true,

        displayField: "senderAddress",

        service: customerAddressService,

        fetchMode: isMine
            ? "mine"
            : "all",

        valueField: "id",

        getOptionLabel: (address) =>
            `${ address.addressType || "Address" } - ${ address.addressLine1 }, ${ address.city } `
    },


    // =========================================================
    // RECEIVER ADDRESS
    // =========================================================

    {
        name: "receiverAddressId",
        label: "Receiver Address",
        type: "relation",
        required: true,

        displayField: "receiverAddress",

        service: customerAddressService,

        fetchMode: isMine
            ? "mine"
            : "all",

        valueField: "id",

        getOptionLabel: (address) =>
            `${ address.addressType || "Address" } - ${ address.addressLine1 }, ${ address.city } `
    },


    // =========================================================
    // SERVICE
    // =========================================================

    {
        name: "serviceId",
        label: "Service",
        type: "relation",
        required: true,

        service: serviceService,

        fetchMode: "all",

        valueField: "id",

        getOptionLabel: (service) =>
            service.name
    },


    // =========================================================
    // PACKAGE
    // =========================================================

    {
        name: "packageType",
        label: "Package Type",
        required: true
    },

    {
        name: "weight",
        label: "Weight (kg)",
        required: true,
        type: "number"
    },

    {
        name: "length",
        label: "Length (cm)",
        required: false,
        type: "number"
    },

    {
        name: "width",
        label: "Width (cm)",
        required: false,
        type: "number"
    },

    {
        name: "height",
        label: "Height (cm)",
        required: false,
        type: "number"
    },

    {
        name: "declaredValue",
        label: "Declared Value",
        required: false,
        type: "number"
    },


    // =========================================================
    // INSURANCE
    // =========================================================

    {
        name: "insurancePlanId",
        label: "Insurance Plan",
        type: "relation",
        required: false,

        service: insurancePlanService,

        fetchMode: "all",

        valueField: "id",

        getOptionLabel: (plan) =>
            plan.name
    },


    // =========================================================
    // SPECIAL INSTRUCTIONS
    // =========================================================

    {
        name: "specialInstructions",
        label: "Special Instructions",
        type: "textarea",
        required: false
    },


    // =========================================================
    // FLAGS
    // =========================================================

    {
        name: "isFragile",
        label: "Fragile",
        type: "checkbox",
        required: false,
        defaultValue: false
    },

    {
        name: "isLarge",
        label: "Large",
        type: "checkbox",
        required: false,
        defaultValue: false
    }
];


// =========================================================
// DISPLAY COLUMNS
// =========================================================

const buildShipmentRequestDisplayColumns = (
    customers,
    customersLoading
) => [
    {
        key: "requestNumber",
        label: "Request #"
    },

    {
        key: "customerId",
        label: "Customer",

        render: (item) => {

            const requestCustomerId =
                String(
                    item.customerId ??
                    item.CustomerId ??
                    ""
                )
                    .trim()
                    .toLowerCase();


            if (customersLoading) {
                return (
                    <>
                        <div className="crud-list-label">
                            Customer
                        </div>

                        <div className="crud-list-value">
                            Loading...
                        </div>
                    </>
                );
            }


            const customer =
                customers.find((c) => {

                    const customerId =
                        String(
                            c.id ??
                            c.Id ??
                            ""
                        )
                            .trim()
                            .toLowerCase();

                    return (
                        customerId &&
                        customerId ===
                            requestCustomerId
                    );
                });


            if (!customer) {
                return (
                    <>
                        <div className="crud-list-label">
                            Customer
                        </div>

                        <div className="crud-list-value">
                            Unknown Customer
                        </div>
                    </>
                );
            }


            const companyName =
                customer.companyName ??
                customer.CompanyName;

            const accountNumber =
                customer.accountNumber ??
                customer.AccountNumber;

            const firstName =
                customer.firstName ??
                customer.FirstName ??
                "";

            const lastName =
                customer.lastName ??
                customer.LastName ??
                "";

            const fullName =
                `${ firstName } ${ lastName } `.trim();


            let displayName =
                "Unknown Customer";


            if (
                companyName &&
                accountNumber
            ) {

                displayName =
                    `${ companyName } (${ accountNumber })`;

            } else if (companyName) {

                displayName =
                    companyName;

            } else if (fullName) {

                displayName =
                    fullName;

            } else if (accountNumber) {

                displayName =
                    accountNumber;
            }


            return (
                <>
                    <div className="crud-list-label">
                        Customer
                    </div>

                    <div className="crud-list-value">
                        {displayName}
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
        key: "packageType",
        label: "Package"
    },


    {
        key: "weight",
        label: "Weight"
    },


    {
        key: "createdAt",
        label: "Created"
    }
];


// =========================================================
// PAGE
// =========================================================

const ShipmentRequestsPage = ({
    scope = "global"
}) => {

    const isMine =
        scope === "me";


    // =========================================================
    // CUSTOMER STATE
    // =========================================================

    const [customers, setCustomers] =
        useState([]);

    const [customersLoading, setCustomersLoading] =
        useState(!isMine);


    // =========================================================
    // LOAD CUSTOMERS
    // =========================================================

    useEffect(() => {

        if (isMine) {

            setCustomers([]);
            setCustomersLoading(false);

            return;
        }


        let cancelled = false;


        const loadCustomers = async () => {

            setCustomersLoading(true);


            try {

                const response =
                    await customerService.getPaged({
                        page: 1,
                        pageSize: 1000
                    });


                if (cancelled) {
                    return;
                }


                const data =
                    response?.data;


                if (Array.isArray(data)) {

                    setCustomers(data);

                    return;
                }


                if (Array.isArray(data?.items)) {

                    setCustomers(
                        data.items
                    );

                    return;
                }


                if (Array.isArray(data?.Items)) {

                    setCustomers(
                        data.Items
                    );

                    return;
                }


                console.warn(
                    "Unexpected customer API response:",
                    data
                );

                setCustomers([]);

            } catch (error) {

                if (cancelled) {
                    return;
                }


                console.error(
                    "Failed to load customers:",
                    error
                );

                setCustomers([]);

            } finally {

                if (!cancelled) {
                    setCustomersLoading(false);
                }
            }
        };


        loadCustomers();


        return () => {
            cancelled = true;
        };

    }, [isMine]);


    // =========================================================
    // SERVICE
    // =========================================================

    const service =
        isMine
            ? shipmentRequestService.me
            : shipmentRequestService;


    // =========================================================
    // FIELD CONFIG
    // =========================================================

    const fieldConfig =
        buildShipmentRequestFieldConfig(
            isMine
        );


    // =========================================================
    // DISPLAY COLUMNS
    // =========================================================

    const displayColumns =
        isMine
            ? [
                {
                    key: "requestNumber",
                    label: "Request #"
                },
                {
                    key: "status",
                    label: "Status"
                },
                {
                    key: "packageType",
                    label: "Package"
                },
                {
                    key: "weight",
                    label: "Weight"
                },
                {
                    key: "createdAt",
                    label: "Created"
                }
            ]
            : buildShipmentRequestDisplayColumns(
                customers,
                customersLoading
            );


    // =========================================================
    // APPROVE REQUEST
    // =========================================================

    const handleApprove = async (item) => {

        const confirmed =
            window.confirm(
                `Approve request ${ item.requestNumber }?`
            );


        if (!confirmed) {
            return;
        }


        try {

            const response =
                await shipmentRequestService.approve(
                    item.id
                );


            alert(
                `Shipment created! Tracking #: ${
    response.data.trackingNumber
} `
            );


            window.location.reload();

        } catch (err) {

            alert(
                `Approval failed: ${
    err.response?.data?.message ||
        err.message
} `
            );
        }
    };


    // =========================================================
    // CUSTOMER EDIT RULE
    // =========================================================
    //
    // Customer can edit ONLY while request is pending.
    //
    // Once approved:
    //     Edit = disabled
    //
    // Global view:
    //     Keep existing permission behaviour.
    //
    // =========================================================

    const canEditItem = (item) => {

        if (!isMine) {
            return true;
        }

        const status =
            String(
                item.status ??
                item.Status ??
                ""
            )
                .trim()
                .toLowerCase();

        return status === "pending";
    };


    // =========================================================
    // CUSTOMER DELETE RULE
    // =========================================================
    //
    // Customer can delete ONLY while request is pending.
    //
    // Once approved:
    //     Delete = disabled
    //
    // =========================================================

    const canDeleteItem = (item) => {

        if (!isMine) {
            return true;
        }

        const status =
            String(
                item.status ??
                item.Status ??
                ""
            )
                .trim()
                .toLowerCase();

        return status === "pending";
    };


    // =========================================================
    // RENDER
    // =========================================================

    return (

        <GenericEntityPage

            entityName={
                isMine
                    ? "My Shipment Requests"
                    : "Shipment Requests"
            }

            permissionPrefix="shipment_requests"

            permissionScope={
                isMine
                    ? "own"
                    : "all"
            }

            requirePermission={true}

            service={service}

            fieldConfig={fieldConfig}

            displayColumns={displayColumns}

            extraActions={
                !isMine
                    ? (item) =>
                        item.status === "pending" ? (
                            <button
                                className="crud-action-button"
                                onClick={() =>
                                    handleApprove(item)
                                }
                                style={{
                                    background: "#4caf50",
                                    color: "white",
                                    border: "none",
                                    padding: "5px 10px",
                                    borderRadius: "3px",
                                    cursor: "pointer"
                                }}
                            >
                                Approve
                            </button>
                        ) : null
                    : undefined
            }

            canEditItem={
                canEditItem
            }

            canDeleteItem={
                canDeleteItem
            }

        />

    );
};


export default ShipmentRequestsPage;