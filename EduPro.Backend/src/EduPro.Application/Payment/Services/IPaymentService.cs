using EduPro.Domain.Dtos;

namespace EduPro.Application.Payment.Services;

public interface IPaymentService
{
    Task<DebtDto?> GetDebtAsync(string studentId, string semesterId);
    Task<PaymentInitResponse> InitPaymentAsync(PaymentInitRequest request);
    Task<PaymentConfirmResponse> ConfirmPaymentAsync(PaymentConfirmRequest request);
    Task<PaymentInfoDto?> GetPaymentByProviderRefAsync(string providerRef);
    Task<IEnumerable<DebtSummaryDto>> GetDebtsAsync(string studentId, string? semesterId = null);
    Task<IEnumerable<DebtDetailDto>> GetDebtDetailsAsync(string studentId, string semesterId);
}
