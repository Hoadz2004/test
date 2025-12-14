import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatCardModule } from '@angular/material/card';
import { MatIconModule } from '@angular/material/icon';
import { MatDividerModule } from '@angular/material/divider';

@Component({
  selector: 'app-admin-dashboard',
  standalone: true,
  imports: [CommonModule, MatCardModule, MatIconModule, MatDividerModule],
  templateUrl: './admin-dashboard.component.html',
  styleUrls: ['./admin-dashboard.component.scss']
})
export class AdminDashboardComponent {
  stats = [
    { label: 'Sinh viên', value: 1240, icon: 'people' },
    { label: 'Giảng viên', value: 86, icon: 'school' },
    { label: 'Lớp học phần đang mở', value: 42, icon: 'class' },
    { label: 'Đơn giá/học phí cập nhật', value: 'HK1-2025', icon: 'payments' }
  ];

  activities = [
    'Cập nhật đơn giá HK1-2025',
    'Mở lớp mới: 20241-IT101',
    'Khóa tài khoản 1 sinh viên',
    'Thêm giảng viên mới'
  ];
}
