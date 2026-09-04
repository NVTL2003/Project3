namespace Project3.DTOs;

public class CustomerDto
{
    public Guid Id { get; set; }

    public Guid UserId { get; set; }

    public string? AccountNumber { get; set; }

    public string? FirstName { get; set; }

    public string? LastName { get; set; }

    public string? CompanyName { get; set; }

    public string? TaxId { get; set; }

    public decimal? CreditLimit { get; set; }

    public bool IsActive { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }
}

public class CreateCustomerDto
{
    public string? AccountNumber { get; set; }

    public string? FirstName { get; set; }

    public string? LastName { get; set; }

    public string? CompanyName { get; set; }

    public string? TaxId { get; set; }

    public decimal? CreditLimit { get; set; }

    public bool IsActive { get; set; } = true;
}