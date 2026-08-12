namespace Project3.Exceptions
{
    public class DuplicateResourceException : Exception
    {
        public DuplicateResourceException(string message)
            : base(message)
        {
        }
    }
}