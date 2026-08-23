function CrudList({
    data,
    columns,
    onEdit,
    onDelete,
    extraActions,
    layout = "vertical"
}) {

    console.log("CrudList - Data received:", data);
    console.log("CrudList - Data length:", data?.length);
    console.log("CrudList - Columns:", columns);

    if (
        !data ||
        !Array.isArray(data) ||
        data.length === 0
    ) {
        return (
            <div className="crud-list-empty">
                No items to display.
            </div>
        );
    }

    const getItemId = (item) => {

        if (item.id) return item.id;
        if (item.Id) return item.Id;
        if (item.facilityId) return item.facilityId;
        if (item.FacilityId) return item.FacilityId;

        const idFields =
            Object.keys(item).filter(
                key =>
                    key.toLowerCase().includes("id")
            );

        if (idFields.length > 0) {
            return item[idFields[0]];
        }

        return null;
    };

    return (

        <div className="crud-list">

            {data.map((item, index) => {

                const itemId =
                    getItemId(item);

                const key =
                    itemId || index;

                return (

                    <div
                        key={key}
                        className="crud-list-item"
                    >

                        {/* DATA */}

                        <div
                            className={
                                layout === "horizontal"
                                    ? "crud-list-data horizontal"
                                    : "crud-list-data"
                            }
                        >

                            {columns.map(col => (

                                <div
                                    key={col.key}
                                    className="crud-list-field"
                                >

                                    {col.render ? (

                                        col.render(item)

                                    ) : (

                                        <>

                                            <div className="crud-list-label">
                                                {col.label || col.key}
                                            </div>

                                            <div className="crud-list-value">
                                                {
                                                    item[col.key] !== undefined
                                                        ? item[col.key]
                                                        : "N/A"
                                                }
                                            </div>

                                        </>

                                    )}

                                </div>

                            ))}

                        </div>


                        {/* ACTIONS */}

                        {(onEdit || onDelete || extraActions) && (

                            <div className="crud-list-actions">

                                {extraActions && extraActions(item)}

                                {onEdit && (

                                    <button
                                        className="crud-action-button crud-action-edit"
                                        onClick={() =>
                                            onEdit(item)
                                        }
                                    >
                                        Edit
                                    </button>

                                )}


                                {onDelete && (

                                    <button
                                        className="crud-action-button crud-action-delete"
                                        onClick={() => {

                                            if (itemId) {

                                                onDelete(itemId);

                                            } else {

                                                alert(
                                                    "Cannot delete: Invalid ID"
                                                );

                                            }

                                        }}
                                    >
                                        Delete
                                    </button>

                                )}

                            </div>

                        )}

                    </div>

                );

            })}

        </div>
    );
}

export default CrudList;