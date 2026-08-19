using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Project3.DTOs;
using Project3.Models;
using Project3.Services.Interfaces;

namespace Project3.Controllers;

[ApiController]
[Authorize]
[Route("api/tracking-events")]
public class TrackingEventsController
    : BaseCrudController<TrackingEvent, TrackingEventDto, CreateTrackingEventDto>
{
    public TrackingEventsController(
        ICrudService<TrackingEvent, TrackingEventDto, CreateTrackingEventDto> service,
        IAuthorizationService authorizationService)
        : base(service, authorizationService)
    {
    }

    protected override string ResourceName => "tracking_events";
}