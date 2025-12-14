using System.Security.Cryptography;
using System.Text;
using EduPro.API.Settings;
using EduPro.Application.Payment.Services;
using EduPro.Domain.Dtos;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;

namespace EduPro.API.Controllers;

[Route("api/[controller]")]
[ApiController]
public class PaymentController : ControllerBase
{
    private readonly IPaymentService _service;
    private readonly VnPaySettings _vnPaySettings;

    public PaymentController(IPaymentService service, IOptions<VnPaySettings> vnPayOptions)
    {
        _service = service;
        _vnPaySettings = vnPayOptions.Value;
    }

    [HttpGet("debt")]
    public async Task<IActionResult> GetDebt([FromQuery] string maSV, [FromQuery] string maHK)
    {
        try
        {
            var result = await _service.GetDebtAsync(maSV, maHK);
            if (result == null) return NotFound(new { message = "Không tìm thấy công nợ" });
            return Ok(result);
        }
        catch (Exception ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    [HttpPost("init")]
    public async Task<IActionResult> InitPayment([FromBody] PaymentInitRequest request)
    {
        var result = await _service.InitPaymentAsync(request);
        return Ok(result);
    }

    [HttpPost("confirm")]
    public async Task<IActionResult> ConfirmPayment([FromBody] PaymentConfirmRequest request)
    {
        var result = await _service.ConfirmPaymentAsync(request);
        return Ok(result);
    }

    [HttpGet("debts")]
    public async Task<IActionResult> GetDebts([FromQuery] string maSV, [FromQuery] string? maHK = null)
    {
        try
        {
            var result = await _service.GetDebtsAsync(maSV, maHK);
            return Ok(result);
        }
        catch (Exception ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    [HttpGet("debt-details")]
    public async Task<IActionResult> GetDebtDetails([FromQuery] string maSV, [FromQuery] string maHK)
    {
        try
        {
            var result = await _service.GetDebtDetailsAsync(maSV, maHK);
            return Ok(result);
        }
        catch (Exception ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    // VNPay init (build signed URL)
    [HttpPost("vnpay/init")]
    public async Task<IActionResult> InitVnPay([FromBody] PaymentInitRequest request)
    {
        var txnRef = Guid.NewGuid().ToString("N").Substring(0, 12);

        // Lưu giao dịch với ProviderRef = txnRef
        var init = await _service.InitPaymentAsync(new PaymentInitRequest
        {
            MaSV = request.MaSV,
            MaHK = request.MaHK,
            Amount = request.Amount,
            Method = "VNPAY",
            Provider = "VNPAY",
            ProviderRef = txnRef
        });

        var amount = (long)(init.Amount * 100); // VNPAY yêu cầu nhân 100
        var createDate = DateTime.Now.ToString("yyyyMMddHHmmss");
        var ipAddr = HttpContext.Connection.RemoteIpAddress?.ToString() ?? "127.0.0.1";

        var query = new SortedDictionary<string, string>
        {
            { "vnp_Version", "2.1.0" },
            { "vnp_Command", "pay" },
            { "vnp_TmnCode", _vnPaySettings.TmnCode },
            { "vnp_Amount", amount.ToString() },
            { "vnp_CurrCode", "VND" },
            { "vnp_TxnRef", txnRef },
            { "vnp_OrderInfo", $"PAY_{init.PaymentId}" },
            { "vnp_OrderType", "other" },
            { "vnp_Locale", "vn" },
            { "vnp_ReturnUrl", _vnPaySettings.ReturnUrl },
            { "vnp_IpAddr", ipAddr },
            { "vnp_CreateDate", createDate }
        };

        var queryString = string.Join("&", query.Select(kv => $"{kv.Key}={Uri.EscapeDataString(kv.Value)}"));
        var signData = string.Join("&", query.Select(kv => $"{kv.Key}={Uri.EscapeDataString(kv.Value)}"));
        var sign = ComputeHmac512(_vnPaySettings.HashSecret, signData);
        var paymentUrl = $"{_vnPaySettings.PayUrl}?{queryString}&vnp_SecureHash={sign}";

        return Ok(new { init.PaymentId, init.Amount, paymentUrl, txnRef });
    }

    // VNPay callback (return & IPN đều có thể dùng endpoint này)
    [HttpGet("vnpay/callback")]
    public async Task<IActionResult> VnPayCallback()
    {
        var query = Request.Query.ToDictionary(q => q.Key, q => q.Value.ToString());

        if (!query.TryGetValue("vnp_SecureHash", out var secureHash) ||
            !query.TryGetValue("vnp_TxnRef", out var txnRef))
        {
            return BadRequest("Missing signature or txnRef");
        }

        // Verify signature
        var filtered = query
            .Where(kv => kv.Key.StartsWith("vnp_") && kv.Key != "vnp_SecureHash" && kv.Key != "vnp_SecureHashType")
            .OrderBy(kv => kv.Key)
            .ToDictionary(k => k.Key, v => v.Value);

        var rawData = string.Join("&", filtered.Select(kv => $"{kv.Key}={Uri.EscapeDataString(kv.Value)}"));
        var calculatedHash = ComputeHmac512(_vnPaySettings.HashSecret, rawData);
        if (!string.Equals(calculatedHash, secureHash, StringComparison.OrdinalIgnoreCase))
        {
            return BadRequest("Invalid signature");
        }

        var responseCode = query.GetValueOrDefault("vnp_ResponseCode");
        var transStatus = query.GetValueOrDefault("vnp_TransactionStatus");
        var providerTransId = query.GetValueOrDefault("vnp_TransactionNo");

        var paymentInfo = await _service.GetPaymentByProviderRefAsync(txnRef);
        if (paymentInfo == null)
        {
            return NotFound("Payment not found");
        }

        var isSuccess = responseCode == "00" && transStatus == "00";

        var confirm = await _service.ConfirmPaymentAsync(new PaymentConfirmRequest
        {
            PaymentId = paymentInfo.Id,
            Status = isSuccess ? "Succeeded" : "Failed",
            ProviderTransId = providerTransId,
            Note = $"VNPAY rc={responseCode};ts={transStatus}"
        });

        var redirectUrl = string.IsNullOrWhiteSpace(_vnPaySettings.ClientReturnUrl)
            ? $"/payments?status={(isSuccess ? "success" : "fail")}&txnRef={txnRef}"
            : $"{_vnPaySettings.ClientReturnUrl}?status={(isSuccess ? "success" : "fail")}&txnRef={txnRef}&paymentId={paymentInfo.Id}&amount={query.GetValueOrDefault("vnp_Amount")}";

        return Redirect(redirectUrl);
    }

    private static string ComputeHmac512(string key, string rawData)
    {
        var keyBytes = Encoding.UTF8.GetBytes(key);
        var dataBytes = Encoding.UTF8.GetBytes(rawData);
        using var hmac = new HMACSHA512(keyBytes);
        var hash = hmac.ComputeHash(dataBytes);
        return BitConverter.ToString(hash).Replace("-", string.Empty);
    }
}
