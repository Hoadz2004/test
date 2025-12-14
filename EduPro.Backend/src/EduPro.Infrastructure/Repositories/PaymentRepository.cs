using Dapper;
using EduPro.Application.Common.Interfaces;
using EduPro.Domain.Dtos;
using EduPro.Domain.Interfaces;
using System.Data;

namespace EduPro.Infrastructure.Repositories;

public class PaymentRepository : IPaymentRepository
{
    private readonly ISqlConnectionFactory _connectionFactory;

    public PaymentRepository(ISqlConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<DebtDto?> GetDebtAsync(string studentId, string semesterId)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryFirstOrDefaultAsync<DebtDto>(
            "sp_Payment_GetDebt",
            new { MaSV = studentId, MaHK = semesterId },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<PaymentInitResponse> InitPaymentAsync(PaymentInitRequest request)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryFirstAsync<PaymentInitResponse>(
            "sp_Payment_Init",
            new
            {
                MaSV = request.MaSV,
                MaHK = request.MaHK,
                Amount = request.Amount,
                Method = request.Method,
                Provider = request.Provider,
                ProviderRef = request.ProviderRef,
                ReturnUrl = request.ProviderRef, // reuse as return url if provided
                AutoRecalc = true
            },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<PaymentConfirmResponse> ConfirmPaymentAsync(PaymentConfirmRequest request)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryFirstAsync<PaymentConfirmResponse>(
            "sp_Payment_Confirm",
            new
            {
                PaymentId = request.PaymentId,
                Status = request.Status,
                ProviderTransId = request.ProviderTransId,
                Note = request.Note
            },
            commandType: CommandType.StoredProcedure);
    }

    public async Task<PaymentInfoDto?> GetPaymentByProviderRefAsync(string providerRef)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryFirstOrDefaultAsync<PaymentInfoDto>(
            "SELECT TOP 1 Id, MaSV, MaHK, Amount, Status, ProviderRef FROM PaymentTransaction WHERE ProviderRef = @ProviderRef",
            new { ProviderRef = providerRef });
    }

    public async Task<IEnumerable<DebtSummaryDto>> GetDebtsAsync(string studentId, string? semesterId = null)
    {
        using var connection = _connectionFactory.CreateConnection();
        // Lấy danh sách học kỳ cần tính: lọc hoặc lấy từ đăng ký trước, fallback CongNo
        var hkList = new List<string>();
        if (!string.IsNullOrWhiteSpace(semesterId))
        {
            hkList.Add(semesterId);
        }
        else
        {
            var hkFromReg = await connection.QueryAsync<string>(
                "SELECT DISTINCT lhp.MaHK FROM DangKyHocPhan dk JOIN LopHocPhan lhp ON dk.MaLHP = lhp.MaLHP WHERE dk.MaSV = @MaSV AND dk.TrangThai != N'Hủy'",
                new { MaSV = studentId });
            hkList.AddRange(hkFromReg);

            var hkFromDebt = await connection.QueryAsync<string>(
                "SELECT DISTINCT MaHK FROM CongNo WHERE MaSV = @MaSV",
                new { MaSV = studentId });
            hkList.AddRange(hkFromDebt);
            hkList = hkList.Distinct().ToList();
        }

        var results = new List<DebtSummaryDto>();
        foreach (var hk in hkList)
        {
            var calc = await connection.QueryFirstOrDefaultAsync<dynamic>(
                "sp_Payment_RecalcDebt",
                new { MaSV = studentId, MaHK = hk },
                commandType: CommandType.StoredProcedure);

            if (calc != null)
            {
                results.Add(new DebtSummaryDto
                {
                    MaSV = studentId,
                    MaHK = hk,
                    SoTienGoc = (decimal)calc.SoTienGoc,
                    DaThanhToan = (decimal)calc.DaThanhToan,
                    SoTienNo = (decimal)calc.SoTienNo,
                    NgayCapNhat = DateTime.Now
                });
            }
        }

        return results;
    }

    public async Task<IEnumerable<DebtDetailDto>> GetDebtDetailsAsync(string studentId, string semesterId)
    {
        using var connection = _connectionFactory.CreateConnection();

        var feeInfo = await connection.QueryFirstOrDefaultAsync<dynamic>(
            @"SELECT TOP 1 DonGiaTinChi, PhuPhiThucHanh, ISNULL(GiamTruPercent,0) AS GiamTruPercent, NgayHetHan
              FROM HocPhiCatalog
              WHERE MaNganh = (SELECT MaNganh FROM SinhVien WHERE MaSV = @MaSV)
                AND MaHK = @MaHK
              ORDER BY HieuLucTu DESC",
            new { MaSV = studentId, MaHK = semesterId });

        decimal donGia = feeInfo?.DonGiaTinChi ?? 0;
        decimal phuPhi = feeInfo?.PhuPhiThucHanh ?? 0;
        decimal giamTru = feeInfo?.GiamTruPercent ?? 0;
        DateTime? han = feeInfo?.NgayHetHan;

        var data = await connection.QueryAsync<dynamic>(
            @"SELECT dk.MaLHP, lhp.MaHP, hp.TenHP, hp.SoTinChi, dk.TrangThai AS TrangThaiDangKy, dk.NgayDangKy
              FROM DangKyHocPhan dk
              JOIN LopHocPhan lhp ON dk.MaLHP = lhp.MaLHP
              JOIN HocPhan hp ON lhp.MaHP = hp.MaHP
              WHERE dk.MaSV = @MaSV AND lhp.MaHK = @MaHK AND dk.TrangThai != N'Hủy'",
            new { MaSV = studentId, MaHK = semesterId });

        return data.Select(d =>
        {
            decimal amount = d.SoTinChi * (donGia + phuPhi);
            amount = amount * (1 - giamTru / 100m);
            return new DebtDetailDto
            {
                MaLHP = d.MaLHP,
                MaHP = d.MaHP,
                TenHP = d.TenHP,
                SoTinChi = d.SoTinChi,
                DonGiaTinChi = donGia,
                PhuPhiThucHanh = phuPhi,
                GiamTruPercent = giamTru,
                SoTien = amount,
                NgayDangKy = d.NgayDangKy,
                HanThanhToan = han,
                TrangThaiDangKy = d.TrangThaiDangKy
            };
        });
    }
}
