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

builder.Services.AddScoped<
    ICrudService<Facility, FacilityDto, CreateFacilityDto>,
    FacilityService>();

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
// SHIPMENT WORKFLOW SERVICES
// ============================================================

builder.Services.AddScoped<
    ICrudService<ShipmentRequest, ShipmentRequestDto, CreateShipmentRequestDto>,
    CrudService<ShipmentRequest, ShipmentRequestDto, CreateShipmentRequestDto>>();

builder.Services.AddScoped<
    ICrudService<Shipment, ShipmentDto, CreateShipmentDto>,
    CrudService<Shipment, ShipmentDto, CreateShipmentDto>>();

builder.Services.AddScoped<
    ICrudService<PackageScan, PackageScanDto, CreatePackageScanDto>,
    CrudService<PackageScan, PackageScanDto, CreatePackageScanDto>>();

builder.Services.AddScoped<
    ICrudService<TrackingEvent, TrackingEventDto, CreateTrackingEventDto>,
    CrudService<TrackingEvent, TrackingEventDto, CreateTrackingEventDto>>();

builder.Services.AddScoped<
    ICrudService<TransportOrder, TransportOrderDto, CreateTransportOrderDto>,
    CrudService<TransportOrder, TransportOrderDto, CreateTransportOrderDto>>();

builder.Services.AddScoped<
    ICrudService<DeliveryAttempt, DeliveryAttemptDto, CreateDeliveryAttemptDto>,
    CrudService<DeliveryAttempt, DeliveryAttemptDto, CreateDeliveryAttemptDto>>();

builder.Services.AddScoped<
    ICrudService<ProofOfDelivery, ProofOfDeliveryDto, CreateProofOfDeliveryDto>,
    CrudService<ProofOfDelivery, ProofOfDeliveryDto, CreateProofOfDeliveryDto>>();
builder.Services.AddScoped<
    ICrudService<CustomerAddress, CustomerAddressDto, CreateCustomerAddressDto>,
    CrudService<CustomerAddress, CustomerAddressDto, CreateCustomerAddressDto>>();
builder.Services.AddScoped<
    IMeCrudService<CustomerAddress, CustomerAddressDto, CreateCustomerAddressDto>,
    CustomerAddressMeService>();
builder.Services.AddScoped<
    ICrudService<DeliveryAssignment, DeliveryAssignmentDto, CreateDeliveryAssignmentDto>,
    CrudService<DeliveryAssignment, DeliveryAssignmentDto, CreateDeliveryAssignmentDto>>();


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