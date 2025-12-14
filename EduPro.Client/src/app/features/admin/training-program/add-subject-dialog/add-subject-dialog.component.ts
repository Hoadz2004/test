import { Component, Inject, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA, MatDialogModule } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';
import { MatSelectModule } from '@angular/material/select';
import { MatSlideToggleModule } from '@angular/material/slide-toggle';
import { MatSnackBar, MatSnackBarModule } from '@angular/material/snack-bar';
import { TrainingProgramService, AddSubjectRequest } from '../services/training-program.service';
import { MasterDataService } from '../../../../core/services/master-data.service';

@Component({
    selector: 'app-add-subject-dialog',
    standalone: true,
    imports: [
        CommonModule,
        FormsModule,
        MatDialogModule,
        MatFormFieldModule,
        MatInputModule,
        MatButtonModule,
        MatSelectModule,
        MatSlideToggleModule,
        MatSnackBarModule
    ],
    template: `
    <h2 mat-dialog-title>Thêm học phần vào CTDT</h2>
    <mat-dialog-content>
        <div class="form-container">
             <mat-form-field appearance="outline" class="full-width">
                <mat-label>Học phần</mat-label>
                <mat-select [(ngModel)]="data.maHP" required>
                    <mat-option *ngFor="let subject of subjects" [value]="subject.ma">
                        {{ subject.ma }} - {{ subject.ten }}
                    </mat-option>
                </mat-select>
            </mat-form-field>

            <mat-form-field appearance="outline" class="half-width">
                <mat-label>Học kỳ dự kiến</mat-label>
                <input matInput type="number" [(ngModel)]="data.hocKyDuKien" min="1" max="10" required>
            </mat-form-field>

             <div class="half-width toggle-container">
                <mat-slide-toggle [(ngModel)]="data.batBuoc" color="primary">Bắt buộc</mat-slide-toggle>
            </div>

            <mat-form-field appearance="outline" class="full-width" *ngIf="!data.batBuoc">
                <mat-label>Nhóm tự chọn (nếu có)</mat-label>
                <input matInput [(ngModel)]="data.nhomTuChon" placeholder="VD: Tự chọn 1">
            </mat-form-field>
        </div>
    </mat-dialog-content>
    <mat-dialog-actions align="end">
        <button mat-button mat-dialog-close>Hủy</button>
        <button mat-raised-button color="primary" (click)="save()" [disabled]="!data.maHP">Thêm</button>
    </mat-dialog-actions>
  `,
    styles: [`
    .form-container { display: flex; flex-wrap: wrap; gap: 10px; padding-top: 10px; }
    .full-width { width: 100%; }
    .half-width { width: calc(50% - 10px); }
    .toggle-container { display: flex; align-items: center; justify-content: start; }
  `]
})
export class AddSubjectDialogComponent implements OnInit {
    data: AddSubjectRequest = {
        maCTDT: 0,
        maHP: '',
        hocKyDuKien: 1,
        batBuoc: true,
        nhomTuChon: ''
    };

    subjects: any[] = [];

    constructor(
        private dialogRef: MatDialogRef<AddSubjectDialogComponent>,
        @Inject(MAT_DIALOG_DATA) public injectedData: any,
        private service: TrainingProgramService,
        private masterDataService: MasterDataService,
        private snackBar: MatSnackBar
    ) {
        if (injectedData && injectedData.maCTDT) {
            this.data.maCTDT = injectedData.maCTDT;
        }
    }

    ngOnInit() {
        this.masterDataService.getSubjects().subscribe(res => this.subjects = res);
    }

    save() {
        this.service.addSubject(this.data).subscribe({
            next: (res) => {
                this.snackBar.open('Thêm thành công', 'Đóng', { duration: 2000 });
                this.dialogRef.close(true);
            },
            error: (err) => {
                this.snackBar.open('Lỗi: ' + err.error?.message, 'Đóng', { duration: 3000 });
            }
        });
    }
}
