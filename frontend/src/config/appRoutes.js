import React from "react";

import Dashboard from "../pages/Dashboard";
import ProfilePage from "../pages/ProfilePage";

import FacilitiesPage from "../pages/FacilitiesPage";
import CustomerAddressPage from "../pages/CustomerAddressPage";

import ShipmentRequestsPage from "../pages/ShipmentRequestsPage";
import ShipmentsPage from "../pages/ShipmentsPage";

import TransportOrdersPage from "../pages/TransportOrdersPage";

import ShipmentManifestsPage from "../pages/ShipmentManifestsPage";
import ShipmentManifestDetailsPage from "../pages/ShipmentManifestDetailsPage";

import PackageScansPage from "../pages/PackageScansPage";

import RoutesPage from "../pages/RoutesPage";
import RouteDetailsPage from "../pages/RouteDetailsPage";

import DeliveryAssignmentsPage
    from "../pages/DeliveryAssignmentsPage";

import DeliveryAttemptsPage
    from "../pages/DeliveryAttemptsPage";

export const APP_ROUTES = [
    {
        path: "/",
        element: <Dashboard />
    },
    {
        path: "/delivery-assignments",
        element: <DeliveryAssignmentsPage />
    },

    {
        path: "/delivery-attempts",
        element: <DeliveryAttemptsPage />
    },
    {
        path: "/profile",
        element: <ProfilePage />
    },
    {
        path: "/facilities",
        element: <FacilitiesPage />
    },

    // Customer Addresses
    {
        path: "/my/customer-addresses",
        element: <CustomerAddressPage scope="me" />
    },
    {
        path: "/customer-addresses",
        element: <CustomerAddressPage scope="global" />
    },

    // Shipment Requests
    {
        path: "/my/shipment-requests",
        element: <ShipmentRequestsPage scope="me" />
    },
    {
        path: "/shipment-requests",
        element: <ShipmentRequestsPage scope="global" />
    },

    // Shipments
    {
        path: "/my/shipments",
        element: <ShipmentsPage scope="me" />
    },
    {
        path: "/shipments",
        element: <ShipmentsPage scope="global" />
    },

    // Transport Orders
    {
        path: "/transport-orders",
        element: <TransportOrdersPage />
    },

    // Shipment Manifests
    {
        path: "/shipment-manifests",
        element: <ShipmentManifestsPage />
    },
    {
        path: "/shipment-manifests/:id",
        element: <ShipmentManifestDetailsPage />
    },

    // Package Scanning
    {
        path: "/package-scans",
        element: <PackageScansPage />
    },

    // Routes
    {
        path: "/routes",
        element: <RoutesPage />
    },
    {
        path: "/routes/:id",
        element: <RouteDetailsPage />
    }

];