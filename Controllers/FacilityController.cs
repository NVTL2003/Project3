// Controllers/FacilityController.cs

using Microsoft.AspNetCore.Mvc;
using Project3.Models;              // for Facility
using Project3.DTOs;               // for FacilityDto, CreateFacilityDto
using Project3.Services.Interfaces; // for ICrudService (if you keep interfaces)

[Route("api/[controller]")]
[ApiController]
public class FacilityController : BaseCrudController<Facility, FacilityDto, CreateFacilityDto>
{
    public FacilityController(ICrudService<Facility, FacilityDto, CreateFacilityDto> service)
        : base(service)
    {
    }

    // Optionally override any method to add custom behaviour
    // e.g., override GetAll to return only active facilities
    // public override async Task<IActionResult> GetAll() { ... }
}