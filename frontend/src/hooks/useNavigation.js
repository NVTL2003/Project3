import { useMemo } from "react";
import {
    getPermissions,
    hasPermission
} from "../utils/permissionUtils";

import { MENU_GROUPS } from "../config/menuConfig";

export const useNavigation = () => {

    const permissions =
        getPermissions();

    const visibleGroups =
        useMemo(() => {

            return MENU_GROUPS
                .map(group => {

                    const visibleEntities =
                        group.entities
                            .map(entity => {

                                // Scoped entity
                                if (entity.children) {

                                    const visibleChildren =
                                        entity.children.filter(
                                            child =>
                                                hasPermission(
                                                    permissions,
                                                    entity.permission,
                                                    "read",
                                                    child.scope
                                                )
                                        );

                                    if (
                                        visibleChildren.length === 0
                                    ) {
                                        return null;
                                    }

                                    return {
                                        ...entity,
                                        children:
                                            visibleChildren
                                    };
                                }

                                // Normal entity
                                const canRead =
                                    hasPermission(
                                        permissions,
                                        entity.permission,
                                        "read",
                                        "all"
                                    );

                                return canRead
                                    ? entity
                                    : null;
                            })
                            .filter(Boolean);

                    return {
                        ...group,
                        entities:
                            visibleEntities
                    };

                })
                .filter(
                    group =>
                        group.entities.length > 0
                );

        }, [permissions]);

    return {
        visibleGroups
    };
};