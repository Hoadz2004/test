import { Component, OnInit, ViewChild } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatSnackBar } from '@angular/material/snack-bar';
import { TuitionAdminService, HocPhiCatalog } from '../../services/tuition-admin.service';
import { MasterDataService, MasterDataDto } from '../../../../core/services/master-data.service';
import { MatPaginator, PageEvent } from '@angular/material/paginator';
import { MatTableDataSource } from '@angular/material/table';

@Component({
  selector: 'app-fee-catalog',
  templateUrl: './fee-catalog.component.html',
  styleUrls: ['./fee-catalog.component.scss']
})
export class FeeCatalogComponent implements OnInit {
  form!: FormGroup;
  fees: HocPhiCatalog[] = [];
  majors: MasterDataDto[] = [];
  semesters: MasterDataDto[] = [];
  dataSource = new MatTableDataSource<HocPhiCatalog>([]);
  displayedColumns = ['maNganh', 'maHK', 'donGiaTinChi', 'phuPhiThucHanh', 'giamTruPercent', 'hieuLucTu', 'hieuLucDen', 'ngayHetHan', 'actions'];
  totalRecords = 0;
  pageIndex = 0;
  pageSize = 10;
  pageSizeOptions = [5, 10, 20, 50];
  @ViewChild(MatPaginator) paginator!: MatPaginator;

  constructor(
    private fb: FormBuilder,
    private service: TuitionAdminService,
    private masterService: MasterDataService,
    private snackBar: MatSnackBar
  ) {}

  ngOnInit(): void {
    this.form = this.fb.group({
      id: [0],
      maNganh: ['', Validators.required],
      maHK: ['', Validators.required],
      donGiaTinChi: [500000, [Validators.required, Validators.min(0)]],
      phuPhiThucHanh: [100000, [Validators.required, Validators.min(0)]],
      giamTruPercent: [0],
      hieuLucTu: [new Date(), Validators.required],
      hieuLucDen: [null],
      ngayHetHan: [null]
    });

    this.masterService.getMajors().subscribe(res => this.majors = res);
    this.masterService.getSemesters().subscribe(res => this.semesters = res);
    this.load();
  }

  load() {
    const pageNumber = this.pageIndex + 1;
    this.service.getFees(pageNumber, this.pageSize).subscribe({
      next: res => {
        this.fees = res;
        this.dataSource.data = res;
        this.totalRecords = res.length > 0 && res[0].totalRecords ? res[0].totalRecords : 0;
      },
      error: () => this.snackBar.open('Lỗi tải đơn giá', 'Đóng', { duration: 2500 })
    });
  }

  onPageChange(event: PageEvent) {
    this.pageIndex = event.pageIndex;
    this.pageSize = event.pageSize;
    this.load();
  }

  save() {
    if (this.form.invalid) return;
    this.service.saveFee(this.form.value).subscribe({
      next: () => {
        this.snackBar.open('Lưu đơn giá thành công', 'Đóng', { duration: 2000 });
        this.form.patchValue({ id: 0 });
        this.pageIndex = 0;
        this.load();
      },
      error: () => this.snackBar.open('Lỗi lưu đơn giá', 'Đóng', { duration: 2500 })
    });
  }

  edit(f: HocPhiCatalog) {
    this.form.patchValue(f);
  }

  delete(id: number) {
    if (!confirm('Xóa đơn giá này?')) return;
    this.service.deleteFee(id).subscribe({
      next: () => {
        this.snackBar.open('Đã xóa', 'Đóng', { duration: 2000 });
        this.load();
      },
      error: () => this.snackBar.open('Lỗi xóa đơn giá', 'Đóng', { duration: 2500 })
    });
  }
}
