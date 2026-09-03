import React, {
    useEffect,
    useState
} from "react";

function RelationSelect({
    field,
    value,
    form,
    onChange,
    disabled = false
}) {

    const [options, setOptions] = useState([]);
    const [loading, setLoading] = useState(false);


    // =============================================================
    // DEPENDENCY VALUE
    // =============================================================

    const dependencyValue =
        field.dependsOn
            ? form?.[field.dependsOn]
            : null;


    // =============================================================
    // LOAD OPTIONS
    // =============================================================

    useEffect(() => {

        let mounted = true;


        const loadOptions = async () => {

            // -----------------------------------------------------
            // READ ONLY
            // -----------------------------------------------------

            if (field.readOnly) {
                return;
            }


            // -----------------------------------------------------
            // DEPENDENT FIELD
            // -----------------------------------------------------

            if (field.dependsOn) {

                if (!dependencyValue) {

                    setOptions([]);

                    return;
                }

                if (
                    typeof field.dependentFetch !==
                    "function"
                ) {

                    console.error(
                        `RelationSelect: ${ field.label } has dependsOn but no dependentFetch`
                    );

                    setOptions([]);

                    return;
                }
            }


            // -----------------------------------------------------
            // NORMAL SERVICE CHECK
            // -----------------------------------------------------

            if (
                !field.dependsOn &&
                !field.service
            ) {

                console.error(
                    `RelationSelect: No service provided for ${ field.label }`
                );

                return;
            }


            try {

                setLoading(true);

                let response;


                // =================================================
                // DEPENDENT FETCH
                // =================================================

                if (field.dependsOn) {

                    console.log(
                        `🔗 Loading ${ field.label } based on ${ field.dependsOn }: `,
                        dependencyValue
                    );

                    response =
                        await field.dependentFetch(
                            dependencyValue,
                            form
                        );

                }


                // =================================================
                // FETCH MODE = MINE
                // =================================================

                else if (
                    field.fetchMode === "mine"
                ) {

                    if (
                        typeof field.service.getMine !==
                        "function"
                    ) {

                        throw new Error(
                            `${ field.label }: service does not implement getMine()`
                        );
                    }

                    console.log(
                        `🔗 Loading MY ${ field.label } `
                    );

                    response =
                        await field.service.getMine();

                }


                // =================================================
                // NORMAL PAGED FETCH
                // =================================================

                else {

                    if (
                        typeof field.service.getPaged !==
                        "function"
                    ) {

                        throw new Error(
                            `${ field.label }: service does not implement getPaged()`
                        );
                    }

                    console.log(
                        `🔗 Loading ALL ${ field.label } `
                    );

                    response =
                        await field.service.getPaged({
                            page: 1,
                            pageSize: 100,
                            search: "",
                            sortBy:
                                field.sortBy || "",
                            sortOrder: "asc"
                        });
                }


                if (!mounted) {
                    return;
                }


                // =================================================
                // NORMALIZE RESPONSE
                // =================================================

                const data =
                    response?.data;

                const items =
                    Array.isArray(data)
                        ? data
                        : data?.items || [];

                console.log(
                    `🔗 ${ field.label } options: `,
                    items
                );

                setOptions(items);

            } catch (error) {

                if (!mounted) {
                    return;
                }

                console.error(
                    `Failed to load ${ field.label }: `,
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

    }, [
        field,
        dependencyValue
    ]);


    // =============================================================
    // READ ONLY
    // =============================================================

    if (field.readOnly) {

        return (
            <input
                className="crud-form-input"
                value={
                    field.getReadOnlyLabel
                        ? field.getReadOnlyLabel(value)
                        : value || ""
                }
                readOnly
                disabled
            />
        );
    }


    // =============================================================
    // SELECT
    // =============================================================

    return (

        <select
            className="crud-form-input"
            value={value || ""}
            onChange={e =>
                onChange(e.target.value)
            }
            disabled={
                disabled ||
                loading ||
                (
                    field.dependsOn &&
                    !dependencyValue
                )
            }
        >

            <option value="">

                {loading
                    ? `Loading ${ field.label }...`
                    : field.dependsOn &&
                      !dependencyValue
                        ? `Select ${ field.dependsOn } first`
                        : `Select ${ field.label } `
                }

            </option>


            {options.map(option => {

                const id =
                    option[
                        field.valueField || "id"
                    ];

                const label =
                    field.getOptionLabel
                        ? field.getOptionLabel(option)
                        : option[
                            field.labelField ||
                            "name"
                        ];


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