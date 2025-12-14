import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { MatTableModule } from '@angular/material/table';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { GradeService, LecturerClass } from '../../../core/services/grade.service';

@Component({
    selector: 'app-lecturer-class-list',
    standalone: true,
    imports: [
        CommonModule,
        RouterModule,
        MatTableModule,
        MatCardModule,
        MatButtonModule,
        MatIconModule,
        MatProgressSpinnerModule
    ],
    templateUrl: './lecturer-class-list.component.html',
    styleUrls: ['./lecturer-class-list.component.scss']
})
export class LecturerClassListComponent implements OnInit {
    classes: LecturerClass[] = [];
    displayedColumns: string[] = ['maLHP', 'tenHP', 'thoiGian', 'siSo', 'actions'];
    isLoading = true;

    constructor(private gradeService: GradeService) { }

    ngOnInit(): void {
        this.loadClasses();
    }

    loadClasses(): void {
        this.isLoading = true;
        this.gradeService.getLecturerClasses().subscribe({
            next: (response) => {
                this.classes = response.data || [];
                this.isLoading = false;
            },
            error: (err) => {
                console.error('Failed to load classes', err);
                this.isLoading = false;
            }
        });
    }
}
