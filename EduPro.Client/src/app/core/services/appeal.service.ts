import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface CreateAppealDto {
    maLHP: string;
    lyDo: string;
}

export interface Appeal {
    id: number;
    maLHP: string;
    tenHP: string;
    lyDo: string;
    trangThai: string;
    ngayGui: string;
    ghiChuXuLy?: string;
}

export interface EligibleSubject {
    maLHP: string;
    tenHP: string;
    diemTK: number;
    ngayCongBo: string;
}

@Injectable({
    providedIn: 'root'
})
export class AppealService {
    private apiUrl = 'http://localhost:5265/api/Appeal';

    constructor(private http: HttpClient) { }

    getEligibleSubjects(studentId: string): Observable<EligibleSubject[]> {
        return this.http.get<EligibleSubject[]>(`${this.apiUrl}/eligible-subjects/${studentId}`);
    }

    createAppeal(studentId: string, appeal: CreateAppealDto): Observable<any> {
        return this.http.post(`${this.apiUrl}/create/${studentId}`, appeal);
    }

    getMyAppeals(studentId: string): Observable<Appeal[]> {
        return this.http.get<Appeal[]>(`${this.apiUrl}/my-appeals/${studentId}`);
    }
}
