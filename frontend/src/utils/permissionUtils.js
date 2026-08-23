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


/*
 * Check exact permission
 *
 * Example:
 *
 * hasPermission(
 *     permissions,
 *     "customer_addresses",
 *     "read",
 *     "own"
 * )
 *
 * => customer_addresses.read.own
 */
export function hasPermission(
    permissions,
    resource,
    action,
    scope
) {
    if (!Array.isArray(permissions)) {
        return false;
    }

    const required =
        `${resource}.${action}.${scope}`.toLowerCase();

    return permissions.some(permission =>
        typeof permission === "string" &&
        permission.toLowerCase() === required
    );
}


/*
 * Check whether the user has ANY permission
 * for a resource.
 *
 * Example:
 *
 * hasResourcePermission(
 *     permissions,
 *     "facilities"
 * )
 *
 * true if user has:
 *
 * facilities.read.all
 * facilities.create.all
 * facilities.update.all
 * etc.
 */
export function hasResourcePermission(
    permissions,
    resource
) {
    if (!Array.isArray(permissions)) {
        return false;
    }

    const prefix =
        `${resource}.`.toLowerCase();

    return permissions.some(permission =>
        typeof permission === "string" &&
        permission.toLowerCase().startsWith(prefix)
    );
}


export function hasRole(role) {

    const roles = getRoles();

    if (!role) {
        return false;
    }

    return roles.some(
        r =>
            typeof r === "string" &&
            r.toLowerCase() ===
            role.toLowerCase()
    );
}