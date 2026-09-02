using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Project3.DTOs;
using Project3.Models;
using Project3.Services.Interfaces;

namespace Project3.Controllers;

[ApiController]
[Authorize]
[Route("api/[controller]")]
public class ManifestItemsController
	: BaseCrudController<
		ManifestItem,
		ManifestItemDto,
		CreateManifestItemDto>
{

	public ManifestItemsController(
		ICrudService<
			ManifestItem,
			ManifestItemDto,
			CreateManifestItemDto> service,
		IAuthorizationService authorizationService,
		ICurrentUserService currentUser)
		: base(
			service,
			authorizationService,
			currentUser)
	{
	}
}