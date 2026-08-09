// import React from "react";
// import { useCrud } from "../hooks/useCrud";
// import CrudForm from "../components/CrudForm";
// import CrudList from "../components/CrudList";
// import { createEntityConfig } from "../utils/entityConfig";

// const GenericEntityPage = ({
//     entityName,
//     service,
//     fieldConfig,
//     displayColumns,
//     fetchExtraData = null
// }) => {
//     Create entity configuration with dynamic options
//     const [extraData, setExtraData] = React.useState(null);
//     const [config, setConfig] = React.useState(null);

//     React.useEffect(() => {
//         const loadConfig = async () => {
//             let optionsData = {};
//             if (fetchExtraData) {
//                 optionsData = await fetchExtraData();
//                 setExtraData(optionsData);
//             }

//             Update field config with options
//             const updatedFieldConfig = fieldConfig.map(field => {
//                 if (field.type === 'select' && optionsData[field.name]) {
//                     return { ...field, options: optionsData[field.name] };
//                 }
//                 return field;
//             });

//             setConfig(createEntityConfig(entityName, updatedFieldConfig));
//         };

//         loadConfig();
//     }, [entityName, fieldConfig, fetchExtraData]);

//     const {
//         data,
//         form,
//         loading,
//         setForm,
//         handleSubmit,
//         handleDelete,
//         resetForm,
//     } = useCrud({
//         service: service,
//         initialForm: config?.initialForm || { id: null },
//         buildPayload: config?.buildPayload || (() => ({})),
//         fetchExtraData: null,
//     });

//     const onEdit = (item) => {
//         if (config) {
//             const mapped = config.mapToForm(item);
//             setForm(mapped);
//         }
//     };

//     Build columns with proper rendering
//     const columns = displayColumns.map(col => ({
//         key: col.key,
//         label: col.label,
//         render: col.render || null,
//     }));

//     Add default render for boolean fields
//     const enhancedColumns = columns.map(col => {
//         if (!col.render) {
//             const field = fieldConfig.find(f => f.name === col.key);
//             if (field && field.type === 'checkbox') {
//                 return {
//                     ...col,
//                     render: (item) => (
//                         <span style={{ color: item[col.key] ? "green" : "red" }}>
//                             {item[col.key] ? "Yes" : "No"}
//                         </span>
//                     ),
//                 };
//             }
//         }
//         return col;
//     });

//     if (!config) {
//         return <div>Loading configuration...</div>;
//     }

//     return (
//         <div style={{ padding: "20px", maxWidth: "1200px", margin: "0 auto" }}>
//             <h2>{entityName} Management</h2>

//             {/* Form Section */}
//             <div style={{
//                 marginBottom: "30px",
//                 background: "#f9f9f9",
//                 padding: "15px",
//                 borderRadius: "8px"
//             }}>
//                 <h3>{form.id ? `Edit ${entityName.slice(0, -1)}` : `Create New ${entityName.slice(0, -1)}`}</h3>
//                 <CrudForm
//                     fields={config.fields}
//                     initialData={form}
//                     onSubmit={handleSubmit}
//                     submitLabel={form.id ? "Update" : "Create"}
//                 />
//                 {form.id && (
//                     <button
//                         onClick={resetForm}
//                         style={{
//                             marginTop: "10px",
//                             marginLeft: "10px",
//                             padding: "8px 16px",
//                             backgroundColor: "#757575",
//                             color: "white",
//                             border: "none",
//                             borderRadius: "4px",
//                             cursor: "pointer"
//                         }}
//                     >
//                         Cancel Edit
//                     </button>
//                 )}
//             </div>

//             {/* List Section */}
//             <div>
//                 <h3>All {entityName}</h3>
//                 {loading ? (
//                     <p>Loading...</p>
//                 ) : (
//                     <CrudList
//                         data={data}
//                         columns={enhancedColumns}
//                         onEdit={onEdit}
//                         onDelete={handleDelete}
//                         layout="vertical"
//                     />
//                 )}
//             </div>
//         </div>
//     );
// };

// export default GenericEntityPage;

import React, { useState, useCallback } from "react";
import { useCrud } from "../hooks/useCrud";
import useTableControls from "../hooks/useTableControls";
import CrudForm from "../components/CrudForm";
import CrudList from "../components/CrudList";
import TableControls from "../components/TableControls";
import Pagination from "../components/Pagination";

const GenericEntityPage = ({
    entityName,
    service,
    fieldConfig,
    displayColumns,
    sortOptions = [],
    filterOptions = [],
    fetchExtraData = null
}) => {
    const [showForm, setShowForm] = useState(false);

    // Memoize fetchData to prevent recreation
    const fetchData = useCallback(async (params, config) => {
        console.log('🔍🔍🔍 FRONTEND FETCH DATA 🔍🔍🔍');
        console.log('Params received:', params);
        console.log('Search:', params.search);
        console.log('Filters:', params.filters);
        console.log('SortBy:', params.sortBy);

        try {
            const response = await service.getPaged(params, config);
            console.log('📦 Response:', response.data);
            console.log('Items count:', response.data?.items?.length);
            return response.data;
        } catch (err) {
            if (err.name === 'AbortError' || err.code === 'ERR_CANCELED') {
                return { items: [], totalCount: 0 };
            }
            console.error('Error in fetchData:', err);
            throw err;
        }
    }, [service]);

    // Table controls
    const {
        data: tableData,
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
        initialPageSize: 10
    });
    const testSearch = () => {
        console.log('Testing search for Mumbai');
        handleSearch('Mumbai');
    };

    const testFilter = () => {
        console.log('Testing filter for Branch');
        handleFilter({ facilityType: 'Branch' });
    };

    const testSort = () => {
        console.log('Testing sort by name');
        handleSort('name', 'asc');
    };

    // CRUD operations
    const {
        form,
        setForm,
        handleSubmit: crudSubmit,
        handleDelete,
        resetForm,
    } = useCrud({
        service: service,
        initialForm: {},
        buildPayload: (formData) => {
            const payload = {};
            fieldConfig.forEach(field => {
                if (field.name !== 'id') {
                    payload[field.name] = formData[field.name];
                }
            });
            return payload;
        },
        fetchExtraData: null
    });

    const handleEdit = useCallback((item) => {
        const mapped = {};
        fieldConfig.forEach(field => {
            mapped[field.name] = item[field.name] || '';
        });
        mapped.id = item.id;
        setForm(mapped);
        setShowForm(true);
    }, [fieldConfig, setForm]);

    const handleSubmit = useCallback(async (formData) => {
        await crudSubmit(formData);
        setShowForm(false);
        reloadData();
    }, [crudSubmit, reloadData]);

    const handleDeleteItem = useCallback(async (id) => {
        await handleDelete(id);
        reloadData();
    }, [handleDelete, reloadData]);

    return (
        <div style={{ padding: "20px", maxWidth: "1200px", margin: "0 auto" }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '20px' }}>
                <h2>{entityName} Management</h2>
                <button
                    onClick={() => {
                        resetForm();
                        setShowForm(!showForm);
                    }}
                    style={{
                        padding: '10px 20px',
                        background: '#1565c0',
                        color: 'white',
                        border: 'none',
                        borderRadius: '4px',
                        cursor: 'pointer'
                    }}
                >
                    {showForm ? 'Cancel' : 'Add New'}
                </button>
            </div>

            {showForm && (
                <div style={{
                    marginBottom: "30px",
                    background: "#f9f9f9",
                    padding: "15px",
                    borderRadius: "8px"
                }}>
                    <h3>{form.id ? `Edit ${entityName.slice(0, -1)}` : `Create New ${entityName.slice(0, -1)}`}</h3>
                    <CrudForm
                        fields={fieldConfig}
                        initialData={form}
                        onSubmit={handleSubmit}
                        submitLabel={form.id ? "Update" : "Create"}
                    />
                </div>
            )}

            <TableControls
                onSearch={handleSearch}
                onSort={handleSort}
                onFilter={handleFilter}
                sortOptions={sortOptions}
                filterOptions={filterOptions}
                initialSearch={search}
                initialSort={sortBy}
                initialSortOrder={sortOrder}
            />

            <div>
                {tableData && tableData.length > 0 ? (
                    <CrudList
                        data={tableData}
                        columns={displayColumns}
                        onEdit={handleEdit}
                        onDelete={handleDeleteItem}
                        layout="vertical"
                    />
                ) : loading ? (
                    <div style={{ textAlign: 'center', padding: '40px' }}>
                        <p>Loading...</p>
                    </div>
                ) : (
                    <div style={{ textAlign: 'center', padding: '40px' }}>
                        <p>No {entityName.toLowerCase()} found. Create one above!</p>
                    </div>
                )}

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