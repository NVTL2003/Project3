// frontend/src/components/CrudForm.js
import { useState, useEffect } from "react";

function CrudForm({ fields, initialData, onSubmit, submitLabel }) {
    const [form, setForm] = useState({});

    useEffect(() => {
        // Initialize form with initialData or empty values
        const initialFormState = {};
        fields.forEach(field => {
            if (initialData?.[field.name] !== undefined && initialData?.[field.name] !== null) {
                initialFormState[field.name] = initialData[field.name];
            } else {
                // For checkboxes, default to false; for others, default to empty string
                if (field.type === "checkbox") {
                    initialFormState[field.name] = false;
                } else if (field.type === "hidden") {
                    initialFormState[field.name] = null;
                } else {
                    initialFormState[field.name] = "";
                }
            }
        });
        console.log("CrudForm - Initializing with:", initialFormState);
        setForm(initialFormState);
    }, [initialData, fields]);

    const handleChange = (name, value) => {
        console.log(`Updating ${name} to:`, value);
        setForm(prevForm => {
            const newForm = { ...prevForm, [name]: value };
            return newForm;
        });
    };

    const handleSubmit = () => {
        console.log("CrudForm - Current form state before validation:", form);

        // Validate required fields (skip hidden fields and checkboxes)
        const missingFields = [];

        for (const field of fields) {
            if (field.required && field.type !== "hidden" && field.type !== "checkbox") {
                const value = form[field.name];
                if (value === undefined || value === null || value === "") {
                    missingFields.push(field.label);
                }
            }
        }

        if (missingFields.length > 0) {
            alert(`Please fill in: ${missingFields.join(', ')}`);
            return;
        }

        console.log("Validation passed, submitting:", form);
        onSubmit(form);
    };

    return (
        <div style={{ border: "1px solid #ddd", padding: "20px", marginBottom: "20px", borderRadius: "8px" }}>
            {fields.map(field => {
                // Skip rendering hidden fields
                if (field.type === "hidden") {
                    return null;
                }

                return (
                    <div key={field.name} style={{ marginBottom: "15px" }}>
                        <label style={{ display: "block", marginBottom: "4px", fontWeight: "500" }}>
                            {field.label}
                            {field.required && <span style={{ color: "red" }}> *</span>}
                        </label>

                        {field.type === "checkbox" ? (
                            <input
                                type="checkbox"
                                checked={form[field.name] || false}
                                onChange={(e) => handleChange(field.name, e.target.checked)}
                                style={{
                                    width: "auto",
                                    marginRight: "8px",
                                    cursor: "pointer",
                                    transform: "scale(1.2)"
                                }}
                            />
                        ) : field.type === "select" ? (
                            <select
                                value={form[field.name] || ""}
                                onChange={(e) => handleChange(field.name, e.target.value)}
                                style={{
                                    width: "100%",
                                    padding: "8px",
                                    borderRadius: "4px",
                                    border: "1px solid #ccc"
                                }}
                            >
                                <option value="">Select {field.label}</option>
                                {field.options?.map(opt => (
                                    <option key={opt.value} value={opt.value}>
                                        {opt.label}
                                    </option>
                                ))}
                            </select>
                        ) : field.type === "textarea" ? (
                            <textarea
                                placeholder={field.label}
                                value={form[field.name] || ""}
                                onChange={(e) => handleChange(field.name, e.target.value)}
                                style={{
                                    width: "100%",
                                    padding: "8px",
                                    boxSizing: "border-box",
                                    borderRadius: "4px",
                                    border: "1px solid #ccc",
                                    minHeight: "80px"
                                }}
                            />
                        ) : (
                            <input
                                type={field.type || "text"}
                                placeholder={field.label}
                                value={form[field.name] || ""}
                                onChange={(e) => handleChange(field.name, e.target.value)}
                                style={{
                                    width: "100%",
                                    padding: "8px",
                                    boxSizing: "border-box",
                                    borderRadius: "4px",
                                    border: "1px solid #ccc"
                                }}
                            />
                        )}
                    </div>
                );
            })}

            <div style={{ display: "flex", gap: "10px", marginTop: "10px" }}>
                <button
                    onClick={handleSubmit}
                    style={{
                        padding: "10px 20px",
                        backgroundColor: "#1565c0",
                        color: "white",
                        border: "none",
                        borderRadius: "4px",
                        cursor: "pointer",
                        fontWeight: "500"
                    }}
                >
                    {submitLabel || "Submit"}
                </button>
            </div>
        </div>
    );
}

export default CrudForm;