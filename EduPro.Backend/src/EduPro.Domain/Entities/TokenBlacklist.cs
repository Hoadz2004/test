using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace EduPro.Domain.Entities;

[Table("TokenBlacklist")]
public class TokenBlacklist
{
    [Key]
    public int Id { get; set; }
    
    [Required]
    [MaxLength(100)]
    public string TokenId { get; set; } = null!; // JTI

    public DateTime ExpiryDate { get; set; }

    [MaxLength(200)]
    public string? Reason { get; set; }

    public DateTime RevokedAt { get; set; } = DateTime.UtcNow;
}
