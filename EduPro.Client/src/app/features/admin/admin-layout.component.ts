import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { AuthService } from '../../core/services/auth.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-admin-layout',
  standalone: true,
  imports: [CommonModule, RouterModule, MatCardModule, MatButtonModule, MatIconModule],
  template: `
    <div class="admin-container">
      <mat-card class="sidebar" [class.collapsed]="collapsed">
        <div class="sidebar-header" (click)="toggleByLogo()">
          <div class="brand">
            <mat-icon class="brand-icon">school</mat-icon>
            <span class="brand-text" *ngIf="!collapsed">EduPro Admin</span>
          </div>
          <button *ngIf="!collapsed" mat-icon-button (click)="toggle($event)" aria-label="Toggle menu">
            <mat-icon>{{ collapsed ? 'menu_open' : 'menu' }}</mat-icon>
          </button>
        </div>
        <nav>
          <a mat-button routerLink="/admin/users" routerLinkActive="active">
            <mat-icon>people</mat-icon>
            <span *ngIf="!collapsed">Users</span>
          </a>
          <a mat-button routerLink="/admin/logs" routerLinkActive="active">
            <mat-icon>history</mat-icon>
            <span *ngIf="!collapsed">Audit Logs</span>
          </a>
          <a mat-button routerLink="/admin/dashboard" routerLinkActive="active">
            <mat-icon>dashboard</mat-icon>
            <span *ngIf="!collapsed">Dashboard</span>
          </a>
          <a mat-button routerLink="/admin/courses" routerLinkActive="active">
            <mat-icon>menu_book</mat-icon>
            <span *ngIf="!collapsed">Học phần</span>
          </a>
          <a mat-button routerLink="/admin/fees" routerLinkActive="active">
            <mat-icon>payments</mat-icon>
            <span *ngIf="!collapsed">Đơn giá</span>
          </a>
          <a mat-button routerLink="/admin/admissions" routerLinkActive="active">
            <mat-icon>how_to_reg</mat-icon>
            <span *ngIf="!collapsed">Tuyển sinh</span>
          </a>
          <a mat-button routerLink="/admin/class-management" routerLinkActive="active">
            <mat-icon>class</mat-icon>
            <span *ngIf="!collapsed">Lớp học phần</span>
          </a>
        </nav>
        <button mat-button (click)="logout()" class="logout-btn">
          <mat-icon>logout</mat-icon>
          <span *ngIf="!collapsed">Logout</span>
        </button>
      </mat-card>
      <div class="content">
        <router-outlet></router-outlet>
      </div>
    </div>
  `,
  styles: [`
    .admin-container { display: flex; height: 100vh; background: #f5f5f5; }
    .sidebar {
      width: 240px;
      transition: width 0.25s ease, padding 0.25s ease;
      height: 100%;
      display: flex;
      flex-direction: column;
      border-radius: 0;
      padding: 12px;
      box-sizing: border-box;
      gap: 10px;
      background: #fff;
      border-right: 1px solid #e0e0e0;
    }
    .sidebar.collapsed { width: 72px; padding: 12px 8px; }
    .sidebar-header { display: flex; align-items: center; justify-content: space-between; gap: 6px; cursor: pointer; }
    .brand { display: flex; align-items: center; gap: 8px; font-size: 18px; font-weight: 700; color: #222; }
    .brand-icon { color: #222; }
    nav { display: flex; flex-direction: column; gap: 4px; }
    nav a {
      text-align: left;
      justify-content: flex-start;
      align-items: center;
      border-radius: 6px;
      height: 44px;
      padding: 0 12px;
      min-width: 0;
      color: #222;
    }
    nav a mat-icon { margin-right: 10px; color: #3b3b3b; }
    nav a.active { background: #e0e0e0; color: #111; }
    nav a.active mat-icon { color: #111; }
    .sidebar.collapsed nav { align-items: center; }
    .sidebar.collapsed nav a {
      justify-content: center;
      padding: 0;
      width: 48px;
      height: 44px;
    }
    .sidebar.collapsed nav a mat-icon { margin-right: 0; }
    .sidebar.collapsed nav a span,
    .sidebar.collapsed .brand-text { display: none; }
    .logout-btn { margin-top: auto; color: #b00020; justify-content: flex-start; border-radius: 6px; }
    .sidebar.collapsed .logout-btn { justify-content: center; }
    .content { flex: 1; padding: 20px; overflow: auto; }
  `]
})
export class AdminLayoutComponent {
  collapsed = false;
  constructor(private authService: AuthService, private router: Router) { }

  toggle(event?: Event) {
    if (event) { event.stopPropagation(); }
    this.collapsed = !this.collapsed;
  }

  toggleByLogo() {
    this.collapsed = !this.collapsed;
  }

  logout() {
    this.authService.logout();
    this.router.navigate(['/login']);
  }
}
