using AutoMapper;
using Project3.Models;
using Project3.DTOs;

public class AutoMapperProfile : Profile
{
    public AutoMapperProfile()
    {
        CreateMap<User, UserDto>();

        CreateMap<CreateUserDto, User>();
    }
}