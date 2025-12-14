import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatCardModule } from '@angular/material/card';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';
import { MatTableModule } from '@angular/material/table';
import { MatIconModule } from '@angular/material/icon';
import { MatSelectModule } from '@angular/material/select'; // New Import
import { AppealService, Appeal, EligibleSubject } from '../../core/services/appeal.service';
import { AuthService } from '../../core/services/auth.service';

@Component({
  selector: 'app-grade-appeal',
  standalone: true,
  imports: [
    CommonModule,
    ReactiveFormsModule,
    MatCardModule,
    MatFormFieldModule,
    MatInputModule,
    MatButtonModule,
    MatTableModule,
    MatIconModule,
    MatSelectModule // New Import
  ],
  templateUrl: './grade-appeal.component.html',
  styleUrl: './grade-appeal.component.scss'
})
export class GradeAppealComponent implements OnInit {
  appealForm: FormGroup;
  appeals: Appeal[] = [];
  eligibleSubjects: EligibleSubject[] = [];
  displayedColumns: string[] = ['tenHP', 'lyDo', 'trangThai', 'ngayGui', 'ghiChuXuLy'];
  studentId: string = '';

  constructor(
    private fb: FormBuilder,
    private appealService: AppealService,
    private authService: AuthService
  ) {
    this.appealForm = this.fb.group({
      maLHP: ['', Validators.required],
      lyDo: ['', Validators.required]
    });
  }

  ngOnInit(): void {
    const user = this.authService.currentUserValue;
    if (user && user.maSV) {
      this.studentId = user.maSV;
      this.loadData();
    }
  }

  loadData(): void {
    this.loadAppeals();
    this.loadEligibleSubjects();
  }

  loadAppeals(): void {
    this.appealService.getMyAppeals(this.studentId).subscribe({
      next: (data) => this.appeals = data,
      error: (err) => console.error('Error loading appeals', err)
    });
  }

  loadEligibleSubjects(): void {
    this.appealService.getEligibleSubjects(this.studentId).subscribe({
      next: (data) => this.eligibleSubjects = data,
      error: (err) => console.error('Error loading eligible subjects', err)
    });
  }

  onSubmit(): void {
    if (!this.studentId) {
      alert('Không tìm thấy thông tin sinh viên. Vui lòng đăng xuất và đăng nhập lại!');
      return;
    }

    if (this.appealForm.valid) {
      const selectedSubject = this.eligibleSubjects.find(s => s.maLHP === this.appealForm.value.maLHP);
      if (!selectedSubject) return;

      this.appealService.createAppeal(this.studentId, this.appealForm.value).subscribe({
        next: () => {
          alert('Gửi yêu cầu phúc khảo thành công!');
          this.appealForm.reset();
          this.loadData(); // Refresh both lists
        },
        error: (err) => alert('Lỗi: ' + (err.error?.message || 'Không thể gửi yêu cầu'))
      });
    }
  }
}
