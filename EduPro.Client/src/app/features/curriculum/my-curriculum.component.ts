import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatCardModule } from '@angular/material/card';
import { MatTableModule } from '@angular/material/table';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { MatDividerModule } from '@angular/material/divider';
import { RouterModule } from '@angular/router';
import { TrainingProgramService } from '../admin/training-program/services/training-program.service';

@Component({
    selector: 'app-my-curriculum',
    standalone: true,
    imports: [
        CommonModule,
        MatCardModule,
        MatTableModule,
        MatProgressBarModule,
        MatIconModule,
        MatButtonModule,
        MatDividerModule,
        RouterModule
    ],
    template: `
    <div class="curriculum-container" *ngIf="curriculum">
        <mat-card class="summary-card">
            <mat-card-header>
                <mat-card-title>{{ curriculum.tenCTDT }}</mat-card-title>
                <mat-card-subtitle>Tiến độ học tập</mat-card-subtitle>
            </mat-card-header>
            <mat-card-content>
                <div class="progress-section">
                     <p>{{ completedCredits }} / {{ totalCredits }} Tín chỉ đã tích lũy</p>
                    <mat-progress-bar mode="determinate" [value]="progressPercent"></mat-progress-bar>
                </div>
            </mat-card-content>
        </mat-card>

        <div class="semester-section" *ngFor="let sem of semesters">
            <h3>Học kỳ {{ sem.semester }}</h3>
            <table mat-table [dataSource]="sem.subjects" class="mat-elevation-z1 subject-table">
                <ng-container matColumnDef="maHP">
                    <th mat-header-cell *matHeaderCellDef> Mã HP </th>
                    <td mat-cell *matCellDef="let element"> {{element.maHP}} </td>
                </ng-container>

                <ng-container matColumnDef="tenHP">
                    <th mat-header-cell *matHeaderCellDef> Tên Học Phần </th>
                    <td mat-cell *matCellDef="let element"> {{element.tenHP}} </td>
                </ng-container>

                <ng-container matColumnDef="soTinChi">
                    <th mat-header-cell *matHeaderCellDef> STC </th>
                    <td mat-cell *matCellDef="let element"> {{element.soTinChi}} </td>
                </ng-container>

                <ng-container matColumnDef="diem">
                    <th mat-header-cell *matHeaderCellDef> Điểm </th>
                    <td mat-cell *matCellDef="let element"> 
                        <span *ngIf="element.status !== 'NotTaken'">{{ element.diem | number:'1.1-1' }}</span>
                    </td>
                </ng-container>

                <ng-container matColumnDef="status">
                    <th mat-header-cell *matHeaderCellDef> Trạng thái </th>
                    <td mat-cell *matCellDef="let element">
                        <span class="status-badge" [ngClass]="element.status">
                            {{ formatStatus(element.status) }}
                        </span>
                    </td>
                </ng-container>

                <tr mat-header-row *matHeaderRowDef="displayedColumns"></tr>
                <tr mat-row *matRowDef="let row; columns: displayedColumns;"></tr>
            </table>
        </div>
    </div>
    <div *ngIf="!curriculum && !loading" class="empty-state">
        <p>Chưa có chương trình đào tạo.</p>
    </div>
  `,
    styles: [`
    .curriculum-container { padding: 20px; max-width: 900px; margin: 0 auto; }
    .summary-card { margin-bottom: 20px; }
    .progress-section { margin-top: 15px; }
    .semester-section { margin-bottom: 30px; }
    h3 { border-bottom: 2px solid #e0e0e0; padding-bottom: 5px; color: #3f51b5; }
    .subject-table { width: 100%; margin-bottom: 10px; }
    .status-badge {
        padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: 500;
        &.Passed { background: #e8f5e9; color: #2e7d32; }
        &.Failed { background: #ffebee; color: #c62828; }
        &.NotTaken { background: #f5f5f5; color: #757575; }
    }
    .empty-state { text-align: center; margin-top: 50px; color: #666; }
  `]
})
export class MyCurriculumComponent implements OnInit {
    curriculum: any = null;
    displayedColumns: string[] = ['maHP', 'tenHP', 'soTinChi', 'diem', 'status'];
    semesters: any[] = [];
    loading = true;

    // Progress
    totalCredits = 0;
    completedCredits = 0;
    progressPercent = 0;

    constructor(private service: TrainingProgramService) { }

    ngOnInit() {
        this.service.getMyCurriculum().subscribe({
            next: (res) => {
                this.curriculum = res.data;
                this.processData();
                this.loading = false;
            },
            error: (err) => {
                console.error(err);
                this.loading = false;
            }
        });
    }

    processData() {
        if (!this.curriculum || !this.curriculum.subjects) return;

        const subjects = this.curriculum.subjects;

        // Calculate Progress
        this.totalCredits = subjects.reduce((acc: number, cur: any) => acc + cur.soTinChi, 0);
        this.completedCredits = subjects
            .filter((s: any) => s.status === 'Passed')
            .reduce((acc: number, cur: any) => acc + cur.soTinChi, 0);

        this.progressPercent = this.totalCredits > 0 ? (this.completedCredits / this.totalCredits) * 100 : 0;

        // Group by Semester
        const grouped = subjects.reduce((acc: any, cur: any) => {
            const key = cur.hocKyDuKien;
            if (!acc[key]) acc[key] = [];
            acc[key].push(cur);
            return acc;
        }, {});

        this.semesters = Object.keys(grouped).sort().map(k => ({
            semester: k,
            subjects: grouped[k]
        }));
    }

    formatStatus(status: string): string {
        switch (status) {
            case 'Passed': return 'Đạt';
            case 'Failed': return 'Không đạt';
            case 'NotTaken': return 'Chưa học';
            default: return status;
        }
    }
}
