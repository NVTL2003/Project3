using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Project3.Authentication;
using Project3.DTOs;
using Project3.Models;
using Project3.Services.Interfaces;

namespace Project3.Controllers;

[ApiController]
[Authorize]
[Route("api/[controller]")]
public class PackageScansController
    : BaseCrudController<
        PackageScan,
        PackageScanDto,
        CreatePackageScanDto>
{
    private readonly IPackageScanService _packageScanService;

    public PackageScansController(
        IPackageScanService packageScanService,
        IAuthorizationService authorizationService,
        ICurrentUserService currentUser)
        : base(
            packageScanService,
            authorizationService,
            currentUser)
    {
        _packageScanService =
            packageScanService;
    }

    protected override string ResourceName =>
        "package_scans";

    // ============================================================
    // SCAN
    // ============================================================

    [HttpPost("scan")]
    public async Task<IActionResult> ScanShipment(
        [FromBody] CreatePackageScanDto dto)
    {
        if (!await HasPermission(
            PermissionActions.Create,
            PermissionScopes.All))
        {
            return Forbid();
        }

        if (!ModelState.IsValid)
            return BadRequest(ModelState);

        if (!TryGetCurrentUserId(out var userId))
            return Unauthorized();

        var result =
            await _packageScanService
                .ScanAsync(dto, userId);

        return Ok(result);
    }
}