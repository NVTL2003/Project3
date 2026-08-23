using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Project3.DTOs;
using Project3.Models;
using Project3.Repositories.Interfaces;
using Project3.Services.Interfaces;

namespace Project3.Services.Implementations;

public class ShipmentRequestService
    : CrudService<
        ShipmentRequest,
        ShipmentRequestDto,
        CreateShipmentRequestDto>,
      IShipmentRequestService
{
    private readonly Pj3Context _context;

    public ShipmentRequestService(
        ICrudRepository<ShipmentRequest> repository,
        IMapper mapper,
        Pj3Context context)
        : base(repository, mapper)
    {
        _context = context;
    }

    protected override IQueryable<ShipmentRequest> ApplyOwnerFilter(
        IQueryable<ShipmentRequest> query,
        Guid userId)
    {
        return query.Where(request =>
            request.Customer.UserId == userId);
    }

    protected override async Task<ShipmentRequest>
        PrepareForCreateAsync(
            ShipmentRequest entity,
            Guid userId)
    {
        var customer = await _context.Customers
            .FirstOrDefaultAsync(c =>
                c.UserId == userId);

        if (customer == null)
            throw new InvalidOperationException(
                "Customer not found.");

        entity.CustomerId = customer.Id;
        entity.Id = Guid.NewGuid();

        entity.RequestNumber =
            "REQ-" +
            DateTime.UtcNow.ToString("yyyyMMddHHmmss") +
            "-" +
            Guid.NewGuid()
                .ToString("N")
                .Substring(0, 4)
                .ToUpper();

        entity.Status = "pending";
        entity.CreatedAt = DateTime.UtcNow;
        entity.UpdatedAt = DateTime.UtcNow;

        return entity;
    }

    // ============================================================
    // APPROVE
    // ============================================================

    public async Task<ApproveShipmentRequestResult> ApproveAsync(
		Guid requestId,
		Guid userId)
	{
		// --------------------------------------------------------
		// 1. Find employee
		// --------------------------------------------------------

		var employee = await _context.Employees
			.FirstOrDefaultAsync(e =>
				e.UserId == userId);

		if (employee == null)
		{
			throw new InvalidOperationException(
				"Current user is not an employee.");
		}

		// --------------------------------------------------------
		// 2. Find shipment request
		// --------------------------------------------------------

		var request = await _context.ShipmentRequests
			.FirstOrDefaultAsync(r =>
				r.Id == requestId);

		if (request == null)
		{
			throw new KeyNotFoundException(
				"Shipment request not found.");
		}

		// --------------------------------------------------------
		// 3. Validate status
		// --------------------------------------------------------

		if (!string.Equals(
				request.Status,
				"pending",
				StringComparison.OrdinalIgnoreCase))
		{
			throw new InvalidOperationException(
				$"Request already {request.Status}.");
		}

		// --------------------------------------------------------
		// 4. Validate service
		// --------------------------------------------------------

		if (request.ServiceId == null)
		{
			throw new InvalidOperationException(
				"Shipment request has no service.");
		}

		// --------------------------------------------------------
		// 5. Generate tracking number
		// --------------------------------------------------------

		var trackingNumber =
			GenerateTrackingNumber();

		// --------------------------------------------------------
		// 6. Create shipment
		// --------------------------------------------------------

		var shipment = new Shipment
		{
			Id = Guid.NewGuid(),

			TrackingNumber = trackingNumber,

			ShipmentRequestId = request.Id,

			ServiceId = request.ServiceId.Value,

			CustomerId = request.CustomerId,

			SenderAddressId = request.SenderAddressId,

			ReceiverAddressId = request.ReceiverAddressId,

			Weight = request.Weight,

			Length = request.Length,

			Width = request.Width,

			Height = request.Height,

			DeclaredValue = request.DeclaredValue,

			InsurancePlanId = request.InsurancePlanId,

			PackageType = request.PackageType,

			SpecialInstructions =
				request.SpecialInstructions,

			IsFragile =
				request.IsFragile ?? false,

			IsLarge =
				request.IsLarge ?? false,

			CurrentStatus = "created",

			IsActive = true,

			CreatedAt = DateTime.UtcNow,

			UpdatedAt = DateTime.UtcNow
		};

		// --------------------------------------------------------
		// 7. Update request
		// --------------------------------------------------------

		request.Status = "approved";

		request.ApprovedBy = employee.Id;

		request.ApprovedAt = DateTime.UtcNow;

		request.UpdatedAt = DateTime.UtcNow;

		// --------------------------------------------------------
		// 8. Add shipment
		// --------------------------------------------------------

		_context.Shipments.Add(shipment);

		// --------------------------------------------------------
		// 9. Get/create CREATED tracking status
		// --------------------------------------------------------

		var trackingStatus =
			await _context.TrackingStatuses
				.FirstOrDefaultAsync(ts =>
					ts.Code == "CREATED");

		if (trackingStatus == null)
		{
			trackingStatus = new TrackingStatus
			{
				Id = Guid.NewGuid(),

				Code = "CREATED",

				Description = "Shipment Created",

				IsPublic = true,

				CreatedAt = DateTime.UtcNow
			};

			_context.TrackingStatuses.Add(
				trackingStatus);
		}

		// --------------------------------------------------------
		// 10. Create tracking event
		// --------------------------------------------------------

		var trackingEvent = new TrackingEvent
		{
			Id = Guid.NewGuid(),

			ShipmentId = shipment.Id,

			TrackingStatusId =
				trackingStatus.Id,

			EventLocation = "System",

			EventTime = DateTime.UtcNow,

			IsPublic = true,

			CreatedAt = DateTime.UtcNow
		};

		_context.TrackingEvents.Add(
			trackingEvent);

		// --------------------------------------------------------
		// 11. Save
		// --------------------------------------------------------

		await _context.SaveChangesAsync();

		// --------------------------------------------------------
		// 12. Return result
		// --------------------------------------------------------

		return new ApproveShipmentRequestResult
		{
			ShipmentId = shipment.Id,

			TrackingNumber =
				shipment.TrackingNumber,

			Message =
				"Shipment request approved and shipment created successfully."
		};
	}

	private string GenerateTrackingNumber()
	{
		return "TRK-" +
			DateTime.UtcNow.ToString("yyyyMMddHHmmss") +
			"-" +
			Guid.NewGuid()
				.ToString("N")
				.Substring(0, 4)
				.ToUpper();
	}
}