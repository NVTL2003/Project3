import React from "react";

import GenericEntityPage from "./GenericEntityPage";

import customerAddressService
    from "../services/customerAddressService";

const customerAddressFieldConfig = [

    {
        name: "id",
        type: "hidden"
    },

    {
        name: "addressLine1",
        label: "Address Line",
        required: true
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
    }
];


const CustomerAddressPage = ({
    scope = "global"
}) => {

    const isMyAddresses =
        scope === "me";


    // ============================================================
    // SELECT CRUD SCOPE
    // ============================================================

    const service = isMyAddresses

        ? {

            getPaged:
                customerAddressService.me.getPaged,

            getById:
                customerAddressService.me.getById,

            create:
                customerAddressService.me.create,

            update:
                customerAddressService.me.update,

            delete:
                customerAddressService.me.delete

        }

        : {

            getPaged:
                customerAddressService.getPaged,

            getById:
                customerAddressService.getById,

            create:
                customerAddressService.create,

            update:
                customerAddressService.update,

            delete:
                customerAddressService.delete
        };


    return (

        <GenericEntityPage

            entityName={
                isMyAddresses
                    ? "My Addresses"
                    : "Customer Addresses"
            }

            permissionPrefix={
                "customer_addresses"
            }

            permissionScope={
                isMyAddresses
                    ? "own"
                    : "all"
            }

            requirePermission={true}

            service={service}

            fieldConfig={
                customerAddressFieldConfig
            }

            displayColumns={
                customerAddressDisplayColumns
            }

            sortOptions={
                customerAddressSortOptions
            }

            filterOptions={[]}

        />

    );
};


export default CustomerAddressPage;