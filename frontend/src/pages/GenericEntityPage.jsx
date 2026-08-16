import React, {
    useCallback,
    useMemo,
    useState
} from "react";

import { useCrud } from "../hooks/useCrud";
import useTableControls from "../hooks/useTableControls";
import "../styles/crud.css";
import CrudForm from "../components/CrudForm";
import CrudList from "../components/CrudList";
import TableControls from "../components/TableControls";
import Pagination from "../components/Pagination";
import {
    hasPermission
} from "../utils/permissionUtils";

const GenericEntityPage = ({
    entityName,
    permissionPrefix,
    service,
    fieldConfig = [],
    displayColumns = [],
    sortOptions = [],
    filterOptions = []
}) => {

    const [showForm, setShowForm] = useState(false);


    // =========================================================
    // DEFAULT FORM
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
    // TABLE DATA
    // =========================================================

    const fetchData = useCallback(
        async (params, config = {}) => {

            console.log(
                "📡 GenericEntityPage fetchData:",
                params
            );

            try {
                // line 77 is the line below this
                const response =
                    await service.getPaged(
                        params,
                        config
                    );

                console.log(
                    "📦 GenericEntityPage response:",
                    response
                );

                console.log(
                    "📦 GenericEntityPage response.data:",
                    response?.data
                );


                /*
                 * Axios response:
                 *
                 * {
                 *     data: {
                 *         items: [],
                 *         totalCount: 7,
                 *         totalPages: 1
                 *     }
                 * }
                 */


                return response?.data ?? {
                    items: [],
                    totalCount: 0,
                    totalPages: 0
                };

            } catch (error) {

                if (
                    error?.name === "AbortError" ||
                    error?.code === "ERR_CANCELED"
                ) {

                    console.log(
                        "🛑 GenericEntityPage request cancelled"
                    );

                    return {
                        items: [],
                        totalCount: 0,
                        totalPages: 0
                    };
                }

                //line 132 is the line below this
                console.error(
                    "❌ GenericEntityPage fetch error:",
                    error
                );

                throw error;
            }

        },
        [service]
    );


    // =========================================================
    // TABLE CONTROLS
    // =========================================================

    const {
        data,
        loading,

        page,
        pageSize,

        totalCount,
        totalPages,

        search,
        sortBy,
        sortOrder,
        filters,

        handleSearch,
        handleSort,
        handleFilter,

        handlePageChange,
        handlePageSizeChange,

        reloadData

    } = useTableControls({

        fetchData,

        initialPage: 1,
        initialPageSize: 10,

        initialSearch: "",
        initialSort: "",
        initialSortOrder: "asc",

        initialFilters: {}

    });


    // =========================================================
    // SAFE TABLE DATA
    // =========================================================

    const safeData =
        Array.isArray(data)
            ? data
            : [];


    // =========================================================
    // CRUD
    // =========================================================

    const {
        form,
        setForm,

        handleSubmit: crudSubmit,

        handleDelete,

        resetForm

    } = useCrud({

        service,

        initialForm,

        buildPayload: (formData) => {

            const payload = {};

            fieldConfig.forEach(field => {

                /*
                 * ID is handled separately by useCrud.
                 */
                if (field.name === "id") {
                    return;
                }


                const value =
                    formData[field.name];


                /*
                 * Preserve checkbox false.
                 */
                if (field.type === "checkbox") {

                    payload[field.name] =
                        value ?? false;

                    return;
                }


                /*
                 * Don't accidentally send undefined.
                 */
                if (
                    value !== undefined &&
                    value !== null
                ) {

                    payload[field.name] =
                        value;

                }

            });


            console.log(
                "📤 GenericEntityPage payload:",
                payload
            );

            return payload;
        }

    });


    // =========================================================
    // EDIT
    // =========================================================

    const handleEdit = useCallback(
        (item) => {

            console.log(
                "✏️ Editing item:",
                item
            );


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


            /*
             * Handle different possible ID casing.
             */
            mapped.id =
                item.id ??
                item.Id ??
                item.facilityId ??
                item.FacilityId ??
                null;


            console.log(
                "✏️ Mapped edit form:",
                mapped
            );


            setForm(mapped);

            setShowForm(true);

        },
        [
            fieldConfig,
            setForm
        ]
    );


    // =========================================================
    // ADD NEW
    // =========================================================

    const handleAddNew = useCallback(() => {

        console.log(
            "➕ Add new clicked"
        );


        resetForm();

        setShowForm(true);

    }, [resetForm]);


    // =========================================================
    // CANCEL FORM
    // =========================================================

    const handleCancel = useCallback(() => {

        console.log(
            "❌ Form cancelled"
        );


        resetForm();

        setShowForm(false);

    }, [resetForm]);


    // =========================================================
    // CREATE / UPDATE
    // =========================================================

    const handleSubmit = useCallback(
        async (formData) => {

            console.log(
                "📤 GenericEntityPage submit:",
                formData
            );


            const success =
                await crudSubmit(formData);


            /*
             * IMPORTANT:
             *
             * Do not close/reload if CRUD failed.
             */
            if (!success) {

                console.log(
                    "❌ CRUD operation failed"
                );

                return;
            }


            console.log(
                "✅ CRUD operation successful"
            );


            setShowForm(false);


            /*
             * Reload the current table.
             */
            await reloadData();

        },
        [
            crudSubmit,
            reloadData
        ]
    );


    // =========================================================
    // DELETE
    // =========================================================

    const handleDeleteItem = useCallback(
        async (id) => {

            console.log(
                "🗑️ Delete requested:",
                id
            );


            const success =
                await handleDelete(id);


            if (!success) {

                console.log(
                    "❌ Delete failed"
                );

                return;
            }


            console.log(
                "✅ Delete successful"
            );


            await reloadData();

        },
        [
            handleDelete,
            reloadData
        ]
    );


    // =========================================================
    // SEARCH
    // =========================================================

    const handleSearchChange = useCallback(
        (value) => {

            console.log(
                "🔍 GenericEntityPage search:",
                value
            );

            handleSearch(
                value || ""
            );

        },
        [handleSearch]
    );


    // =========================================================
    // FILTER
    // =========================================================

    const handleFilterChange = useCallback(
        (newFilters) => {

            console.log(
                "🏷️ GenericEntityPage filters:",
                newFilters
            );


            handleFilter(
                newFilters || {}
            );

        },
        [handleFilter]
    );

    const canRead =
        hasPermission(
            `${permissionPrefix}.Read`
        );

    const canCreate =
        hasPermission(
            `${permissionPrefix}.Create`
        );

    const canUpdate =
        hasPermission(
            `${permissionPrefix}.Update`
        );

    const canDelete =
        hasPermission(
            `${permissionPrefix}.Delete`
        );
    if (!canRead) {
        return (
            <div
                style={{
                    padding: "40px",
                    textAlign: "center"
                }}
            >
                <h2>Access Denied</h2>

                <p>
                    You do not have permission to view{" "}
                    {entityName}.
                </p>
            </div>
        );
    }
    // =========================================================
    // UI
    // =========================================================
    return (
        <div className="crud-page">

            <div className="crud-container">

                {/* HEADER */}

                <div className="crud-header">

                    <div className="crud-header-content">

                        <h1 className="crud-title">
                            {entityName} Management
                        </h1>

                        <p className="crud-subtitle">
                            Manage and maintain your {entityName.toLowerCase()}.
                        </p>

                    </div>

                    {!showForm ? (

                        canCreate && (
                            <button
                                className="crud-button crud-button-primary"
                                onClick={handleAddNew}
                            >
                                + Add New
                            </button>
                        )

                    ) : (

                        <button
                            className="crud-button crud-button-secondary"
                            onClick={handleCancel}
                        >
                            Cancel
                        </button>

                    )}

                </div>


                {/* FORM */}

                {showForm && (

                    <div className="crud-form-card">

                        <div className="crud-form-header">

                            <h2 className="crud-form-title">

                                {form?.id
                                    ? `Edit ${entityName.replace(/s$/, "")}`
                                    : `Create New ${entityName.replace(/s$/, "")}`
                                }

                            </h2>

                        </div>

                        <CrudForm
                            fields={fieldConfig}
                            initialData={form}
                            onSubmit={handleSubmit}
                            submitLabel={
                                form?.id
                                    ? "Update"
                                    : "Create"
                            }
                        />

                    </div>

                )}


                {/* CONTROLS */}

                <TableControls
                    onSearch={handleSearchChange}
                    onSort={handleSort}
                    onFilter={handleFilterChange}
                    sortOptions={sortOptions}
                    filterOptions={filterOptions}
                    initialSearch={search}
                    initialSort={sortBy}
                    initialSortOrder={sortOrder}
                    initialFilters={filters}
                />


                {/* TABLE */}

                <div className="crud-table-card">

                    {loading ? (

                        <div className="crud-loading">
                            Loading...
                        </div>

                    ) : safeData.length > 0 ? (

                        <CrudList
                            data={safeData}
                            columns={displayColumns}
                            onEdit={
                                canUpdate
                                    ? handleEdit
                                    : undefined
                            }
                            onDelete={
                                canDelete
                                    ? handleDeleteItem
                                    : undefined
                            }
                            layout="vertical"
                        />

                    ) : (

                        <div className="crud-empty">

                            <div className="crud-empty-title">
                                No {entityName.toLowerCase()} found
                            </div>

                            <div>
                                Try changing your search or filters.
                            </div>

                        </div>

                    )}

                </div>


                {/* PAGINATION */}

                {totalCount > 0 && (

                    <Pagination
                        currentPage={page}
                        totalPages={totalPages}
                        totalItems={totalCount}
                        pageSize={pageSize}
                        onPageChange={handlePageChange}
                        onPageSizeChange={handlePageSizeChange}
                    />

                )}

            </div>

        </div>
    );
};


export default GenericEntityPage;