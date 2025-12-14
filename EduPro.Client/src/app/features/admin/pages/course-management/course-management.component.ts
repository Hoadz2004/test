import { Component, OnInit, ViewChild } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatSnackBar } from '@angular/material/snack-bar';
import { TuitionAdminService, HocPhanAdmin } from '../../services/tuition-admin.service';
import { MatPaginator, PageEvent } from '@angular/material/paginator';
import { MatTableDataSource } from '@angular/material/table';

@Component({
  selector: 'app-course-management',
  templateUrl: './course-management.component.html',
  styleUrls: ['./course-management.component.scss']
})
export class CourseManagementComponent implements OnInit {
  courses: HocPhanAdmin[] = [];
  form!: FormGroup;
  dataSource = new MatTableDataSource<HocPhanAdmin>([]);
  displayedColumns = ['maHP', 'tenHP', 'soTinChi', 'actions'];
  totalRecords = 0;
  pageIndex = 0;
  pageSize = 10;
  pageSizeOptions = [5, 10, 20, 50];
  @ViewChild(MatPaginator) paginator!: MatPaginator;

  constructor(
    private fb: FormBuilder,
    private service: TuitionAdminService,
    private snackBar: MatSnackBar
  ) {}

  ngOnInit(): void {
    this.form = this.fb.group({
      maHP: ['', Validators.required],
      tenHP: ['', Validators.required],
      soTinChi: [3, [Validators.required, Validators.min(1)]],
      loaiHocPhan: ['Lý thuyết'],
      batBuoc: [true],
      soTietLT: [30],
      soTietTH: [0]
    });
    this.load();
  }

  load() {
    const pageNumber = this.pageIndex + 1;
    this.service.getCourses(pageNumber, this.pageSize).subscribe({
      next: res => {
        this.courses = res;
        this.dataSource.data = res;
        this.totalRecords = res.length > 0 && res[0].totalRecords ? res[0].totalRecords : 0;
      },
      error: () => this.snackBar.open('Lỗi tải học phần', 'Đóng', { duration: 2500 })
    });
  }

  onPageChange(event: PageEvent) {
    this.pageIndex = event.pageIndex;
    this.pageSize = event.pageSize;
    this.load();
  }

  save() {
    if (this.form.invalid) return;
    this.service.saveCourse(this.form.value).subscribe({
      next: () => {
        this.snackBar.open('Lưu học phần thành công', 'Đóng', { duration: 2000 });
        this.form.reset({
          soTinChi: 3,
          loaiHocPhan: 'Lý thuyết',
          batBuoc: true,
          soTietLT: 30,
          soTietTH: 0
        });
        this.pageIndex = 0;
        this.load();
      },
      error: () => this.snackBar.open('Lỗi lưu học phần', 'Đóng', { duration: 2500 })
    });
  }

  edit(c: HocPhanAdmin) {
    this.form.patchValue(c);
  }

  delete(maHP: string) {
    if (!confirm('Xóa học phần này?')) return;
    this.service.deleteCourse(maHP).subscribe({
      next: () => {
        this.snackBar.open('Đã xóa', 'Đóng', { duration: 2000 });
        this.load();
      },
      error: () => this.snackBar.open('Lỗi xóa học phần', 'Đóng', { duration: 2500 })
    });
  }
}
