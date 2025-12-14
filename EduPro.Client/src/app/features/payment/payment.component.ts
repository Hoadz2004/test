import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatSnackBar, MatSnackBarModule } from '@angular/material/snack-bar';
import { MatInputModule } from '@angular/material/input';
import { AuthService } from '../../core/services/auth.service';
import { PaymentService, Debt, PaymentInitVnpayResponse, DebtSummary, DebtDetail } from '../../core/services/payment.service';

@Component({
  selector: 'app-payment',
  standalone: true,
  imports: [
    CommonModule,
    FormsModule,
    MatButtonModule,
    MatSnackBarModule,
    MatInputModule
  ],
  templateUrl: './payment.component.html',
  styleUrls: ['./payment.component.scss']
})
export class PaymentComponent implements OnInit {
  maHK: string = '';
  debt?: Debt;
  debts: DebtSummary[] = [];
  loading = false;
  paymentInfo?: PaymentInitVnpayResponse;
  filterMaHK: string = '';
  debtDetails: DebtDetail[] = [];

  constructor(
    private authService: AuthService,
    private paymentService: PaymentService,
    private snackBar: MatSnackBar
  ) {}

  ngOnInit(): void {
    const user = this.authService.currentUserValue;
    if (!user) {
      this.snackBar.open('Bạn cần đăng nhập', 'Đóng', { duration: 3000 });
      return;
    }
    this.loadDebts();
  }

  loadDebt(): void {
    const user = this.authService.currentUserValue;
    if (!user || !this.maHK) {
      this.snackBar.open('Vui lòng nhập mã học kỳ', 'Đóng', { duration: 2500 });
      return;
    }
    const studentId = user.maSV || user.username;
    this.loading = true;
    this.paymentService.getDebt(studentId, this.maHK).subscribe({
      next: (res) => {
        this.debt = res;
        this.paymentInfo = undefined;
        this.loading = false;
        // Load chi tiết môn nợ
        this.paymentService.getDebtDetails(studentId, this.maHK).subscribe({
          next: (detail) => this.debtDetails = detail,
          error: () => this.debtDetails = []
        });
      },
      error: () => {
        this.debt = undefined;
        this.debtDetails = [];
        this.loading = false;
        this.snackBar.open('Không tìm thấy công nợ', 'Đóng', { duration: 2500 });
      }
    });
  }

  loadDebts(): void {
    const user = this.authService.currentUserValue;
    if (!user) return;
    const studentId = user.maSV || user.username;
    this.paymentService.getDebts(studentId, this.filterMaHK || undefined).subscribe({
      next: (res) => this.debts = res,
      error: () => this.debts = []
    });
  }

  initPayment(): void {
    const user = this.authService.currentUserValue;
    if (!user || !this.maHK) {
      this.snackBar.open('Vui lòng nhập mã học kỳ', 'Đóng', { duration: 2500 });
      return;
    }
    const studentId = user.maSV || user.username;
    this.loading = true;
    this.paymentService.initVnPay({
      maSV: studentId,
      maHK: this.maHK,
      amount: this.debt?.soTienNo ?? undefined,
      method: 'VNPAY'
    }).subscribe({
      next: (initRes) => {
        this.paymentInfo = initRes;
        this.loading = false;
        if (initRes.paymentUrl) {
          window.location.href = initRes.paymentUrl;
        } else {
          this.snackBar.open('Không nhận được URL thanh toán', 'Đóng', { duration: 2500 });
        }
      },
      error: () => {
        this.loading = false;
        this.snackBar.open('Khởi tạo thanh toán VNPay thất bại', 'Đóng', { duration: 2500 });
      }
    });
  }
}
