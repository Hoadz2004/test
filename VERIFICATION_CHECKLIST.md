# EduPro Class Management - System Verification Checklist

## ✅ Backend Implementation Verification

### Database Schema (SQL Server)
- [x] LopHocPhan table has 5 new columns:
  - [ ] `NgayBatDau` (DATE, nullable)
  - [ ] `NgayKetThuc` (DATE, nullable)
  - [ ] `SoBuoiHoc` (INT, default 13)
  - [ ] `SoBuoiTrongTuan` (TINYINT, default 1)
  - [ ] `TrangThaiLop` (NVARCHAR(20), default 'Sắp khai giảng')

### Stored Procedures
- [ ] sp_LayDanhSachLopHocPhan_Admin - SELECT returns 5 new columns
- [ ] sp_ThemLopHocPhan - INSERT accepts 5 new parameters
- [ ] sp_SuaLopHocPhan - UPDATE accepts 5 new parameters
- [ ] All SPs executed successfully without errors

### C# Layer
- [ ] ClassDto.cs updated with 5 new properties:
  ```csharp
  public DateTime? NgayBatDau { get; set; }
  public DateTime? NgayKetThuc { get; set; }
  public int SoBuoiHoc { get; set; }
  public int SoBuoiTrongTuan { get; set; }
  public string TrangThaiLop { get; set; }
  ```
- [ ] CreateClassDto.cs has same properties with defaults
- [ ] UpdateClassDto.cs has same properties (TrangThaiLop nullable)
- [ ] ClassRepository still works without changes (Dapper maps automatically)
- [ ] No compilation errors in EduPro.Backend.sln

---

## ✅ Frontend Implementation Verification

### Service Layer
- [ ] class-management.service.ts interfaces updated:
  - [ ] ClassDto has 5 new properties
  - [ ] CreateClassDto has 5 new properties
  - [ ] UpdateClassDto has 5 new properties
- [ ] API endpoints work with new data
- [ ] No TypeScript compilation errors

### Component TypeScript
- [ ] Imports added:
  - [ ] MatDatepickerModule
  - [ ] MatNativeDateModule
  - [ ] MatTooltipModule
- [ ] Component decorator includes new modules in imports array
- [ ] displayedColumns updated with 'ngayBatDau' and 'trangThaiLop'
- [ ] newClass initialization includes 5 new fields
- [ ] editClass() method includes new fields
- [ ] cancelEdit() method resets new fields
- [ ] No TypeScript compilation errors

### Component Template (HTML)
- [ ] Form Section "1. Thời Gian" has:
  - [ ] Ngày Bắt Đầu date picker with calendar button
  - [ ] Ngày Kết Thúc date picker with calendar button
- [ ] Form Section "3. Nguồn Lực" has:
  - [ ] Số Buổi Học number input
  - [ ] Số Buổi/Tuần number input
  - [ ] Trạng Thái Lớp select with 4 options
- [ ] Form has Ghi Chú textarea field
- [ ] Table displays 9 columns (added 2):
  - [ ] Mã Lớp
  - [ ] Tên Học Phần
  - [ ] Giảng Viên
  - [ ] Lịch Học
  - [ ] Sĩ Số
  - [x] **Ngày Bắt Đầu** (NEW)
  - [x] **Trạng Thái Lớp** (NEW)
  - [ ] Action buttons
- [ ] Date displayed in table as dd/MM/yyyy format
- [ ] Status badges have correct colors

### Component Style (SCSS)
- [ ] Status badge styles defined:
  - [ ] .status-new (Blue background)
  - [ ] .status-active (Green background)
  - [ ] .status-closed (Purple background)
  - [ ] .status-cancel (Red background)
- [ ] All styles have proper padding and border-radius

---

## 🧪 Functional Testing

### Create New Class Form
- [ ] User can enter all 5 new fields
- [ ] Date pickers open when clicking calendar icons
- [ ] Date format is correct (dd/MM/yyyy)
- [ ] Trạng Thái dropdown shows 4 options
- [ ] Default values are applied correctly
- [ ] Form validation works
- [ ] Submit button creates class successfully
- [ ] Success message appears

### Edit Existing Class
- [ ] Edit button loads class data into form
- [ ] All 5 new fields are populated correctly
- [ ] User can modify all fields
- [ ] Submit button updates class successfully
- [ ] Success message appears
- [ ] Table updates with new values
- [ ] Status badge color updates immediately

### Class List Display
- [ ] Table shows all classes
- [ ] Ngày Bắt Đầu column displays dates correctly
- [ ] Trạng Thái column displays badges with correct colors
- [ ] Status badges are readable
- [ ] Date picker still filters correctly by year/semester

### Date Picker Functionality
- [ ] Date pickers allow null values (can be cleared)
- [ ] Dates are properly formatted
- [ ] Calendar picker opens and closes
- [ ] Selected dates appear in input fields

### Conflict Detection
- [ ] Existing conflict detection still works
- [ ] New fields don't interfere with conflict checks

---

## 🔍 Data Integrity Checks

### Backend Validation
- [ ] Null dates don't cause errors
- [ ] Valid status values are accepted
- [ ] Invalid status values are rejected (if validation added)
- [ ] SoBuoiHoc defaults to 13 if not provided
- [ ] SoBuoiTrongTuan defaults to 1 if not provided
- [ ] TrangThaiLop defaults to "Sắp khai giảng" if not provided

### Database Checks
- [ ] New columns store data correctly
- [ ] Null values in date columns work
- [ ] Default values are applied
- [ ] Data persists across updates

### Type Safety
- [ ] All properties are correctly typed
- [ ] No type mismatches in template binding
- [ ] No null reference errors
- [ ] Date objects handled correctly

---

## 🚀 Performance Tests

- [ ] Form loads quickly with new fields
- [ ] Table renders smoothly with new columns
- [ ] Date pickers don't cause lag
- [ ] No console errors or warnings
- [ ] Network requests complete without delays

---

## 📱 UI/UX Verification

- [ ] Form layout is clean and organized
- [ ] New fields are properly labeled
- [ ] Material Design is consistent
- [ ] Form is responsive on different screen sizes
- [ ] Status badges are visually distinct
- [ ] Table is easy to read with new columns
- [ ] All inputs have proper placeholder/label text
- [ ] Error messages are clear

---

## 🔐 Security Checks

- [ ] No SQL injection vulnerabilities (Dapper handles parameterization)
- [ ] No XSS vulnerabilities in template binding
- [ ] No sensitive data displayed in logs
- [ ] User input is properly escaped
- [ ] Date inputs are validated

---

## 📋 Final Verification

### Build Status
- [ ] Backend builds without errors
- [ ] Frontend builds without errors
- [ ] No TypeScript compilation warnings
- [ ] No ESLint warnings (if enabled)

### Runtime Status
- [ ] Backend API starts without errors
- [ ] Angular app starts without errors
- [ ] No console errors on page load
- [ ] All features work as expected

### Documentation
- [ ] Implementation guide is complete
- [ ] Changes summary is documented
- [ ] Code comments explain new logic
- [ ] Database schema changes are documented

---

## 🎯 Sign-off

- [ ] Development complete
- [ ] Testing complete
- [ ] Code review complete
- [ ] Ready for deployment

**Completed by**: ________________
**Date**: ________________
**Notes**: ________________________________________

---

## 📝 Common Issues and Solutions

### Issue 1: Date Picker Not Showing
**Solution**: Ensure MatNativeDateModule is imported in component

### Issue 2: Status Badge Colors Not Displaying
**Solution**: Check that CSS classes are properly applied with ngClass directive

### Issue 3: Form Validation Errors
**Solution**: Verify all required properties are initialized in newClass object

### Issue 4: Dates Not Saving to Database
**Solution**: Check that database columns accept DATE data type

### Issue 5: Type Errors in TypeScript
**Solution**: Update interfaces in class-management.service.ts with all new properties

---

## 🔄 Rollback Procedure (if needed)

1. **SQL**: Remove the 5 new columns from LopHocPhan table
2. **C#**: Revert ClassDto, CreateClassDto, UpdateClassDto to previous version
3. **Angular**: Remove date picker imports and new form fields
4. **Angular**: Remove new table columns
5. **Angular**: Update service interfaces to remove new properties

---

## 📞 Support

For issues with implementation:
1. Check this checklist for missing steps
2. Review IMPLEMENTATION_GUIDE.md
3. Review CHANGES_DETAILED.md
4. Check database schema matches
5. Verify all DTOs are updated consistently
