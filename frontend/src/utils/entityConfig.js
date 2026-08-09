// Generic entity configuration factory
export const createEntityConfig = (entityName, fieldConfig) => {
    // Build initial form state from field config
    const buildInitialForm = () => {
        const form = { id: null };
        fieldConfig.forEach(field => {
            if (field.type === 'checkbox') {
                form[field.name] = field.defaultValue !== undefined ? field.defaultValue : false;
            } else if (field.type === 'hidden') {
                form[field.name] = null;
            } else {
                form[field.name] = field.defaultValue !== undefined ? field.defaultValue : '';
            }
        });
        return form;
    };

    // Build form fields for CrudForm
    const buildFields = () => {
        return [
            { name: "id", type: "hidden" },
            ...fieldConfig.map(field => ({
                name: field.name,
                label: field.label,
                type: field.type || 'text',
                required: field.required || false,
                options: field.options || null,
            }))
        ];
    };

    // Map API response item to form
    const mapToForm = (item) => {
        const form = { id: item.id || null };
        fieldConfig.forEach(field => {
            if (field.type === 'checkbox') {
                form[field.name] = item[field.name] !== undefined ? item[field.name] : false;
            } else {
                form[field.name] = item[field.name] || field.defaultValue || '';
            }
        });
        return form;
    };

    // Build payload for API
    const buildPayload = (formData) => {
        const payload = {};
        fieldConfig.forEach(field => {
            if (field.name === 'id') return; // Skip id field

            const value = formData[field.name];

            // Handle null/empty values
            if (value === null || value === undefined || value === '') {
                payload[field.name] = field.nullable !== false ? null : value;
            } else {
                payload[field.name] = value;
            }

            // Special handling for checkbox
            if (field.type === 'checkbox') {
                payload[field.name] = value === true || value === 'true';
            }
        });
        return payload;
    };

    // Build columns for CrudList
    const buildColumns = (displayConfig) => {
        return displayConfig.map(col => ({
            key: col.key,
            label: col.label,
            render: col.render || null,
        }));
    };

    return {
        initialForm: buildInitialForm(),
        fields: buildFields(),
        mapToForm,
        buildPayload,
        buildColumns,
    };
};