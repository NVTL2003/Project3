//hook/useCrud.js
import { useEffect, useState } from "react";

export function useCrud({
  service,
  initialForm,
  buildPayload,
  fetchExtraData
}) {
  const [data, setData] = useState([]);
  const [extraData, setExtraData] = useState(null);
  const [form, setForm] = useState(initialForm);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const loadData = async () => {
    setLoading(true);
    try {
      const res = await service.getAll();
      setData(res.data);

      if (fetchExtraData) {
        const extra = await fetchExtraData();
        setExtraData(extra);
      }
    } catch (err) {
      console.error("Load data error:", err);
      setError(err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadData();
  }, []);

  // Generic handleSubmit that works for any entity
  const handleSubmit = async (formData) => {
  console.log("useCrud - handleSubmit called with formData:", formData);
  console.log("formData.id value:", formData.id);
  console.log("formData.id type:", typeof formData.id);
  
  // Check if any required fields are empty
  const requiredFields = Object.keys(initialForm).filter(key => key !== 'id');
  const missingFields = [];
  
  for (const field of requiredFields) {
    const value = formData[field];
    if (!value || value === "" || value === null || value === undefined) {
      missingFields.push(field);
    }
  }
  
  if (missingFields.length > 0) {
    alert(`Please fill in: ${missingFields.join(', ')}`);
    console.log("Missing fields:", missingFields);
    return;
  }
  
  // Build payload
  const payload = buildPayload(formData);
  console.log("Final payload to send:", payload);
  console.log("Is this an update?", formData.id ? "YES - Updating" : "NO - Creating new");
  
  if (!payload) {
    console.log("Payload building failed, submission cancelled");
    return;
  }
  
  setLoading(true);
  try {
    if (formData.id) {
      console.log("UPDATING with ID:", formData.id);
      await service.update(formData.id, payload);
    } else {
      console.log("CREATING new record");
      await service.create(payload);
    }
    
    resetForm();
    await loadData();
  } catch (err) {
    console.error("Submit error:", err);
    // ... error handling
  } finally {
    setLoading(false);
  }
};

  const handleEdit = (item, mapToForm) => {
    setForm(mapToForm(item));
  };

  const handleDelete = async (id) => {
    if (!window.confirm("Are you sure you want to delete this item?")) {
      return;
    }
    
    setLoading(true);
    try {
      await service.delete(id);
      await loadData();
    } catch (err) {
      console.error("Delete error:", err);
      alert(`Error deleting: ${err.message}`);
    } finally {
      setLoading(false);
    }
  };

  const resetForm = () => {
    setForm(initialForm);
  };

  return {
    data,
    extraData,
    form,
    loading,
    error,
    setForm,
    handleSubmit,
    handleEdit,
    handleDelete,
    resetForm,
    reloadData: loadData
  };
}