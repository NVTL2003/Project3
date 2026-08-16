export function getPermissions() {
    try {
        const permissions = JSON.parse(
            localStorage.getItem("permissions") || "[]"
        );

        return Array.isArray(permissions)
            ? permissions
            : [];

    } catch {
        return [];
    }
}

export function getRoles() {
    try {
        const roles = JSON.parse(
            localStorage.getItem("roles") || "[]"
        );

        return Array.isArray(roles)
            ? roles
            : [];

    } catch {
        return [];
    }
}

export function getCurrentUser() {
    try {
        return JSON.parse(
            localStorage.getItem("user") || "null"
        );

    } catch {
        return null;
    }
}

export function hasPermission(permission) {

    const permissions =
        getPermissions();

    return permissions.some(
        p =>
            typeof p === "string" &&
            p.toLowerCase() ===
            permission.toLowerCase()
    );
}

export function hasRole(role) {

    const roles =
        getRoles();

    return roles.some(
        r =>
            typeof r === "string" &&
            r.toLowerCase() ===
            role.toLowerCase()
    );
}