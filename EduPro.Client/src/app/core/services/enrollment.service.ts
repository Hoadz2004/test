import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface CourseOffering {
    maLHP: string;
    tenHP: string;
    soTinChi: number;
    siSoToiDa: number;
    siSoHienTai: number;
    giangVien: string;
    thuTrongTuan: number;
    maCa: string;
    maPhong: string;
    lichHoc?: string; // Optional if not mapped directly
    trangThaiLop?: string;
    trangThaiCode?: string;
    coTheDangKy?: boolean;
    lyDoKhongDangKy?: string;
}

export interface RegisteredCourse {
    maLHP: string;
    tenHP: string;
    soTinChi: number;
    thuTrongTuan: number;
    maCa: string;
    maPhong: string;
    trangThai: string;
    ngayDangKy: Date;
}

@Injectable({
    providedIn: 'root'
})
export class EnrollmentService {
    private apiUrl = 'http://localhost:5265/api/Enrollment';

    constructor(private http: HttpClient) { }

    getOpenCourses(maNam?: string, maHK?: string): Observable<CourseOffering[]> {
        let params = new HttpParams();
        if (maNam) params = params.set('maNam', maNam);
        if (maHK) params = params.set('maHK', maHK);

        return this.http.get<CourseOffering[]>(`${this.apiUrl}/open-courses`, { params });
    }

    getMyCourses(studentId: string): Observable<RegisteredCourse[]> {
        return this.http.get<RegisteredCourse[]>(`${this.apiUrl}/my-courses/${studentId}`);
    }

    registerCourse(studentId: string, classId: string): Observable<any> {
        return this.http.post(`${this.apiUrl}/register`, { maSV: studentId, maLHP: classId });
    }

    cancelRegistration(studentId: string, classId: string): Observable<any> {
        return this.http.post(`${this.apiUrl}/cancel`, { maSV: studentId, maLHP: classId });
    }
}
