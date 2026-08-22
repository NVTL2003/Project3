using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Project3.DTOs;
using Project3.Models;
using Project3.Services.Interfaces;

namespace Project3.Controllers;

[ApiController]
[Authorize]
[Route("api/delivery-assignments")]
public class DeliveryAssignmentsController
    : BaseCrudController<DeliveryAssignment, DeliveryAssignmentDto, CreateDeliveryAssignmentDto>
{
    private readonly Pj3Context _context;
    private readonly ICurrentUserService _currentUser;

    public DeliveryAssignmentsController(
        ICrudService<DeliveryAssignment, DeliveryAssignmentDto, CreateDeliveryAssignmentDto> service,
        IAuthorizationService authorizationService,
        Pj3Context context,
        ICurrentUserService currentUser)
        : base(service, authorizationService,currentUser)
    {
        _context = context;
        _currentUser = currentUser;
    }

    protected override string ResourceName => "delivery_assignments";
}