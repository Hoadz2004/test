# EduPro Class Management - Implementation Guide

## ✅ Hoàn thành

### Backend (C#/.NET)
- [x] Migration schema `LopHocPhan` - Thêm 5 cột mới:
  - `NgayBatDau` (DATE nullable)
  - `NgayKetThuc` (DATE nullable) 
  - `SoBuoiHoc` (INT, default 13)
  - `SoBuoiTrongTuan` (TINYINT, default 1)
  - `TrangThaiLop` (NVARCHAR(20), default 'Sắp khai giảng')

- [x] DTOs (ClassDto.cs):
  - `ClassDto` - Bao gồm tất cả 5 trường mới
  - `CreateClassDto` - Bao gồm tất cả 5 trường mới (với default values)
  - `UpdateClassDto` - Bao gồm tất cả 5 trường mới (TrangThaiLop nullable)

- [x] Stored Procedures:
  - `sp_LayDanhSachLopHocPhan_Admin` - SELECT với tất cả trường mới
  - `sp_ThemLopHocPhan` - INSERT với 5 tham số mới + validations
  - `sp_SuaLopHocPhan` - UPDATE với 5 tham số mới + validations

- [x] Service & Repository Layer:
  - `IClassService` & `ClassService` - Không cần thay đổi (delegate tới repository)
  - `ClassRepository` - Dapper tự động map DTO properties với SP parameters

- [x] Controller:
  - `ClassController` - Không cần thay đổi (chỉ chuyển DTOs tới service)

### Frontend (Angular Material)
- [x] Service Interface (class-management.service.ts):
  - Cập nhật `ClassDto` - Thêm 5 properties mới
  - Cập nhật `CreateClassDto` - Thêm 5 properties mới
  - Cập nhật `UpdateClassDto` - Thêm 5 properties mới

- [x] Component TypeScript (class-management.component.ts):
  - Import `MatDatepickerModule` & `MatNativeDateModule`
  - Import `MatTooltipModule`
  - Cập nhật `newClass` initialization với 5 trường mới
  - Cập nhật `editClass()` method
  - Cập nhật `cancelEdit()` method
  - Cập nhật `displayedColumns` array - Thêm cột `ngayBatDau` & `trangThaiLop`

- [x] Component Template (class-management.component.html):
  - Section "1. Thời Gian":
    - Thêm "Ngày Bắt Đầu" date picker
    - Thêm "Ngày Kết Thúc" date picker
  
  - Section "3. Nguồn Lực":
    - Thêm "Số Buổi Học" input (number)
    - Thêm "Số Buổi/Tuần" input (number)
    - Thêm "Trạng Thái Lớp" select dropdown với 4 options:
      - Sắp khai giảng
      - Đang khai giảng
      - Kết thúc
      - Hủy
  
  - Thêm "Ghi Chú" textarea field
  
  - Table columns:
    - Thêm cột "Ngày Bắt Đầu" (format: dd/MM/yyyy)
    - Thêm cột "Trạng Thái" với styling color-coded

- [x] Component Style (class-management.component.scss):
  - Thêm CSS styles cho status badges:
    - `.status-new` - Blue (#e3f2fd)
    - `.status-active` - Green (#e8f5e9)
    - `.status-closed` - Purple (#f3e5f5)
    - `.status-cancel` - Red (#ffebee)

## 📋 Summary of Changes

### Database Schema
```sql
ALTER TABLE LopHocPhan ADD 
    NgayBatDau DATE NULL,
    NgayKetThuc DATE NULL,
    SoBuoiHoc INT DEFAULT 13,
    SoBuoiTrongTuan TINYINT DEFAULT 1,
    TrangThaiLop NVARCHAR(20) DEFAULT N'Sắp khai giảng';
```

### C# DTOs
```csharp
public class ClassDto / CreateClassDto / UpdateClassDto
{
    // ... existing properties ...
    public DateTime? NgayBatDau { get; set; }
    public DateTime? NgayKetThuc { get; set; }
    public int SoBuoiHoc { get; set; } = 13;
    public int SoBuoiTrongTuan { get; set; } = 1;
    public string TrangThaiLop { get; set; } = "Sắp khai giảng";
}
```

### Angular DTOs
```typescript
export interface ClassDto / CreateClassDto / UpdateClassDto
{
    // ... existing properties ...
    ngayBatDau?: Date | null;
    ngayKetThuc?: Date | null;
    soBuoiHoc: number;
    soBuoiTrongTuan: number;
    trangThaiLop: string;
}
```

### Angular Template Form
```html
<mat-form-field>
    <mat-label>Ngày Bắt Đầu</mat-label>
    <input matInput [matDatepicker]="startPicker" [(ngModel)]="newClass.ngayBatDau">
    <mat-datepicker-toggle matSuffix [for]="startPicker"></mat-datepicker-toggle>
    <mat-datepicker #startPicker></mat-datepicker>
</mat-form-field>

<mat-form-field>
    <mat-label>Trạng Thái Lớp</mat-label>
    <mat-select [(ngModel)]="newClass.trangThaiLop">
        <mat-option value="Sắp khai giảng">Sắp khai giảng</mat-option>
        <mat-option value="Đang khai giảng">Đang khai giảng</mat-option>
        <mat-option value="Kết thúc">Kết thúc</mat-option>
        <mat-option value="Hủy">Hủy</mat-option>
    </mat-select>
</mat-form-field>
```

### Angular Table Display
```html
<ng-container matColumnDef="ngayBatDau">
    <th mat-header-cell *matHeaderCellDef>Ngày Bắt Đầu</th>
    <td mat-cell *matCellDef="let element">{{element.ngayBatDau | date: 'dd/MM/yyyy'}}</td>
</ng-container>

<ng-container matColumnDef="trangThaiLop">
    <th mat-header-cell *matHeaderCellDef>Trạng Thái</th>
    <td mat-cell *matCellDef="let element">
        <span [ngClass]="{'status-new': element.trangThaiLop === 'Sắp khai giảng', ...}">
            {{element.trangThaiLop}}
        </span>
    </td>
</ng-container>
```

## 🔄 Data Flow

```
Frontend (Angular)
  ↓ (HTTP POST/PUT)
ClassController
  ↓ (CreateClassDto/UpdateClassDto)
ClassService
  ↓
ClassRepository
  ↓ (Dapper)
sp_ThemLopHocPhan / sp_SuaLopHocPhan
  ↓ (SQL)
Database (LopHocPhan table)
```

## 🧪 Testing Checklist

- [ ] Create new class with all new fields filled
- [ ] Update existing class with new fields
- [ ] Verify date picker works correctly
- [ ] Verify status dropdown displays correct options
- [ ] Verify status badges show correct colors in table
- [ ] Verify conflict detection still works
- [ ] Verify form validation works
- [ ] Test with null dates (should be allowed)
- [ ] Test with different status values
- [ ] Verify database stores values correctly

## 📝 Notes

1. **Date Format**: Angular Material uses `MatNativeDateModule` for date handling. The date is displayed as `dd/MM/yyyy` in the table.

2. **Status Values**: The status dropdown has 4 predefined values. If you need more, update both the dropdown in the template and the backend validation.

3. **Default Values**:
   - `SoBuoiHoc`: 13
   - `SoBuoiTrongTuan`: 1
   - `TrangThaiLop`: "Sắp khai giảng"

4. **Nullable Dates**: `NgayBatDau` and `NgayKetThuc` are nullable, so users can leave them empty.

5. **Styling**: Color-coded status badges make it easy to identify class status at a glance.

## 🚀 Next Steps (Optional Enhancements)

1. Add validation for date ranges (NgayBatDau <= NgayKetThuc)
2. Add status filter in the class list view
3. Add date range filter for schedule management
4. Add export to Excel with new fields
5. Add email notifications when status changes
6. Add audit logging for status changes
