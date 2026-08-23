import React, { useEffect, useState } from "react";

function RelationSelect({
    field,
    value,
    onChange
}) {

    const [options, setOptions] = useState([]);
    const [loading, setLoading] = useState(false);

    useEffect(() => {

        let mounted = true;

        const loadOptions = async () => {

            if (!field.service) {
                console.error(
                    `RelationSelect: No service provided for ${field.label}`
                );
                return;
            }

            try {

                setLoading(true);

                let response;

                // =====================================================
                // FETCH MODE
                // =====================================================

                if (field.fetchMode === "mine") {

                    console.log(
                        `🔗 Loading MY ${field.label}`
                    );

                    response =
                        await field.service.getMine();

                } else {

                    console.log(
                        `🔗 Loading ALL ${field.label}`
                    );

                    response =
                        await field.service.getPaged({
                            page: 1,
                            pageSize: 100,
                            search: "",
                            sortBy: field.sortBy || "",
                            sortOrder: "asc"
                        });
                }

                if (!mounted) {
                    return;
                }

                // =====================================================
                // NORMALIZE RESPONSE
                // =====================================================

                const data =
                    response?.data;

                const items =
                    Array.isArray(data)
                        ? data
                        : data?.items || [];

                console.log(
                    `🔗 ${field.label} options:`,
                    items
                );

                setOptions(items);

            } catch (error) {

                if (!mounted) {
                    return;
                }

                console.error(
                    `Failed to load ${field.label}:`,
                    error
                );

                setOptions([]);

            } finally {

                if (mounted) {
                    setLoading(false);
                }

            }

        };

        loadOptions();

        return () => {
            mounted = false;
        };

    }, [field]);


    return (

        <select
            className="crud-form-input"
            value={value || ""}
            onChange={e =>
                onChange(e.target.value)
            }
            disabled={loading}
        >

            <option value="">
                {loading
                    ? `Loading ${field.label}...`
                    : `Select ${field.label}`
                }
            </option>

            {options.map(option => {

                const id =
                    option[field.valueField || "id"];

                const label =
                    field.getOptionLabel
                        ? field.getOptionLabel(option)
                        : option[field.labelField || "name"];

                return (

                    <option
                        key={id}
                        value={id}
                    >
                        {label}
                    </option>

                );

            })}

        </select>

    );
}

export default RelationSelect;