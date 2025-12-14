import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatSnackBar } from '@angular/material/snack-bar';
import { FormBuilder, FormGroup, Validators, ReactiveFormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from '../../../core/services/auth.service';
import { MatCardModule } from '@angular/material/card';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatSnackBarModule } from '@angular/material/snack-bar';
import { RouterModule } from '@angular/router';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [
    CommonModule,
    ReactiveFormsModule,
    RouterModule,
    MatCardModule,
    MatInputModule,
    MatButtonModule,
    MatIconModule,
    MatFormFieldModule,
    MatSnackBarModule
  ],
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit {
  loginForm!: FormGroup;
  loading = false;
  submitted = false;
  error = '';
  hidePassword = true;

  constructor(
    private formBuilder: FormBuilder,
    private router: Router,
    private authService: AuthService,
    private snackBar: MatSnackBar // Injected MatSnackBar
  ) {
    // Redirect if already logged in
    if (this.authService.currentUserValue) {
      const role = this.authService.currentUserValue.role;
      if (role === 'ADMIN') {
        this.router.navigate(['/admin/dashboard']);
      } else {
        this.router.navigate(['/dashboard']);
      }
    }
  }

  ngOnInit() {
    this.loginForm = this.formBuilder.group({
      username: ['', Validators.required],
      password: ['', Validators.required]
    });
  }

  // Convenience getter for easy access to form fields
  get f() { return this.loginForm.controls; }

  onSubmit(): void {
    this.submitted = true;
    if (this.loginForm.invalid) {
      return;
    }

    this.loading = true; // Fixed typo from isLoading to loading

    // Fix: Pass object { username, password } as expected by AuthService.login
    const credentials = {
      username: this.f['username'].value,
      password: this.f['password'].value
    };

    this.authService.login(credentials) // Fixed login method call
      .subscribe({
        next: (user) => { // Changed 'response' to 'user'
          console.log('Login Success User:', user);

          // Check if first login - redirect to change password
          if (user.firstLogin) {
            this.router.navigate(['/profile/change-password'], { queryParams: { firstLogin: true } });
          } else {
            const role = user.role;
            if (role === 'ADMIN') {
              this.router.navigate(['/admin/dashboard']);
            } else {
              this.router.navigate(['/dashboard']);
            }
          }
        },
        error: (error) => {
          this.loading = false; // Fixed typo from isLoading to loading
          console.error('Login error:', error);

          let message = 'Đăng nhập thất bại. Vui lòng thử lại.';

          if (error.status === 401) {
            message = 'Tên đăng nhập hoặc mật khẩu không đúng.';
          } else if (error.status === 403) {
            // Account Locked
            message = error.error?.message || 'Tài khoản đã bị khóa do đăng nhập sai nhiều lần.';
          }

          this.snackBar.open(message, 'Đóng', {
            duration: 5000,
            horizontalPosition: 'center',
            verticalPosition: 'top',
            panelClass: ['error-snackbar'] // Ensure you have this class or use default
          });
        }
      });
  }
}
