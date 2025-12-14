import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { MatCardModule } from '@angular/material/card';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';
import { MatSelectModule } from '@angular/material/select';
import { MatSnackBar, MatSnackBarModule } from '@angular/material/snack-bar';
import { MatIconModule } from '@angular/material/icon';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatNativeDateModule } from '@angular/material/core';
import { ProfileService, SinhVienProfile } from '../services/profile.service';

@Component({
    selector: 'app-profile',
    standalone: true,
    imports: [
        CommonModule, FormsModule,
        MatCardModule, MatFormFieldModule, MatInputModule, MatButtonModule,
        MatSelectModule, MatSnackBarModule, MatIconModule,
        MatDatepickerModule, MatNativeDateModule
    ],
    templateUrl: './profile.component.html',
    styleUrls: ['./profile.component.css']
})
export class ProfileComponent implements OnInit {
    profile: SinhVienProfile | null = null;
    loading = true;
    saving = false;
    isEditing = false;

    // Edit form
    editData = {
        email: '',
        dienThoai: '',
        diaChi: '',
        ngaySinh: null as Date | null,
        gioiTinh: ''
    };

    constructor(
        private profileService: ProfileService,
        private router: Router,
        private snackBar: MatSnackBar
    ) { }

    ngOnInit(): void {
        this.loadProfile();
    }

    loadProfile(): void {
        this.loading = true;
        this.profileService.getMyProfile().subscribe({
            next: (data) => {
                this.profile = data;
                this.editData = {
                    email: data.email || '',
                    dienThoai: data.dienThoai || '',
                    diaChi: data.diaChi || '',
                    ngaySinh: data.ngaySinh ? new Date(data.ngaySinh) : null,
                    gioiTinh: data.gioiTinh || ''
                };
                this.loading = false;
            },
            error: (err) => {
                this.loading = false;
                this.snackBar.open('Lỗi tải profile: ' + (err.error?.message || 'Không xác định'), 'Đóng', { duration: 3000 });
            }
        });
    }

    toggleEdit(): void {
        this.isEditing = !this.isEditing;
    }

    saveProfile(): void {
        this.saving = true;
        this.profileService.updateProfile(this.editData).subscribe({
            next: () => {
                this.snackBar.open('Cập nhật profile thành công!', 'Đóng', { duration: 2000 });
                this.isEditing = false;
                this.saving = false;
                this.loadProfile();
            },
            error: (err) => {
                this.saving = false;
                this.snackBar.open('Lỗi: ' + (err.error?.message || 'Không xác định'), 'Đóng', { duration: 3000 });
            }
        });
    }

    goToDashboard(): void {
        this.router.navigate(['/dashboard']);
    }
}
