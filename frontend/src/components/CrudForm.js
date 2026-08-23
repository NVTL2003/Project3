import { useState, useEffect } from "react";
import RelationSelect
    from "./generic/RelationSelect";
function CrudForm({
    fields,
    initialData,
    onSubmit,
    submitLabel
}) {

    const [form, setForm] = useState({});


    useEffect(() => {

        const initialFormState = {};

        fields.forEach(field => {

            if (
                initialData?.[field.name] !== undefined &&
                initialData?.[field.name] !== null
            ) {

                initialFormState[field.name] =
                    initialData[field.name];

            } else {

                if (field.type === "checkbox") {

                    initialFormState[field.name] =
                        false;

                } else if (field.type === "hidden") {

                    initialFormState[field.name] =
                        null;

                } else {

                    initialFormState[field.name] =
                        "";
                }

            }

        });

        console.log(
            "CrudForm - Initializing with:",
            initialFormState
        );

        setForm(initialFormState);

    }, [initialData, fields]);


    const handleChange = (
        name,
        value
    ) => {

        console.log(
            `Updating ${name} to:`,
            value
        );

        setForm(prevForm => ({
            ...prevForm,
            [name]: value
        }));

    };


    const handleSubmit = () => {

        console.log(
            "CrudForm - Current form state before validation:",
            form
        );

        const missingFields = [];

        for (const field of fields) {

            if (
                field.required &&
                field.type !== "hidden" &&
                field.type !== "checkbox"
            ) {

                const value =
                    form[field.name];

                if (
                    value === undefined ||
                    value === null ||
                    value === ""
                ) {

                    missingFields.push(
                        field.label
                    );

                }

            }

        }


        if (missingFields.length > 0) {

            alert(
                `Please fill in: ${missingFields.join(", ")}`
            );

            return;
        }


        console.log(
            "Validation passed, submitting:",
            form
        );

        onSubmit(form);

    };


    return (

        <div className="crud-form">

            <div className="crud-form-fields">

                {fields.map(field => {

                    if (field.type === "hidden") {
                        return null;
                    }


                    return (

                        <div
                            key={field.name}
                            className={
                                field.type === "textarea"
                                    ? "crud-form-field crud-form-field-full"
                                    : "crud-form-field"
                            }
                        >

                            <label className="crud-form-label">

                                {field.label}

                                {field.required && (

                                    <span className="crud-required">
                                        *
                                    </span>

                                )}

                            </label>


                            {field.type === "checkbox" ? (

                                <label className="crud-checkbox">

                                    <input
                                        type="checkbox"
                                        checked={
                                            form[field.name] || false
                                        }
                                        onChange={(e) =>
                                            handleChange(
                                                field.name,
                                                e.target.checked
                                            )
                                        }
                                    />

                                    <span>
                                        {field.label}
                                    </span>

                                </label>

                            ) : field.type === "select" ? (

                                <select
                                    className="crud-form-input"
                                    value={
                                        form[field.name] || ""
                                    }
                                    onChange={(e) =>
                                        handleChange(
                                            field.name,
                                            e.target.value
                                        )
                                    }
                                >

                                    <option value="">
                                        Select {field.label}
                                    </option>

                                    {field.options?.map(opt => (

                                        <option
                                            key={opt.value}
                                            value={opt.value}
                                        >
                                            {opt.label}
                                        </option>

                                    ))}

                                    </select>
                            ) : field.type === "relation" ? (

                                <RelationSelect
                                    field={field}
                                    value={form[field.name]}
                                    onChange={(value) =>
                                        handleChange(
                                            field.name,
                                            value
                                        )
                                    }
                                />
                            ) : field.type === "textarea" ? (

                                <textarea
                                    className="crud-form-input crud-form-textarea"
                                    placeholder={field.label}
                                    value={
                                        form[field.name] || ""
                                    }
                                    onChange={(e) =>
                                        handleChange(
                                            field.name,
                                            e.target.value
                                        )
                                    }
                                />

                            ) : (

                                <input
                                    className="crud-form-input"
                                    type={field.type || "text"}
                                    placeholder={field.label}
                                    value={
                                        form[field.name] || ""
                                    }
                                    onChange={(e) =>
                                        handleChange(
                                            field.name,
                                            e.target.value
                                        )
                                    }
                                />

                            )}

                        </div>

                    );

                })}

            </div>


            <div className="crud-form-actions">

                <button
                    type="button"
                    className="crud-button crud-button-primary"
                    onClick={handleSubmit}
                >
                    {submitLabel || "Submit"}
                </button>

            </div>

        </div>

    );

}

export default CrudForm;