import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface GraduationResult {
    lanXet: number;
    ketQua: string;
    lyDo: string;
    ngayXet: string;
}

@Injectable({
    providedIn: 'root'
})
export class GraduationService {
    private apiUrl = 'http://localhost:5265/api/Graduation';

    constructor(private http: HttpClient) { }

    checkStatus(studentId: string): Observable<GraduationResult> {
        return this.http.get<GraduationResult>(`${this.apiUrl}/check-status/${studentId}`);
    }
}
