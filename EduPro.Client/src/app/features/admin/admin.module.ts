import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Routes } from '@angular/router';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MatTableModule } from '@angular/material/table';
import { MatPaginatorModule } from '@angular/material/paginator';
import { MatSortModule } from '@angular/material/sort';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatSelectModule } from '@angular/material/select';
import { MatDialogModule } from '@angular/material/dialog';
import { MatSnackBarModule } from '@angular/material/snack-bar';
import { MatCardModule } from '@angular/material/card';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatNativeDateModule } from '@angular/material/core';
import { MatCheckboxModule } from '@angular/material/checkbox';
import { MatDividerModule } from '@angular/material/divider';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { ClassManagementDeactivateGuard } from '../class-management/class-management.guard';
import { CourseManagementComponent } from './pages/course-management/course-management.component';
import { FeeCatalogComponent } from './pages/fee-catalog/fee-catalog.component';
import { ClassManagementComponent } from '../class-management/class-management.component';

import { AdminLayoutComponent } from './admin-layout.component';
import { UserManagementComponent } from './pages/user-management/user-management.component';
import { AuditLogComponent } from './pages/audit-log/audit-log.component';

const routes: Routes = [
    {
        path: '',
        component: AdminLayoutComponent,
        children: [
            { path: 'users', component: UserManagementComponent },
            { path: 'logs', component: AuditLogComponent },
            {
                path: 'dashboard',
                loadComponent: () => import('./pages/admin-dashboard/admin-dashboard.component').then(m => m.AdminDashboardComponent)
            },
            { path: 'courses', component: CourseManagementComponent },
            { path: 'fees', component: FeeCatalogComponent },
            {
                path: 'training-program',
                loadComponent: () => import('./training-program/list/training-program-list.component').then(m => m.TrainingProgramListComponent)
            },
            {
                path: 'training-program/:id',
                loadComponent: () => import('./training-program/detail/training-program-detail.component').then(m => m.TrainingProgramDetailComponent)
            },
            {
                path: 'class-management',
                component: ClassManagementComponent,
                canDeactivate: [ClassManagementDeactivateGuard]
            },
            {
                path: 'admissions',
                loadComponent: () => import('./pages/admissions-list/admissions-list.component').then(m => m.AdmissionsListComponent)
            },
            {
                path: 'admissions/:code',
                loadComponent: () => import('./pages/admissions-detail/admissions-detail.component').then(m => m.AdmissionsDetailComponent)
            },
            { path: '', redirectTo: 'dashboard', pathMatch: 'full' }
        ]
    }
];

@NgModule({
    declarations: [
        UserManagementComponent,
        AuditLogComponent,
        CourseManagementComponent,
        FeeCatalogComponent
    ],
    imports: [
        CommonModule,
        RouterModule.forChild(routes),
        FormsModule,
        ReactiveFormsModule,
        MatTableModule,
        MatPaginatorModule,
        MatSortModule,
        MatInputModule,
        MatButtonModule,
        MatIconModule,
        MatSelectModule,
        MatDialogModule,
        MatSnackBarModule,
        MatCardModule,
        MatDatepickerModule,
        MatNativeDateModule,
        MatCheckboxModule,
        MatDividerModule,
        MatProgressBarModule,
        AdminLayoutComponent,
        ClassManagementComponent
    ]
})
export class AdminModule { }
