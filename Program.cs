using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.Text;

using Project3.DTOs;
using Project3.Models;
using Project3.Authentication;
using Project3.Repositories.Interfaces;
using Project3.Repositories.Implementations;
using Project3.Services.Interfaces;
using Project3.Services.Implementations;

var builder = WebApplication.CreateBuilder(args);

// ============================================================
// JWT CONFIGURATION
// ============================================================

var jwtKey = builder.Configuration["Jwt:Key"]
    ?? throw new InvalidOperationException(
        "JWT Key is missing.");

var jwtIssuer = builder.Configuration["Jwt:Issuer"];
var jwtAudience = builder.Configuration["Jwt:Audience"];

builder.Services.AddScoped<
    IAuthorizationHandler,
    PermissionAuthorizationHandler>();

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
                        Encoding.UTF8.GetBytes(jwtKey)),

                // Make sure ASP.NET Core uses ClaimTypes.Role
                // when checking [Authorize(Roles = "...")]
                RoleClaimType = System.Security.Claims.ClaimTypes.Role,

                NameClaimType = System.Security.Claims.ClaimTypes.Name
            };
    });

builder.Services.AddAuthorization();

// ============================================================
// DATABASE
// ============================================================

var connectionString =
    builder.Configuration.GetConnectionString(
        "DefaultConnection");

builder.Services.AddDbContext<Pj3Context>(options =>
    options.UseMySql(
        connectionString,
        ServerVersion.AutoDetect(connectionString)
    )
);

// ============================================================
// AUTHENTICATION SERVICES
// ============================================================

builder.Services.AddScoped<IJwtService, JwtService>();

builder.Services.AddScoped<
    IAuthService,
    AuthService>();

// ============================================================
// REPOSITORY
// ============================================================

builder.Services.AddScoped(
    typeof(ICrudRepository<>),
    typeof(CrudRepository<>));

// ============================================================
// CRUD SERVICES
// ============================================================

builder.Services.AddScoped(
    typeof(ICrudService<,,>),
    typeof(CrudService<,,>));

// ============================================================
// CURRENT USER SERVICE
// ============================================================

builder.Services.AddHttpContextAccessor();

builder.Services.AddScoped<
    ICurrentUserService,
    CurrentUserService>();

// ============================================================
// OTHER SERVICES
// ============================================================

builder.Services.AddScoped<ICrudRepository<DeliveryAssignment>, CrudRepository<DeliveryAssignment>>();

builder.Services.AddScoped<
    ICrudService<
        DeliveryAssignment,
        DeliveryAssignmentDto,
        CreateDeliveryAssignmentDto>,
    DeliveryAssignmentService>();

builder.Services.AddScoped<DeliveryAssignmentService>();

// Delivery Attempt
builder.Services.AddScoped<
    ICrudRepository<DeliveryAttempt>,
    CrudRepository<DeliveryAttempt>>();

builder.Services.AddScoped<
    ICrudService<
        DeliveryAttempt,
        DeliveryAttemptDto,
        CreateDeliveryAttemptDto>,
    DeliveryAttemptService>();

builder.Services.AddScoped<DeliveryAttemptService>();

// Proof of Delivery
builder.Services.AddScoped<ICrudRepository<ProofOfDelivery>, CrudRepository<ProofOfDelivery>>();
builder.Services.AddScoped<ICrudService<ProofOfDelivery, ProofOfDeliveryDto, CreateProofOfDeliveryDto>, ProofOfDeliveryService>();

builder.Services.AddScoped<
    ICrudService<Facility, FacilityDto, CreateFacilityDto>,
    FacilityService>();

builder.Services.AddScoped<
    ICrudService<Shipment, ShipmentDto, CreateShipmentDto>,
    ShipmentService>();

builder.Services.AddScoped<
    IShipmentRequestService,
    ShipmentRequestService>();

builder.Services.AddScoped<
    ICrudService<CustomerAddress, CustomerAddressDto, CreateCustomerAddressDto>,
    CustomerAddressService>();

builder.Services.AddScoped<
    IPackageScanService,
    PackageScanService>();

builder.Services.AddScoped<
    IVehicleService,
    VehicleService>();

builder.Services.AddScoped<
    ITransportOrderService,
    TransportOrderService>();

builder.Services.AddScoped<IRouteService, RouteService>();
builder.Services.AddScoped<IRouteStopService, RouteStopService>();

builder.Services.AddScoped<
    ICrudService<
        ShipmentManifest,
        ShipmentManifestDto,
        CreateShipmentManifestDto>,
    ShipmentManifestService>();

builder.Services.AddScoped<
    ICrudService<
        ManifestItem,
        ManifestItemDto,
        CreateManifestItemDto>,
    ManifestItemService>();
// ============================================================
// CONTROLLERS
// ============================================================

builder.Services.AddControllers();

// ============================================================
// CORS
// ============================================================

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

// ============================================================
// AUTOMAPPER
// ============================================================

builder.Services.AddAutoMapper(
    AppDomain.CurrentDomain.GetAssemblies());

// ============================================================
// BUILD
// ============================================================

var app = builder.Build();

// ============================================================
// MIDDLEWARE
// ============================================================

app.UseMiddleware<RequestCounterMiddleware>();

app.UseHttpsRedirection();

app.UseCors("AllowReact");

// IMPORTANT:
// Authentication MUST come before Authorization.
app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();