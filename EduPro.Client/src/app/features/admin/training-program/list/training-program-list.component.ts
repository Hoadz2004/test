import { Component, OnInit, ViewChild } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { MatTableModule } from '@angular/material/table';
import { MatPaginator, MatPaginatorModule, PageEvent } from '@angular/material/paginator';
import { MatSortModule } from '@angular/material/sort';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatDialog, MatDialogModule } from '@angular/material/dialog';
import { MatSnackBar, MatSnackBarModule } from '@angular/material/snack-bar';
import { RouterModule } from '@angular/router';
import { TrainingProgramService, CTDT } from '../services/training-program.service';
import { CreateTrainingProgramDialogComponent } from '../create-dialog/create-training-program-dialog.component';

@Component({
    selector: 'app-training-program-list',
    standalone: true,
    imports: [
        CommonModule,
        FormsModule,
        MatTableModule,
        MatPaginatorModule,
        MatSortModule,
        MatInputModule,
        MatButtonModule,
        MatIconModule,
        MatDialogModule,
        MatSnackBarModule,
        RouterModule
    ],
    templateUrl: './training-program-list.component.html',
    styleUrls: ['./training-program-list.component.scss']
})
export class TrainingProgramListComponent implements OnInit {
    displayedColumns: string[] = ['maCTDT', 'tenCTDT', 'tenNganh', 'tenKhoaTS', 'namBanHanh', 'trangThai', 'actions'];
    dataSource: CTDT[] = [];
    totalRecords = 0;
    keyword = '';
    page = 1;
    pageSize = 10;

    @ViewChild(MatPaginator) paginator!: MatPaginator;

    constructor(
        private service: TrainingProgramService,
        private dialog: MatDialog,
        private snackBar: MatSnackBar
    ) { }

    ngOnInit(): void {
        this.loadData();
    }

    loadData(): void {
        this.service.getCTDTs(this.keyword, this.page, this.pageSize).subscribe({
            next: (res: any) => {
                // Handle result which might be array or wrapping object
                // Based on Backend Controller: Ok(new { data = result });
                // result is IEnumerable<CTDTDto> which is array.
                // But Dapper query returns TotalRecords in first row or separate?
                // My SP `sp_Admin_GetCTDT` returns TotalRecords column in each row.

                const data = res.data || [];
                this.dataSource = data;
                if (data.length > 0) {
                    this.totalRecords = data[0].totalRecords;
                } else {
                    this.totalRecords = 0;
                }
            },
            error: (err) => {
                console.error(err);
                this.snackBar.open('Lỗi tải dữ liệu', 'Đóng', { duration: 3000 });
            }
        });
    }

    onPageChange(event: PageEvent): void {
        this.page = event.pageIndex + 1;
        this.pageSize = event.pageSize;
        this.loadData();
    }

    openCreateDialog(): void {
        const dialogRef = this.dialog.open(CreateTrainingProgramDialogComponent, {
            width: '600px'
        });

        dialogRef.afterClosed().subscribe(result => {
            if (result) {
                this.loadData();
            }
        });
    }
}
