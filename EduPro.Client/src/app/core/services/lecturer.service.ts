import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface LecturerProfile {
    maGV: string;
    hoTen: string;
    email: string;
    dienThoai: string;
    maKhoa: string;
    tenKhoa: string;
}

@Injectable({
    providedIn: 'root'
})
export class LecturerService {
    private apiUrl = 'http://localhost:5265/api/Lecturer';

    constructor(private http: HttpClient) { }

    getProfile(lecturerId: string): Observable<LecturerProfile> {
        return this.http.get<LecturerProfile>(`${this.apiUrl}/profile/${lecturerId}`);
    }
}
