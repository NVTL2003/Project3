using Project3.Models;

namespace Project3.Authentication;

public interface IJwtService
{
    string GenerateToken(
        User user,
        List<string> roles,
        List<string> permissions);
}