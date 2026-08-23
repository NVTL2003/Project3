import React from "react";
import CrudForm from "../CrudForm";

const EntityFormSection = ({
    entityName,
    form,
    fields,
    onSubmit
}) => {

    const singularName =
        entityName.replace(/s$/, "");

    const isEditing =
        Boolean(form?.id);

    return (
        <div className="crud-form-card">

            <div className="crud-form-header">

                <h2 className="crud-form-title">

                    {isEditing
                        ? `Edit ${singularName}`
                        : `Create New ${singularName}`
                    }

                </h2>

            </div>

            <CrudForm
                fields={fields}
                initialData={form}
                onSubmit={onSubmit}
                submitLabel={
                    isEditing
                        ? "Update"
                        : "Create"
                }
            />

        </div>
    );
};

export default EntityFormSection;