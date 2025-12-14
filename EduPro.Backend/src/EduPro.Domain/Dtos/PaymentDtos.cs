namespace EduPro.Domain.Dtos;

public class DebtDto
{
    public string MaSV { get; set; } = string.Empty;
    public string MaHK { get; set; } = string.Empty;
    public decimal SoTienGoc { get; set; }
    public decimal DaThanhToan { get; set; }
    public decimal SoTienNo { get; set; }
    public DateTime NgayCapNhat { get; set; }
}

public class PaymentInitRequest
{
    public string MaSV { get; set; } = string.Empty;
    public string MaHK { get; set; } = string.Empty;
    public decimal? Amount { get; set; }
    public string Method { get; set; } = "Offline";
    public string? Provider { get; set; }
    public string? ProviderRef { get; set; }
}

public class PaymentInitResponse
{
    public int PaymentId { get; set; }
    public decimal Amount { get; set; }
    public string? PaymentUrl { get; set; }
}

public class PaymentConfirmRequest
{
    public int PaymentId { get; set; }
    public string Status { get; set; } = "Succeeded"; // Succeeded / Failed / Canceled
    public string? ProviderTransId { get; set; }
    public string? Note { get; set; }
}

public class PaymentConfirmResponse
{
    public int PaymentId { get; set; }
    public string Status { get; set; } = string.Empty;
    public DateTime? ConfirmedAt { get; set; }
}

public class PaymentInfoDto
{
    public int Id { get; set; }
    public string MaSV { get; set; } = string.Empty;
    public string MaHK { get; set; } = string.Empty;
    public decimal Amount { get; set; }
    public string Status { get; set; } = string.Empty;
    public string? ProviderRef { get; set; }
}

public class DebtSummaryDto
{
    public string MaSV { get; set; } = string.Empty;
    public string MaHK { get; set; } = string.Empty;
    public decimal SoTienGoc { get; set; }
    public decimal DaThanhToan { get; set; }
    public decimal SoTienNo { get; set; }
    public DateTime NgayCapNhat { get; set; }
}

public class DebtDetailDto
{
    public string MaLHP { get; set; } = string.Empty;
    public string MaHP { get; set; } = string.Empty;
    public string TenHP { get; set; } = string.Empty;
    public int SoTinChi { get; set; }
    public decimal DonGiaTinChi { get; set; }
    public decimal PhuPhiThucHanh { get; set; }
    public decimal GiamTruPercent { get; set; }
    public decimal SoTien { get; set; }
    public DateTime? NgayDangKy { get; set; }
    public DateTime? HanThanhToan { get; set; }
    public string TrangThaiDangKy { get; set; } = string.Empty;
}
