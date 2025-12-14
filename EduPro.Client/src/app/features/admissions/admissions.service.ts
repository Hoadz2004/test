import { Injectable } from "@angular/core";
import { HttpClient } from "@angular/common/http";
import { Observable } from "rxjs";

export interface CreateAdmissionRequest {
  fullName: string;
  email?: string;
  phone?: string;
  cccd?: string;
  ngaySinh?: string;
  diaChi?: string;
  maNam?: string;
  maHK?: string;
  maNganh?: string;
  ghiChu?: string;
  mon1?: string;
  mon2?: string;
  mon3?: string;
  diem1?: number;
  diem2?: number;
  diem3?: number;
}

export interface AdmissionDto {
  id: number;
  fullName: string;
  email?: string;
  phone?: string;
  maHK?: string;
  maNganh?: string;
  trangThai: string;
  maTraCuu: string;
  ngayNop: string;
  ngayCapNhat: string;
  ghiChu?: string;
  mon1?: string;
  mon2?: string;
  mon3?: string;
  diem1?: number;
  diem2?: number;
  diem3?: number;
  totalRecords?: number;
}

export interface UpdateAdmissionStatusRequest {
  id: number;
  trangThai: string;
  ghiChu?: string;
}

export interface AdmissionRequirement {
  maNganh: string;
  mon1?: string;
  mon2?: string;
  mon3?: string;
  heSo1: number;
  heSo2: number;
  heSo3: number;
  diemChuan?: number;
}

export interface SaveScoresRequest {
  admissionId: number;
  mon1: string;
  diem1: number;
  mon2: string;
  diem2: number;
  mon3: string;
  diem3: number;
  ghiChu?: string;
}

export interface ScoreResult {
  tongDiem: number;
  trangThai: string;
}

@Injectable({ providedIn: "root" })
export class AdmissionsService {
  private baseUrl = "http://localhost:5265/api/Admissions";

  constructor(private http: HttpClient) {}

  create(req: CreateAdmissionRequest): Observable<{ id: number; maTraCuu: string }> {
    return this.http.post<{ id: number; maTraCuu: string }>(this.baseUrl, req);
  }

  lookup(code: string): Observable<AdmissionDto> {
    return this.http.get<AdmissionDto>(`${this.baseUrl}/lookup/${code}`);
  }

  list(filter: { maHK?: string; maNganh?: string; trangThai?: string; pageNumber?: number; pageSize?: number }): Observable<AdmissionDto[]> {
    const params: any = {};
    if (filter.maHK) params.maHK = filter.maHK;
    if (filter.maNganh) params.maNganh = filter.maNganh;
    if (filter.trangThai) params.trangThai = filter.trangThai;
    if (filter.pageNumber) params.pageNumber = filter.pageNumber;
    if (filter.pageSize) params.pageSize = filter.pageSize;
    return this.http.get<AdmissionDto[]>(this.baseUrl, { params });
  }

  updateStatus(req: UpdateAdmissionStatusRequest): Observable<AdmissionDto> {
    return this.http.put<AdmissionDto>(`${this.baseUrl}/status`, req);
  }

  getRequirement(maNganh: string): Observable<AdmissionRequirement> {
    return this.http.get<AdmissionRequirement>(`${this.baseUrl}/requirements/${maNganh}`);
  }

  saveScores(req: SaveScoresRequest): Observable<ScoreResult> {
    return this.http.post<ScoreResult>(`${this.baseUrl}/scores`, req);
  }
}
