import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { MatTabsModule } from '@angular/material/tabs';
import { MatTableModule } from '@angular/material/table';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatSnackBar, MatSnackBarModule } from '@angular/material/snack-bar';
import { MatSelectModule } from '@angular/material/select';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatTooltipModule } from '@angular/material/tooltip';

import { EnrollmentService, CourseOffering, RegisteredCourse } from '../../core/services/enrollment.service';
import { AuthService } from '../../core/services/auth.service';
import { MasterDataService, MasterDataDto } from '../../core/services/master-data.service';

@Component({
  selector: 'app-enrollment',
  standalone: true,
  imports: [
    CommonModule,
    FormsModule,
    MatTabsModule,
    MatTableModule,
    MatButtonModule,
    MatIconModule,
    MatSnackBarModule,
    MatSelectModule,
    MatFormFieldModule,
    MatTooltipModule
  ],
  templateUrl: './enrollment.component.html',
  styleUrls: ['./enrollment.component.scss']
})
export class EnrollmentComponent implements OnInit {
  openCourses: CourseOffering[] = [];
  myCourses: RegisteredCourse[] = [];
  registeredIds = new Set<string>();

  years: MasterDataDto[] = [];
  semesters: MasterDataDto[] = [];
  selectedYearId: string = '';
  selectedSemesterId: string = '';

  openColumns: string[] = ['maLHP', 'tenHP', 'tinChi', 'siSo', 'giangVien', 'lichHoc', 'trangThai', 'action'];
  myColumns: string[] = ['maLHP', 'tenHP', 'tinChi', 'lichHoc', 'trangThai', 'action'];

  currentUser: any;

  constructor(
    private enrollmentService: EnrollmentService,
    private masterDataService: MasterDataService,
    private authService: AuthService,
    private snackBar: MatSnackBar
  ) {
    this.currentUser = this.authService.currentUserValue;
  }

  ngOnInit(): void {
    this.loadMasterData();
    this.loadMyCourses();
  }

  loadMasterData() {
    // Lấy năm/kỳ và thiết lập mặc định ổn định: năm mới nhất, học kỳ đầu danh sách đã sắp xếp
    this.masterDataService.getAcademicYears().subscribe(d => {
      // Sắp xếp giảm dần theo mã/năm để chọn năm mới nhất
      const seen = new Set<string>();
      this.years = [...d]
        .map(y => ({ ...y, ma: y.ma.trim(), ten: y.ten.trim() }))
        .filter(y => {
          const key = y.ma.toUpperCase();
          if (seen.has(key)) return false;
          seen.add(key);
          return true;
        })
        .sort((a, b) => b.ma.localeCompare(a.ma));
      if (this.years.length > 0) {
        this.selectedYearId = this.years[0].ma;
      }
      this.tryLoadOpenCourses();
    });
    this.masterDataService.getSemesters().subscribe(d => {
      // Sắp xếp theo mã để ổn định (tùy cấu trúc maHK: HK1-2025, HK2-2025...)
      this.semesters = [...d].sort((a, b) => a.ma.localeCompare(b.ma));
      if (this.semesters.length > 0) {
        // Ưu tiên học kỳ hiện hành (học kỳ đầu sau sort)
        this.selectedSemesterId = this.semesters[0].ma;
      }
      this.tryLoadOpenCourses();
    });
  }

  private tryLoadOpenCourses() {
    if (this.selectedYearId && this.selectedSemesterId) {
      this.loadOpenCourses();
    }
  }

  loadOpenCourses() {
    this.enrollmentService.getOpenCourses(this.selectedYearId, this.selectedSemesterId).subscribe({
      next: (data) => this.openCourses = data,
      error: (err) => console.error(err)
    });
  }

  loadMyCourses() {
    if (this.currentUser) {
      const studentId = this.currentUser.maSV || this.currentUser.username;
      this.enrollmentService.getMyCourses(studentId).subscribe({
        next: (data) => {
          this.myCourses = data;
          this.registeredIds = new Set<string>(data.map(d => d.maLHP));
        },
        error: (err) => console.error(err)
      });
    }
  }

  register(classId: string) {
    if (!this.currentUser) return;
    const studentId = this.currentUser.maSV || this.currentUser.username;

    const course = this.openCourses.find(c => c.maLHP === classId);
    const reason = course ? this.disableReason(course) : '';
    // Nếu có lý do không thể đăng ký thì thông báo ngay, tránh gọi API vô ích
    if (reason) {
      this.snackBar.open(reason, 'Đóng', { duration: 3000 });
      return;
    }

    this.enrollmentService.registerCourse(studentId, classId).subscribe({
      next: () => {
        this.snackBar.open('Đăng ký thành công!', 'Đóng', { duration: 3000 });
        this.loadOpenCourses();
        this.loadMyCourses();
      },
      error: (err) => {
        this.snackBar.open(err.error?.message || 'Lỗi đăng ký', 'Đóng', { duration: 3000 });
      }
    });
  }

  cancel(classId: string) {
    if (!this.currentUser) return;
    const studentId = this.currentUser.maSV || this.currentUser.username;

    if (!confirm('Bạn có chắc muốn hủy học phần này?')) return;

    this.enrollmentService.cancelRegistration(studentId, classId).subscribe({
      next: (res) => {
        this.snackBar.open('Hủy đăng ký thành công!', 'Đóng', { duration: 3000 });
        this.loadOpenCourses();
        this.loadMyCourses();
      },
      error: (err) => {
        this.snackBar.open(err.error?.message || 'Lỗi hủy đăng ký', 'Đóng', { duration: 3000 });
      }
    });
  }

  // Helpers for status/disable
  statusLabel(course: CourseOffering): string {
    return course.trangThaiLop || 'Sắp khai giảng';
  }

  isPlanned(course: CourseOffering): boolean {
    const code = (course.trangThaiCode || '').toUpperCase();
    const text = this.normalizeStatus(course.trangThaiLop || '');
    return code === 'PLANNED' || text === 'sapkhaigiang';
  }

  isRegistered(course: CourseOffering): boolean {
    return this.registeredIds.has(course.maLHP);
  }

  isFull(course: CourseOffering): boolean {
    return course.siSoHienTai >= course.siSoToiDa;
  }

  disableReason(course: CourseOffering): string {
    if (this.isRegistered(course)) return 'Bạn đã đăng ký lớp này';
    if (!this.isPlanned(course)) return 'Lớp không mở đăng ký';
    if (course.lyDoKhongDangKy) return course.lyDoKhongDangKy;
    if (this.isFull(course)) return 'Lớp đã đầy';
    return '';
  }

  private normalizeStatus(value: string): string {
    if (!value) return '';
    // Chuẩn hóa: bỏ dấu, bỏ khoảng trắng
    const decomposed = value.normalize('NFD').replace(/[\u0300-\u036f]/g, '');
    return decomposed.toLowerCase().replace(/\s+/g, '');
  }
}
