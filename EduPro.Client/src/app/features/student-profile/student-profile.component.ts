import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatDividerModule } from '@angular/material/divider';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatNativeDateModule } from '@angular/material/core';
import { MatSnackBar, MatSnackBarModule } from '@angular/material/snack-bar';
import { StudentService, StudentProfile } from '../../core/services/student.service';
import { ProfileService } from '../profile/services/profile.service';
import { AuthService } from '../../core/services/auth.service';
import { RouterModule } from '@angular/router';

@Component({
    selector: 'app-student-profile',
    standalone: true,
    imports: [
        CommonModule,
        FormsModule,
        MatCardModule,
        MatButtonModule,
        MatIconModule,
        MatDividerModule,
        MatProgressSpinnerModule,
        MatFormFieldModule,
        MatInputModule,
        MatSelectModule,
        MatDatepickerModule,
        MatNativeDateModule,
        MatSnackBarModule,
        RouterModule
    ],
    templateUrl: './student-profile.component.html',
    styleUrl: './student-profile.component.scss'
})
export class StudentProfileComponent implements OnInit {
    profile: StudentProfile | null = null;
    error: string = '';
    isEditing = false;
    saving = false;

    // Edit form data
    editData = {
        email: '',
        dienThoai: '',
        diaChi: '',
        ngaySinh: null as Date | null,
        gioiTinh: ''
    };

    constructor(
        private studentService: StudentService,
        private profileService: ProfileService,
        private authService: AuthService,
        private snackBar: MatSnackBar
    ) { }

    ngOnInit(): void {
        this.loadProfile();
    }

    loadProfile(): void {
        const user = this.authService.currentUserValue;
        if (user && user.maSV) {
            this.studentService.getProfile(user.maSV).subscribe({
                next: (data) => {
                    this.profile = data;
                    this.editData = {
                        email: data.email || '',
                        dienThoai: data.dienThoai || '',
                        diaChi: data.diaChi || '',
                        ngaySinh: data.ngaySinh && !this.isDefaultDate(data.ngaySinh) ? new Date(data.ngaySinh) : null,
                        gioiTinh: data.gioiTinh || ''
                    };
                },
                error: (err) => this.error = 'Không thể tải thông tin sinh viên.'
            });
        } else {
            this.error = 'Không tìm thấy thông tin đăng nhập.';
        }
    }

    // Check if date is default (2000-01-01)
    isDefaultDate(dateStr: string): boolean {
        if (!dateStr) return true;
        const d = new Date(dateStr);
        return d.getFullYear() === 2000 && d.getMonth() === 0 && d.getDate() === 1;
    }

    // Display formatters
    formatDate(dateStr: string | undefined): string {
        if (!dateStr || this.isDefaultDate(dateStr)) return 'Chưa cập nhật';
        const d = new Date(dateStr);
        return d.toLocaleDateString('vi-VN');
    }

    displayValue(val: string | undefined | null): string {
        return val && val.trim() ? val : 'Chưa cập nhật';
    }

    toggleEdit(): void {
        this.isEditing = !this.isEditing;
    }

    saveProfile(): void {
        this.saving = true;
        this.profileService.updateProfile(this.editData).subscribe({
            next: () => {
                this.snackBar.open('Cập nhật thành công!', 'Đóng', { duration: 2000 });
                this.isEditing = false;
                this.saving = false;
                this.loadProfile();
            },
            error: (err) => {
                this.saving = false;
                this.snackBar.open('Lỗi: ' + (err.error?.message || 'Không thể cập nhật'), 'Đóng', { duration: 3000 });
            }
        });
    }
}
