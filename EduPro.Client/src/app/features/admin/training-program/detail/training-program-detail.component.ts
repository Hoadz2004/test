import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, RouterModule } from '@angular/router';
import { MatTableModule } from '@angular/material/table';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatSnackBar, MatSnackBarModule } from '@angular/material/snack-bar';
import { MatDialog, MatDialogModule } from '@angular/material/dialog';
import { MatTooltipModule } from '@angular/material/tooltip';
import { TrainingProgramService, CTDTDetail, CTDTSubject } from '../services/training-program.service';
import { AddSubjectDialogComponent } from '../add-subject-dialog/add-subject-dialog.component';
import { AddPrerequisiteDialogComponent } from '../add-prerequisite-dialog/add-prerequisite-dialog.component';

@Component({
    selector: 'app-training-program-detail',
    standalone: true,
    imports: [
        CommonModule,
        MatTableModule,
        MatButtonModule,
        MatIconModule,
        MatSnackBarModule,
        MatDialogModule,
        MatTooltipModule,
        RouterModule
    ],
    templateUrl: './training-program-detail.component.html',
    styleUrls: ['./training-program-detail.component.scss']
})
export class TrainingProgramDetailComponent implements OnInit {
    ctdt: CTDTDetail | null = null;
    subjects: CTDTSubject[] = [];
    displayedColumns: string[] = ['maHP', 'tenHP', 'soTinChi', 'hocKyDuKien', 'loai', 'tienQuyet', 'actions'];

    constructor(
        private route: ActivatedRoute,
        private service: TrainingProgramService,
        private snackBar: MatSnackBar,
        private dialog: MatDialog
    ) { }

    ngOnInit(): void {
        const id = this.route.snapshot.paramMap.get('id');
        if (id) {
            this.loadData(+id);
        }
    }

    loadData(id: number) {
        this.service.getCTDTDetail(id).subscribe({
            next: (res) => {
                this.ctdt = res.data;
                this.subjects = res.data.subjects;
            },
            error: (err) => {
                this.snackBar.open('Lỗi tải dữ liệu', 'Đóng', { duration: 3000 });
            }
        });
    }

    openAddSubject() {
        if (!this.ctdt) return;
        const dialogRef = this.dialog.open(AddSubjectDialogComponent, {
            width: '500px',
            data: { maCTDT: this.ctdt.maCTDT }
        });

        dialogRef.afterClosed().subscribe(result => {
            if (result && this.ctdt) {
                this.loadData(this.ctdt.maCTDT);
            }
        });
    }

    removeSubject(id: number) {
        if (!confirm('Bạn có chắc chắn muốn xóa học phần này khỏi CTDT?')) return;

        this.service.removeSubject(id).subscribe({
            next: () => {
                this.snackBar.open('Đã xóa', 'Đóng', { duration: 2000 });
                if (this.ctdt) this.loadData(this.ctdt.maCTDT);
            },
            error: (err) => {
                this.snackBar.open('Lỗi xóa: ' + err.message, 'Đóng', { duration: 3000 });
            }
        });
    }

    openPrerequisite(subject: CTDTSubject) {
        const dialogRef = this.dialog.open(AddPrerequisiteDialogComponent, {
            width: '500px',
            data: {
                maHP: subject.maHP,
                tenHP: subject.tenHP,
                availableSubjects: this.subjects.filter(s => s.maHP !== subject.maHP && s.hocKyDuKien <= subject.hocKyDuKien)
            }
        });

        dialogRef.afterClosed().subscribe(result => {
            if (result && this.ctdt) {
                this.loadData(this.ctdt.maCTDT);
            }
        });
    }
}
