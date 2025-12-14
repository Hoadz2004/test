namespace EduPro.Domain.Entities;

public class AuditLog
{
    public int Id { get; set; }
    public string Action { get; set; } = null!;
    public string EntityName { get; set; } = null!;
    public string EntityId { get; set; } = null!;
    public string Details { get; set; } = null!;
    public string PerformedBy { get; set; } = null!;
    public DateTime PerformedAt { get; set; }
    public string? IpAddress { get; set; }
}
