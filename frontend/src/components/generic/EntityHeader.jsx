import React from "react";

const EntityHeader = ({
    entityName,
    showForm,
    canCreate,
    onAddNew,
    onCancel
}) => {

    return (
        <div className="crud-header">

            <div className="crud-header-content">

                <h1 className="crud-title">
                    {entityName} Management
                </h1>

                <p className="crud-subtitle">
                    Manage and maintain your{" "}
                    {entityName.toLowerCase()}.
                </p>

            </div>

            {!showForm ? (

                canCreate && (
                    <button
                        className="crud-button crud-button-primary"
                        onClick={onAddNew}
                    >
                        + Add New
                    </button>
                )

            ) : (

                <button
                    className="crud-button crud-button-secondary"
                    onClick={onCancel}
                >
                    Cancel
                </button>

            )}

        </div>
    );
};

export default EntityHeader;