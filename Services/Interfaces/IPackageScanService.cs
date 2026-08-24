using Project3.DTOs;
using Project3.Models;

namespace Project3.Services.Interfaces;

public interface IPackageScanService
    : ICrudService<
        PackageScan,
        PackageScanDto,
        CreatePackageScanDto>
{
    Task<PackageScanResultDto> ScanAsync(
        CreatePackageScanDto dto,
        Guid userId);
}