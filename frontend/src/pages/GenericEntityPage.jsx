import React from "react";

import useGenericEntity from "../hooks/useGenericEntity";

import TableControls from "../components/TableControls";
import Pagination from "../components/Pagination";

import EntityHeader from "../components/generic/EntityHeader";
import EntityFormSection from "../components/generic/EntityFormSection";
import EntityTableSection from "../components/generic/EntityTableSection";
import AccessDenied from "../components/generic/AccessDenied";

import "../styles/crud.css";

const GenericEntityPage = ({
    entityName,
    permissionPrefix,
    service,

    fieldConfig = [],

    displayColumns = [],

    sortOptions = [],

    filterOptions = [],

    requirePermission = true,

    extraActions = null
}) => {

    const entity = useGenericEntity({

        entityName,

        permissionPrefix,

        service,

        fieldConfig,

        requirePermission

    });


    // =========================================================
    // ACCESS DENIED
    // =========================================================

    if (!entity.canRead) {

        return (
            <AccessDenied
                entityName={entityName}
            />
        );
    }


    // =========================================================
    // PAGE
    // =========================================================

    return (

        <div className="crud-page">

            <div className="crud-container">


                {/* ================================================= */}
                {/* HEADER */}
                {/* ================================================= */}

                <EntityHeader

                    entityName={entityName}

                    showForm={entity.showForm}

                    canCreate={entity.canCreate}

                    onAddNew={
                        entity.handleAddNew
                    }

                    onCancel={
                        entity.handleCancel
                    }

                />


                {/* ================================================= */}
                {/* FORM */}
                {/* ================================================= */}

                {entity.showForm && (

                    <EntityFormSection

                        entityName={entityName}

                        form={entity.form}

                        fields={fieldConfig}

                        onSubmit={
                            entity.handleSubmit
                        }

                    />

                )}


                {/* ================================================= */}
                {/* TABLE CONTROLS */}
                {/* ================================================= */}

                <TableControls

                    onSearch={
                        entity.handleSearchChange
                    }

                    onSort={
                        entity.handleSort
                    }

                    onFilter={
                        entity.handleFilterChange
                    }

                    sortOptions={
                        sortOptions
                    }

                    filterOptions={
                        filterOptions
                    }

                    initialSearch={
                        entity.search
                    }

                    initialSort={
                        entity.sortBy
                    }

                    initialSortOrder={
                        entity.sortOrder
                    }

                    initialFilters={
                        entity.filters
                    }

                />


                {/* ================================================= */}
                {/* TABLE */}
                {/* ================================================= */}

                <EntityTableSection

                    data={entity.data}

                    loading={entity.loading}

                    entityName={entityName}

                    displayColumns={
                        displayColumns
                    }

                    canUpdate={
                        entity.canUpdate
                    }

                    canDelete={
                        entity.canDelete
                    }

                    onEdit={
                        entity.handleEdit
                    }

                    onDelete={
                        entity.handleDeleteItem
                    }

                    extraActions={
                        extraActions
                    }

                />


                {/* ================================================= */}
                {/* PAGINATION */}
                {/* ================================================= */}

                {entity.totalCount > 0 && (

                    <Pagination

                        currentPage={
                            entity.page
                        }

                        totalPages={
                            entity.totalPages
                        }

                        totalItems={
                            entity.totalCount
                        }

                        pageSize={
                            entity.pageSize
                        }

                        onPageChange={
                            entity.handlePageChange
                        }

                        onPageSizeChange={
                            entity.handlePageSizeChange
                        }

                    />

                )}

            </div>

        </div>
    );
};

export default GenericEntityPage;