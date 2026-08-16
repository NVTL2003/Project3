using System;

namespace Project3.DTOs
{
    public class RolePermissionDto
    {
        public Guid Id { get; set; }
        public Guid RoleId { get; set; }
        public Guid PermissionId { get; set; }
        public DateTime? CreatedAt { get; set; }
    }
    public class CreateRolePermissionDto
    {
        public Guid RoleId { get; set; }
        public Guid PermissionId { get; set; }
    }
}