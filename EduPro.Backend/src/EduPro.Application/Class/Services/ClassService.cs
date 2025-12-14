using System.Collections.Generic;
using System.Linq;
using System.Globalization;
using System.Text;
using EduPro.Domain.Dtos;
using EduPro.Domain.Interfaces;

namespace EduPro.Application.Class.Services;

public class ClassService : IClassService
{
    private readonly IClassRepository _classRepository;

    private static readonly Dictionary<string, string> StatusLabelByCode = new(StringComparer.OrdinalIgnoreCase)
    {
        ["PLANNED"] = "Sắp khai giảng",
        ["ONGOING"] = "Đang học",
        ["CLOSED"] = "Kết thúc",
        ["CANCELED"] = "Hủy"
    };

    private static readonly Dictionary<string, string> StatusCodeByLabel =
        StatusLabelByCode.ToDictionary(kvp => kvp.Value, kvp => kvp.Key, StringComparer.OrdinalIgnoreCase);

    public ClassService(IClassRepository classRepository)
    {
        _classRepository = classRepository;
    }

    public async Task<IEnumerable<ClassDto>> GetClassesAsync(string? academicYearId, string? semesterId, int pageNumber, int pageSize)
    {
        var data = (await _classRepository.GetClassesAsync(academicYearId, semesterId, pageNumber, pageSize)).ToList();
        foreach (var item in data)
        {
            item.TrangThaiCode = ToStatusCode(item.TrangThaiCode ?? item.TrangThaiLop);
            item.TrangThaiLop = ToStatusLabel(item.TrangThaiLop);
        }
        return data;
    }

    public async Task CreateClassAsync(CreateClassDto classDto)
    {
        NormalizeStatus(classDto);
        ValidateClassDto(classDto);

        if (await _classRepository.IsClassExistsAsync(classDto.MaLHP))
        {
            throw new ArgumentException("MÃ£ lá»›p Ä‘Ã£ tá»“n táº¡i.");
        }

        var conflict = await _classRepository.CheckConflictAsync(ToConflictRequest(classDto));
        if (conflict.IsConflict)
        {
            var msg = string.IsNullOrWhiteSpace(conflict.ConflictMessage)
                ? "Xung Ä‘á»™t lá»‹ch (phÃ²ng/giáº£ng viÃªn) cho ca há»c nÃ y."
                : conflict.ConflictMessage;
            throw new ArgumentException(msg);
        }

        await _classRepository.CreateClassAsync(classDto);
    }

    public async Task UpdateClassAsync(UpdateClassDto classDto)
    {
        NormalizeStatus(classDto);
        ValidateClassDto(classDto);

        // Ensure capacity is not less than current enrollment
        var currentEnrollment = await _classRepository.GetCurrentEnrollmentAsync(classDto.MaLHP);
        if (classDto.SiSoToiDa < currentEnrollment)
        {
            throw new ArgumentException($"SÄ© sá»‘ tá»‘i Ä‘a ({classDto.SiSoToiDa}) nhá» hÆ¡n sá»‘ sinh viÃªn Ä‘Ã£ Ä‘Äƒng kÃ½ ({currentEnrollment}).");
        }

        var conflict = await _classRepository.CheckConflictAsync(ToConflictRequest(classDto));
        if (conflict.IsConflict)
        {
            var msg = string.IsNullOrWhiteSpace(conflict.ConflictMessage)
                ? "Xung Ä‘á»™t lá»‹ch (phÃ²ng/giáº£ng viÃªn) cho ca há»c nÃ y."
                : conflict.ConflictMessage;
            throw new ArgumentException(msg);
        }

        await _classRepository.UpdateClassAsync(classDto);
    }

    public async Task<ConflictCheckResult> CheckConflictAsync(ConflictCheckRequest request)
    {
        return await _classRepository.CheckConflictAsync(request);
    }

    public async Task DeleteClassAsync(string classId)
    {
        await _classRepository.DeleteClassAsync(classId);
    }

    private static void ValidateClassDto(CreateClassDto dto)
    {
        if (dto.SiSoToiDa <= 0) throw new ArgumentException("SÄ© sá»‘ tá»‘i Ä‘a pháº£i lá»›n hÆ¡n 0.");
        if (dto.SoBuoiHoc <= 0) throw new ArgumentException("Sá»‘ buá»•i há»c pháº£i lá»›n hÆ¡n 0.");
        if (dto.SoBuoiTrongTuan <= 0 || dto.SoBuoiTrongTuan > 7) throw new ArgumentException("Sá»‘ buá»•i/tuáº§n pháº£i trong khoáº£ng 1-7.");

        if (dto.NgayBatDau.HasValue && dto.NgayKetThuc.HasValue && dto.NgayBatDau.Value > dto.NgayKetThuc.Value)
        {
            throw new ArgumentException("NgÃ y báº¯t Ä‘áº§u pháº£i trÆ°á»›c hoáº·c báº±ng ngÃ y káº¿t thÃºc.");
        }
    }

    private static void ValidateClassDto(UpdateClassDto dto)
    {
        if (dto.SiSoToiDa <= 0) throw new ArgumentException("SÄ© sá»‘ tá»‘i Ä‘a pháº£i lá»›n hÆ¡n 0.");
        if (dto.SoBuoiHoc <= 0) throw new ArgumentException("Sá»‘ buá»•i há»c pháº£i lá»›n hÆ¡n 0.");
        if (dto.SoBuoiTrongTuan <= 0 || dto.SoBuoiTrongTuan > 7) throw new ArgumentException("Sá»‘ buá»•i/tuáº§n pháº£i trong khoáº£ng 1-7.");

        if (dto.NgayBatDau.HasValue && dto.NgayKetThuc.HasValue && dto.NgayBatDau.Value > dto.NgayKetThuc.Value)
        {
            throw new ArgumentException("NgÃ y báº¯t Ä‘áº§u pháº£i trÆ°á»›c hoáº·c báº±ng ngÃ y káº¿t thÃºc.");
        }
    }

    private static ConflictCheckRequest ToConflictRequest(CreateClassDto dto) =>
        new ConflictCheckRequest
        {
            MaLHP = dto.MaLHP,
            MaNam = dto.MaNam,
            MaHK = dto.MaHK,
            Thu = dto.ThuTrongTuan,
            MaCa = dto.MaCa,
            MaPhong = dto.MaPhong,
            MaGV = dto.MaGV
        };

    private static ConflictCheckRequest ToConflictRequest(UpdateClassDto dto) =>
        new ConflictCheckRequest
        {
            MaLHP = dto.MaLHP,
            MaNam = dto.MaNam,
            MaHK = dto.MaHK,
            Thu = dto.ThuTrongTuan,
            MaCa = dto.MaCa,
            MaPhong = dto.MaPhong,
            MaGV = dto.MaGV
        };

    private static string ToStatusLabel(string? codeOrLabel)
    {
        if (string.IsNullOrWhiteSpace(codeOrLabel)) return StatusLabelByCode["PLANNED"];
        if (StatusLabelByCode.TryGetValue(codeOrLabel.Trim(), out var label)) return label;
        return codeOrLabel;
    }

    private static string ToStatusCode(string? codeOrLabel)
    {
        if (string.IsNullOrWhiteSpace(codeOrLabel)) return "PLANNED";
        var trimmed = codeOrLabel.Trim();
        if (StatusLabelByCode.ContainsKey(trimmed)) return trimmed.ToUpperInvariant();
        if (StatusCodeByLabel.TryGetValue(trimmed, out var code)) return code;
        // Thử so khớp không dấu để tránh lỗi encoding hoặc thiếu dấu
        var normalized = RemoveDiacritics(trimmed).ToLowerInvariant().Replace(" ", string.Empty);
        if (normalized == "sapkhaigiang") return "PLANNED";
        if (normalized == "danghoc" || normalized == "dangkhaigiang") return "ONGOING";
        if (normalized == "ketthuc") return "CLOSED";
        if (normalized == "huy") return "CANCELED";
        return "PLANNED";
    }

    private static string RemoveDiacritics(string input)
    {
        var normalizedString = input.Normalize(NormalizationForm.FormD);
        var stringBuilder = new StringBuilder();

        foreach (var c in normalizedString)
        {
            var unicodeCategory = CharUnicodeInfo.GetUnicodeCategory(c);
            if (unicodeCategory != UnicodeCategory.NonSpacingMark)
            {
                stringBuilder.Append(c);
            }
        }

        return stringBuilder.ToString().Normalize(NormalizationForm.FormC);
    }

    private static void NormalizeStatus(CreateClassDto dto)
    {
        dto.TrangThaiCode = ToStatusCode(dto.TrangThaiCode ?? dto.TrangThaiLop);
        dto.TrangThaiLop = ToStatusLabel(dto.TrangThaiLop ?? dto.TrangThaiCode);
    }

    private static void NormalizeStatus(UpdateClassDto dto)
    {
        dto.TrangThaiCode = ToStatusCode(dto.TrangThaiCode ?? dto.TrangThaiLop);
        dto.TrangThaiLop = ToStatusLabel(dto.TrangThaiLop ?? dto.TrangThaiCode);
    }
}




