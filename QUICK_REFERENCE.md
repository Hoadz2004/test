# 🚀 EduPro Class Management - Quick Reference Guide

**Last Updated**: December 11, 2025  
**Status**: ✅ Ready for Use

---

## ⚡ Quick Start

### What Changed?
5 new properties added to class management:
1. **NgayBatDau** - Start date
2. **NgayKetThuc** - End date
3. **SoBuoiHoc** - Number of sessions
4. **SoBuoiTrongTuan** - Sessions per week
5. **TrangThaiLop** - Class status

### Files to Know
- Backend DTOs: `EduPro.Domain/Dtos/ClassDto.cs`
- Service: `EduPro.Client/src/app/core/services/class-management.service.ts`
- Component: `EduPro.Client/src/app/features/class-management/`
  - `.ts` (logic)
  - `.html` (form & table)
  - `.scss` (styles)

---

## 📝 Common Tasks

### Run Backend
```powershell
cd D:\EduPro\EduPro.Backend
dotnet build
dotnet run
```

### Run Frontend
```bash
cd D:\EduPro\EduPro.Client
npm install  # if needed
ng serve
```

### Create New Class (API)
```bash
POST http://localhost:5265/api/Class
{
  "maLHP": "20241-IT1110-01",
  "maHP": "IT1110",
  "maHK": "HK1",
  "maNam": "NAM2024",
  "maGV": "GV001",
  "maPhong": "P101",
  "maCa": "CA1",
  "thuTrongTuan": 2,
  "siSoToiDa": 40,
  "ngayBatDau": "2024-12-15",
  "ngayKetThuc": "2025-03-15",
  "soBuoiHoc": 13,
  "soBuoiTrongTuan": 1,
  "trangThaiLop": "Sắp khai giảng",
  "ghiChu": "Lớp chuẩn"
}
```

### Update Class (API)
```bash
PUT http://localhost:5265/api/Class/20241-IT1110-01
{
  "maLHP": "20241-IT1110-01",
  "trangThaiLop": "Đang khai giảng",
  ... other fields ...
}
```

---

## 🎨 UI Components

### Date Picker
```html
<mat-form-field appearance="outline">
    <mat-label>Ngày Bắt Đầu</mat-label>
    <input matInput [matDatepicker]="picker" [(ngModel)]="newClass.ngayBatDau">
    <mat-datepicker-toggle matSuffix [for]="picker"></mat-datepicker-toggle>
    <mat-datepicker #picker></mat-datepicker>
</mat-form-field>
```

### Status Dropdown
```html
<mat-form-field appearance="outline">
    <mat-label>Trạng Thái Lớp</mat-label>
    <mat-select [(ngModel)]="newClass.trangThaiLop">
        <mat-option value="Sắp khai giảng">Sắp khai giảng</mat-option>
        <mat-option value="Đang khai giảng">Đang khai giảng</mat-option>
        <mat-option value="Kết thúc">Kết thúc</mat-option>
        <mat-option value="Hủy">Hủy</mat-option>
    </mat-select>
</mat-form-field>
```

### Status Badge
```html
<span [ngClass]="{
    'status-new': item.trangThaiLop === 'Sắp khai giảng',
    'status-active': item.trangThaiLop === 'Đang khai giảng',
    'status-closed': item.trangThaiLop === 'Kết thúc',
    'status-cancel': item.trangThaiLop === 'Hủy'
}">
    {{item.trangThaiLop}}
</span>
```

---

## 📊 Status Values

| Value | Color | Meaning |
|-------|-------|---------|
| `Sắp khai giảng` | 🔵 Blue | Class coming soon |
| `Đang khai giảng` | 🟢 Green | Class in progress |
| `Kết thúc` | 🟣 Purple | Class finished |
| `Hủy` | 🔴 Red | Class cancelled |

---

## 🔍 Debugging Tips

### TypeScript Compilation Error?
Check that interfaces include all 5 new properties:
```typescript
// ❌ Wrong
export interface CreateClassDto {
    maLHP: string;
    // missing: ngayBatDau, ngayKetThuc, etc.
}

// ✅ Correct
export interface CreateClassDto {
    maLHP: string;
    ngayBatDau?: Date | null;
    ngayKetThuc?: Date | null;
    soBuoiHoc: number;
    soBuoiTrongTuan: number;
    trangThaiLop: string;
}
```

### Date Not Showing in Table?
Ensure pipe is applied:
```html
<!-- ❌ Wrong -->
<td>{{element.ngayBatDau}}</td>

<!-- ✅ Correct -->
<td>{{element.ngayBatDau | date: 'dd/MM/yyyy'}}</td>
```

### Date Picker Not Working?
Ensure modules are imported:
```typescript
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatNativeDateModule } from '@angular/material/core';

imports: [
    MatDatepickerModule,
    MatNativeDateModule
]
```

### Form Submission Error?
Ensure all fields are initialized:
```typescript
newClass: CreateClassDto = {
    maLHP: '', maHP: '', maHK: '', maNam: '', maGV: '', maPhong: '', maCa: '',
    thuTrongTuan: 2, siSoToiDa: 40, ghiChu: '',
    ngayBatDau: null,        // ✅ Must be initialized
    ngayKetThuc: null,       // ✅ Must be initialized
    soBuoiHoc: 13,           // ✅ Must be initialized
    soBuoiTrongTuan: 1,      // ✅ Must be initialized
    trangThaiLop: 'Sắp khai giảng'  // ✅ Must be initialized
};
```

---

## 🧪 Quick Test Cases

### Test 1: Create Class
1. Navigate to "Mở Lớp Mới" tab
2. Fill all fields including new ones
3. Click "MỞ LỚP"
4. Verify success message
5. Verify class appears in list

### Test 2: Edit Class
1. Click edit button on any class
2. Modify date fields
3. Change status
4. Click "CẬP NHẬT"
5. Verify status badge color changes

### Test 3: Date Picker
1. Click calendar icon on date field
2. Select date from picker
3. Verify date appears in input
4. Clear date and verify it becomes empty

### Test 4: Status Badge Color
1. Create/edit class with each status
2. Verify correct color displays:
   - Blue for "Sắp khai giảng"
   - Green for "Đang khai giảng"
   - Purple for "Kết thúc"
   - Red for "Hủy"

---

## 🆘 Troubleshooting

| Issue | Solution |
|-------|----------|
| Date picker blank | Import MatNativeDateModule |
| Form won't submit | Check all required fields initialized |
| Wrong date format | Use pipe: `date: 'dd/MM/yyyy'` |
| Status colors wrong | Check CSS class spelling |
| API error 400 | Verify all DTO properties match |
| Date showing as NaN | Ensure date is Date object, not string |

---

## 📚 Related Documents

- **IMPLEMENTATION_GUIDE.md** - Full implementation details
- **CHANGES_DETAILED.md** - Line-by-line code changes
- **VERIFICATION_CHECKLIST.md** - Testing checklist
- **PROJECT_COMPLETE.md** - Project summary

---

## 🔗 Important Links

### Database Tables
- LopHocPhan (with 5 new columns)

### Stored Procedures
- sp_LayDanhSachLopHocPhan_Admin
- sp_ThemLopHocPhan
- sp_SuaLopHocPhan
- sp_XoaLopHocPhan

### API Endpoints
```
GET    /api/Class?maNam={maNam}&maHK={maHK}
POST   /api/Class
PUT    /api/Class/{id}
DELETE /api/Class/{id}
POST   /api/Class/check-conflict
```

---

## 💡 Pro Tips

1. **Batch Create Classes**: Use PUT endpoint to update multiple classes efficiently
2. **Filter by Status**: Can add status filter to the list view for better UX
3. **Date Validation**: Add min/max date validators to prevent invalid date ranges
4. **Status Workflow**: Implement status transition rules (e.g., only go from draft→active→closed)
5. **Audit Trail**: Log all status changes for compliance

---

## ✅ Checklist Before Push

- [ ] All code compiles without errors
- [ ] No TypeScript errors in console
- [ ] Create new class works
- [ ] Edit class works
- [ ] Status colors display correctly
- [ ] Date picker works
- [ ] Date format is dd/MM/yyyy in table
- [ ] Form validation works
- [ ] No API errors in network tab
- [ ] Documentation updated

---

## 📞 Quick Help

**Forgot what changed?**
→ See CHANGES_DETAILED.md

**Want to test something?**
→ See VERIFICATION_CHECKLIST.md

**Need implementation details?**
→ See IMPLEMENTATION_GUIDE.md

**Want full project overview?**
→ See PROJECT_COMPLETE.md

---

**Questions?** Check the full documentation in the root EduPro folder.

**Last Updated**: Dec 11, 2025  
**Status**: ✅ Production Ready
