//using Microsoft.AspNetCore.Authorization;
//using Microsoft.AspNetCore.Mvc;
//using Microsoft.EntityFrameworkCore;
//using Project3.DTOs;
//using Project3.Models;
//using Project3.Services.Interfaces;
//using Project3.Services.Implementations;

//namespace Project3.Controllers;

//// ============================================================
//// SHIPMENT REQUESTS CONTROLLER
//// ============================================================

//[ApiController]
//[Authorize]
//[Route("api/[controller]")]
//public class ShipmentRequestsController
//    : BaseCrudController<ShipmentRequest, ShipmentRequestDto, CreateShipmentRequestDto>
//{
//    private readonly Pj3Context _context;
//    private readonly ICurrentUserService _currentUser;

//    public ShipmentRequestsController(
//        ICrudService<ShipmentRequest, ShipmentRequestDto, CreateShipmentRequestDto> service,
//        IAuthorizationService authorizationService,
//        Pj3Context context,
//        ICurrentUserService currentUser)
//        : base(service, authorizationService)
//    {
//        _context = context;
//        _currentUser = currentUser;
//    }

//    protected override string ResourceName => "shipment_requests";

//    // ============================================================
//    // APPROVE SHIPMENT REQUEST -> CREATE SHIPMENT
//    // ============================================================

//    [HttpPost("{id}/approve")]
//    public async Task<IActionResult> Approve(Guid id)
//    {
//        var request = await _context.ShipmentRequests
//            .Include(r => r.SenderAddress)
//            .Include(r => r.ReceiverAddress)
//            .Include(r => r.Service)
//            .FirstOrDefaultAsync(r => r.Id == id);

//        if (request == null)
//            return NotFound(new { message = "Shipment request not found." });

//        if (request.Status != "pending")
//            return BadRequest(new { message = $"Request already {request.Status}." });

//        // Get current user ID
//        var userId = _currentUser.UserId;
//        if (userId == null)
//            return Unauthorized();

//        // Find employee record for current user
//        var employee = await _context.Employees
//            .FirstOrDefaultAsync(e => e.UserId == userId.Value);

//        if (employee == null)
//            return BadRequest(new { message = "Current user is not an employee." });

//        // Generate tracking number
//        var trackingNumber = GenerateTrackingNumber();

//        // Create Shipment
//        var shipment = new Shipment
//        {
//            Id = Guid.NewGuid(),
//            TrackingNumber = trackingNumber,
//            ShipmentRequestId = request.Id,
//            ServiceId = request.ServiceId ?? throw new InvalidOperationException("Service is required"),
//            CustomerId = request.CustomerId,
//            SenderAddressId = request.SenderAddressId,
//            ReceiverAddressId = request.ReceiverAddressId,
//            Weight = request.Weight,
//            Length = request.Length,
//            Width = request.Width,
//            Height = request.Height,
//            DeclaredValue = request.DeclaredValue,
//            InsurancePlanId = request.InsurancePlanId,
//            InsuranceAmount = null,
//            PackageType = request.PackageType,
//            SpecialInstructions = request.SpecialInstructions,
//            IsFragile = request.IsFragile ?? false,
//            IsLarge = request.IsLarge ?? false,
//            CurrentStatus = "created",
//            EstimatedDelivery = null,
//            ActualDelivery = null,
//            IsActive = true,
//            CreatedAt = DateTime.UtcNow,
//            UpdatedAt = DateTime.UtcNow
//        };

//        // Update request
//        request.Status = "approved";
//        request.ApprovedBy = employee.Id;
//        request.ApprovedAt = DateTime.UtcNow;

//        _context.Shipments.Add(shipment);

//        // Create initial tracking event
//        var trackingStatus = await _context.TrackingStatuses
//            .FirstOrDefaultAsync(ts => ts.Code == "CREATED");

//        if (trackingStatus == null)
//        {
//            trackingStatus = new TrackingStatus
//            {
//                Id = Guid.NewGuid(),
//                Code = "CREATED",
//                Description = "Shipment Created",
//                IsPublic = true,
//                CreatedAt = DateTime.UtcNow
//            };
//            _context.TrackingStatuses.Add(trackingStatus);
//        }

//        var trackingEvent = new TrackingEvent
//        {
//            Id = Guid.NewGuid(),
//            ShipmentId = shipment.Id,
//            PackageScanId = null,
//            TrackingStatusId = trackingStatus.Id,
//            EventLocation = "System",
//            EventTime = DateTime.UtcNow,
//            IsPublic = true,
//            CreatedAt = DateTime.UtcNow
//        };

//        _context.TrackingEvents.Add(trackingEvent);

//        await _context.SaveChangesAsync();

//        return Ok(new
//        {
//            shipmentId = shipment.Id,
//            trackingNumber = shipment.TrackingNumber,
//            message = "Shipment created successfully."
//        });
//    }

//    private string GenerateTrackingNumber()
//    {
//        return "TRK-" + DateTime.UtcNow.ToString("yyyyMMddHHmmss") + "-" +
//               Guid.NewGuid().ToString("N").Substring(0, 4).ToUpper();
//    }
//}

//// ============================================================
//// SHIPMENTS CONTROLLER
//// ============================================================

//[ApiController]
//[Authorize]
//[Route("api/[controller]")]
//public class ShipmentsController
//    : BaseCrudController<Shipment, ShipmentDto, CreateShipmentDto>
//{
//    public ShipmentsController(
//        ICrudService<Shipment, ShipmentDto, CreateShipmentDto> service,
//        IAuthorizationService authorizationService)
//        : base(service, authorizationService)
//    {
//    }

//    protected override string ResourceName => "shipments";
//}

//// ============================================================
//// PACKAGE SCANS CONTROLLER
//// ============================================================

//[ApiController]
//[Authorize]
//[Route("api/[controller]")]
//public class PackageScansController
//    : BaseCrudController<PackageScan, PackageScanDto, CreatePackageScanDto>
//{
//    private readonly Pj3Context _context;
//    private readonly ICurrentUserService _currentUser;

//    public PackageScansController(
//        ICrudService<PackageScan, PackageScanDto, CreatePackageScanDto> service,
//        IAuthorizationService authorizationService,
//        Pj3Context context,
//        ICurrentUserService currentUser)
//        : base(service, authorizationService)
//    {
//        _context = context;
//        _currentUser = currentUser;
//    }

//    protected override string ResourceName => "package_scans";

//    // ============================================================
//    // SCAN SHIPMENT -> CREATE TRACKING EVENT
//    // ============================================================

//    [HttpPost("scan")]
//    public async Task<IActionResult> ScanShipment([FromBody] CreatePackageScanDto dto)
//    {
//        var shipment = await _context.Shipments
//            .FindAsync(dto.ShipmentId);

//        if (shipment == null)
//            return NotFound(new { message = "Shipment not found." });

//        // Get current user ID
//        var userId = _currentUser.UserId;
//        if (userId == null)
//            return Unauthorized();

//        // Find employee
//        var employee = await _context.Employees
//            .FirstOrDefaultAsync(e => e.UserId == userId.Value);

//        if (employee == null)
//            return BadRequest(new { message = "Current user is not an employee." });

//        // Create package scan
//        var scan = new PackageScan
//        {
//            Id = Guid.NewGuid(),
//            ScanNumber = GenerateScanNumber(),
//            ShipmentId = dto.ShipmentId,
//            EmployeeId = employee.Id,
//            FacilityId = dto.FacilityId,
//            VehicleId = dto.VehicleId,
//            LocationType = dto.LocationType,
//            ScanType = dto.ScanType,
//            ScanTime = DateTime.UtcNow,
//            Latitude = dto.Latitude,
//            Longitude = dto.Longitude,
//            IpAddress = dto.IpAddress ?? HttpContext.Connection.RemoteIpAddress?.ToString(),
//            Notes = dto.Notes,
//            CreatedAt = DateTime.UtcNow
//        };

//        _context.PackageScans.Add(scan);

//        // Determine tracking status code
//        var statusCode = dto.ScanType.ToLowerInvariant() switch
//        {
//            "pickup" => "PICKED_UP",
//            "sorting" => "IN_SORTING",
//            "loaded" => "LOADED",
//            "out_for_delivery" => "OUT_FOR_DELIVERY",
//            "delivered" => "DELIVERED",
//            _ => "IN_TRANSIT"
//        };

//        var trackingStatus = await _context.TrackingStatuses
//            .FirstOrDefaultAsync(ts => ts.Code == statusCode);

//        if (trackingStatus == null)
//        {
//            trackingStatus = new TrackingStatus
//            {
//                Id = Guid.NewGuid(),
//                Code = statusCode,
//                Description = statusCode.Replace("_", " "),
//                IsPublic = true,
//                CreatedAt = DateTime.UtcNow
//            };
//            _context.TrackingStatuses.Add(trackingStatus);
//        }

//        var trackingEvent = new TrackingEvent
//        {
//            Id = Guid.NewGuid(),
//            ShipmentId = dto.ShipmentId,
//            PackageScanId = scan.Id,
//            TrackingStatusId = trackingStatus.Id,
//            EventLocation = dto.FacilityId != null ? "Facility" : (dto.VehicleId != null ? "Vehicle" : "Unknown"),
//            EventTime = DateTime.UtcNow,
//            IsPublic = true,
//            CreatedAt = DateTime.UtcNow
//        };

//        _context.TrackingEvents.Add(trackingEvent);

//        // Update shipment status
//        if (dto.ScanType.ToLowerInvariant() == "delivered")
//        {
//            shipment.CurrentStatus = "delivered";
//            shipment.ActualDelivery = DateTime.UtcNow;
//            shipment.UpdatedAt = DateTime.UtcNow;
//        }
//        else
//        {
//            shipment.CurrentStatus = statusCode.ToLowerInvariant();
//            shipment.UpdatedAt = DateTime.UtcNow;
//        }

//        await _context.SaveChangesAsync();

//        return Ok(new
//        {
//            scanId = scan.Id,
//            scanNumber = scan.ScanNumber,
//            trackingEventId = trackingEvent.Id,
//            message = "Package scanned successfully."
//        });
//    }

//    private string GenerateScanNumber()
//    {
//        return "SCN-" + DateTime.UtcNow.ToString("yyyyMMddHHmmss") + "-" +
//               Guid.NewGuid().ToString("N").Substring(0, 4).ToUpper();
//    }
//}

//// ============================================================
//// TRACKING EVENTS CONTROLLER
//// ============================================================

//[ApiController]
//[Authorize]
//[Route("api/[controller]")]
//public class TrackingEventsController
//    : BaseCrudController<TrackingEvent, TrackingEventDto, CreateTrackingEventDto>
//{
//    public TrackingEventsController(
//        ICrudService<TrackingEvent, TrackingEventDto, CreateTrackingEventDto> service,
//        IAuthorizationService authorizationService)
//        : base(service, authorizationService)
//    {
//    }

//    protected override string ResourceName => "tracking_events";
//}

//// ============================================================
//// TRANSPORT ORDERS CONTROLLER
//// ============================================================

//[ApiController]
//[Authorize]
//[Route("api/[controller]")]
//public class TransportOrdersController
//    : BaseCrudController<TransportOrder, TransportOrderDto, CreateTransportOrderDto>
//{
//    private readonly Pj3Context _context;

//    public TransportOrdersController(
//        ICrudService<TransportOrder, TransportOrderDto, CreateTransportOrderDto> service,
//        IAuthorizationService authorizationService,
//        Pj3Context context)
//        : base(service, authorizationService)
//    {
//        _context = context;
//    }

//    protected override string ResourceName => "transport_orders";

//    // ============================================================
//    // ASSIGN TRANSPORT
//    // ============================================================

//    [HttpPost("assign")]
//    public async Task<IActionResult> AssignTransport([FromBody] CreateTransportOrderDto dto)
//    {
//        var shipment = await _context.Shipments
//            .FindAsync(dto.ShipmentId);

//        if (shipment == null)
//            return NotFound(new { message = "Shipment not found." });

//        var order = new TransportOrder
//        {
//            Id = Guid.NewGuid(),
//            OrderNumber = GenerateOrderNumber(),
//            ShipmentId = dto.ShipmentId,
//            Priority = dto.Priority ?? 5,
//            Weight = dto.Weight,
//            Volume = dto.Volume,
//            SpecialInstructions = dto.SpecialInstructions,
//            Status = "planned",
//            CreatedBy = dto.CreatedBy,
//            AssignedVehicleId = dto.AssignedVehicleId,
//            AssignedDriverId = dto.AssignedDriverId,
//            PlannedDeparture = dto.PlannedDeparture,
//            PlannedArrival = dto.PlannedArrival,
//            ActualDeparture = null,
//            ActualArrival = null,
//            CreatedAt = DateTime.UtcNow,
//            UpdatedAt = DateTime.UtcNow
//        };

//        _context.TransportOrders.Add(order);

//        // Update shipment status
//        shipment.CurrentStatus = "in_transit";
//        shipment.UpdatedAt = DateTime.UtcNow;

//        await _context.SaveChangesAsync();

//        return Ok(new
//        {
//            transportOrderId = order.Id,
//            orderNumber = order.OrderNumber,
//            message = "Transport order created."
//        });
//    }

//    private string GenerateOrderNumber()
//    {
//        return "TO-" + DateTime.UtcNow.ToString("yyyyMMddHHmmss") + "-" +
//               Guid.NewGuid().ToString("N").Substring(0, 4).ToUpper();
//    }
//}

//// ============================================================
//// DELIVERY ATTEMPTS CONTROLLER
//// ============================================================

//[ApiController]
//[Authorize]
//[Route("api/[controller]")]
//public class DeliveryAttemptsController
//    : BaseCrudController<DeliveryAttempt, DeliveryAttemptDto, CreateDeliveryAttemptDto>
//{
//    private readonly Pj3Context _context;

//    public DeliveryAttemptsController(
//        ICrudService<DeliveryAttempt, DeliveryAttemptDto, CreateDeliveryAttemptDto> service,
//        IAuthorizationService authorizationService,
//        Pj3Context context)
//        : base(service, authorizationService)
//    {
//        _context = context;
//    }

//    protected override string ResourceName => "delivery_attempts";

//    // ============================================================
//    // DELIVER SHIPMENT
//    // ============================================================

//    [HttpPost("deliver")]
//    public async Task<IActionResult> Deliver([FromBody] CreateDeliveryAttemptDto dto)
//    {
//        var shipment = await _context.Shipments
//            .FindAsync(dto.ShipmentId);

//        if (shipment == null)
//            return NotFound(new { message = "Shipment not found." });

//        // Create delivery attempt
//        var attempt = new DeliveryAttempt
//        {
//            Id = Guid.NewGuid(),
//            ShipmentId = dto.ShipmentId,
//            DeliveryAssignmentId = dto.DeliveryAssignmentId,
//            AttemptNumber = dto.AttemptNumber,
//            AttemptTime = dto.AttemptTime ?? DateTime.UtcNow,
//            Status = dto.Status ?? "delivered",
//            Reason = dto.Reason,
//            Notes = dto.Notes,
//            Latitude = dto.Latitude,
//            Longitude = dto.Longitude,
//            IsDelivered = dto.IsDelivered ?? (dto.Status == "delivered"),
//            CreatedAt = DateTime.UtcNow,
//            UpdatedAt = DateTime.UtcNow
//        };

//        _context.DeliveryAttempts.Add(attempt);

//        // Create proof of delivery if delivered
//        if (dto.Status == "delivered")
//        {
//            var proof = new ProofOfDelivery
//            {
//                Id = Guid.NewGuid(),
//                ShipmentId = dto.ShipmentId,
//                DeliveryAttemptId = attempt.Id,
//                ReceiverName = "Receiver", // You can add receiver name to DTO
//                ReceiverSignature = null,
//                ReceiverRelation = null,
//                DeliveryPhoto = null,
//                DeliveryTime = dto.AttemptTime ?? DateTime.UtcNow,
//                Latitude = dto.Latitude,
//                Longitude = dto.Longitude,
//                GpsAccuracy = null,
//                Notes = dto.Notes,
//                CreatedAt = DateTime.UtcNow
//            };

//            _context.ProofOfDeliveries.Add(proof);

//            // Update shipment status
//            shipment.CurrentStatus = "delivered";
//            shipment.ActualDelivery = dto.AttemptTime ?? DateTime.UtcNow;
//            shipment.UpdatedAt = DateTime.UtcNow;
//        }

//        await _context.SaveChangesAsync();

//        return Ok(new
//        {
//            attemptId = attempt.Id,
//            message = "Delivery attempt recorded."
//        });
//    }
//}

//// ============================================================
//// PROOF OF DELIVERY CONTROLLER
//// ============================================================

//[ApiController]
//[Authorize]
//[Route("api/[controller]")]
//public class ProofOfDeliveriesController
//    : BaseCrudController<ProofOfDelivery, ProofOfDeliveryDto, CreateProofOfDeliveryDto>
//{
//    public ProofOfDeliveriesController(
//        ICrudService<ProofOfDelivery, ProofOfDeliveryDto, CreateProofOfDeliveryDto> service,
//        IAuthorizationService authorizationService)
//        : base(service, authorizationService)
//    {
//    }

//    protected override string ResourceName => "proof_of_delivery";
//}