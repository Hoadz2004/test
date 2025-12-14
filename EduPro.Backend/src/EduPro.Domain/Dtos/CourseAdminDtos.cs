namespace EduPro.Domain.Dtos;

public class HocPhanAdminDto
{
    public string MaHP { get; set; } = string.Empty;
    public string TenHP { get; set; } = string.Empty;
    public int SoTinChi { get; set; }
    public string? LoaiHocPhan { get; set; }
    public bool BatBuoc { get; set; }
    public int? SoTietLT { get; set; }
    public int? SoTietTH { get; set; }
    public int TotalRecords { get; set; }
}

public class HocPhiCatalogDto
{
    public int Id { get; set; }
    public string MaNganh { get; set; } = string.Empty;
    public string MaHK { get; set; } = string.Empty;
    public decimal DonGiaTinChi { get; set; }
    public decimal PhuPhiThucHanh { get; set; }
    public decimal GiamTruPercent { get; set; }
    public DateTime HieuLucTu { get; set; }
    public DateTime? HieuLucDen { get; set; }
    public DateTime? NgayHetHan { get; set; }
    public int TotalRecords { get; set; }
}
