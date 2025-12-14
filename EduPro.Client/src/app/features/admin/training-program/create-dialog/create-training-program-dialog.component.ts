import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { MatDialogRef, MatDialogModule } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';
import { MatSelectModule } from '@angular/material/select';
import { MatSnackBar, MatSnackBarModule } from '@angular/material/snack-bar';
import { TrainingProgramService, CreateCTDTRequest } from '../services/training-program.service';
import { MasterDataService } from '../../../../core/services/master-data.service';

@Component({
    selector: 'app-create-training-program-dialog',
    standalone: true,
    imports: [
        CommonModule,
        FormsModule,
        MatDialogModule,
        MatFormFieldModule,
        MatInputModule,
        MatButtonModule,
        MatSelectModule,
        MatSnackBarModule
    ],
    template: `
    <h2 mat-dialog-title>Tạo mới Chương trình đào tạo</h2>
    <mat-dialog-content>
        <div class="form-container">
            <mat-form-field appearance="outline" class="full-width">
                <mat-label>Tên CTDT</mat-label>
                <input matInput [(ngModel)]="data.tenCTDT" required>
            </mat-form-field>

            <mat-form-field appearance="outline" class="full-width">
                <mat-label>Năm ban hành</mat-label>
                <input matInput type="number" [(ngModel)]="data.namBanHanh" required>
            </mat-form-field>

            <mat-form-field appearance="outline" class="half-width">
                <mat-label>Ngành</mat-label>
                <mat-select [(ngModel)]="data.maNganh" required>
                    <mat-option *ngFor="let major of majors" [value]="major.ma">
                        {{ major.ten }}
                    </mat-option>
                </mat-select>
            </mat-form-field>

            <mat-form-field appearance="outline" class="half-width">
                <mat-label>Khóa tuyển sinh</mat-label>
                <mat-select [(ngModel)]="data.maKhoaTS" required>
                    <mat-option *ngFor="let cohort of cohorts" [value]="cohort.ma">
                        {{ cohort.ten }}
                    </mat-option>
                </mat-select>
            </mat-form-field>

             <mat-form-field appearance="outline" class="full-width">
                <mat-label>Trạng thái</mat-label>
                <mat-select [(ngModel)]="data.trangThai" required>
                    <mat-option [value]="1">Hoạt động</mat-option>
                    <mat-option [value]="0">Nháp</mat-option>
                </mat-select>
            </mat-form-field>
        </div>
    </mat-dialog-content>
    <mat-dialog-actions align="end">
        <button mat-button mat-dialog-close>Hủy</button>
        <button mat-raised-button color="primary" (click)="save()" [disabled]="isValid()">Lưu</button>
    </mat-dialog-actions>
  `,
    styles: [`
    .form-container { display: flex; flex-wrap: wrap; gap: 10px; padding-top: 10px; }
    .full-width { width: 100%; }
    .half-width { width: calc(50% - 10px); }
  `]
})
export class CreateTrainingProgramDialogComponent {
    data: CreateCTDTRequest = {
        maNganh: '',
        maKhoaTS: '',
        tenCTDT: '',
        namBanHanh: new Date().getFullYear(),
        trangThai: 1
    };

    majors: any[] = [];
    cohorts: any[] = [];

    constructor(
        private dialogRef: MatDialogRef<CreateTrainingProgramDialogComponent>,
        private service: TrainingProgramService,
        private masterDataService: MasterDataService,
        private snackBar: MatSnackBar
    ) {
        this.loadMasterData();
    }

    loadMasterData() {
        this.masterDataService.getMajors().subscribe(res => this.majors = res);
        this.masterDataService.getAdmissionBatches().subscribe(res => this.cohorts = res);
    }

    isValid() {
        return !this.data.tenCTDT || !this.data.maNganh || !this.data.maKhoaTS;
    }

    save() {
        this.service.createCTDT(this.data).subscribe({
            next: (res) => {
                this.snackBar.open('Tạo thành công', 'Đóng', { duration: 2000 });
                this.dialogRef.close(true);
            },
            error: (err) => {
                this.snackBar.open('Lỗi: ' + (err.error?.message || 'Không thể tạo'), 'Đóng', { duration: 3000 });
            }
        });
    }
}
