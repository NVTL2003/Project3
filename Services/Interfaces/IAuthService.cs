using Project3.DTOs;

namespace Project3.Services.Interfaces;

//public interface IAuthService
//{
//    Task<LoginResponseDto?> LoginAsync(
//        LoginRequestDto request);
//}
public interface IAuthService
{
    Task<AuthResponseDto?> LoginAsync(LoginDto request);
}