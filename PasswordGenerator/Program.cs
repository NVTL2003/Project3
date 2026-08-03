using BCryptHasher = BCrypt.Net.BCrypt;

Console.WriteLine(
    BCryptHasher.HashPassword("admin123")
);