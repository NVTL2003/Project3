namespace Project3.DTOs;

public class QueryParamsDto
{
    public string? Search { get; set; }

    public string? SortBy { get; set; }

    public string? SortOrder { get; set; } = "asc";

    public int Page { get; set; } = 1;

    public int PageSize { get; set; } = 10;

    public Dictionary<string, string>? Filters { get; set; }
}

public class PagedResult<T>
{
    public List<T> Items { get; set; } = new();

    public int TotalCount { get; set; }

    public int Page { get; set; }

    public int PageSize { get; set; }

    public int TotalPages =>
        PageSize <= 0
            ? 0
            : (int)Math.Ceiling(
                (double)TotalCount / PageSize
            );

    public bool HasPrevious =>
        Page > 1;

    public bool HasNext =>
        Page < TotalPages;
}