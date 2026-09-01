// Generic entity configuration factory
export const createEntityConfig = (
    entityName,
    fieldConfig
) => {

    // =========================================================
    // BUILD INITIAL FORM
    // =========================================================

    const buildInitialForm = () => {

        const form = {
            id: null
        };

        fieldConfig.forEach(field => {

            if (field.type === "checkbox") {

                form[field.name] =
                    field.defaultValue !== undefined
                        ? field.defaultValue
                        : false;

            } else if (field.type === "hidden") {

                form[field.name] = null;

            } else {

                form[field.name] =
                    field.defaultValue !== undefined
                        ? field.defaultValue
                        : "";
            }

        });

        return form;
    };


    // =========================================================
    // BUILD FORM FIELDS
    // Preserve the ENTIRE field configuration.
    // =========================================================

    const buildFields = () => {

        return [

            {
                name: "id",
                type: "hidden"
            },

            ...fieldConfig.map(field => ({
                ...field,

                type:
                    field.type || "text",

                required:
                    field.required ?? false,

                options:
                    field.options ?? null
            }))
        ];
    };


    // =========================================================
    // MAP API ITEM TO FORM
    // =========================================================

    const mapToForm = (item) => {

        const form = {
            id: item.id || null
        };

        fieldConfig.forEach(field => {

            const value = item[field.name];

            // =====================================================
            // CHECKBOX
            // =====================================================

            if (field.type === "checkbox") {

                form[field.name] =
                    value !== undefined &&
                        value !== null
                        ? value
                        : false;

                return;
            }

            // =====================================================
            // DATETIME LOCAL
            // =====================================================

            if (field.type === "datetime-local") {

                if (!value) {
                    form[field.name] = "";
                    return;
                }

                // Backend:
                // 2026-09-02T18:00:00
                //
                // HTML:
                // 2026-09-02T18:00

                form[field.name] =
                    String(value).slice(0, 16);

                return;
            }

            // =====================================================
            // DEFAULT
            // =====================================================

            form[field.name] =
                value !== undefined &&
                    value !== null
                    ? value
                    : (
                        field.defaultValue !== undefined
                            ? field.defaultValue
                            : ""
                    );

        });

        return form;
    };


    // =========================================================
    // BUILD API PAYLOAD
    // =========================================================

    const buildPayload = (formData) => {

        const payload = {};

        fieldConfig.forEach(field => {

            if (field.name === "id") {
                return;
            }

            let value =
                formData[field.name];

            // =====================================================
            // EMPTY VALUES
            // =====================================================

            if (
                value === null ||
                value === undefined ||
                value === ""
            ) {

                payload[field.name] =
                    field.nullable !== false
                        ? null
                        : value;

                return;
            }

            // =====================================================
            // NUMBER
            // =====================================================

            if (field.type === "number") {

                const numberValue =
                    Number(value);

                payload[field.name] =
                    Number.isNaN(numberValue)
                        ? null
                        : numberValue;

                return;
            }

            // =====================================================
            // CHECKBOX
            // =====================================================

            if (field.type === "checkbox") {

                payload[field.name] =
                    value === true ||
                    value === "true";

                return;
            }

            // =====================================================
            // DATETIME LOCAL
            // =====================================================

            if (field.type === "datetime-local") {

                const stringValue =
                    String(value);

                const match =
                    stringValue.match(
                        /^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2})$/
                    );

                if (!match) {
                    console.error(
                        `Invalid datetime for ${field.name}:`,
                        value
                    );

                    payload[field.name] = null;
                    return;
                }

                const year =
                    Number(match[1]);

                if (
                    year < 1 ||
                    year > 9999
                ) {

                    console.error(
                        `Invalid year for ${field.name}:`,
                        year
                    );

                    payload[field.name] = null;
                    return;
                }

                payload[field.name] =
                    stringValue;

                return;
            }

            // =====================================================
            // DEFAULT
            // =====================================================

            payload[field.name] = value;
        });

        return payload;
    };

            // =====================================================
            // DEFAULT
            // =====================================================

            payload[field.name] = value;

        });

        return payload;
    };


    // =========================================================
    // BUILD DISPLAY COLUMNS
    // =========================================================

    const buildColumns = (
        displayConfig
    ) => {

        return displayConfig.map(col => ({
            key: col.key,
            label: col.label,
            render: col.render || null
        }));
    };


    return {

        initialForm:
            buildInitialForm(),

        fields:
            buildFields(),

        mapToForm,

        buildPayload,

        buildColumns
    };
};