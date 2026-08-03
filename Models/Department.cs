using System;
using System.Collections.Generic;

namespace Project3.Models;

public partial class Department
{
    public Guid Id { get; set; }

    public string Name { get; set; } = null!;

    public string? Description { get; set; }

    public bool? IsActive { get; set; }

    public DateTime? CreatedAt { get; set; }

    public virtual ICollection<Employee> Employees { get; set; } = new List<Employee>();
}
