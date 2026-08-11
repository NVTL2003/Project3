//using AutoMapper;
//using Project3.Models;
//using Project3.DTOs;
//using Project3.Repositories.Interfaces;

//namespace Project3.Services.Implementations
//{
//    public class FacilityService : CrudService<Facility, FacilityDto, CreateFacilityDto>
//    {
//        public FacilityService(ICrudRepository<Facility> repository, IMapper mapper)
//            : base(repository, mapper)
//        {
//        }

//        public override async Task<FacilityDto> CreateAsync(CreateFacilityDto dto)
//        {
//            // Auto-generate code if not provided
//            if (string.IsNullOrEmpty(dto.Code))
//            {
//                dto.Code = GenerateFacilityCode(dto.Name);
//            }

//            // Ensure facilityType is set
//            if (string.IsNullOrEmpty(dto.FacilityType))
//            {
//                dto.FacilityType = "Branch";
//            }

//            return await base.CreateAsync(dto);
//        }

//        private string GenerateFacilityCode(string name)
//        {
//            if (string.IsNullOrEmpty(name)) return "FAC-001";

//            // Generate code from name
//            var prefix = string.Concat(name.Split(' ')
//                .Where(w => !string.IsNullOrEmpty(w))
//                .Select(w => char.ToUpper(w[0])))
//                .Take(3)
//                .ToArray();

//            var codePrefix = new string(prefix).ToUpper();
//            if (string.IsNullOrEmpty(codePrefix)) codePrefix = "FAC";

//            // Get count of existing facilities with same prefix
//            var facilities = _repository.GetAllAsync().Result;
//            var count = facilities.Count(f => f.Code != null && f.Code.StartsWith(codePrefix));

//            return $"{codePrefix}-{(count + 1).ToString("D3")}";
//        }
//    }
//}
using AutoMapper;
using Project3.Models;
using Project3.DTOs;
using Project3.Repositories.Interfaces;
using System.Linq.Expressions;

namespace Project3.Services.Implementations
{
    public class FacilityService : CrudService<Facility, FacilityDto, CreateFacilityDto>
    {
        private readonly ILogger<FacilityService> _logger;

        public FacilityService(
            ICrudRepository<Facility> repository,
            IMapper mapper,
            ILogger<FacilityService> logger)
            : base(repository, mapper)
        {
            _logger = logger;
        }

        protected override Expression<Func<Facility, bool>>? BuildFilter(QueryParamsDto queryParams)
        {
            Console.WriteLine($"========== BUILDING FILTER ==========");
            Console.WriteLine($"Search: '{queryParams.Search}'");
            Console.WriteLine($"SortBy: '{queryParams.SortBy}'");
            Console.WriteLine($"Filters: {System.Text.Json.JsonSerializer.Serialize(queryParams.Filters)}");
            Console.WriteLine($"======================================");

            Expression<Func<Facility, bool>>? filter = null;

            // Handle search
            if (!string.IsNullOrEmpty(queryParams.Search))
            {
                var search = queryParams.Search.ToLower().Trim();
                Console.WriteLine($"📝 Applying search for: '{search}'");

                // Check what properties exist on Facility
                var properties = typeof(Facility).GetProperties();
                Console.WriteLine($"📋 Facility properties: {string.Join(", ", properties.Select(p => p.Name))}");

                filter = f =>
                    (f.Name != null && f.Name.ToLower().Contains(search)) ||
                    (f.Code != null && f.Code.ToLower().Contains(search)) ||
                    (f.City != null && f.City.ToLower().Contains(search)) ||
                    (f.State != null && f.State.ToLower().Contains(search)) ||
                    (f.AddressLine1 != null && f.AddressLine1.ToLower().Contains(search));

                Console.WriteLine($"✅ Search filter created");
            }

            // Handle filters
            if (queryParams.Filters != null && queryParams.Filters.Any())
            {
                foreach (var kvp in queryParams.Filters)
                {
                    var key = kvp.Key.ToLower().Trim();
                    var value = kvp.Value?.ToLower().Trim();

                    if (string.IsNullOrEmpty(value)) continue;

                    Console.WriteLine($"🔍 Applying filter: {key} = {value}");

                    switch (key)
                    {
                        case "facilitytype":
                        case "type":
                            Expression<Func<Facility, bool>> typeFilter = f =>
                                f.FacilityType != null &&
                                f.FacilityType.ToLower() == value;

                            filter = filter == null
                                ? typeFilter
                                : CombineExpressions(filter, typeFilter);

                            Console.WriteLine($"✅ Added type filter: {value}");
                            break;

                        case "isactive":
                        case "active":
                            var isActive = value == "true" || value == "1";

                            Expression<Func<Facility, bool>> activeFilter = f =>
                                f.IsActive == isActive;

                            filter = filter == null
                                ? activeFilter
                                : CombineExpressions(filter, activeFilter);

                            Console.WriteLine($"✅ Added active filter: {isActive}");
                            break;

                        case "city":
                            Expression<Func<Facility, bool>> cityFilter = f =>
                                f.City != null &&
                                f.City.ToLower().Contains(value);

                            filter = filter == null
                                ? cityFilter
                                : CombineExpressions(filter, cityFilter);

                            Console.WriteLine($"✅ Added city filter: {value}");
                            break;

                        case "state":
                            Expression<Func<Facility, bool>> stateFilter = f =>
                                f.State != null &&
                                f.State.ToLower().Contains(value);

                            filter = filter == null
                                ? stateFilter
                                : CombineExpressions(filter, stateFilter);

                            Console.WriteLine($"✅ Added state filter: {value}");
                            break;

                        default:
                            Console.WriteLine($"⚠️ Unknown filter key: {key}");
                            break;
                    }
                }
            }

            Console.WriteLine($"Final filter: {(filter != null ? "✅ HAS FILTER" : "❌ NO FILTER")}");
            return filter;
        }

        private Expression<Func<Facility, bool>> CombineExpressions(
            Expression<Func<Facility, bool>> first,
            Expression<Func<Facility, bool>> second)
        {
            var parameter = Expression.Parameter(typeof(Facility), "x");
            var visitor = new ReplaceParameterVisitor(second.Parameters[0], parameter);
            var body = Expression.AndAlso(first.Body, visitor.Visit(second.Body));
            return Expression.Lambda<Func<Facility, bool>>(body, parameter);
        }

        private class ReplaceParameterVisitor : ExpressionVisitor
        {
            private readonly ParameterExpression _oldParameter;
            private readonly ParameterExpression _newParameter;

            public ReplaceParameterVisitor(ParameterExpression oldParameter, ParameterExpression newParameter)
            {
                _oldParameter = oldParameter;
                _newParameter = newParameter;
            }

            protected override Expression VisitParameter(ParameterExpression node)
            {
                return node == _oldParameter ? _newParameter : base.VisitParameter(node);
            }
        }
    }
}