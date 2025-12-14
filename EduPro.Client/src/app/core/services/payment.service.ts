import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface Debt {
  maSV: string;
  maHK: string;
  soTienGoc: number;
  daThanhToan: number;
  soTienNo: number;
  ngayCapNhat: string;
}

export interface PaymentInitRequest {
  maSV: string;
  maHK: string;
  amount?: number | null;
  method: string;
  provider?: string | null;
  providerRef?: string | null;
}

export interface PaymentInitResponse {
  paymentId: number;
  amount: number;
  paymentUrl?: string;
}

export interface PaymentInitVnpayResponse {
  paymentId: number;
  amount: number;
  paymentUrl: string;
  txnRef: string;
}

export interface PaymentConfirmRequest {
  paymentId: number;
  status: string;
  providerTransId?: string | null;
  note?: string | null;
}

export interface PaymentConfirmResponse {
  paymentId: number;
  status: string;
  confirmedAt?: string;
}

export interface DebtSummary {
  maSV: string;
  maHK: string;
  soTienGoc: number;
  daThanhToan: number;
  soTienNo: number;
  ngayCapNhat: string;
}

export interface DebtDetail {
  maLHP: string;
  maHP: string;
  tenHP: string;
  soTinChi: number;
  donGiaTinChi: number;
  phuPhiThucHanh: number;
  giamTruPercent: number;
  soTien: number;
  ngayDangKy?: string;
  hanThanhToan?: string;
  trangThaiDangKy: string;
}

@Injectable({
  providedIn: 'root'
})
export class PaymentService {
  private apiUrl = 'http://localhost:5265/api/Payment';

  constructor(private http: HttpClient) {}

  getDebt(maSV: string, maHK: string): Observable<Debt> {
    return this.http.get<Debt>(`${this.apiUrl}/debt`, { params: { maSV, maHK } });
  }

  initPayment(payload: PaymentInitRequest): Observable<PaymentInitResponse> {
    return this.http.post<PaymentInitResponse>(`${this.apiUrl}/init`, payload);
  }

  confirmPayment(payload: PaymentConfirmRequest): Observable<PaymentConfirmResponse> {
    return this.http.post<PaymentConfirmResponse>(`${this.apiUrl}/confirm`, payload);
  }

  getDebts(maSV: string, maHK?: string): Observable<DebtSummary[]> {
    const params: any = { maSV };
    if (maHK) params.maHK = maHK;
    return this.http.get<DebtSummary[]>(`${this.apiUrl}/debts`, { params });
  }

  initVnPay(payload: PaymentInitRequest): Observable<PaymentInitVnpayResponse> {
    return this.http.post<PaymentInitVnpayResponse>(`${this.apiUrl}/vnpay/init`, payload);
  }

  getDebtDetails(maSV: string, maHK: string): Observable<DebtDetail[]> {
    return this.http.get<DebtDetail[]>(`${this.apiUrl}/debt-details`, { params: { maSV, maHK } });
  }
}
