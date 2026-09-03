// import { useState, useEffect } from "react";

// import RelationSelect
//     from "./generic/RelationSelect";


// function CrudForm({
//     fields,
//     initialData,
//     onSubmit,
//     submitLabel
// }) {

//     const [form, setForm] = useState({});


//     =========================================================
//     EDIT MODE
//     =========================================================

//     const isEditing =
//         !!initialData?.id ;


//     =========================================================
//     INITIALIZE FORM
//     =========================================================

//     useEffect(() => {

//         const initialFormState = {
//             id: initialData?.id ?? null
//         };

//         fields.forEach(field => {

//             ID is handled separately above
//             if (field.name === "id") {
//                 return;
//             }

//             if (
//                 initialData?.[field.name] !== undefined &&
//                 initialData?.[field.name] !== null
//             ) {

//                 initialFormState[field.name] =
//                     initialData[field.name];

//             } else {

//                 if (field.type === "checkbox") {

//                     initialFormState[field.name] =
//                         field.defaultValue ?? false;

//                 } else if (field.type === "hidden") {

//                     initialFormState[field.name] =
//                         null;

//                 } else {

//                     initialFormState[field.name] =
//                         field.defaultValue ?? "";

//                 }

//             }

//         });

//         console.log(
//             "CrudForm - Initializing with:",
//             initialFormState
//         );

//         setForm(initialFormState);

//     }, [
//         initialData,
//         fields
//     ]);


//     =========================================================
//     HANDLE CHANGE
//     =========================================================

//     const handleChange = (name, value) => {

//         const field = fields.find(
//             field => field.name === name
//         );

//         =====================================================
//         NUMBER
//         =====================================================

//         if (field?.type === "number") {
//             const numericValue = value === "" ? "" : Number(value);
//             setForm(prev => ({ ...prev, [name]: numericValue }));
//             return;
//         }

//         =====================================================
//         DATETIME LOCAL
//         =====================================================

//         if (field?.type === "datetime-local") {
//             if (value === "") {
//                 setForm(prev => ({ ...prev, [name]: "" }));
//                 return;
//             }

//             const yearMatch = value.match(/^(\d{4})-/);
//             if (!yearMatch) {
//                 console.warn(`Invalid ${name}:`, value);
//                 return;
//             }

//             const year = Number(yearMatch[1]);
//             if (year < 1 || year > 9999) {
//                 alert(`${field.label} must contain a valid year between 0001 and 9999.`);
//                 return;
//             }

//             setForm(prev => ({ ...prev, [name]: value }));
//             return;
//         }

//         =====================================================
//         CHECKBOX
//         =====================================================

//         if (field?.type === "checkbox") {
//             setForm(prev => ({ ...prev, [name]: value === true }));
//             return;
//         }

//         =====================================================
//         DEFAULT
//         =====================================================

//         setForm(prev => ({ ...prev, [name]: value }));
//     };


//     =========================================================
//     SUBMIT
//     =========================================================

//     const handleSubmit = () => {

//         console.log(
//             "CrudForm - Current form state before validation:",
//             form
//         );


//         const missingFields = [];


//         for (const field of fields) {

//             if (
//                 field.required &&
//                 field.type !== "hidden" &&
//                 field.type !== "checkbox"
//             ) {

//                 const value =
//                     form[field.name];


//                 if (
//                     value === undefined ||
//                     value === null ||
//                     value === ""
//                 ) {

//                     missingFields.push(
//                         field.label
//                     );

//                 }

//             }

//         }


//         if (missingFields.length > 0) {

//             alert(
//                 `Please fill in: ${missingFields.join(", ")}`
//             );

//             return;
//         }


//         console.log(
//             "Validation passed, submitting:",
//             form
//         );


//         onSubmit(form);

//     };


//     =========================================================
//     RENDER
//     =========================================================

//     return (

//         <div className="crud-form">

//             <div className="crud-form-fields">

//                 {fields.map(field => {

//                     -------------------------------------------------
//                     HIDDEN
//                     -------------------------------------------------

//                     if (field.type === "hidden") {
//                         return null;
//                     }


//                     -------------------------------------------------
//                     FIELD DISABLED STATE
//                     -------------------------------------------------

//                     const disabled =
//                         isEditing &&
//                         field.disabledWhenEditing === true;


//                     return (

//                         <div
//                             key={field.name}
//                             className={
//                                 field.type === "textarea"
//                                     ? "crud-form-field crud-form-field-full"
//                                     : "crud-form-field"
//                             }
//                         >

//                             <label className="crud-form-label">

//                                 {field.label}

//                                 {field.required && (

//                                     <span className="crud-required">
//                                         *
//                                     </span>

//                                 )}

//                             </label>


//                             {/* ================================================= */}
//                             {/* CHECKBOX */}
//                             {/* ================================================= */}

//                             {field.readAble ? (

//                                 <div className="crud-readonly-value">
//                                     {form[field.name] || "Not available"}
//                                 </div>

//                             ) : field.type === "checkbox" ? (

//                                 <label className="crud-checkbox">

//                                     <input

//                                         type="checkbox"

//                                         checked={
//                                             form[field.name] || false
//                                         }

//                                         disabled={disabled}

//                                         onChange={(e) =>
//                                             handleChange(
//                                                 field.name,
//                                                 e.target.checked
//                                             )
//                                         }

//                                     />

//                                     <span>
//                                         {field.label}
//                                     </span>

//                                 </label>


//                             ) : field.type === "select" ? (

//                                 /* ================================================= */
//                                 /* NORMAL SELECT */
//                                 /* ================================================= */

//                                 <select

//                                     className="crud-form-input"

//                                     value={
//                                         form[field.name] || ""
//                                     }

//                                     disabled={disabled}

//                                     onChange={(e) =>
//                                         handleChange(
//                                             field.name,
//                                             e.target.value
//                                         )
//                                     }

//                                 >

//                                     <option value="">
//                                         Select {field.label}
//                                     </option>


//                                     {field.options?.map(opt => (

//                                         <option
//                                             key={opt.value}
//                                             value={opt.value}
//                                         >
//                                             {opt.label}
//                                         </option>

//                                     ))}

//                                 </select>


//                             ) : field.type === "relation" ? (

//                                 /* ================================================= */
//                                 /* RELATION */
//                                 /* ================================================= */


//                                 <RelationSelect
//                                     field={field}
//                                     value={form[field.name]}
//                                     form={form}
//                                     disabled={disabled}
//                                     onChange={(value) =>
//                                         handleChange(
//                                             field.name,
//                                             value
//                                         )
//                                     }
//                                 />




//                             ) : field.type === "textarea" ? (

//                                 /* ================================================= */
//                                 /* TEXTAREA */
//                                 /* ================================================= */

//                                 <textarea

//                                     className="crud-form-input crud-form-textarea"

//                                     placeholder={
//                                         field.label
//                                     }

//                                     value={
//                                         form[field.name] || ""
//                                     }

//                                     disabled={disabled}

//                                     onChange={(e) =>
//                                         handleChange(
//                                             field.name,
//                                             e.target.value
//                                         )
//                                     }

//                                 />


//                             ) : (

//                                 /* ================================================= */
//                                 /* NORMAL INPUT */
//                                 /* ================================================= */

//                                 <input

//                                     className="crud-form-input"

//                                     type={
//                                         field.type || "text"
//                                     }

//                                     placeholder={
//                                         field.label
//                                     }

//                                     value={
//                                         form[field.name] || ""
//                                     }

//                                     disabled={disabled}

//                                     onChange={(e) =>
//                                         handleChange(
//                                             field.name,
//                                             e.target.value
//                                         )
//                                     }

//                                 />

//                             )}

//                         </div>

//                     );

//                 })}

//             </div>


//             {/* ========================================================= */}
//             {/* ACTIONS */}
//             {/* ========================================================= */}

//             <div className="crud-form-actions">

//                 <button

//                     type="button"

//                     className="crud-button crud-button-primary"

//                     onClick={handleSubmit}

//                 >

//                     {submitLabel || "Submit"}

//                 </button>

//             </div>

//         </div>

//     );

// }


// export default CrudForm;
import { useState, useEffect } from "react";
import RelationSelect from "./generic/RelationSelect";

function CrudForm({
    fields,
    initialData,
    onSubmit,
    submitLabel
}) {
    const [form, setForm] = useState({});

    const isEditing = !!initialData?.id;

    useEffect(() => {
        const initialFormState = {
            id: initialData?.id ?? null
        };

        fields.forEach(field => {

            if (field.name === "id") {
                return;
            }

            if (
                initialData?.[field.name] !== undefined &&
                initialData?.[field.name] !== null
            ) {
                initialFormState[field.name] =
                    initialData[field.name];
            } else {

                if (field.type === "checkbox") {

                    initialFormState[field.name] =
                        field.defaultValue ?? false;

                } else if (field.type === "hidden") {

                    initialFormState[field.name] =
                        null;

                } else {

                    initialFormState[field.name] =
                        field.defaultValue ?? "";
                }
            }
        });

        console.log(
            "CrudForm - Initializing with:",
            initialFormState
        );

        setForm(initialFormState);

    }, [initialData, fields]);


    // =============================================================
    // HANDLE FIELD CHANGE
    // =============================================================

    const handleChange = async (name, value) => {

        const field = fields.find(
            field => field.name === name
        );

        let normalizedValue = value;


        // ---------------------------------------------------------
        // NUMBER
        // ---------------------------------------------------------

        if (field?.type === "number") {

            normalizedValue =
                value === ""
                    ? ""
                    : Number(value);
        }


        // ---------------------------------------------------------
        // DATETIME LOCAL
        // ---------------------------------------------------------

        if (field?.type === "datetime-local") {

            if (value === "") {

                normalizedValue = "";

            } else {

                const yearMatch =
                    value.match(/^(\d{4})-/);

                if (!yearMatch) {

                    console.warn(
                        `Invalid ${ name }: `,
                        value
                    );

                    return;
                }

                const year =
                    Number(yearMatch[1]);

                if (year < 1 || year > 9999) {

                    alert(
                        `${ field.label } must contain a valid year between 0001 and 9999.`
                    );

                    return;
                }

                normalizedValue = value;
            }
        }


        // ---------------------------------------------------------
        // CHECKBOX
        // ---------------------------------------------------------

        if (field?.type === "checkbox") {

            normalizedValue =
                value === true;
        }


        // ---------------------------------------------------------
        // UPDATE FORM
        // ---------------------------------------------------------

        const nextForm = {
            ...form,
            [name]: normalizedValue
        };

        setForm(nextForm);


        // ---------------------------------------------------------
        // FIELD-SPECIFIC CHANGE HANDLER
        // ---------------------------------------------------------

        if (typeof field?.onChange === "function") {

            try {

                await field.onChange(
                    normalizedValue,
                    nextForm,
                    setForm
                );

            } catch (error) {

                console.error(
                    `Error handling ${ field.label } change: `,
                    error
                );
            }
        }
    };


    // =============================================================
    // SUBMIT
    // =============================================================

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
                `Please fill in: ${ missingFields.join(", ") } `
            );

            return;
        }

        console.log(
            "Validation passed, submitting:",
            form
        );

        onSubmit(form);
    };


    // =============================================================
    // RENDER
    // =============================================================

    return (
        <div className="crud-form">

            <div className="crud-form-fields">

                {fields.map(field => {

                    if (field.type === "hidden") {
                        return null;
                    }


                    const disabled =
                        field.disabled === true ||
                        (
                            isEditing &&
                            field.disabledWhenEditing === true
                        );


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


                            {field.readAble ? (

                                <div className="crud-readonly-value">
                                    {form[field.name] ||
                                        "Not available"}
                                </div>

                            ) : field.type === "checkbox" ? (

                                <label className="crud-checkbox">

                                    <input
                                        type="checkbox"
                                        checked={
                                            form[field.name] ||
                                            false
                                        }
                                        disabled={disabled}
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
                                    disabled={disabled}
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
                                    form={form}
                                    disabled={disabled}
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
                                    disabled={disabled}
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
                                    type={
                                        field.type || "text"
                                    }
                                    placeholder={field.label}
                                    value={
                                        form[field.name] || ""
                                    }
                                    disabled={disabled}
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