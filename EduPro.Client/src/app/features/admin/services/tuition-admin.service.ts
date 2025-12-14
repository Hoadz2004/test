import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface HocPhanAdmin {
  maHP: string;
  tenHP: string;
  soTinChi: number;
  loaiHocPhan?: string;
  batBuoc: boolean;
  soTietLT?: number | null;
  soTietTH?: number | null;
  totalRecords?: number;
}

export interface HocPhiCatalog {
  id: number;
  maNganh: string;
  maHK: string;
  donGiaTinChi: number;
  phuPhiThucHanh: number;
  giamTruPercent: number;
  hieuLucTu: string;
  hieuLucDen?: string | null;
  ngayHetHan?: string | null;
  totalRecords?: number;
}

@Injectable({
  providedIn: 'root'
})
export class TuitionAdminService {
  private baseUrl = 'http://localhost:5265/api/admin/tuition';

  constructor(private http: HttpClient) {}

  getCourses(pageNumber: number = 1, pageSize: number = 20): Observable<HocPhanAdmin[]> {
    const params = new HttpParams()
      .set('pageNumber', pageNumber)
      .set('pageSize', pageSize);
    return this.http.get<HocPhanAdmin[]>(`${this.baseUrl}/courses`, { params });
  }

  saveCourse(payload: HocPhanAdmin): Observable<void> {
    return this.http.post<void>(`${this.baseUrl}/courses`, payload);
  }

  deleteCourse(maHP: string): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/courses/${maHP}`);
  }

  getFees(pageNumber: number = 1, pageSize: number = 20): Observable<HocPhiCatalog[]> {
    const params = new HttpParams()
      .set('pageNumber', pageNumber)
      .set('pageSize', pageSize);
    return this.http.get<HocPhiCatalog[]>(`${this.baseUrl}/fees`, { params });
  }

  getFeeByMajorSemester(maNganh: string, maHK: string): Observable<HocPhiCatalog | null> {
    const params = new HttpParams()
      .set('maNganh', maNganh)
      .set('maHK', maHK);
    return this.http.get<HocPhiCatalog>(`${this.baseUrl}/fees/by-major-semester`, { params });
  }

  saveFee(payload: Partial<HocPhiCatalog>): Observable<{ id: number }> {
    return this.http.post<{ id: number }>(`${this.baseUrl}/fees`, payload);
  }

  deleteFee(id: number): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/fees/${id}`);
  }
}
