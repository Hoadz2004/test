import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { LecturerService, LecturerProfile } from '../../core/services/lecturer.service';
import { AuthService } from '../../core/services/auth.service';
import { RouterModule } from '@angular/router';

@Component({
    selector: 'app-lecturer-profile',
    standalone: true,
    imports: [
        CommonModule,
        MatCardModule,
        MatButtonModule,
        MatIconModule,
        MatProgressSpinnerModule,
        RouterModule
    ],
    templateUrl: './lecturer-profile.component.html',
    styleUrl: './lecturer-profile.component.scss'
})
export class LecturerProfileComponent implements OnInit {
    profile: LecturerProfile | null = null;
    error: string = '';

    constructor(
        private lecturerService: LecturerService,
        private authService: AuthService
    ) { }

    ngOnInit(): void {
        const user = this.authService.currentUserValue;
        // Assuming for Lecturer, maSV property might be reused or we add maGV to auth.
        // In AuthService.Login, we map 'User' to MaSV (null for Lecturers currently?). 
        // Let's check AuthService logic. 
        // If user.role is GIANGVIEN, use user.username as ID (since username is often the ID).

        if (user && user.role === 'GIANGVIEN') {
            const lecturerId = user.username; // Or user.maSV if we decide to store it there, but username is safer here.
            this.lecturerService.getProfile(lecturerId).subscribe({
                next: (data) => this.profile = data,
                error: (err) => this.error = 'Không thể tải thông tin giảng viên.'
            });
        } else {
            this.error = 'Bạn không có quyền truy cập hồ sơ giảng viên.';
        }
    }
}
