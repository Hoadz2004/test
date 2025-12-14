import { Routes } from '@angular/router';
import { LoginComponent } from './features/auth/login/login.component';
import { DashboardComponent } from './features/dashboard/dashboard.component';
import { inject } from '@angular/core';
import { AuthService } from './core/services/auth.service';
import { Router } from '@angular/router';

// Simple Auth Guard
const authGuard = () => {
    const authService = inject(AuthService);
    const router = inject(Router);

    if (authService.currentUserValue) {
        return true;
    }

    return router.parseUrl('/login');
};

// Role-Based Guards
const adminGuard = () => {
    const authService = inject(AuthService);
    const router = inject(Router);

    if (authService.currentUserValue?.role === 'ADMIN') {
        return true;
    }

    return router.parseUrl('/dashboard');
};

const lecturerGuard = () => {
    const authService = inject(AuthService);
    const router = inject(Router);

    if (authService.currentUserValue?.role === 'GIANGVIEN') {
        return true;
    }

    return router.parseUrl('/dashboard');
};

const studentGuard = () => {
    const authService = inject(AuthService);
    const router = inject(Router);

    if (authService.currentUserValue?.role === 'SINHVIEN') {
        return true;
    }

    return router.parseUrl('/dashboard');
};

import { EnrollmentComponent } from './features/enrollment/enrollment.component';
import { GradeComponent } from './features/grade/grade.component';
import { GradeAppealComponent } from './features/grade-appeal/grade-appeal.component';
import { GraduationComponent } from './features/graduation/graduation.component';
import { PaymentComponent } from './features/payment/payment.component';

import { StudentProfileComponent } from './features/student-profile/student-profile.component';
import { LecturerProfileComponent } from './features/lecturer-profile/lecturer-profile.component';
import { MasterDataComponent } from './features/master-data/master-data.component';

export const routes: Routes = [
    { path: 'login', component: LoginComponent },
    { path: 'dashboard', component: DashboardComponent, canActivate: [authGuard] },

    // Student routes
    { path: 'enrollment', component: EnrollmentComponent, canActivate: [authGuard, studentGuard] },
    { path: 'grades', component: GradeComponent, canActivate: [authGuard, studentGuard] },
    { path: 'grade-appeal', component: GradeAppealComponent, canActivate: [authGuard, studentGuard] },
    { path: 'graduation', component: GraduationComponent, canActivate: [authGuard, studentGuard] },
    { path: 'payments', component: PaymentComponent, canActivate: [authGuard, studentGuard] },
    { path: 'profile', component: StudentProfileComponent, canActivate: [authGuard, studentGuard] },

    // Lecturer routes
    { path: 'lecturer-profile', component: LecturerProfileComponent, canActivate: [authGuard, lecturerGuard] },
    {
        path: 'lecturer/classes',
        loadComponent: () => import('./features/grade/lecturer-class-list/lecturer-class-list.component').then(m => m.LecturerClassListComponent),
        canActivate: [authGuard, lecturerGuard]
    },
    {
        path: 'lecturer/grades/:id',
        loadComponent: () => import('./features/grade/lecturer-grade-entry/lecturer-grade-entry.component').then(m => m.LecturerGradeEntryComponent),
        canActivate: [authGuard, lecturerGuard]
    },

    // Admin routes
    { path: 'master-data', component: MasterDataComponent, canActivate: [authGuard, adminGuard] },
    { path: 'class-management', redirectTo: '/admin/class-management', pathMatch: 'full' },

    // Admin Module (Lazy Loaded)
    {
        path: 'admin',
        loadChildren: () => import('./features/admin/admin.module').then(m => m.AdminModule),
        canActivate: [authGuard, adminGuard]
    },

    // Profile Routes (for all authenticated users)
    {
        path: 'profile/change-password',
        loadComponent: () => import('./features/profile/change-password/change-password.component').then(m => m.ChangePasswordComponent),
        canActivate: [authGuard]
    },
    {
        path: 'my-profile',
        loadComponent: () => import('./features/profile/profile/profile.component').then(m => m.ProfileComponent),
        canActivate: [authGuard]
    },
    {
        path: 'my-curriculum',
        loadComponent: () => import('./features/curriculum/my-curriculum.component').then(m => m.MyCurriculumComponent),
        canActivate: [authGuard, studentGuard]
    },

    { path: 'admissions', loadComponent: () => import('./features/admissions/admissions-form.component').then(m => m.AdmissionsFormComponent) },
    { path: 'admissions/lookup', loadComponent: () => import('./features/admissions/admissions-lookup.component').then(m => m.AdmissionsLookupComponent) },
    { path: '', redirectTo: '/login', pathMatch: 'full' },
    { path: '**', redirectTo: '/login' }
];
