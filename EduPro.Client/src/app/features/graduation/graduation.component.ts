import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { GraduationService, GraduationResult } from '../../core/services/graduation.service';
import { AuthService } from '../../core/services/auth.service';

@Component({
  selector: 'app-graduation',
  standalone: true,
  imports: [
    CommonModule,
    MatCardModule,
    MatButtonModule,
    MatIconModule,
    MatProgressSpinnerModule
  ],
  templateUrl: './graduation.component.html',
  styleUrl: './graduation.component.scss'
})
export class GraduationComponent implements OnInit {
  result: GraduationResult | null = null;
  loading: boolean = false;
  studentId: string = '';
  hasChecked: boolean = false;

  constructor(
    private graduationService: GraduationService,
    private authService: AuthService
  ) { }

  ngOnInit(): void {
    const user = this.authService.currentUserValue;
    if (user && user.maSV) {
      this.studentId = user.maSV;
    }
  }

  checkGraduation(): void {
    if (!this.studentId) {
      alert('Không tìm thấy thông tin sinh viên. Vui lòng đăng xuất và đăng nhập lại!');
      return;
    }

    this.loading = true;
    this.graduationService.checkStatus(this.studentId).subscribe({
      next: (data) => {
        this.result = (data && data.ketQua) ? data : null;
        this.hasChecked = true;
        this.loading = false;
      },
      error: (err) => {
        console.error('Error checking graduation', err);
        this.loading = false;
        alert('Có lỗi xảy ra khi kiểm tra.');
      }
    });
  }
}
