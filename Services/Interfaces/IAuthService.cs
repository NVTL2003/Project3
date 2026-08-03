using Project3.DTOs.Auth;

namespace Project3.Services.Interfaces;

public interface IAuthService
{
    Task<LoginResponseDto?> LoginAsync(
        LoginRequestDto request);
}