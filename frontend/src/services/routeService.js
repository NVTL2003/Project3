import createResourceService
    from "./genericResourceService";

import client
    from "../api/client";


const baseService =
    createResourceService("/Routes");


export const routeService = {

    ...baseService,


    // GET /api/Routes/{routeId}/stops
    getStops: (routeId) =>
        client.get(`/Routes/${routeId}/stops`),


    // POST /api/Routes/{routeId}/activate
    activate: (routeId) =>
        client.post(`/Routes/${routeId}/activate`),


    // POST /api/Routes/{routeId}/deactivate
    deactivate: (routeId) =>
        client.post(`/Routes/${routeId}/deactivate`)
};