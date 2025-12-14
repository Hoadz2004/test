using EduPro.Domain.Dtos;
using EduPro.Domain.Interfaces;

namespace EduPro.Application.Payment.Services;

public class PaymentService : IPaymentService
{
    private readonly IPaymentRepository _repository;

    public PaymentService(IPaymentRepository repository)
    {
        _repository = repository;
    }

    public Task<DebtDto?> GetDebtAsync(string studentId, string semesterId) =>
        _repository.GetDebtAsync(studentId, semesterId);

    public Task<PaymentInitResponse> InitPaymentAsync(PaymentInitRequest request) =>
        _repository.InitPaymentAsync(request);

    public Task<PaymentConfirmResponse> ConfirmPaymentAsync(PaymentConfirmRequest request) =>
        _repository.ConfirmPaymentAsync(request);

    public Task<PaymentInfoDto?> GetPaymentByProviderRefAsync(string providerRef) =>
        _repository.GetPaymentByProviderRefAsync(providerRef);

    public Task<IEnumerable<DebtSummaryDto>> GetDebtsAsync(string studentId, string? semesterId = null) =>
        _repository.GetDebtsAsync(studentId, semesterId);

    public Task<IEnumerable<DebtDetailDto>> GetDebtDetailsAsync(string studentId, string semesterId) =>
        _repository.GetDebtDetailsAsync(studentId, semesterId);
}
