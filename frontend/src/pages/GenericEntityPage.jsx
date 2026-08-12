// import React, {
//     useCallback,
//     useState
// } from "react";

// import { useCrud } from "../hooks/useCrud";
// import useTableControls from "../hooks/useTableControls";

// import CrudForm from "../components/CrudForm";
// import CrudList from "../components/CrudList";
// import TableControls from "../components/TableControls";
// import Pagination from "../components/Pagination";

// const GenericEntityPage = ({
//     entityName,
//     service,
//     fieldConfig = [],
//     displayColumns = [],
//     sortOptions = [],
//     filterOptions = []
// }) => {

//     const [showForm, setShowForm] = useState(false);


//     =========================================================
//     TABLE DATA
//     =========================================================

//     const fetchData = useCallback(
//         async (params, config) => {

//             console.log(
//                 "📡 GenericEntityPage fetchData:",
//                 params
//             );

//             try {

//                 Make sure the service actually supports getPaged
//                 if (
//                     !service ||
//                     typeof service.getPaged !== "function"
//                 ) {
//                     console.error(
//                         "❌ Service does not have getPaged():",
//                         service
//                     );

//                     return {
//                         items: [],
//                         totalCount: 0,
//                         totalPages: 0
//                     };
//                 }


//                 const response =
//                     await service.getPaged(
//                         params,
//                         config
//                     );


//                 console.log(
//                     "📦 GenericEntityPage response:",
//                     response
//                 );

//                 console.log(
//                     "📦 GenericEntityPage response.data:",
//                     response?.data
//                 );


//                 /*
//                  * Expected backend response:
//                  *
//                  * {
//                  *     items: [...],
//                  *     totalCount: 20,
//                  *     totalPages: 2
//                  * }
//                  */


//                 const result = response?.data;


//                 Defensive response handling
//                 if (!result || typeof result !== "object") {

//                     console.warn(
//                         "⚠️ Invalid table response:",
//                         result
//                     );

//                     return {
//                         items: [],
//                         totalCount: 0,
//                         totalPages: 0
//                     };
//                 }


//                 return {
//                     items: Array.isArray(result.items)
//                         ? result.items
//                         : [],

//                     totalCount:
//                         Number(result.totalCount) || 0,

//                     totalPages:
//                         Number(result.totalPages) || 0
//                 };


//             } catch (error) {

//                 if (
//                     error?.name === "AbortError" ||
//                     error?.code === "ERR_CANCELED"
//                 ) {

//                     console.log(
//                         "🛑 GenericEntityPage request cancelled"
//                     );

//                     return {
//                         items: [],
//                         totalCount: 0,
//                         totalPages: 0
//                     };
//                 }


//                 console.error(
//                     "❌ GenericEntityPage fetch error:",
//                     error
//                 );


//                 throw error;
//             }

//         },
//         [service]
//     );


//     =========================================================
//     TABLE CONTROLS
//     =========================================================

//     const {
//         data,
//         loading,

//         page,
//         pageSize,

//         totalCount,
//         totalPages,

//         search,
//         sortBy,
//         sortOrder,

//         handleSearch,
//         handleSort,
//         handleFilter,

//         handlePageChange,
//         handlePageSizeChange,

//         reloadData

//     } = useTableControls({

//         fetchData,

//         initialPage: 1,
//         initialPageSize: 10,

//         initialSearch: "",
//         initialSort: "",
//         initialSortOrder: "asc",

//         initialFilters: {}

//     });


//     =========================================================
//     SAFE TABLE DATA
//     =========================================================

//     /*
//      * This is important.
//      *
//      * Even if something goes wrong in useTableControls
//      * or the backend response, GenericEntityPage will
//      * NEVER attempt:
//      *
//      *     undefined.length
//      *
//      * Instead it always works with an array.
//      */

//     const safeData =
//         Array.isArray(data)
//             ? data
//             : [];


//     =========================================================
//     CRUD
//     =========================================================

//     const {
//         form,
//         setForm,

//         handleSubmit: crudSubmit,

//         handleDelete,

//         resetForm

//     } = useCrud({

//         service,

//         /*
//          * IMPORTANT:
//          *
//          * Your previous code used:
//          *
//          *     initialForm: {}
//          *
//          * That means useCrud has no knowledge of the
//          * fields in the form.
//          *
//          * We generate the initial form from fieldConfig.
//          */

//         initialForm: fieldConfig.reduce(
//             (initial, field) => {

//                 if (field.name === "id") {
//                     initial[field.name] = null;
//                 }
//                 else if (
//                     field.defaultValue !== undefined
//                 ) {
//                     initial[field.name] =
//                         field.defaultValue;
//                 }
//                 else if (
//                     field.type === "checkbox"
//                 ) {
//                     initial[field.name] = false;
//                 }
//                 else {
//                     initial[field.name] = "";
//                 }

//                 return initial;

//             },
//             {}
//         ),

//         buildPayload: (formData) => {

//             const payload = {};

//             fieldConfig.forEach(field => {

//                 /*
//                  * ID belongs in the URL for update,
//                  * not inside the request body.
//                  */

//                 if (field.name !== "id") {

//                     payload[field.name] =
//                         formData[field.name];

//                 }

//             });

//             console.log(
//                 "📤 GenericEntityPage payload:",
//                 payload
//             );

//             return payload;
//         }

//     });


//     =========================================================
//     EDIT
//     =========================================================

//     const handleEdit = useCallback(
//         (item) => {

//             console.log(
//                 "✏️ Editing item:",
//                 item
//             );


//             const mapped = {};


//             fieldConfig.forEach(field => {

//                 if (field.name === "id") {

//                     mapped.id =
//                         item.id ??
//                         item.Id ??
//                         item.facilityId ??
//                         item.FacilityId ??
//                         null;

//                     return;
//                 }


//                 /*
//                  * Use the existing value if present.
//                  *
//                  * Otherwise use defaultValue,
//                  * checkbox false, or empty string.
//                  */

//                 if (
//                     item[field.name] !== undefined &&
//                     item[field.name] !== null
//                 ) {

//                     mapped[field.name] =
//                         item[field.name];

//                 }
//                 else if (
//                     field.defaultValue !== undefined
//                 ) {

//                     mapped[field.name] =
//                         field.defaultValue;

//                 }
//                 else if (
//                     field.type === "checkbox"
//                 ) {

//                     mapped[field.name] = false;

//                 }
//                 else {

//                     mapped[field.name] = "";

//                 }

//             });


//             console.log(
//                 "✏️ Mapped edit form:",
//                 mapped
//             );


//             setForm(mapped);

//             setShowForm(true);

//         },
//         [
//             fieldConfig,
//             setForm
//         ]
//     );


//     =========================================================
//     CREATE / UPDATE
//     =========================================================

//     const handleSubmit = useCallback(
//         async (formData) => {

//             console.log(
//                 "📤 GenericEntityPage submit:",
//                 formData
//             );


//             /*
//              * crudSubmit returns:
//              *
//              * true  = successful
//              * false = failed
//              */

//             const success =
//                 await crudSubmit(formData);


//             if (!success) {

//                 console.warn(
//                     "⚠️ CRUD operation failed."
//                 );

//                 /*
//                  * DO NOT close the form.
//                  *
//                  * This lets the user see/fix
//                  * the entered data.
//                  */

//                 return;
//             }


//             console.log(
//                 "✅ CRUD operation successful."
//             );


//             setShowForm(false);

//             resetForm();


//             /*
//              * Reload table after successful
//              * create/update.
//              */

//             await reloadData();

//         },
//         [
//             crudSubmit,
//             reloadData,
//             resetForm
//         ]
//     );


//     =========================================================
//     DELETE
//     =========================================================

//     const handleDeleteItem = useCallback(
//         async (id) => {

//             console.log(
//                 "🗑️ Delete requested:",
//                 id
//             );


//             const success =
//                 await handleDelete(id);


//             /*
//              * Only reload if delete actually succeeded.
//              */

//             if (success) {

//                 console.log(
//                     "✅ Delete successful. Reloading..."
//                 );

//                 await reloadData();

//             }
//             else {

//                 console.log(
//                     "⚠️ Delete cancelled or failed."
//                 );

//             }

//         },
//         [
//             handleDelete,
//             reloadData
//         ]
//     );


//     =========================================================
//     ADD NEW
//     =========================================================

//     const handleAddNew = useCallback(
//         () => {

//             console.log(
//                 "➕ Add new clicked"
//             );

//             resetForm();

//             setShowForm(true);

//         },
//         [
//             resetForm
//         ]
//     );


//     =========================================================
//     CANCEL
//     =========================================================

//     const handleCancel = useCallback(
//         () => {

//             console.log(
//                 "❌ Form cancelled"
//             );

//             resetForm();

//             setShowForm(false);

//         },
//         [
//             resetForm
//         ]
//     );


//     =========================================================
//     ENTITY SINGULAR NAME
//     =========================================================

//     /*
//      * "Facilities" -> "Facility"
//      *
//      * This is only cosmetic.
//      */

//     const singularEntityName =
//         entityName.endsWith("ies")
//             ? entityName.slice(0, -3) + "y"
//             : entityName.endsWith("s")
//                 ? entityName.slice(0, -1)
//                 : entityName;


//     =========================================================
//     UI
//     =========================================================

//     return (

//         <div
//             style={{
//                 padding: "20px",
//                 maxWidth: "1200px",
//                 margin: "0 auto"
//             }}
//         >

//             {/* =================================================
//                 HEADER
//             ================================================= */}

//             <div
//                 style={{
//                     display: "flex",
//                     justifyContent: "space-between",
//                     alignItems: "center",
//                     marginBottom: "20px"
//                 }}
//             >

//                 <h2>
//                     {entityName} Management
//                 </h2>


//                 <button
//                     onClick={
//                         showForm
//                             ? handleCancel
//                             : handleAddNew
//                     }
//                     style={{
//                         padding: "10px 20px",
//                         background: "#1565c0",
//                         color: "white",
//                         border: "none",
//                         borderRadius: "4px",
//                         cursor: "pointer"
//                     }}
//                 >

//                     {showForm
//                         ? "Cancel"
//                         : "Add New"
//                     }

//                 </button>

//             </div>


//             {/* =================================================
//                 FORM
//             ================================================= */}

//             {showForm && (

//                 <div
//                     style={{
//                         marginBottom: "30px",
//                         background: "#f9f9f9",
//                         padding: "15px",
//                         borderRadius: "8px"
//                     }}
//                 >

//                     <h3>

//                         {form?.id
//                             ? `Edit ${singularEntityName}`
//                             : `Create New ${singularEntityName}`
//                         }

//                     </h3>


//                     <CrudForm
//                         fields={fieldConfig}
//                         initialData={form || {}}
//                         onSubmit={handleSubmit}
//                         submitLabel={
//                             form?.id
//                                 ? "Update"
//                                 : "Create"
//                         }
//                     />

//                 </div>

//             )}


//             {/* =================================================
//                 SEARCH / SORT / FILTER
//             ================================================= */}

//             <TableControls

//                 onSearch={handleSearch}

//                 onSort={handleSort}

//                 onFilter={handleFilter}

//                 sortOptions={sortOptions}

//                 filterOptions={filterOptions}

//                 initialSearch={search}

//                 initialSort={sortBy}

//                 initialSortOrder={sortOrder}

//             />


//             {/* =================================================
//                 TABLE
//             ================================================= */}

//             <div>

//                 {loading ? (

//                     <div
//                         style={{
//                             textAlign: "center",
//                             padding: "40px"
//                         }}
//                     >

//                         Loading...

//                     </div>

//                 ) : safeData.length > 0 ? (

//                     <CrudList
//                         data={safeData}
//                         columns={displayColumns}
//                         onEdit={handleEdit}
//                         onDelete={handleDeleteItem}
//                         layout="vertical"
//                     />

//                 ) : (

//                     <div
//                         style={{
//                             textAlign: "center",
//                             padding: "40px"
//                         }}
//                     >

//                         No {entityName.toLowerCase()} found.

//                     </div>

//                 )}


//                 {/* =================================================
//                     PAGINATION
//                 ================================================= */}

//                 {totalCount > 0 && (

//                     <Pagination

//                         currentPage={page}

//                         totalPages={totalPages}

//                         totalItems={totalCount}

//                         pageSize={pageSize}

//                         onPageChange={
//                             handlePageChange
//                         }

//                         onPageSizeChange={
//                             handlePageSizeChange
//                         }

//                     />

//                 )}

//             </div>

//         </div>
//     );
// };


// export default GenericEntityPage;

import React, {
    useCallback,
    useMemo,
    useState
} from "react";

import { useCrud } from "../hooks/useCrud";
import useTableControls from "../hooks/useTableControls";

import CrudForm from "../components/CrudForm";
import CrudList from "../components/CrudList";
import TableControls from "../components/TableControls";
import Pagination from "../components/Pagination";


const GenericEntityPage = ({
    entityName,
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


    // =========================================================
    // UI
    // =========================================================

    return (

        <div
            style={{
                padding: "20px",
                maxWidth: "1200px",
                margin: "0 auto"
            }}
        >

            {/* ================================================= */}
            {/* HEADER */}
            {/* ================================================= */}

            <div
                style={{
                    display: "flex",
                    justifyContent: "space-between",
                    alignItems: "center",
                    marginBottom: "20px"
                }}
            >

                <h2>
                    {entityName} Management
                </h2>


                {!showForm ? (

                    <button
                        onClick={handleAddNew}
                        style={{
                            padding: "10px 20px",
                            background: "#1565c0",
                            color: "white",
                            border: "none",
                            borderRadius: "4px",
                            cursor: "pointer"
                        }}
                    >
                        Add New
                    </button>

                ) : (

                    <button
                        onClick={handleCancel}
                        style={{
                            padding: "10px 20px",
                            background: "#666",
                            color: "white",
                            border: "none",
                            borderRadius: "4px",
                            cursor: "pointer"
                        }}
                    >
                        Cancel
                    </button>

                )}

            </div>


            {/* ================================================= */}
            {/* FORM */}
            {/* ================================================= */}

            {showForm && (

                <div
                    style={{
                        marginBottom: "30px",
                        background: "#f9f9f9",
                        padding: "15px",
                        borderRadius: "8px"
                    }}
                >

                    <h3>

                        {form?.id
                            ? `Edit ${entityName.replace(/s$/, "")}`
                            : `Create New ${entityName.replace(/s$/, "")}`
                        }

                    </h3>


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


            {/* ================================================= */}
            {/* SEARCH / SORT / FILTER */}
            {/* ================================================= */}

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


            {/* ================================================= */}
            {/* TABLE */}
            {/* ================================================= */}

            <div>

                {loading ? (

                    <div
                        style={{
                            textAlign: "center",
                            padding: "40px"
                        }}
                    >
                        Loading...
                    </div>

                ) : safeData.length > 0 ? (

                    <CrudList

                        data={safeData}

                        columns={displayColumns}

                        onEdit={handleEdit}

                        onDelete={handleDeleteItem}

                        layout="vertical"

                    />

                ) : (

                    <div
                        style={{
                            textAlign: "center",
                            padding: "40px",
                            color: "#666"
                        }}
                    >

                        No {entityName.toLowerCase()} found.

                    </div>

                )}

            </div>


            {/* ================================================= */}
            {/* PAGINATION */}
            {/* ================================================= */}

            {totalCount > 0 && (

                <Pagination

                    currentPage={page}

                    totalPages={totalPages}

                    totalItems={totalCount}

                    pageSize={pageSize}

                    onPageChange={
                        handlePageChange
                    }

                    onPageSizeChange={
                        handlePageSizeChange
                    }

                />

            )}

        </div>

    );
};


export default GenericEntityPage;