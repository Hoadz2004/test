import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../../environments/environment';

export interface SinhVienProfile {
    maSV: string;
    hoTen: string;
    ngaySinh?: string;
    gioiTinh?: string;
    email?: string;
    dienThoai?: string;
    diaChi?: string;
    maNganh?: string;
    tenNganh?: string;
    tenKhoa?: string;
    maKhoaTS?: string;
    tenKhoaTS?: string;
    trangThai?: string;
}

@Injectable({
    providedIn: 'root'
})
export class ProfileService {
    private apiUrl = `${environment.apiUrl}/Profile`;

    constructor(private http: HttpClient) { }

    changePassword(oldPassword: string, newPassword: string): Observable<any> {
        return this.http.post(`${this.apiUrl}/change-password`, { oldPassword, newPassword });
    }

    getMyProfile(): Observable<SinhVienProfile> {
        return this.http.get<SinhVienProfile>(`${this.apiUrl}/my-profile`);
    }

    updateProfile(data: any): Observable<any> {
        return this.http.put(`${this.apiUrl}/update`, data);
    }
}
