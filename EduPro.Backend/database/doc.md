Đồng bộ FE/BE hiện tại

Trạng thái lớp & ngôn ngữ:

BE ClassDto, CreateClassDto default "Sắp khai giảng" (Unicode).
FE constants CLASS_STATUS_OPTIONS dùng đúng dấu, component hiển thị/so sánh trạng thái bằng chuỗi tiếng Việt.
=> Đồng bộ ổn.
Paging server-side:

BE: Lớp, Học phần, Đơn giá đều trả TotalRecords (COUNT OVER). Controller nhận pageNumber/pageSize.
FE: Course/Fee/Class đều gửi pageNumber/pageSize, đọc totalRecords và gắn vào paginator.
=> Đồng bộ tham số và dữ liệu.
Routes/Lazy-load:

ClassManagement chuyển sang import trực tiếp trong AdminModule (AOT), không còn loadComponent JIT.
=> Tránh lỗi compiler.
Form Edit lớp:

Khi “Sửa”, set selectedTabIndex=1, nạp dữ liệu form, bật chọn môn (filteredSubjects).
=> Dòng chảy đã khớp.
Chuỗi tiếng Việt:

Constants, HTML đã chuyển UTF-8.
=> Không còn chữ lỗi font.
Nhược điểm/Cần lưu ý

FE/BE chưa có validation đồng nhất cho các trường lớp (năm học, học kỳ, mã lớp unique) ở FE. BE có check mã lớp? (chưa thấy).
Khi vào edit, danh sách giảng viên/phòng chưa tự filter theo giá trị đang có (chỉ filter theo chọn khoa). Nếu dữ liệu cũ thuộc khoa khác có thể bị rỗng.
Fee lookup: FE lấy getFees(1,200) tạm thời; nếu dữ liệu >200 sẽ thiếu.
Không có loading/error states cho bảng (spinner, thông báo).
Chưa có xác nhận khi rời form đang sửa (mất dữ liệu).
Status options: so sánh chuỗi hard-code; nếu BE đổi chuỗi sẽ lệch (nên chuyển sang enum/code).
Lớp tạo/sửa vẫn cho phép trạng thái tùy ý; chưa có luồng workflow (khai giảng/kết thúc) ràng buộc.
Security: BE controllers mở rộng, chưa thấy auth/role check trong code này (phụ thuộc middleware).
Unit/UI tests chưa có.
Gợi ý phát triển hướng tới sản phẩm thực tế

Loại bỏ phụ thuộc vào chuỗi trạng thái

Dùng code enum trong DB (e.g., Planning, Ongoing, Closed, Canceled) và map ra nhãn tiếng Việt ở FE.
Trả cả statusCode từ API, FE hiển thị label dựa trên map.
Cải thiện luồng Edit

Khi vào edit: tự động chọn faculty, major, subject, lecturer, room dựa trên dữ liệu lớp (điền filtered lists trước).
Thêm guard nếu form dirty hỏi trước khi rời tab.
Loading/Error UX

Thêm spinner cho bảng và form (mat-progress-bar) khi fetch/create/update.
Thông báo lỗi hiển thị message thân thiện, retry.
Validation & Business rules

FE: Reactive form validators cho ngày bắt đầu/kết thúc, sĩ số, mã lớp (pattern).
BE: Ràng buộc mã lớp unique theo học kỳ, kiểm tra sĩ số tối đa ≥ hiện tại, ngày bắt đầu ≤ kết thúc, trạng thái hợp lệ. Trả lỗi chi tiết.
Fee lookup tối ưu

Thêm endpoint GET fee/by-major-semester?maNganh=&maHK= để lấy đúng bản ghi, tránh fetch lớn.
FE: gọi endpoint này khi chọn ngành/học kỳ.
Tối ưu danh sách dữ liệu

Thêm lọc/ tìm kiếm trên bảng lớp (mã lớp, môn, GV).
Thêm sắp xếp server-side nếu dữ liệu lớn.
Workflow & nhật ký

Ghi audit log khi tạo/sửa/xóa lớp, đổi trạng thái; hiển thị trong Audit Logs.
Nếu có phân quyền, ẩn thao tác tùy role.
Kiểm thử & chất lượng

Thêm unit test cho service FE (ClassManagementService) và API controllers.
E2E test đơn giản: tạo lớp, sửa, xóa, kiểm tra paging.
Hiệu năng

Đã có index cho HocPhan/HocPhiCatalog. Xem xét index cho bảng lớp theo (MaHK, MaNam, MaGV, MaPhong).
Cache master data (năm, kỳ, khoa, ngành, môn) trên FE để giảm call lặp.
- Audit Log: thêm index `Indexes/IX_AuditLog_FilterPaging.sql` để tối ưu lọc/paging theo Timestamp/Action/Status/Module/PerformedBy.
Khả năng sử dụng

Cho phép copy mở lớp từ lớp cũ (prefill form).
Cho phép bulk import/xlsx (tuân theo luật validation).
