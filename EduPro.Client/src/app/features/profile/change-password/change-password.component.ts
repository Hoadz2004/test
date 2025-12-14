import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, ActivatedRoute } from '@angular/router';
import { MatCardModule } from '@angular/material/card';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';
import { MatSnackBar, MatSnackBarModule } from '@angular/material/snack-bar';
import { MatIconModule } from '@angular/material/icon';
import { ProfileService } from '../services/profile.service';

@Component({
    selector: 'app-change-password',
    standalone: true,
    imports: [
        CommonModule, FormsModule,
        MatCardModule, MatFormFieldModule, MatInputModule, MatButtonModule, MatSnackBarModule, MatIconModule
    ],
    templateUrl: './change-password.component.html',
    styleUrls: ['./change-password.component.css']
})
export class ChangePasswordComponent implements OnInit {
    isFirstLogin = false;
    oldPassword = '';
    newPassword = '';
    confirmPassword = '';
    loading = false;
    hideOld = true;
    hideNew = true;

    constructor(
        private profileService: ProfileService,
        private router: Router,
        private route: ActivatedRoute,
        private snackBar: MatSnackBar
    ) { }

    ngOnInit(): void {
        this.route.queryParams.subscribe(params => {
            this.isFirstLogin = params['firstLogin'] === 'true';
        });
    }

    submit(): void {
        if (!this.oldPassword || !this.newPassword || !this.confirmPassword) {
            this.snackBar.open('Vui lòng điền đầy đủ thông tin', 'Đóng', { duration: 2000 });
            return;
        }

        if (this.newPassword !== this.confirmPassword) {
            this.snackBar.open('Mật khẩu mới không khớp', 'Đóng', { duration: 2000 });
            return;
        }

        if (this.newPassword.length < 6) {
            this.snackBar.open('Mật khẩu mới phải ít nhất 6 ký tự', 'Đóng', { duration: 2000 });
            return;
        }

        this.loading = true;
        this.profileService.changePassword(this.oldPassword, this.newPassword).subscribe({
            next: () => {
                this.snackBar.open('Đổi mật khẩu thành công!', 'Đóng', { duration: 2000 });
                if (this.isFirstLogin) {
                    this.router.navigate(['/profile']);
                } else {
                    this.router.navigate(['/dashboard']);
                }
            },
            error: (err) => {
                this.loading = false;
                this.snackBar.open('Lỗi: ' + (err.error?.message || 'Mật khẩu cũ không đúng'), 'Đóng', { duration: 3000 });
            }
        });
    }
}
