import React from "react";
import GenericEntityPage from "./GenericEntityPage";
import customerAddressService from "../services/customerAddressService";

const customerAddressFieldConfig = [
    {
        name: "id",
        type: "hidden"
    },
    {
        name: "addressLine1",
        label: "Address Line 1",
        required: true
    },
    {
        name: "addressLine2",
        label: "Address Line 2",
        required: false
    },
    {
        name: "city",
        label: "City",
        required: true
    },
    {
        name: "state",
        label: "State",
        required: true
    },
    {
        name: "pincode",
        label: "Pincode",
        required: true
    },
    {
        name: "country",
        label: "Country",
        required: true,
        defaultValue: "Vietnam"
    },
    {
        name: "phone",
        label: "Phone",
        required: false
    },
    {
        name: "isDefault",
        label: "Default Address",
        type: "checkbox",
        required: false,
        defaultValue: false
    }
];

const customerAddressDisplayColumns = [
    {
        key: "addressLine1",
        label: "Address"
    },
    {
        key: "city",
        label: "City"
    },
    {
        key: "state",
        label: "State"
    },
    {
        key: "pincode",
        label: "Pincode"
    },
    {
        key: "country",
        label: "Country"
    },
    {
        key: "phone",
        label: "Phone"
    },
    {
        key: "isDefault",
        label: "Default"
    }
];

const customerAddressSortOptions = [
    {
        value: "city",
        label: "City"
    },
    {
        value: "state",
        label: "State"
    },
    {
        value: "pincode",
        label: "Pincode"
    },
    {
        value: "createdAt",
        label: "Created Date"
    }
];


const CustomerAddressPage = ({
    scope = "global"
}) => {

    const isMyAddresses =
        scope === "me";

    const service =
        isMyAddresses
            ? customerAddressService.me
            : customerAddressService;

    return (
        <GenericEntityPage
            entityName={
                isMyAddresses
                    ? "My Addresses"
                    : "Customer Addresses"
            }

            permissionPrefix={
                isMyAddresses
                    ? null
                    : "customer_addresses"
            }

            requirePermission={
                !isMyAddresses
            }

            service={service}

            fieldConfig={customerAddressFieldConfig}

            displayColumns={customerAddressDisplayColumns}

            sortOptions={customerAddressSortOptions}

            filterOptions={[]}
        />
    );
};

export default CustomerAddressPage;