using System;
using System.Threading.Tasks;
using EduPro.Application.Class.Services;
using EduPro.Domain.Dtos;
using EduPro.Domain.Interfaces;
using Xunit;

namespace EduPro.Application.Tests;

public class ClassServiceTests
{
    private class FakeClassRepository : IClassRepository
    {
        public Task CreateClassAsync(CreateClassDto classDto) => Task.CompletedTask;
        public Task DeleteClassAsync(string classId) => Task.CompletedTask;
        public Task<IEnumerable<ClassDto>> GetClassesAsync(string? academicYearId, string? semesterId, int pageNumber, int pageSize) =>
            Task.FromResult<IEnumerable<ClassDto>>(Array.Empty<ClassDto>());
        public Task UpdateClassAsync(UpdateClassDto classDto) => Task.CompletedTask;
        public Task<ConflictCheckResult> CheckConflictAsync(ConflictCheckRequest request) =>
            Task.FromResult(new ConflictCheckResult { IsConflict = false });
        public Task<bool> IsClassExistsAsync(string classId) => Task.FromResult(false);
        public Task<int> GetCurrentEnrollmentAsync(string classId) => Task.FromResult(0);
    }

    private readonly ClassService _service = new(new FakeClassRepository());

    [Fact]
    public async Task CreateClass_ShouldThrow_WhenCapacityNonPositive()
    {
        var dto = new CreateClassDto
        {
            MaLHP = "L1",
            MaHP = "HP1",
            MaHK = "HK1",
            MaNam = "N1",
            MaGV = "GV1",
            MaPhong = "P1",
            MaCa = "C1",
            ThuTrongTuan = 2,
            SiSoToiDa = 0, // invalid
            SoBuoiHoc = 10,
            SoBuoiTrongTuan = 1,
            TrangThaiLop = "Sắp khai giảng"
        };

        await Assert.ThrowsAsync<ArgumentException>(() => _service.CreateClassAsync(dto));
    }

    [Fact]
    public async Task UpdateClass_ShouldThrow_WhenEndDateBeforeStartDate()
    {
        var dto = new UpdateClassDto
        {
            MaLHP = "L1",
            MaHP = "HP1",
            MaHK = "HK1",
            MaNam = "N1",
            MaGV = "GV1",
            MaPhong = "P1",
            MaCa = "C1",
            ThuTrongTuan = 2,
            SiSoToiDa = 10,
            SoBuoiHoc = 10,
            SoBuoiTrongTuan = 1,
            NgayBatDau = new DateTime(2025, 12, 31),
            NgayKetThuc = new DateTime(2025, 12, 1),
            TrangThaiLop = "Sắp khai giảng"
        };

        await Assert.ThrowsAsync<ArgumentException>(() => _service.UpdateClassAsync(dto));
    }
}
