namespace Project3.DTOs.Auth;

public class LoginResponseDto
{
    public string Token { get; set; } = null!;

    public Guid UserId { get; set; }

    public string Username { get; set; } = null!;

    public List<string> Roles { get; set; } = new();
}