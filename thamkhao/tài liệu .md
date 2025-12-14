I. WORKFLOW CHI TIẾT THEO MODULE

Mình mô tả theo luồng nghiệp vụ, để sau này bạn map sang API / Stored Procedure cho dễ.

1. Module Tài khoản & phân quyền
Bảng liên quan

TaiKhoan, VaiTro, Quyen, VaiTro_Quyen.

Luồng chính

Khởi tạo hệ thống

Admin tạo sẵn:

Các vai trò: Admin, PhongDaoTao, GiangVien, SinhVien, BanGiamHieu.

Gán quyền (tương ứng các màn hình/menu/API) cho từng vai trò.

Tạo tài khoản tự động khi thêm người dùng

Khi thêm Sinh viên:

Module Sinh viên gọi SP sp_TaoTaiKhoanSinhVien:

Username = mã SV, Password = mặc định (VD: ngày sinh hoặc chuỗi random).

Vai trò = SinhVien.

Link TaiKhoan.MaSV = SinhVien.MaSV.

Khi thêm Giảng viên:

Gọi sp_TaoTaiKhoanGiangVien:

Username = mã GV.

Vai trò = GiangVien.

Đăng nhập

Angular gửi username + password → API Auth → SP kiểm tra:

TaiKhoan.TrangThai = 1.

Lấy danh sách quyền (theo role) → trả về token (JWT) + claims quyền.

Phân quyền trên UI

Front-end Angular đọc role từ token:

Nếu SinhVien: hiển thị menu Đăng ký học phần, Xem điểm, Xem TKB.

Nếu GiangVien: hiển thị Lịch dạy, Nhập điểm…

Nếu PhongDaoTao: hiển thị Danh mục, CTĐT, Mở lớp học phần,…

2. Module Danh mục dùng chung
Bảng

Khoa, Nganh, KhoaTuyenSinh, NamHoc, HocKy, PhongHoc, CaHoc, LoaiHinhDaoTao, LoaiDiem.

Luồng nghiệp vụ

Phòng đào tạo nhập danh mục cơ bản:

Thêm Khoa → Ngành → Khóa tuyển sinh.

Thêm Phòng học, Ca học (tiết 1–3, 4–6,...).

Thêm Năm học, Học kỳ (1, 2, Hè).

Các module khác chỉ được chọn từ danh mục:

Sinh viên khi tạo phải chọn: MaKhoa, MaNganh, MaKhoaTS.

Lớp học phần chọn: MaPhong, MaCaHoc, MaHK, MaNam.

3. Module Quản lý sinh viên
Bảng

SinhVien, SinhVien_TrangThai (lịch sử), liên kết TaiKhoan.

Luồng nghiệp vụ

Thêm sinh viên mới

Phòng đào tạo nhập hồ sơ → SP sp_ThemSinhVien:

Insert SinhVien.

Insert SinhVien_TrangThai với trạng thái “Đang học”.

Gọi sp_TaoTaiKhoanSinhVien.

Sau đó, sinh viên có thể đăng nhập hệ thống.

Cập nhật hồ sơ / thay đổi tình trạng

Khi sinh viên bảo lưu/thôi học:

Cập nhật SinhVien.TrangThai.

Thêm bản ghi mới vào SinhVien_TrangThai.

Module Đăng ký học phần & Xét tốt nghiệp luôn kiểm tra tình trạng:

Nếu TrangThai ≠ “Đang học” → không cho đăng ký, không xét tốt nghiệp.

Tra cứu / báo cáo

Phòng đào tạo tra cứu SV theo Khoa/Ngành/Khóa.

Ban giám hiệu xem thống kê số lượng SV từng Khoa/Ngành.

4. Module Giảng viên
Bảng

GiangVien, liên kết TaiKhoan.

Luồng nghiệp vụ

Thêm giảng viên mới

Thêm vào GiangVien.

Gọi sp_TaoTaiKhoanGiangVien.

Phân công giảng dạy

Khi mở lớp học phần, chọn MaGV phụ trách.

Lịch dạy & nhập điểm của giảng viên dựa trên LopHocPhan.MaGV.

5. Module Chương trình đào tạo & học phần
Bảng

HocPhan

CTDT

CTDT_ChiTiet

TienQuyet

Luồng nghiệp vụ

Định nghĩa học phần

Tạo HocPhan:

Số tín chỉ, số giờ LT/TH, có tính tích lũy, bắt buộc hay tự chọn…

Thiết kế CTĐT theo Ngành + Khóa

Tạo bản ghi CTDT (VD: CTĐT ngành CNTT, khóa 2022).

Thêm chi tiết CTDT_ChiTiet:

Mỗi dòng 1 học phần + học kỳ dự kiến, bắt buộc/tự chọn, nhóm tự chọn.

Khai báo tiên quyết

Bảng TienQuyet:

Học phần A cần qua học phần B.

Module Đăng ký học phần sẽ check bảng này.

Liên kết với đăng ký học phần

Khi sinh viên đăng ký:

Hệ thống tìm CTĐT của ngành + khóa tuyển sinh SV.

Chỉ cho đăng ký học phần thuộc CTĐT (hoặc ngoại lệ nếu có cấu hình).

6. Module Kế hoạch đào tạo – Lớp học phần – TKB
Bảng

NamHoc, HocKy

LopHocPhan

Liên kết HocPhan, GiangVien, PhongHoc, CaHoc.

Luồng nghiệp vụ

Mở học kỳ

Phòng đào tạo chọn Năm hoc + Học kỳ → SP sp_MoHocKy.

Xác định khoảng thời gian:

Ngày bắt đầu – ngày kết thúc học kỳ.

Thời gian cho đăng ký môn học, thời gian thi.

Mở lớp học phần

Chọn danh sách học phần sẽ mở (theo CTĐT).

Mỗi lớp học phần:

Gán MaHP, MaHK, MaNam, MaGV, MaPhong, MaCaHoc, ThuTrongTuan, SiSoToiDa.

Check:

Không trùng phòng, ca, ngày cho 2 lớp khác nhau.

Không trùng lịch 1 giảng viên dạy 2 lớp cùng thời điểm.

Sinh viên xem & đăng ký TKB

Module Đăng ký học phần sẽ đọc từ LopHocPhan để hiển thị.

TKB cá nhân của SV được kết hợp từ:

Các LopHocPhan mà SV đã đăng ký.

7. Module Đăng ký học phần
Bảng

DangKyHocPhan liên kết SinhVien – LopHocPhan.

Luồng nghiệp vụ

Mở/đóng đợt đăng ký

Cấu hình thời gian trong bảng CauHinhHeThong hoặc HocKy.

SP sp_KiemTraThoiGianDangKy sẽ được gọi trước khi đăng ký.

Sinh viên đăng nhập → chọn học kỳ → xem danh sách lớp học phần

Backend:

Dùng SinhVien.MaNganh, MaKhoaTS → lấy CTĐT.

Lọc ra các HocPhan phù hợp học kỳ hiện tại.

Lọc từ LopHocPhan tương ứng học phần đó.

Khi sinh viên bấm Đăng ký lớp học phần

Gọi SP sp_SinhVienDangKyHocPhan(MaSV, MaLHP):

Check 1: Sinh viên còn đang học không?

Check 2: Đã trong thời gian đăng ký?

Check 3: Lớp còn chỗ? (COUNT(*) < SiSoToiDa)

Check 4: Trùng lịch không?

So sánh Thu, CaHoc, MaPhong với các lớp SV đã đăng ký.

Check 5: Điều kiện CTĐT & tiên quyết:

Học phần có trong CTĐT của SV?

Các học phần tiên quyết đã Đạt?

Nếu OK → Insert vào DangKyHocPhan.

Hủy đăng ký

Trong thời gian cho phép:

Gọi SP sp_HuyDangKyHocPhan(MaSV, MaLHP) → set TrangThai = 'Huy' hoặc xóa bản ghi.

8. Module Điểm & Phúc khảo
Bảng

Diem, PhucKhao.

Luồng nghiệp vụ

Khởi tạo dòng điểm

Sau khi kết thúc đăng ký, hệ thống có thể:

Tự động tạo bản ghi Diem cho mỗi DangKyHocPhan hợp lệ.

Hoặc tạo khi lần đầu giảng viên nhập điểm.

Giảng viên nhập điểm

Chọn lớp học phần → SP sp_LayDanhSachSV_CuaLHP(MaLHP).

Nhập điểm thành phần → gọi sp_NhapDiemSinhVien(MaSV, MaLHP, DiemQT, DiemGK, DiemCK):

Tính điểm tổng kết theo công thức từ CauHinhHeThong (VD: 0.3GK + 0.7CK).

Tính điểm chữ, điểm hệ 4.

Cập nhật trạng thái “Đạt/Không đạt”.

Phúc khảo điểm

Sinh viên gửi yêu cầu:

Insert PhucKhao với trạng thái “Chờ xử lý”.

Phòng đào tạo/giảng viên xử lý:

Cập nhật điểm nếu có → log lại thay đổi → set PhucKhao.TrangThai = 'Đã xử lý'.

9. Module Xét tốt nghiệp
Bảng

DieuKienTotNghiep, XetTotNghiep.

Luồng nghiệp vụ

Cấu hình điều kiện tốt nghiệp

Theo Ngành + Khóa:

Số tín chỉ tối thiểu.

Không nợ học phần bắt buộc.

Điểm trung bình tích lũy tối thiểu.

Chạy xét tốt nghiệp

SP sp_XetTotNghiep_NganhKhoa(MaNganh, MaKhoaTS):

Lấy danh sách sinh viên thỏa:

TrangThai = 'Đang học' hoặc ‘Đã hoàn thành’.

Tín chỉ tích lũy ≥ yêu cầu.

Không còn học phần bắt buộc có trạng thái “Không đạt” hoặc “Chưa học”.

Ghi kết quả vào bảng XetTotNghiep.

Xuất danh sách

Dùng để in quyết định, bảng điểm tốt nghiệp.

10. Module Thông báo – Nhật ký hệ thống
Bảng

ThongBao, ThongBao_NguoiNhan, LogHeThong.

Luồng nghiệp vụ

Gửi thông báo

Phòng đào tạo tạo ThongBao (VD: “Lịch đăng ký học phần học kỳ I năm 2025–2026”).

Chọn đối tượng nhận (theo Khoa, Khóa, Ngành…) → insert vào ThongBao_NguoiNhan.

Nhật ký hệ thống

Mỗi thao tác quan trọng (đăng nhập, thay đổi điểm, đăng ký môn học…) ghi 1 dòng vào LogHeThong.







I. WORKFLOW TỔNG HỢP (TẬP TRUNG CÁC MODULE MỚI)
1. Học phí & Công nợ

Ý tưởng:

Mỗi học kỳ, nhà trường tạo đợt thu học phí.

Hệ thống phát sinh tiền phải thu cho từng sinh viên → thành công nợ.

Khi sinh viên nộp tiền → ghi nhận thanh toán; tự động trừ công nợ.

Kết nối với module Đăng ký học phần, Thực tập & ĐATN (có thể chặn nếu còn nợ nhiều).

Workflow:

Phòng đào tạo / tài vụ:

Tạo Đợt thu học phí (HocPhi_DotThu) cho năm học + học kỳ.

Cấu hình mức thu theo ngành/khóa/loại: học phí tín chỉ, phí dịch vụ, phí ĐATN… (HocPhi_MucThu).

Chạy SP phát sinh công nợ:

Dựa trên số tín chỉ sinh viên đăng ký (từ ĐKHP) → tạo bản ghi HocPhi_PhatSinh.

Khi sinh viên nộp tiền:

Ghi nhận HocPhi_ThanhToan.

Cập nhật trạng thái công nợ (đã thanh toán, còn thiếu).

Liên kết:

Khi sinh viên đăng ký học phần / ĐATN / thi lại → có thể check công nợ:

Nếu nợ > hạn mức → không cho đăng ký.

2. Thực tập & Đồ án tốt nghiệp (ĐATN)

Ý tưởng:

Có 2 module: Thực tập và ĐATN.

Có quy trình đăng ký đề tài, phê duyệt, phân giảng viên hướng dẫn, chấm điểm.

Workflow tóm tắt:

Đăng ký thực tập:

Sinh viên tạo yêu cầu thực tập: đơn vị, đề tài, thời gian, người hướng dẫn dự kiến.

Yêu cầu vào bảng ThucTap, trạng thái “Chờ duyệt”.

Cố vấn học tập / Khoa duyệt → cập nhật trạng thái, phân giảng viên hướng dẫn.

Đăng ký ĐATN:

Sinh viên đã đạt điều kiện (tín chỉ, điểm TB, không nợ môn) mới đăng ký ĐATN.

Đề tài vào DoAnTotNghiep, trạng thái “Chờ duyệt”.

Hội đồng/Khoa duyệt → “Đã duyệt”, phân giảng viên hướng dẫn, phản biện.

Chấm điểm:

Giảng viên nhập điểm quá trình, báo cáo, bảo vệ → lưu vào bảng.

Điểm ĐATN có thể cũng phản ánh vào bảng Diem (như một học phần đặc biệt).

3. Lịch thi (chi tiết)

Ý tưởng:

Tách riêng Kỳ thi (Midterm, Final, Thi lại) và Lịch thi cụ thể cho từng LHP.

Có đăng ký thi lại (đặc biệt với môn trượt).

Workflow:

Phòng đào tạo:

Tạo Kỳ thi (KyThi): Học kỳ, loại kỳ thi (Giữa kỳ, Cuối kỳ, Thi lại).

Tạo Lịch thi (LichThi) cho từng LHP: ngày, ca, phòng, giám thị.

Sinh viên:

Tự động có quyền thi lần 1 theo LHP đã đăng ký.

Nếu thi lại:

Đăng ký thi lại → DangKyThiLai → phê duyệt + phát sinh học phí thi lại → lịch thi.

Tích hợp:

Lịch thi hiển thị bên cạnh TKB.

Lịch thi liên kết LopHocPhan + KyThi.

4. Approval / phê duyệt workflow

Áp dụng cho:

Đăng ký ĐATN, Đăng ký thực tập

Phúc khảo điểm

Xin thôi học / bảo lưu

Đăng ký thi lại đặc biệt

Miễn học / miễn thi, v.v.

Ý tưởng:

Tạo bảng phiếu phê duyệt chung:

Loại phiếu, ID tham chiếu đối tượng (ĐATN, Thực tập, Phúc khảo,…), trạng thái, người duyệt.

Mỗi module khi cần phải duyệt sẽ tạo 1 phiếu tương ứng.

5. Báo cáo / thống kê chi tiết

Một số báo cáo:

Học phí:

Công nợ theo Khoa/Ngành/Khoá.

DS SV chưa đóng học phí đúng hạn.

Học tập:

Tỷ lệ Đạt/Không đạt theo môn/Khoa/Học kỳ.

Điểm TB theo khóa, theo ngành.

Thực tập & ĐATN:

DS SV đã/đang/thực tập/hoàn thành.

Tỷ lệ hoàn thành đúng hạn, tỷ lệ đạt ĐATN.

Có thể triển khai bằng VIEW + SELECT / SP cho Angular call.

6. Versioning cho CTĐT

Vấn đề: CTĐT thường được cập nhật theo năm, nhưng SV khóa cũ vẫn học CTĐT cũ.

Ý tưởng:

Mỗi CTĐT có version (số hiệu, ngày hiệu lực).

SinhVien gắn với 1 bản CTĐT cụ thể (MaCTDT).

Khi CTĐT thay đổi:

Tạo bản mới (version +1), bản cũ giữ lại nhưng LaBanHienHanh = 0.

7. Notification (email/SMS/push)

Ta đã có ThongBao / ThongBao_NguoiNhan (in-app).

Bổ sung:

NotificationQueue để xếp hàng gửi email/SMS/push.

Trạng thái: Chờ gửi, Đã gửi, Lỗi.

Ứng dụng ngoài (service) sẽ đọc queue và thực sự gửi.

8. Đa ngôn ngữ

Nếu cần đa ngôn ngữ:

Dùng bảng NgonNgu, ResourceText, ResourceText_Dich.

UI Angular sẽ gọi API lấy dictionary theo ngôn ngữ.

9. Security audit & data retention

Mở rộng LogHeThong: thêm loại hành động, entity, Id.

Thêm bảng ChinhSachLuuTruDuLieu: cấu hình số năm lưu log, soft-delete.

Các job / SP định kỳ:

Xóa hoặc ẩn (anonymize) dữ liệu nhạy cảm sau X năm.