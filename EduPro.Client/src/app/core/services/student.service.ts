import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface StudentProfile {
    maSV: string;
    hoTen: string;
    ngaySinh: string;
    gioiTinh: string;
    email: string;
    dienThoai: string;
    diaChi?: string;  // Address
    lopHanhChinh: string;
    maNganh: string;
    tenNganh: string;
    maKhoaTS: string;
    tenKhoaTS: string;
    trangThai: string;
}

@Injectable({
    providedIn: 'root'
})
export class StudentService {
    private apiUrl = 'http://localhost:5265/api/Student';

    constructor(private http: HttpClient) { }

    getProfile(studentId: string): Observable<StudentProfile> {
        return this.http.get<StudentProfile>(`${this.apiUrl}/profile/${studentId}`);
    }
}
