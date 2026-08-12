import { useCallback, useEffect, useRef, useState } from "react";

const useTableControls = ({
    fetchData,

    initialPage = 1,
    initialPageSize = 10,

    initialSearch = "",
    initialSort = "",
    initialSortOrder = "asc",

    initialFilters = {}
}) => {

    // =========================================================
    // STATE
    // =========================================================

    const [data, setData] = useState([]);

    const [loading, setLoading] = useState(false);

    const [page, setPage] = useState(initialPage);

    const [pageSize, setPageSize] = useState(initialPageSize);

    const [totalCount, setTotalCount] = useState(0);

    const [totalPages, setTotalPages] = useState(0);

    const [search, setSearch] = useState(initialSearch);

    const [sortBy, setSortBy] = useState(initialSort);

    const [sortOrder, setSortOrder] = useState(initialSortOrder);

    const [filters, setFilters] = useState(initialFilters);


    // =========================================================
    // REQUEST CONTROL
    // =========================================================

    const requestIdRef = useRef(0);

    const abortControllerRef = useRef(null);


    // =========================================================
    // LOAD DATA
    // =========================================================

    const loadData = useCallback(async () => {

        const requestId = ++requestIdRef.current;

        console.log("========================================");
        console.log("📡 TABLE REQUEST");
        console.log("Request ID:", requestId);

        const params = {
            search: search || undefined,

            sortBy: sortBy || undefined,

            sortOrder: sortOrder || "asc",

            page,

            pageSize,

            filters:
                filters &&
                    Object.keys(filters).length > 0
                    ? filters
                    : undefined
        };

        console.log("Params:", params);
        console.log("========================================");


        // Cancel previous request
        if (abortControllerRef.current) {
            abortControllerRef.current.abort();
        }

        const controller = new AbortController();

        abortControllerRef.current = controller;


        setLoading(true);


        try {

            const response = await fetchData(
                params,
                {
                    signal: controller.signal
                }
            );


            // Ignore stale request
            if (requestId !== requestIdRef.current) {
                console.log(
                    "⚠️ Ignoring stale request:",
                    requestId
                );

                return;
            }


            console.log(
                "📦 TABLE RESPONSE:",
                response
            );


            // =====================================================
            // IMPORTANT
            // =====================================================

            // Your backend should return something like:
            //
            // {
            //     items: [...],
            //     totalCount: 7,
            //     totalPages: 1
            // }


            const items = Array.isArray(response?.items)
                ? response.items
                : [];


            const count =
                Number(response?.totalCount) || 0;


            const pages =
                Number(response?.totalPages) ||
                (
                    count > 0
                        ? Math.ceil(count / pageSize)
                        : 0
                );


            setData(items);

            setTotalCount(count);

            setTotalPages(pages);


        } catch (error) {

            if (
                error?.name === "AbortError" ||
                error?.code === "ERR_CANCELED"
            ) {

                console.log(
                    "🛑 Request cancelled:",
                    requestId
                );

                return;
            }


            console.error(
                "❌ TABLE REQUEST ERROR:",
                error
            );


            // VERY IMPORTANT:
            // Never leave data undefined.

            setData([]);

            setTotalCount(0);

            setTotalPages(0);


        } finally {

            if (requestId === requestIdRef.current) {
                setLoading(false);
            }

        }

    }, [
        fetchData,
        search,
        sortBy,
        sortOrder,
        page,
        pageSize,
        filters
    ]);


    // =========================================================
    // INITIAL / STATE CHANGE LOAD
    // =========================================================

    useEffect(() => {

        loadData();

    }, [loadData]);


    // =========================================================
    // SEARCH
    // =========================================================

    const handleSearch = useCallback((value) => {

        console.log(
            "🔍 Search:",
            value
        );

        setSearch(value || "");

        // Search should always start from page 1
        setPage(1);

    }, []);


    // =========================================================
    // SORT
    // =========================================================

    const handleSort = useCallback(
        (field, order = "asc") => {

            console.log(
                "📊 Sort:",
                field,
                order
            );

            setSortBy(field || "");

            setSortOrder(order || "asc");

            setPage(1);

        },
        []
    );


    // =========================================================
    // FILTER
    // =========================================================

    const handleFilter = useCallback((newFilters) => {

        console.log(
            "🏷️ Filters:",
            newFilters
        );


        // Remove empty filters
        const cleanedFilters = Object.fromEntries(
            Object.entries(newFilters || {})
                .filter(
                    ([, value]) =>
                        value !== "" &&
                        value !== null &&
                        value !== undefined
                )
        );


        setFilters(cleanedFilters);

        // Filter should start from page 1
        setPage(1);

    }, []);


    // =========================================================
    // PAGE
    // =========================================================

    const handlePageChange = useCallback(
        (newPage) => {

            console.log(
                "📄 Page:",
                newPage
            );

            setPage(newPage);

        },
        []
    );


    // =========================================================
    // PAGE SIZE
    // =========================================================

    const handlePageSizeChange = useCallback(
        (newPageSize) => {

            console.log(
                "📏 Page size:",
                newPageSize
            );

            setPageSize(newPageSize);

            setPage(1);

        },
        []
    );


    // =========================================================
    // RELOAD
    // =========================================================

    const reloadData = useCallback(() => {

        console.log(
            "🔄 Manual table reload"
        );

        return loadData();

    }, [loadData]);


    // =========================================================
    // CLEANUP
    // =========================================================

    useEffect(() => {

        return () => {

            if (abortControllerRef.current) {
                abortControllerRef.current.abort();
            }

        };

    }, []);


    // =========================================================
    // RETURN
    // =========================================================

    return {

        data,

        loading,

        page,
        pageSize,

        totalCount,
        totalPages,

        search,

        sortBy,
        sortOrder,

        filters,

        handleSearch,
        handleSort,
        handleFilter,

        handlePageChange,
        handlePageSizeChange,

        reloadData
    };
};


export default useTableControls;