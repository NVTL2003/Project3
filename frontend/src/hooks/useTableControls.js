import React, { useState, useEffect, useRef } from 'react';

const TableControls = ({
    onSearch,
    onSort,
    onFilter,
    sortOptions = [],
    filterOptions = [],
    initialSearch = '',
    initialSort = '',
    initialSortOrder = 'asc'
}) => {
    const [search, setSearch] = useState(initialSearch);
    const [sortBy, setSortBy] = useState(initialSort);
    const [sortOrder, setSortOrder] = useState(initialSortOrder);
    const [filters, setFilters] = useState({});
    const searchTimeoutRef = useRef(null);

    // Immediately call onSearch when search changes (with debounce)
    useEffect(() => {
        // Clear previous timeout
        if (searchTimeoutRef.current) {
            clearTimeout(searchTimeoutRef.current);
        }

        // Set new timeout
        searchTimeoutRef.current = setTimeout(() => {
            console.log('🔍 TableControls - Debounced search with value:', search);
            if (onSearch) {
                onSearch(search);
            }
        }, 500);

        return () => {
            if (searchTimeoutRef.current) {
                clearTimeout(searchTimeoutRef.current);
            }
        };
    }, [search, onSearch]);

    const handleSortChange = (value) => {
        console.log('📊 TableControls - Sort change:', value);
        setSortBy(value);
        if (onSort) {
            onSort(value, sortOrder);
        }
    };

    const handleSortOrderToggle = () => {
        const newOrder = sortOrder === 'asc' ? 'desc' : 'asc';
        console.log('📊 TableControls - Sort order toggle:', newOrder);
        setSortOrder(newOrder);
        if (onSort) {
            onSort(sortBy, newOrder);
        }
    };

    const handleFilterChange = (key, value) => {
        console.log('🏷️ TableControls - Filter change:', key, '=', value);
        const newFilters = { ...filters, [key]: value };
        if (!value) {
            delete newFilters[key];
        }
        setFilters(newFilters);
        if (onFilter) {
            onFilter(newFilters);
        }
    };

    const clearAllFilters = () => {
        setFilters({});
        if (onFilter) {
            onFilter({});
        }
    };

    return (
        <div style={{
            marginBottom: '20px',
            padding: '15px',
            background: '#f5f5f5',
            borderRadius: '8px'
        }}>
            <div style={{ display: 'flex', gap: '15px', flexWrap: 'wrap', alignItems: 'center' }}>
                {/* Search */}
                <div style={{ flex: '1', minWidth: '200px' }}>
                    <input
                        type="text"
                        placeholder="Search by name, code, city, state..."
                        value={search}
                        onChange={(e) => {
                            console.log('✏️ Input change:', e.target.value);
                            setSearch(e.target.value);
                        }}
                        style={{
                            width: '100%',
                            padding: '8px 12px',
                            border: '1px solid #ddd',
                            borderRadius: '4px',
                            fontSize: '14px'
                        }}
                    />
                </div>

                {/* Sort By */}
                {sortOptions.length > 0 && (
                    <div style={{ display: 'flex', gap: '8px', alignItems: 'center' }}>
                        <select
                            value={sortBy}
                            onChange={(e) => handleSortChange(e.target.value)}
                            style={{
                                padding: '8px 12px',
                                border: '1px solid #ddd',
                                borderRadius: '4px',
                                fontSize: '14px',
                                background: 'white'
                            }}
                        >
                            <option value="">Sort By</option>
                            {sortOptions.map(option => (
                                <option key={option.value} value={option.value}>
                                    {option.label}
                                </option>
                            ))}
                        </select>

                        {sortBy && (
                            <button
                                onClick={handleSortOrderToggle}
                                style={{
                                    padding: '8px 12px',
                                    border: '1px solid #ddd',
                                    borderRadius: '4px',
                                    background: 'white',
                                    cursor: 'pointer',
                                    fontSize: '14px'
                                }}
                            >
                                {sortOrder === 'asc' ? '↑ Asc' : '↓ Desc'}
                            </button>
                        )}
                    </div>
                )}

                {/* Filters */}
                {filterOptions.map(filter => (
                    <div key={filter.key} style={{ minWidth: '150px' }}>
                        <select
                            value={filters[filter.key] || ''}
                            onChange={(e) => handleFilterChange(filter.key, e.target.value)}
                            style={{
                                width: '100%',
                                padding: '8px 12px',
                                border: '1px solid #ddd',
                                borderRadius: '4px',
                                fontSize: '14px',
                                background: 'white'
                            }}
                        >
                            <option value="">All {filter.label}</option>
                            {filter.options.map(option => (
                                <option key={option.value} value={option.value}>
                                    {option.label}
                                </option>
                            ))}
                        </select>
                    </div>
                ))}
            </div>

            {/* Active filters display */}
            {Object.keys(filters).filter(k => filters[k]).length > 0 && (
                <div style={{ marginTop: '10px', display: 'flex', gap: '8px', flexWrap: 'wrap' }}>
                    {Object.entries(filters).filter(([_, value]) => value).map(([key, value]) => (
                        <span
                            key={key}
                            style={{
                                background: '#e0e0e0',
                                padding: '4px 12px',
                                borderRadius: '12px',
                                fontSize: '12px',
                                display: 'flex',
                                alignItems: 'center',
                                gap: '6px'
                            }}
                        >
                            {key}: {value}
                            <button
                                onClick={() => handleFilterChange(key, '')}
                                style={{
                                    background: 'none',
                                    border: 'none',
                                    cursor: 'pointer',
                                    fontSize: '14px',
                                    padding: '0 4px'
                                }}
                            >
                                ×
                            </button>
                        </span>
                    ))}
                    <button
                        onClick={clearAllFilters}
                        style={{
                            background: 'none',
                            border: 'none',
                            color: '#1565c0',
                            cursor: 'pointer',
                            fontSize: '12px',
                            textDecoration: 'underline'
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