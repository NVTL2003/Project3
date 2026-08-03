using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.IdentityModel.Tokens;
using Project3.Models;

namespace Project3.Authentication;

public class JwtService : IJwtService
{
    private readonly IConfiguration _configuration;

    public JwtService(IConfiguration configuration)
    {
        _configuration = configuration;
    }

    public string GenerateToken(
        User user,
        IEnumerable<string> roles)
    {
        var jwtSettings = _configuration.GetSection("Jwt");

        var key = jwtSettings["Key"]
            ?? throw new InvalidOperationException(
                "JWT Key is missing.");

        var issuer = jwtSettings["Issuer"];
        var audience = jwtSettings["Audience"];

        var expiresInMinutes =
            int.Parse(jwtSettings["ExpiresInMinutes"] ?? "60");

        var claims = new List<Claim>
        {
            new Claim(
                ClaimTypes.NameIdentifier,
                user.Id.ToString()),

            new Claim(
                ClaimTypes.Name,
                user.Username),

            new Claim(
                ClaimTypes.Email,
                user.Email)
        };

        foreach (var role in roles)
        {
            claims.Add(
                new Claim(ClaimTypes.Role, role));
        }

        var signingKey = new SymmetricSecurityKey(
            Encoding.UTF8.GetBytes(key));

        var credentials = new SigningCredentials(
            signingKey,
            SecurityAlgorithms.HmacSha256);

        var token = new JwtSecurityToken(
            issuer: issuer,
            audience: audience,
            claims: claims,
            expires: DateTime.UtcNow.AddMinutes(
                expiresInMinutes),
            signingCredentials: credentials);

        return new JwtSecurityTokenHandler()
            .WriteToken(token);
    }
}