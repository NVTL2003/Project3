import React from "react";
import CrudList from "../CrudList";

const EntityTableSection = ({
    data,
    loading,
    entityName,
    displayColumns,
    canUpdate,
    canDelete,
    onEdit,
    onDelete,
    extraActions
}) => {

    return (
        <div className="crud-table-card">

            {loading ? (

                <div className="crud-loading">
                    Loading...
                </div>

            ) : data.length > 0 ? (

                <CrudList
                    data={data}
                    columns={displayColumns}
                    onEdit={
                        canUpdate
                            ? onEdit
                            : undefined
                    }
                    onDelete={
                        canDelete
                            ? onDelete
                            : undefined
                    }
                    extraActions={extraActions}
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
    );
};

export default EntityTableSection;