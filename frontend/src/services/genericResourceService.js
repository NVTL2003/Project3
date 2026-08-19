import api from "../api/client";

const createResourceService = (
    baseUrl,
    options = {}
) => {

    const {
        pagedPath = "/paged"
    } = options;

    return {

        getAll: (config = {}) =>
            api.get(
                baseUrl,
                config
            ),

        getPaged: (
            params = {},
            config = {}
        ) =>
            api.get(
                pagedPath
                    ? `${baseUrl}${pagedPath}`
                    : baseUrl,
                {
                    ...config,
                    params
                }
            ),

        getById: (
            id,
            config = {}
        ) =>
            api.get(
                `${baseUrl}/${id}`,
                config
            ),

        create: (
            data,
            config = {}
        ) =>
            api.post(
                baseUrl,
                data,
                config
            ),

        update: (
            id,
            data,
            config = {}
        ) =>
            api.put(
                `${baseUrl}/${id}`,
                data,
                config
            ),

        delete: (
            id,
            config = {}
        ) =>
            api.delete(
                `${baseUrl}/${id}`,
                config
            )

    };
};

export default createResourceService;