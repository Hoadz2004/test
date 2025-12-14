using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace EduPro.Domain.Entities;

[Table("LoginAttempt")]
public class LoginAttempt
{
    [Key]
    public int Id { get; set; }
    
    [Required]
    [MaxLength(50)]
    public string UserName { get; set; } = null!;

    [MaxLength(50)]
    public string? IPAddress { get; set; }

    public DateTime AttemptTime { get; set; } = DateTime.UtcNow;

    public bool IsSuccess { get; set; }

    [MaxLength(255)]
    public string? FailureReason { get; set; }
}
