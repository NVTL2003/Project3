// import api from "../api/client";

// const facilityService = {

//     getPaged: (params, config = {}) => {

//         const query = new URLSearchParams();

//         if (params.search) {
//             query.append("search", params.search);
//         }

//         if (params.sortBy) {
//             query.append("sortBy", params.sortBy);
//         }

//         query.append(
//             "sortOrder",
//             params.sortOrder || "asc"
//         );

//         query.append(
//             "page",
//             params.page
//         );

//         query.append(
//             "pageSize",
//             params.pageSize
//         );

//         if (params.filters) {

//             Object.entries(params.filters)
//                 .forEach(([key, value]) => {

//                     if (
//                         value !== null &&
//                         value !== undefined &&
//                         value !== ""
//                     ) {

//                         query.append(
//                             `filters[${key}]`,
//                             value
//                         );

//                     }

//                 });
//         }

//         const url =
//             `/facility/paged?${query.toString()}`;

//         console.log(
//             "📡 GET:",
//             url
//         );

//         return api.get(
//             url,
//             config
//         );
//     },


//     =====================================================
//     CREATE
//     =====================================================

//     create: (data, config = {}) => {

//         console.log(
//             "📤 POST /facility:",
//             data
//         );

//         return api.post(
//             "/facility",
//             data,
//             config
//         );
//     },


//     =====================================================
//     UPDATE
//     =====================================================

//     update: (id, data, config = {}) => {

//         console.log(
//             "📤 PUT /facility/" + id,
//             data
//         );

//         return api.put(
//             `/facility/${id}`,
//             data,
//             config
//         );
//     },


//     =====================================================
//     DELETE
//     =====================================================

//     delete: (id, config = {}) => {

//         console.log(
//             "🗑️ DELETE /facility/" + id
//         );

//         return api.delete(
//             `/facility/${id}`,
//             config
//         );
//     }

// };

// export default facilityService;

import api from "../api/client";


const facilityService = {

    // =========================================================
    // GET PAGED
    // =========================================================

    getPaged: (params = {}, config = {}) => {

        const query = new URLSearchParams();


        // -----------------------------------------------------
        // SEARCH
        // -----------------------------------------------------

        if (
            params.search !== undefined &&
            params.search !== null &&
            params.search.trim() !== ""
        ) {

            query.append(
                "search",
                params.search.trim()
            );

        }


        // -----------------------------------------------------
        // SORT
        // -----------------------------------------------------

        if (
            params.sortBy !== undefined &&
            params.sortBy !== null &&
            params.sortBy !== ""
        ) {

            query.append(
                "sortBy",
                params.sortBy
            );

        }


        query.append(
            "sortOrder",
            params.sortOrder || "asc"
        );


        // -----------------------------------------------------
        // PAGINATION
        // -----------------------------------------------------

        query.append(
            "page",
            params.page || 1
        );

        query.append(
            "pageSize",
            params.pageSize || 10
        );


        // -----------------------------------------------------
        // FILTERS
        // -----------------------------------------------------

        if (
            params.filters &&
            typeof params.filters === "object"
        ) {

            Object.entries(params.filters)
                .forEach(([key, value]) => {

                    if (
                        value !== undefined &&
                        value !== null &&
                        value !== ""
                    ) {

                        query.append(
                            `filters[${key}]`,
                            String(value)
                        );

                    }

                });

        }


        const url =
            `/facility/paged?${query.toString()}`;


        console.log(
            "📡 GET:",
            url
        );


        return api.get(
            url,
            config
        );

    },


    // =========================================================
    // CREATE
    // =========================================================

    create: (payload) => {

        console.log(
            "📤 POST /facility:",
            payload
        );

        return api.post(
            "/facility",
            payload
        );

    },


    // =========================================================
    // UPDATE
    // =========================================================

    update: (id, payload) => {

        console.log(
            "📤 PUT /facility/" + id,
            payload
        );

        return api.put(
            `/facility/${id}`,
            payload
        );

    },


    // =========================================================
    // DELETE
    // =========================================================

    delete: (id) => {

        console.log(
            "🗑️ DELETE /facility/" + id
        );

        return api.delete(
            `/facility/${id}`
        );

    }

};


export default facilityService;