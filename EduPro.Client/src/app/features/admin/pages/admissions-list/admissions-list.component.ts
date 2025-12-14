import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormBuilder } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatSelectModule } from '@angular/material/select';
import { MatInputModule } from '@angular/material/input';
import { MatTableModule } from '@angular/material/table';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatPaginatorModule, PageEvent } from '@angular/material/paginator';
import { FormsModule } from '@angular/forms';
import { MatSnackBar, MatSnackBarModule } from '@angular/material/snack-bar';
import { Router, RouterModule } from '@angular/router';
import { AdmissionsService, AdmissionDto } from '../../../admissions/admissions.service';
import { MasterDataService, MasterDataDto } from '../../../../core/services/master-data.service';

@Component({
  selector: 'app-admissions-list',
  standalone: true,
  imports: [
    CommonModule,
    ReactiveFormsModule,
    FormsModule,
    MatFormFieldModule,
    MatSelectModule,
    MatInputModule,
    MatTableModule,
    MatButtonModule,
    MatIconModule,
    MatSnackBarModule,
    RouterModule,
    MatPaginatorModule
  ],
  templateUrl: './admissions-list.component.html',
  styleUrls: ['./admissions-list.component.scss']
})
export class AdmissionsListComponent implements OnInit {
  filterForm = this.fb.group({
    maHK: [''],
    maNganh: [''],
    trangThai: ['']
  });

  admissions: AdmissionDto[] = [];
  totalRecords = 0;
  pageIndex = 0;
  pageSize = 20;
  pageSizeOptions: number[] = [10, 20, 50, 100];
  majors: MasterDataDto[] = [];
  semesters: MasterDataDto[] = [];

  statuses = [
    'Đã nộp',
    'Đủ hồ sơ',
    'Thiếu hồ sơ',
    'Mời phỏng vấn',
    'Đủ điều kiện',
    'Đậu',
    'Rớt',
    'Đã nhập học',
    'Chưa đạt'
  ];

  displayedColumns = ['maTraCuu', 'fullName', 'maNganh', 'maHK', 'trangThai', 'ngayNop', 'actions'];

  constructor(
    private fb: FormBuilder,
    private service: AdmissionsService,
    private master: MasterDataService,
    private snack: MatSnackBar,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.master.getMajors().subscribe(res => this.majors = res);
    this.master.getSemesters().subscribe(res => this.semesters = res);
    this.load();
  }

  load() {
    const filter = {
      maHK: this.filterForm.value.maHK || undefined,
      maNganh: this.filterForm.value.maNganh || undefined,
      trangThai: this.filterForm.value.trangThai || undefined,
      pageNumber: this.pageIndex + 1,
      pageSize: this.pageSize
    };
    this.service.list(filter).subscribe(res => {
      this.admissions = res;
      if (res && res.length > 0 && res[0].totalRecords) {
        this.totalRecords = res[0].totalRecords!;
      } else {
        this.totalRecords = 0;
      }
    });
  }

  updateStatus(row: AdmissionDto) {
    this.service.updateStatus({ id: row.id, trangThai: row.trangThai, ghiChu: row.ghiChu }).subscribe({
      next: () => {
        this.snack.open('Đã lưu và gửi email.', 'Đóng', { duration: 2500 });
        this.load();
      },
      error: () => this.snack.open('Lưu trạng thái thất bại.', 'Đóng', { duration: 2500 })
    });
  }

  viewDetail(row: AdmissionDto) {
    this.router.navigate(['/admin/admissions', row.maTraCuu]);
  }

  pageChange(event: PageEvent) {
    this.pageIndex = event.pageIndex;
    this.pageSize = event.pageSize;
    this.load();
  }
}
