import api from "../api/client";

const createGenericService = (endpoint) => {

    return {

        // =====================================================
        // GET PAGED
        // =====================================================

        getPaged: (params = {}, config = {}) => {

            const query = new URLSearchParams();

            // -------------------------------------------------
            // SEARCH
            // -------------------------------------------------

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

            // -------------------------------------------------
            // SORT
            // -------------------------------------------------

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

            // -------------------------------------------------
            // PAGINATION
            // -------------------------------------------------

            query.append(
                "page",
                params.page || 1
            );

            query.append(
                "pageSize",
                params.pageSize || 10
            );

            // -------------------------------------------------
            // FILTERS
            // -------------------------------------------------

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

            const queryString =
                query.toString();

            const url =
                queryString
                    ? `${endpoint}/paged?${queryString}`
                    : `${endpoint}/paged`;

            console.log(
                `📡 GET ${url}`
            );

            return api.get(
                url,
                config
            );
        },


        // =====================================================
        // GET BY ID
        // =====================================================

        getById: (id, config = {}) => {

            console.log(
                `📡 GET ${endpoint}/${id}`
            );

            return api.get(
                `${endpoint}/${id}`,
                config
            );
        },


        // =====================================================
        // CREATE
        // =====================================================

        create: (payload, config = {}) => {

            console.log(
                `📤 POST ${endpoint}:`,
                payload
            );

            return api.post(
                endpoint,
                payload,
                config
            );
        },


        // =====================================================
        // UPDATE
        // =====================================================

        update: (id, payload, config = {}) => {

            console.log(
                `📤 PUT ${endpoint}/${id}:`,
                payload
            );

            return api.put(
                `${endpoint}/${id}`,
                payload,
                config
            );
        },


        // =====================================================
        // DELETE
        // =====================================================

        delete: (id, config = {}) => {

            console.log(
                `🗑️ DELETE ${endpoint}/${id}`
            );

            return api.delete(
                `${endpoint}/${id}`,
                config
            );
        }

    };
};

export default createGenericService;