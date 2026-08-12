//components/CrudList.js
function CrudList({ data, columns, onEdit, onDelete, layout = "vertical" }) {
    console.log('CrudList - Data received:', data);
    console.log('CrudList - Data length:', data?.length);
    console.log('CrudList - Columns:', columns);

    // Check if data exists and is an array
    if (!data || !Array.isArray(data) || data.length === 0) {
        return <div style={{ padding: '20px', textAlign: 'center', color: '#666' }}>
            No items to display. Data: {JSON.stringify(data)}
        </div>;
    }

    // Helper function to get the ID from any item
    const getItemId = (item) => {
        if (item.id) return item.id;
        if (item.Id) return item.Id;
        if (item.facilityId) return item.facilityId;
        if (item.FacilityId) return item.FacilityId;

        const idFields = Object.keys(item).filter(key =>
            key.toLowerCase().includes('id') || key === 'id' || key === 'Id'
        );

        if (idFields.length > 0) {
            return item[idFields[0]];
        }

        return null;
    };

    return (
        <div>
            {data.map((item, index) => {
                const itemId = getItemId(item);
                const key = itemId || index;

                return (
                    <div
                        key={key}
                        style={{
                            borderBottom: "1px solid #ccc",
                            padding: "8px",
                            marginBottom: "8px"
                        }}
                    >
                        <div style={{
                            display: layout === "horizontal" ? "flex" : "block",
                            flexWrap: "wrap",
                            gap: "16px",
                            marginBottom: "8px"
                        }}>
                            {columns.map(col => (
                                <div key={col.key} style={{
                                    marginBottom: layout === "vertical" ? "4px" : "0"
                                }}>
                                    {col.render ? (
                                        col.render(item)
                                    ) : (
                                        <span>
                                            <strong>{col.label || col.key}:</strong> {item[col.key] !== undefined ? item[col.key] : 'N/A'}
                                        </span>
                                    )}
                                </div>
                            ))}
                        </div>

                        <div>
                            <button
                                onClick={() => onEdit(item)}
                                style={{ marginRight: "8px" }}
                            >
                                Edit
                            </button>
                            <button
                                onClick={() => {
                                    if (itemId) {
                                        onDelete(itemId);
                                    } else {
                                        alert("Cannot delete: Invalid ID");
                                    }
                                }}
                            >
                                Delete
                            </button>
                        </div>
                    </div>
                );
            })}
        </div>
    );
}

export default CrudList;