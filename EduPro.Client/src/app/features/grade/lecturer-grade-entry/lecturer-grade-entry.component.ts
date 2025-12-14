import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router, RouterModule } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { MatTableModule } from '@angular/material/table';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatSnackBar, MatSnackBarModule } from '@angular/material/snack-bar';
import { GradeService, StudentGrade, UpdateGradeRequest } from '../../../core/services/grade.service';

interface StudentGradeUI extends StudentGrade {
    isSaving?: boolean;
}

@Component({
    selector: 'app-lecturer-grade-entry',
    standalone: true,
    imports: [
        CommonModule,
        FormsModule,
        RouterModule,
        MatTableModule,
        MatCardModule,
        MatButtonModule,
        MatIconModule,
        MatInputModule,
        MatFormFieldModule,
        MatProgressSpinnerModule,
        MatSnackBarModule
    ],
    templateUrl: './lecturer-grade-entry.component.html',
    styleUrls: ['./lecturer-grade-entry.component.scss']
})
export class LecturerGradeEntryComponent implements OnInit {
    maLHP: string | null = null;
    students: StudentGradeUI[] = [];
    dataSource: StudentGradeUI[] = [];
    displayedColumns: string[] = ['maSV', 'hoTen', 'lop', 'diemCC', 'diemGK', 'diemCK', 'diemTK', 'diemChu', 'actions'];
    isLoading = true;
    classInfo: any = {}; // Store class metadata if needed

    // Default Weights (Should fetch from API ideally, but for now assuming standard or fetching with class info)
    // Since API `GetClassGrades` returns just student list, I might need `GetLecturerClasses` to find weight or assume standard.
    // Actually, I can pass weight in previous screen or fetch detail. 
    // Let's assume standard 10/40/50 for preview if not available.
    weights = { cc: 0.1, gk: 0.4, ck: 0.5 };

    constructor(
        private route: ActivatedRoute,
        private router: Router,
        private gradeService: GradeService,
        private snackBar: MatSnackBar
    ) { }

    ngOnInit(): void {
        this.maLHP = this.route.snapshot.paramMap.get('id');
        if (this.maLHP) {
            this.loadGrades();
        }
    }

    loadGrades(): void {
        if (!this.maLHP) return;
        this.isLoading = true;

        // We need Class Info for Header. Can reuse `getLecturerClasses` filtering by ID or just show ID.
        // For better UX, let's fetch class info first (or parallel).
        // Actually `getLecturerClasses` returns list.

        this.gradeService.getLecturerClasses().subscribe(clsResponse => {
            const cls = clsResponse.data?.find((c: any) => c.maLHP === this.maLHP);
            if (cls) {
                this.classInfo = cls;
                this.weights = { cc: cls.trongSoCC, gk: cls.trongSoGK, ck: cls.trongSoCK };
            }
        });

        this.gradeService.getClassGrades(this.maLHP).subscribe({
            next: (response) => {
                this.students = response.data || [];
                this.dataSource = this.students;
                this.isLoading = false;
            },
            error: (err) => {
                console.error('Failed to load grades', err);
                this.isLoading = false;
                this.snackBar.open('Không thể tải bảng điểm', 'Đóng', { duration: 3000 });
            }
        });
    }

    calculateTotal(student: StudentGradeUI): void {
        // Client-side preview calculation
        // Note: Backend is authority. This is just for UX.
        const cc = student.diemCC || 0;
        const gk = student.diemGK || 0;
        const ck = student.diemCK || 0;

        const total = (cc * this.weights.cc) + (gk * this.weights.gk) + (ck * this.weights.ck);
        student.diemTK = parseFloat(total.toFixed(1)); // Display 1 decimal

        // Special Rule: Final Grade (CK) < 4 must Fail
        if (ck < 4.0) {
            student.diemChu = 'F';
            student.ketQua = 'Không đạt';
            // Note: DiemTK might still be > 4.0 but result is Fail
        } else {
            // Normal Grade Mapping
            if (total >= 8.5) student.diemChu = 'A';
            else if (total >= 8.0) student.diemChu = 'B+';
            else if (total >= 7.0) student.diemChu = 'B';
            else if (total >= 6.5) student.diemChu = 'C+';
            else if (total >= 5.5) student.diemChu = 'C';
            else if (total >= 5.0) student.diemChu = 'D+';
            else if (total >= 4.0) student.diemChu = 'D';
            else student.diemChu = 'F';

            if (total >= 4.0) student.ketQua = 'Đạt';
            else student.ketQua = 'Không đạt';
        }
    }

    saveGrade(student: StudentGradeUI): void {
        if (!this.maLHP) return;
        student.isSaving = true;

        const request: UpdateGradeRequest = {
            maLHP: this.maLHP,
            maSV: student.maSV,
            diemCC: student.diemCC || 0,
            diemGK: student.diemGK || 0,
            diemCK: student.diemCK || 0
        };

        this.gradeService.updateGrade(request).subscribe({
            next: () => {
                student.isSaving = false;
                this.snackBar.open(`Đã lưu điểm cho ${student.hoTen}`, 'OK', { duration: 2000 });
            },
            error: (err) => {
                console.error('Failed to save grade', err);
                if (err.error && err.error.message) {
                    console.error('Server Message:', err.error.message);
                    this.snackBar.open(`Lỗi: ${err.error.message}`, 'Đóng', { duration: 5000 });
                } else if (err.error && err.error.errors) {
                    console.error('Validation Errors:', err.error.errors);
                    this.snackBar.open('Lỗi dữ liệu không hợp lệ', 'Đóng', { duration: 5000 });
                } else {
                    this.snackBar.open('Lỗi khi lưu điểm', 'Đóng', { duration: 3000 });
                }
                student.isSaving = false;
            }
        });
    }

    goBack(): void {
        this.router.navigate(['/lecturer/classes']);
    }

    isFailed(student: StudentGradeUI): boolean {
        return (student.diemTK || 0) < 4.0;
    }

    getBadgeClass(student: StudentGradeUI): string {
        const grade = student.diemChu;
        if (!grade || grade === 'F') return 'badge-fail';
        if (grade === 'A' || grade === 'B+') return 'badge-good';
        return 'badge-pass';
    }
}
