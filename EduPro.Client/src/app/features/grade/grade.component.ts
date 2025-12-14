import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatTableModule } from '@angular/material/table';
import { MatCardModule } from '@angular/material/card';
import { MatIconModule } from '@angular/material/icon';
import { Grade, GradeService } from '../../core/services/grade.service';
import { AuthService } from '../../core/services/auth.service';

@Component({
  selector: 'app-grade',
  standalone: true,
  imports: [CommonModule, MatTableModule, MatCardModule, MatIconModule],
  templateUrl: './grade.component.html',
  styleUrls: ['./grade.component.scss']
})
export class GradeComponent implements OnInit {
  grades: Grade[] = [];
  displayedColumns: string[] = ['maLHP', 'tenHP', 'soTinChi', 'diemQT', 'diemGK', 'diemCK', 'diemTK', 'diemChu', 'ketQua'];

  constructor(
    private gradeService: GradeService,
    private authService: AuthService
  ) { }

  ngOnInit(): void {
    const user = this.authService.currentUserValue;
    const studentId = user?.maSV || user?.username;
    if (studentId) {
      this.gradeService.getMyGrades(studentId).subscribe({
        next: (data) => {
          this.grades = data;
        },
        error: (err) => console.error('Error fetching grades:', err)
      });
    } else {
      console.error('No user or username found in AuthService');
    }
  }

  // Helper to colorize status
  getStatusColor(status?: string): string {
    return status === 'Đạt' ? 'green' : 'red';
  }
}
