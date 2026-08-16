using System;

namespace Project3.DTOs
{
    public class UserRoleDto
    {
        public Guid Id { get; set; }
        public Guid UserId { get; set; }
        public Guid RoleId { get; set; }
        public DateTime? CreatedAt { get; set; }
    }
    public class CreateUserRoleDto
    {
        public Guid UserId { get; set; }
        public Guid RoleId { get; set; }
    }
}