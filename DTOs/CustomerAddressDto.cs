namespace Project3.DTOs
{
    public class CustomerAddressDto
    {
        public Guid Id { get; set; }
        public string AddressType { get; set; } = string.Empty;
        public string RecipientName { get; set; } = string.Empty;
        public string? Phone { get; set; }

        public string AddressLine1 { get; set; } = string.Empty;
        public string? AddressLine2 { get; set; }

        public string City { get; set; } = string.Empty;
        public string? State { get; set; }
        public string Pincode { get; set; } = string.Empty;
        public string Country { get; set; } = string.Empty;

        public string? Landmark { get; set; }

        public bool IsDefault { get; set; }
        public bool IsActive { get; set; }
    }
    public class CreateCustomerAddressDto
    {
        public string AddressType { get; set; } = string.Empty;
        public string RecipientName { get; set; } = string.Empty;
        public string? Phone { get; set; }

        public string AddressLine1 { get; set; } = string.Empty;
        public string? AddressLine2 { get; set; }

        public string City { get; set; } = string.Empty;
        public string? State { get; set; }
        public string Pincode { get; set; } = string.Empty;
        public string Country { get; set; } = "Vietnam";

        public string? Landmark { get; set; }

        public bool IsDefault { get; set; }
    }
    public class UpdateCustomerAddressDto
    {
        public string? AddressType { get; set; }

        public string? RecipientName { get; set; }

        public string? Phone { get; set; }

        public string? AddressLine1 { get; set; }

        public string? AddressLine2 { get; set; }

        public string? City { get; set; }

        public string? State { get; set; }

        public string? Pincode { get; set; }

        public string? Country { get; set; }

        public string? Landmark { get; set; }

        public bool? IsDefault { get; set; }

        public bool? IsActive { get; set; }
    }
}