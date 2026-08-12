using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;

using Project3.Models;
using Project3.DTOs;
using Project3.Authentication;

using Project3.Repositories.Interfaces;
using Project3.Repositories.Implementations;

using Project3.Services.Interfaces;
using Project3.Services.Implementations;

var builder = WebApplication.CreateBuilder(args);


// ============================================================
// JWT AUTHENTICATION
// ============================================================

var jwtKey =
    builder.Configuration["Jwt:Key"]
    ?? throw new InvalidOperationException(
        "JWT Key is missing."
    );

var jwtIssuer =
    builder.Configuration["Jwt:Issuer"];

var jwtAudience =
    builder.Configuration["Jwt:Audience"];


builder.Services
    .AddAuthentication(
        JwtBearerDefaults.AuthenticationScheme
    )
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
                        Encoding.UTF8.GetBytes(jwtKey)
                    )
            };
    });


builder.Services.AddAuthorization();


// ============================================================
// DATABASE
// ============================================================

var connectionString =
    builder.Configuration.GetConnectionString(
        "DefaultConnection"
    );

if (string.IsNullOrWhiteSpace(connectionString))
{
    throw new InvalidOperationException(
        "DefaultConnection is missing."
    );
}


builder.Services.AddDbContext<Pj3Context>(
    options =>
        options.UseMySql(
            connectionString,
            ServerVersion.AutoDetect(
                connectionString
            )
        )
);


// ============================================================
// AUTHENTICATION SERVICES
// ============================================================

builder.Services.AddScoped<
    IJwtService,
    JwtService
>();

builder.Services.AddScoped<
    IAuthService,
    AuthService
>();


// ============================================================
// GENERIC REPOSITORY
// ============================================================
//
// This allows:
//
// ICrudRepository<Facility>
//        ↓
// CrudRepository<Facility>
//
// ICrudRepository<User>
//        ↓
// CrudRepository<User>
//
// etc.
//

builder.Services.AddScoped(
    typeof(ICrudRepository<>),
    typeof(CrudRepository<>)
);


// ============================================================
// GENERIC CRUD SERVICE
// ============================================================
//
// Generic fallback.
//
// This handles entities that don't have their own
// specialized service.
//
// Example:
//
// ICrudService<Department, DepartmentDto, CreateDepartmentDto>
//        ↓
// CrudService<Department, ...>
//

builder.Services.AddScoped(
    typeof(ICrudService<,,>),
    typeof(CrudService<,,>)
);


// ============================================================
// FACILITY SERVICE
// ============================================================
//
// IMPORTANT:
//
// Facility has custom filtering/search logic.
//
// Therefore FacilityController must receive:
//
// ICrudService<Facility, FacilityDto, CreateFacilityDto>
//        ↓
// FacilityService
//
// instead of:
//
// ICrudService<Facility, FacilityDto, CreateFacilityDto>
//        ↓
// CrudService<Facility, ...>
//

builder.Services.AddScoped<
    ICrudService<Facility, FacilityDto, CreateFacilityDto>,
    FacilityService
>();


// ============================================================
// CONTROLLERS
// ============================================================

builder.Services.AddControllers();


// ============================================================
// CORS
// ============================================================

builder.Services.AddCors(options =>
{
    options.AddPolicy(
        "AllowReact",
        policy =>
        {
            policy
                .WithOrigins(
                    "http://localhost:3000"
                )
                .AllowAnyHeader()
                .AllowAnyMethod();
        }
    );
});


// ============================================================
// AUTOMAPPER
// ============================================================

builder.Services.AddAutoMapper(
    AppDomain.CurrentDomain.GetAssemblies()
);


// ============================================================
// BUILD APPLICATION
// ============================================================

var app = builder.Build();


// ============================================================
// MIDDLEWARE
// ============================================================

app.UseMiddleware<RequestCounterMiddleware>();

app.UseHttpsRedirection();

app.UseCors("AllowReact");

app.UseAuthentication();

app.UseAuthorization();

app.MapControllers();

app.Run();