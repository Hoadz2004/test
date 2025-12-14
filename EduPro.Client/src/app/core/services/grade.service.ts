import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface Grade {
  tenHK: string;
  maLHP: string;
  tenHP: string;
  soTinChi: number;
  diemQT?: number;
  diemGK?: number;
  diemCK?: number;
  diemTK?: number;
  diemChu?: string;
  diemHe4?: number;
  ketQua?: string;
}

export interface LecturerClass {
  maLHP: string;
  tenHP: string;
  soTinChi: number;
  siSoToiDa: number;
  siSoThucTe: number;
  thuTrongTuan: number;
  maCa: string;
  maPhong: string;
  trongSoCC: number;
  trongSoGK: number;
  trongSoCK: number;
}

export interface StudentGrade {
  maSV: string;
  hoTen: string;
  lop: string;
  diemCC: number;
  diemGK: number;
  diemCK: number;
  diemTK?: number;
  diemChu?: string;
  ketQua?: string;
}

export interface UpdateGradeRequest {
  maLHP: string;
  maSV: string;
  diemCC: number;
  diemGK: number;
  diemCK: number;
}

@Injectable({
  providedIn: 'root'
})
export class GradeService {
  private apiUrl = 'http://localhost:5265/api/Grade';

  constructor(private http: HttpClient) { }

  getMyGrades(studentId: string): Observable<Grade[]> {
    return this.http.get<Grade[]>(`${this.apiUrl}/my-grades/${studentId}`);
  }

  // Lecturer Methods
  getLecturerClasses(namHoc?: number, hocKy?: number): Observable<any> {
    let params = new HttpParams();
    if (namHoc) params = params.set('namHoc', namHoc);
    if (hocKy) params = params.set('hocKy', hocKy);
    return this.http.get<any>(`${this.apiUrl}/lecturer/classes`, { params });
  }

  getClassGrades(maLHP: string): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/lecturer/grades/${maLHP}`);
  }

  updateGrade(request: UpdateGradeRequest): Observable<any> {
    return this.http.post<any>(`${this.apiUrl}/lecturer/update-grade`, request);
  }
}
