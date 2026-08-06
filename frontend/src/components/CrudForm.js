//components/CrudForm.js

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
        initialFormState[field.name] = field.type === "hidden" ? null : "";
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
    
    // Validate required fields (skip hidden fields)
    const missingFields = [];
    
    for (const field of fields) {
      if (field.required && field.type !== "hidden") {
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
    <div style={{ border: "1px solid gray", padding: "10px", marginBottom: "10px" }}>
      {fields.map(field => {
        // Skip rendering hidden fields
        if (field.type === "hidden") {
          return null;
        }
        
        return (
          <div key={field.name} style={{ marginBottom: "10px" }}>
            <label style={{ display: "block", marginBottom: "4px", fontWeight: "500" }}>
              {field.label}
              {field.required && <span style={{ color: "red" }}> *</span>}
            </label>
            
            {field.type === "select" ? (
              <select
                value={form[field.name] || ""}
                onChange={(e) => handleChange(field.name, e.target.value)}
                style={{ width: "100%", padding: "8px" }}
              >
                <option value="">Select {field.label}</option>
                {field.options?.map(opt => (
                  <option key={opt.value} value={opt.value}>
                    {opt.label}
                  </option>
                ))}
              </select>
            ) : (
              <input
                type={field.type || "text"}
                placeholder={field.label}
                value={form[field.name] || ""}
                onChange={(e) => handleChange(field.name, e.target.value)}
                style={{ width: "100%", padding: "8px", boxSizing: "border-box" }}
              />
            )}
          </div>
        );
      })}

      <button 
        onClick={handleSubmit}
        style={{ padding: "8px 16px", marginTop: "10px" }}
      >
        {submitLabel}
      </button>
    </div>
  );
}

export default CrudForm;