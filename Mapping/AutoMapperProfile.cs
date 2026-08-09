using AutoMapper;
using Project3.Models;
using Project3.DTOs;

namespace Project3.Mapping
{
    public class AutoMapperProfile : Profile
    {
        public AutoMapperProfile()
        {
            // Existing mappings
            CreateMap<User, UserDto>();
            CreateMap<CreateUserDto, User>();

            // Facility mappings
            CreateMap<CreateFacilityDto, Facility>()
                .ForMember(dest => dest.FacilityType,
                    opt => opt.MapFrom(src => src.FacilityType))
                .ForMember(dest => dest.Code,
                    opt => opt.MapFrom(src => src.Code ?? GenerateDefaultCode(src.Name)))
                .ForMember(dest => dest.Capacity,
                    opt => opt.Ignore())
                .ForMember(dest => dest.CurrentOccupancy,
                    opt => opt.Ignore())
                .ForMember(dest => dest.BranchManagerId,
                    opt => opt.Ignore());

            CreateMap<Facility, FacilityDto>();
        }

        private string GenerateDefaultCode(string name)
        {
            if (string.IsNullOrEmpty(name)) return "FAC-001";
            var prefix = string.Concat(name.Split(' ')
                .Where(w => !string.IsNullOrEmpty(w))
                .Select(w => char.ToUpper(w[0])))
                .Take(3)
                .ToArray();
            return new string(prefix).ToUpper() + "-001";
        }
    }
}