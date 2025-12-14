import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, map } from 'rxjs';

export interface MasterDataDto {
    ma: string;
    ten: string;
    maKhoa?: string;
}

@Injectable({
    providedIn: 'root'
})
export class MasterDataService {
    private apiUrl = 'http://localhost:5265/api/MasterData';

    constructor(private http: HttpClient) { }

    getFaculties(): Observable<MasterDataDto[]> {
        return this.http.get<MasterDataDto[]>(`${this.apiUrl}/faculties`);
    }

    getMajors(): Observable<MasterDataDto[]> {
        return this.http.get<MasterDataDto[]>(`${this.apiUrl}/majors`);
    }

    getSemesters(): Observable<MasterDataDto[]> {
        return this.http.get<MasterDataDto[]>(`${this.apiUrl}/semesters`);
    }

    getAcademicYears(): Observable<MasterDataDto[]> {
        return this.http.get<MasterDataDto[]>(`${this.apiUrl}/academic-years`).pipe(
            map(list => {
                const seen = new Set<string>();
                return list
                    .map(y => ({ ...y, ma: y.ma.trim(), ten: y.ten.trim() }))
                    .filter(y => {
                        const key = y.ma.toUpperCase();
                        if (seen.has(key)) return false;
                        seen.add(key);
                        return true;
                    })
                    .sort((a, b) => b.ma.localeCompare(a.ma));
            })
        );
    }

    getAdmissionBatches(): Observable<MasterDataDto[]> {
        return this.http.get<MasterDataDto[]>(`${this.apiUrl}/batches`);
    }

    getClassrooms(): Observable<MasterDataDto[]> {
        return this.http.get<MasterDataDto[]>(`${this.apiUrl}/classrooms`);
    }

    getShifts(): Observable<MasterDataDto[]> {
        return this.http.get<MasterDataDto[]>(`${this.apiUrl}/shifts`);
    }

    getSubjects(): Observable<MasterDataDto[]> {
        return this.http.get<MasterDataDto[]>(`${this.apiUrl}/subjects`);
    }
}
