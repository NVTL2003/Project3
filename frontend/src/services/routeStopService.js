import createResourceService
    from "./genericResourceService";

import client
    from "../api/client";


const baseService =
    createResourceService("/RouteStops");


export const routeStopService = {

    ...baseService,


    // GET /api/RouteStops/route/{routeId}
    getByRoute: (routeId) =>
        client.get(`/RouteStops/route/${routeId}`)
};