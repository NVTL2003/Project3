using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using Project3.Models;
using Project3.Authentication;
using Project3.Repositories.Interfaces;
using Project3.Repositories.Implementations;
using Project3.Services.Interfaces;
using Project3.Services.Implementations;

var builder = WebApplication.CreateBuilder(args);

// ============================================
// JWT
// ============================================

var jwtKey = builder.Configuration["Jwt:Key"]
    ?? throw new InvalidOperationException(
        "JWT Key is missing.");

var jwtIssuer = builder.Configuration["Jwt:Issuer"];
var jwtAudience = builder.Configuration["Jwt:Audience"];

builder.Services
    .AddAuthentication(
        JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters =
            new TokenValidationParameters
            {
                ValidateIssuer = true,
                ValidateAudience = true,
                ValidateLifetime = true,
                ValidateIssuerSigningKey = true,

                ValidIssuer = jwtIssuer,
                ValidAudience = jwtAudience,

                IssuerSigningKey =
                    new SymmetricSecurityKey(
                        Encoding.UTF8.GetBytes(jwtKey))
            };
    });

builder.Services.AddAuthorization();

// ============================================
// Database
// ============================================

builder.Services.AddDbContext<Pj3Context>(options =>
    options.UseMySql(
        builder.Configuration.GetConnectionString(
            "DefaultConnection"),

        ServerVersion.AutoDetect(
            builder.Configuration.GetConnectionString(
                "DefaultConnection"))
    ));

// ============================================
// Authentication services
// ============================================

builder.Services.AddScoped<IJwtService, JwtService>();

builder.Services.AddScoped<
    IAuthService,
    AuthService>();

// ============================================
// Repository
// ============================================

builder.Services.AddScoped(
    typeof(ICrudRepository<>),
    typeof(CrudRepository<>));

// ============================================
// Generic CRUD service
// ============================================

builder.Services.AddScoped(
    typeof(ICrudService<,,>),
    typeof(CrudService<,,>));

// ============================================
// Controllers
// ============================================

builder.Services.AddControllers();

// ============================================
// CORS
// ============================================

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowReact", policy =>
    {
        policy
            .WithOrigins("http://localhost:3000")
            .AllowAnyHeader()
            .AllowAnyMethod();
    });
});

// ============================================
// AutoMapper
// ============================================

builder.Services.AddAutoMapper(
    AppDomain.CurrentDomain.GetAssemblies());

// ============================================
// Build
// ============================================

var app = builder.Build();

// ============================================
// Middleware
// ============================================

app.UseMiddleware<RequestCounterMiddleware>();
app.UseHttpsRedirection();

app.UseCors("AllowReact");

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();