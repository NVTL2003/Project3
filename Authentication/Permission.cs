namespace Project3.Authentication;

public static class Permission
{
    public static string Build(
        string resource,
        string action,
        string scope)
    {
        return $"{resource.ToLowerInvariant()}." +
               $"{action.ToLowerInvariant()}." +
               $"{scope.ToLowerInvariant()}";
    }
}