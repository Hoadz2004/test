import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface ClassDto {
    maLHP: string;
    maHP: string;
    tenHP: string;
    soTinChi: number;
    maHK: string;
    tenHK: string;
    maNam: string;
    namBatDau: number;
    maGV: string;
    tenGV: string;
    maKhoa?: string;
    maNganh?: string;
    maPhong: string;
    tenPhong: string;
    maCa: string;
    tenCa: string;
    thuTrongTuan: number;
    siSoToiDa: number;
    siSoHienTai: number;
    ghiChu?: string;
    ngayBatDau?: Date;
    ngayKetThuc?: Date;
    soBuoiHoc: number;
    soBuoiTrongTuan: number;
    trangThaiLop: string;
    trangThaiCode?: string;
    totalRecords?: number;
}

export interface CreateClassDto {
    maLHP: string;
    maHP: string;
    maHK: string;
    maNam: string;
    maGV: string;
    maPhong: string;
    maCa: string;
    thuTrongTuan: number;
    siSoToiDa: number;
    ghiChu?: string;
    ngayBatDau?: Date | null;
    ngayKetThuc?: Date | null;
    soBuoiHoc: number;
    soBuoiTrongTuan: number;
    trangThaiLop: string;
    trangThaiCode?: string;
}

export interface UpdateClassDto {
    maLHP: string;
    maHP: string;
    maHK: string;
    maNam: string;
    maGV: string;
    maPhong: string;
    maCa: string;
    thuTrongTuan: number;
    siSoToiDa: number;
    ghiChu?: string;
    ngayBatDau?: Date | null;
    ngayKetThuc?: Date | null;
    soBuoiHoc: number;
    soBuoiTrongTuan: number;
    trangThaiLop?: string;
    trangThaiCode?: string;
}

@Injectable({
    providedIn: 'root'
})
export class ClassManagementService {
    private apiUrl = 'http://localhost:5265/api/Class';

    constructor(private http: HttpClient) { }

    getClasses(maNam?: string, maHK?: string, pageNumber: number = 1, pageSize: number = 20): Observable<ClassDto[]> {
        let params = new HttpParams();
        if (maNam) params = params.set('maNam', maNam);
        if (maHK) params = params.set('maHK', maHK);
        params = params.set('pageNumber', pageNumber).set('pageSize', pageSize);

        return this.http.get<ClassDto[]>(this.apiUrl, { params });
    }

    createClass(dto: CreateClassDto): Observable<any> {
        return this.http.post(this.apiUrl, dto);
    }

    updateClass(classId: string, dto: UpdateClassDto): Observable<any> {
        return this.http.put(`${this.apiUrl}/${classId}`, dto);
    }

    deleteClass(classId: string): Observable<any> {
        return this.http.delete(`${this.apiUrl}/${classId}`);
    }

    getLecturers(facultyId?: string): Observable<any[]> {
        let params = new HttpParams();
        if (facultyId) params = params.set('facultyId', facultyId);
        return this.http.get<any[]>('http://localhost:5265/api/Lecturer/list', { params });
    }

    checkConflict(request: any): Observable<any> {
        return this.http.post(`${this.apiUrl}/check-conflict`, request);
    }
}
