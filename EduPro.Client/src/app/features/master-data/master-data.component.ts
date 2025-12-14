import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatCardModule } from '@angular/material/card';
import { MatListModule } from '@angular/material/list';
import { MatButtonModule } from '@angular/material/button';
import { RouterModule } from '@angular/router';
import { MasterDataService, MasterDataDto } from '../../core/services/master-data.service';

@Component({
    selector: 'app-master-data',
    standalone: true,
    imports: [CommonModule, MatCardModule, MatListModule, MatButtonModule, RouterModule],
    templateUrl: './master-data.component.html',
    styleUrl: './master-data.component.scss'
})
export class MasterDataComponent implements OnInit {
    faculties: MasterDataDto[] = [];
    majors: MasterDataDto[] = [];
    semesters: MasterDataDto[] = [];
    academicYears: MasterDataDto[] = [];
    batches: MasterDataDto[] = [];
    classrooms: MasterDataDto[] = [];
    shifts: MasterDataDto[] = [];
    subjects: MasterDataDto[] = [];

    constructor(private masterDataService: MasterDataService) { }

    ngOnInit(): void {
        this.masterDataService.getFaculties().subscribe(d => this.faculties = d);
        this.masterDataService.getMajors().subscribe(d => this.majors = d);
        this.masterDataService.getSemesters().subscribe(d => this.semesters = d);
        this.masterDataService.getAcademicYears().subscribe(d => this.academicYears = d);
        this.masterDataService.getAdmissionBatches().subscribe(d => this.batches = d);
        this.masterDataService.getClassrooms().subscribe(d => this.classrooms = d);
        this.masterDataService.getShifts().subscribe(d => this.shifts = d);
        this.masterDataService.getSubjects().subscribe(d => this.subjects = d);
    }
}
