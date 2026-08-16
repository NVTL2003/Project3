import React, {
    useEffect,
    useRef,
    useState
} from "react";
import "../styles/crud.css";

const TableControls = ({
    onSearch,
    onSort,
    onFilter,

    sortOptions = [],
    filterOptions = [],

    initialSearch = "",
    initialSort = "",
    initialSortOrder = "asc"
}) => {

    const [search, setSearch] =
        useState(initialSearch);

    const [sortBy, setSortBy] =
        useState(initialSort);

    const [sortOrder, setSortOrder] =
        useState(initialSortOrder);

    const [filters, setFilters] =
        useState({});


    const searchTimeoutRef =
        useRef(null);


    // =========================================================
    // SEARCH DEBOUNCE
    // =========================================================

    useEffect(() => {

        if (searchTimeoutRef.current) {

            clearTimeout(
                searchTimeoutRef.current
            );

        }


        searchTimeoutRef.current =
            setTimeout(() => {

                console.log(
                    "🔍 Debounced search:",
                    search
                );

                if (onSearch) {
                    onSearch(search);
                }

            }, 500);


        return () => {

            if (searchTimeoutRef.current) {

                clearTimeout(
                    searchTimeoutRef.current
                );

            }

        };

    }, [search, onSearch]);


    // =========================================================
    // SORT
    // =========================================================

    const handleSortChange = (event) => {

        const value =
            event.target.value;


        console.log(
            "📊 Sort:",
            value
        );


        setSortBy(value);


        if (onSort) {

            onSort(
                value,
                sortOrder
            );

        }

    };


    // =========================================================
    // SORT ORDER
    // =========================================================

    const handleSortOrderToggle = () => {

        const newOrder =
            sortOrder === "asc"
                ? "desc"
                : "asc";


        console.log(
            "📊 Sort order:",
            newOrder
        );


        setSortOrder(newOrder);


        if (onSort) {

            onSort(
                sortBy,
                newOrder
            );

        }

    };


    // =========================================================
    // FILTER
    // =========================================================

    const handleFilterChange =
        (key, value) => {

            console.log(
                "🏷️ Filter:",
                key,
                value
            );


            const newFilters = {
                ...filters
            };


            if (
                value === "" ||
                value === null ||
                value === undefined
            ) {

                delete newFilters[key];

            } else {

                newFilters[key] = value;

            }


            setFilters(newFilters);


            if (onFilter) {

                onFilter(newFilters);

            }

        };


    // =========================================================
    // CLEAR FILTERS
    // =========================================================

    const clearAllFilters = () => {

        setFilters({});


        if (onFilter) {

            onFilter({});

        }

    };


    // =========================================================
    // UI
    // =========================================================

    return (

        <div
            style={{
                marginBottom: "20px",
                padding: "15px",
                background: "#f5f5f5",
                borderRadius: "8px"
            }}
        >

            <div
                style={{
                    display: "flex",
                    gap: "15px",
                    flexWrap: "wrap",
                    alignItems: "center"
                }}
            >

                {/* SEARCH */}

                <div
                    style={{
                        flex: 1,
                        minWidth: "200px"
                    }}
                >

                    <input
                        type="text"

                        placeholder="Search by name, code, city, state..."

                        value={search}

                        onChange={(e) => {

                            setSearch(
                                e.target.value
                            );

                        }}

                        style={{
                            width: "100%",
                            padding: "8px 12px",
                            border: "1px solid #ddd",
                            borderRadius: "4px",
                            fontSize: "14px"
                        }}
                    />

                </div>


                {/* SORT */}

                {sortOptions.length > 0 && (

                    <div
                        style={{
                            display: "flex",
                            gap: "8px",
                            alignItems: "center"
                        }}
                    >

                        <select
                            value={sortBy}

                            onChange={
                                handleSortChange
                            }

                            style={{
                                padding: "8px 12px",
                                border: "1px solid #ddd",
                                borderRadius: "4px",
                                background: "white"
                            }}
                        >

                            <option value="">
                                Sort By
                            </option>


                            {sortOptions.map(
                                option => (

                                    <option
                                        key={option.value}
                                        value={option.value}
                                    >
                                        {option.label}
                                    </option>

                                )
                            )}

                        </select>


                        {sortBy && (

                            <button
                                onClick={
                                    handleSortOrderToggle
                                }

                                style={{
                                    padding: "8px 12px",
                                    border: "1px solid #ddd",
                                    borderRadius: "4px",
                                    background: "white",
                                    cursor: "pointer"
                                }}
                            >

                                {sortOrder === "asc"
                                    ? "↑ Asc"
                                    : "↓ Desc"
                                }

                            </button>

                        )}

                    </div>

                )}


                {/* FILTERS */}

                {filterOptions.map(
                    filter => (

                        <div
                            key={filter.key}
                            style={{
                                minWidth: "150px"
                            }}
                        >

                            <select
                                value={
                                    filters[
                                    filter.key
                                    ] || ""
                                }

                                onChange={(e) =>
                                    handleFilterChange(
                                        filter.key,
                                        e.target.value
                                    )
                                }

                                style={{
                                    width: "100%",
                                    padding: "8px 12px",
                                    border: "1px solid #ddd",
                                    borderRadius: "4px",
                                    background: "white"
                                }}
                            >

                                <option value="">
                                    All {filter.label}
                                </option>


                                {filter.options.map(
                                    option => (

                                        <option
                                            key={option.value}
                                            value={option.value}
                                        >
                                            {option.label}
                                        </option>

                                    )
                                )}

                            </select>

                        </div>

                    )
                )}

            </div>


            {/* ACTIVE FILTERS */}

            {Object.keys(filters).length > 0 && (

                <div
                    style={{
                        marginTop: "10px",
                        display: "flex",
                        gap: "8px",
                        flexWrap: "wrap"
                    }}
                >

                    {Object.entries(filters).map(
                        ([key, value]) => (

                            <span
                                key={key}
                                style={{
                                    background: "#e0e0e0",
                                    padding: "4px 12px",
                                    borderRadius: "12px",
                                    fontSize: "12px"
                                }}
                            >

                                {key}: {value}

                            </span>

                        )
                    )}


                    <button
                        onClick={
                            clearAllFilters
                        }

                        style={{
                            background: "none",
                            border: "none",
                            color: "#1565c0",
                            cursor: "pointer",
                            textDecoration: "underline"
                        }}
                    >

                        Clear All

                    </button>

                </div>

            )}

        </div>

    );

};


export default TableControls;