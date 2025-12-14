import { Component, Inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA, MatDialogModule } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatSelectModule } from '@angular/material/select';
import { MatButtonModule } from '@angular/material/button';
import { MatSnackBar, MatSnackBarModule } from '@angular/material/snack-bar';
import { TrainingProgramService, AddPrerequisiteRequest } from '../services/training-program.service';

@Component({
    selector: 'app-add-prerequisite-dialog',
    standalone: true,
    imports: [
        CommonModule,
        FormsModule,
        MatDialogModule,
        MatFormFieldModule,
        MatSelectModule,
        MatButtonModule,
        MatSnackBarModule
    ],
    template: `
    <h2 mat-dialog-title>Thiết lập Tiên quyết cho {{ dataName }}</h2>
    <mat-dialog-content>
        <div class="form-container">
             <mat-form-field appearance="outline" class="full-width">
                <mat-label>Môn học tiên quyết</mat-label>
                <mat-select [(ngModel)]="data.maHP_TienQuyet" required>
                    <mat-option *ngFor="let subject of availableSubjects" [value]="subject.maHP">
                        {{ subject.maHP }} - {{ subject.tenHP }}
                    </mat-option>
                </mat-select>
            </mat-form-field>
            <p class="hint">Sinh viên phải qua môn này trước khi đăng ký {{ dataName }}</p>
        </div>
    </mat-dialog-content>
    <mat-dialog-actions align="end">
        <button mat-button mat-dialog-close>Hủy</button>
        <button mat-raised-button color="primary" (click)="save()" [disabled]="!data.maHP_TienQuyet">Lưu</button>
    </mat-dialog-actions>
  `,
    styles: [`
    .form-container { padding-top: 10px; }
    .full-width { width: 100%; }
    .hint { color: #666; font-size: 13px; margin: 0; font-style: italic;}
  `]
})
export class AddPrerequisiteDialogComponent {
    data: AddPrerequisiteRequest = {
        maHP: '',
        maHP_TienQuyet: ''
    };
    dataName = '';
    availableSubjects: any[] = [];

    constructor(
        private dialogRef: MatDialogRef<AddPrerequisiteDialogComponent>,
        @Inject(MAT_DIALOG_DATA) public injectedData: any,
        private service: TrainingProgramService,
        private snackBar: MatSnackBar
    ) {
        if (injectedData) {
            this.data.maHP = injectedData.maHP;
            this.dataName = injectedData.tenHP;
            this.availableSubjects = injectedData.availableSubjects || [];
        }
    }

    save() {
        this.service.addPrerequisite(this.data).subscribe({
            next: (res) => {
                this.snackBar.open('Thiết lập thành công', 'Đóng', { duration: 2000 });
                this.dialogRef.close(true);
            },
            error: (err) => {
                this.snackBar.open('Lỗi: ' + err.error?.message, 'Đóng', { duration: 3000 });
            }
        });
    }
}
