import {
    useCallback,
    useMemo,
    useState
} from "react";

import { useCrud } from "./useCrud";
import useTableControls from "./useTableControls";
import {getPermissions,hasPermission} from "../utils/permissionUtils";

const emptyResult = {
    items: [],
    totalCount: 0,
    totalPages: 0
};

const useGenericEntity = ({
    entityName,
    permissionPrefix,
    service,
    fieldConfig = [],
    requirePermission = true
}) => {

    const [showForm, setShowForm] = useState(false);

    // =========================================================
    // INITIAL FORM
    // =========================================================

    const initialForm = useMemo(() => {

        const form = {};

        fieldConfig.forEach(field => {

            if (field.type === "checkbox") {

                form[field.name] =
                    field.defaultValue ?? false;

            } else if (field.type === "hidden") {

                form[field.name] = null;

            } else {

                form[field.name] =
                    field.defaultValue ?? "";
            }

        });

        return form;

    }, [fieldConfig]);


    // =========================================================
    // PERMISSIONS
    // =========================================================

    const permissions = getPermissions();

    const canRead =
        !requirePermission ||
        hasPermission(
            permissions,
            permissionPrefix,
            "read",
            "all"
        );

    const canCreate =
        !requirePermission ||
        hasPermission(
            permissions,
            permissionPrefix,
            "create",
            "all"
        );

    const canUpdate =
        !requirePermission ||
        hasPermission(
            permissions,
            permissionPrefix,
            "update",
            "all"
        );

    const canDelete =
        !requirePermission ||
        hasPermission(
            permissions,
            permissionPrefix,
            "delete",
            "all"
        );

    // =========================================================
    // FETCH DATA
    // =========================================================

    const fetchData = useCallback(
        async (params, config = {}) => {

            try {

                const response =
                    await service.getPaged(
                        params,
                        config
                    );

                const data =
                    response?.data;

                // -------------------------------------------------
                // API returned array
                // -------------------------------------------------

                if (Array.isArray(data)) {

                    return {
                        items: data,
                        totalCount: data.length,
                        totalPages:
                            Math.ceil(
                                data.length /
                                (params.pageSize || 1)
                            )
                    };
                }

                // -------------------------------------------------
                // Empty response
                // -------------------------------------------------

                if (!data) {
                    return emptyResult;
                }

                // -------------------------------------------------
                // Paged API response
                // -------------------------------------------------

                if (data.items !== undefined) {

                    const totalCount =
                        data.totalCount ??
                        data.items.length;

                    return {
                        items: data.items,
                        totalCount,
                        totalPages:
                            data.totalPages ??
                            Math.ceil(
                                totalCount /
                                (params.pageSize || 1)
                            )
                    };
                }

                return emptyResult;

            } catch (error) {

                if (
                    error?.name === "AbortError" ||
                    error?.code === "ERR_CANCELED"
                ) {
                    return emptyResult;
                }

                console.error(
                    `Failed to load ${entityName}:`,
                    error
                );

                throw error;
            }

        },
        [
            service,
            entityName
        ]
    );


    // =========================================================
    // TABLE CONTROLS
    // =========================================================

    const table = useTableControls({

        fetchData,

        initialPage: 1,

        initialPageSize: 10,

        initialSearch: "",

        initialSort: "",

        initialSortOrder: "asc",

        initialFilters: {}

    });


    // =========================================================
    // CRUD
    // =========================================================

    const crud = useCrud({

        service,

        initialForm,

        buildPayload: useCallback(
            (formData) => {

                const payload = {};

                fieldConfig.forEach(field => {

                    if (field.name === "id") {
                        return;
                    }

                    if (
                        field.readOnly &&
                        formData.id
                    ) {
                        return;
                    }

                    const value =
                        formData[field.name];


                    // Checkbox
                    if (field.type === "checkbox") {

                        payload[field.name] =
                            value ?? false;

                        return;
                    }


                    // Optional empty field
                    if (
                        (
                            value === "" ||
                            value === undefined ||
                            value === null
                        ) &&
                        !field.required
                    ) {
                        return;
                    }


                    // Normal value
                    if (
                        value !== undefined &&
                        value !== null &&
                        value !== ""
                    ) {

                        payload[field.name] =
                            value;

                    } else if (field.required) {

                        payload[field.name] =
                            value;
                    }

                });

                console.log(
                    "📤 Generic CRUD payload:",
                    payload
                );

                return payload;

            },
            [fieldConfig]
        )

    });


    // =========================================================
    // EDIT
    // =========================================================

    const handleEdit = useCallback(
        (item) => {

            const mapped = {};

            fieldConfig.forEach(field => {

                const value =
                    item[field.name];


                if (field.type === "checkbox") {

                    mapped[field.name] =
                        value ?? false;

                } else if (field.type === "hidden") {

                    mapped[field.name] =
                        value ?? null;

                } else {

                    mapped[field.name] =
                        value ?? "";
                }

            });


            // Handle possible ID casing
            mapped.id =
                item.id ??
                item.Id ??
                item.facilityId ??
                item.FacilityId ??
                null;


            crud.setForm(mapped);

            setShowForm(true);

        },
        [
            fieldConfig,
            crud.setForm
        ]
    );


    // =========================================================
    // ADD
    // =========================================================

    const handleAddNew = useCallback(
        () => {

            crud.resetForm();

            setShowForm(true);

        },
        [
            crud.resetForm
        ]
    );


    // =========================================================
    // CANCEL
    // =========================================================

    const handleCancel = useCallback(
        () => {

            crud.resetForm();

            setShowForm(false);

        },
        [
            crud.resetForm
        ]
    );


    // =========================================================
    // SUBMIT
    // =========================================================

    const handleSubmit = useCallback(
        async (formData) => {

            const success =
                await crud.handleSubmit(
                    formData
                );


            if (!success) {
                return false;
            }


            setShowForm(false);

            await table.reloadData();

            return true;

        },
        [
            crud.handleSubmit,
            table.reloadData
        ]
    );


    // =========================================================
    // DELETE
    // =========================================================

    const handleDeleteItem = useCallback(
        async (id) => {

            const success =
                await crud.handleDelete(id);


            if (!success) {
                return false;
            }


            await table.reloadData();

            return true;

        },
        [
            crud.handleDelete,
            table.reloadData
        ]
    );


    // =========================================================
    // SEARCH
    // =========================================================

    const handleSearchChange = useCallback(
        (value) => {

            table.handleSearch(
                value || ""
            );

        },
        [
            table.handleSearch
        ]
    );


    // =========================================================
    // FILTER
    // =========================================================

    const handleFilterChange = useCallback(
        (filters) => {

            table.handleFilter(
                filters || {}
            );

        },
        [
            table.handleFilter
        ]
    );


    // =========================================================
    // SAFE DATA
    // =========================================================

    const safeData =
        Array.isArray(table.data)
            ? table.data
            : [];


    // =========================================================
    // RETURN
    // =========================================================

    return {

        // Form
        showForm,
        form: crud.form,

        // Table
        data: safeData,
        loading: table.loading,

        page: table.page,
        pageSize: table.pageSize,

        totalCount: table.totalCount,
        totalPages: table.totalPages,

        search: table.search,
        sortBy: table.sortBy,
        sortOrder: table.sortOrder,
        filters: table.filters,

        // Permissions
        canRead,
        canCreate,
        canUpdate,
        canDelete,

        // Form actions
        handleAddNew,
        handleEdit,
        handleCancel,
        handleSubmit,

        // Table actions
        handleDeleteItem,
        handleSearchChange,
        handleFilterChange,

        handleSort:
            table.handleSort,

        handlePageChange:
            table.handlePageChange,

        handlePageSizeChange:
            table.handlePageSizeChange,

        reloadData:
            table.reloadData
    };
};

export default useGenericEntity;