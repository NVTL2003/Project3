import React from "react";

const AccessDenied = ({ entityName }) => {

    return (
        <div
            style={{
                padding: "40px",
                textAlign: "center"
            }}
        >

            <h2>
                Access Denied
            </h2>

            <p>
                You do not have permission to view{" "}
                {entityName}.
            </p>

        </div>
    );
};

export default AccessDenied;