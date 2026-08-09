public class RequestCounterMiddleware
{
    private readonly RequestDelegate _next;
    private static int _requestCount = 0;
    private readonly ILogger<RequestCounterMiddleware> _logger;

    public RequestCounterMiddleware(RequestDelegate next, ILogger<RequestCounterMiddleware> logger)
    {
        _next = next;
        _logger = logger;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        Interlocked.Increment(ref _requestCount);
        _logger.LogInformation($"Request #{_requestCount} to {context.Request.Path}");

        await _next(context);
    }
}