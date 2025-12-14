import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../../../environments/environment';

export interface CTDT {
    maCTDT: number;
    maNganh: string;
    tenNganh: string;
    maKhoaTS: string;
    tenKhoaTS: string;
    tenCTDT: string;
    namBanHanh: number;
    trangThai: number;
    totalRecords?: number;
}

export interface CTDTSubject {
    id: number;
    maCTDT: number;
    maHP: string;
    tenHP: string;
    soTinChi: number;
    hocKyDuKien: number;
    batBuoc: boolean;
    nhomTuChon?: string;
    monTienQuyet?: string;
}

export interface CTDTDetail extends CTDT {
    subjects: CTDTSubject[];
}

export interface CreateCTDTRequest {
    maNganh: string;
    maKhoaTS: string;
    tenCTDT: string;
    namBanHanh: number;
    trangThai: number;
}

export interface AddSubjectRequest {
    maCTDT: number;
    maHP: string;
    hocKyDuKien: number;
    batBuoc: boolean;
    nhomTuChon?: string;
}

export interface AddPrerequisiteRequest {
    maHP: string;
    maHP_TienQuyet: string;
}

@Injectable({
    providedIn: 'root'
})
export class TrainingProgramService {
    private apiUrl = `${environment.apiUrl}/TrainingProgram`;

    constructor(private http: HttpClient) { }

    getCTDTs(keyword: string = '', page: number = 1, pageSize: number = 20): Observable<{ data: CTDT[] }> {
        return this.http.get<{ data: CTDT[] }>(`${this.apiUrl}/admin/list`, {
            params: { keyword, page, pageSize }
        });
    }

    createCTDT(data: CreateCTDTRequest): Observable<any> {
        return this.http.post(`${this.apiUrl}/admin/create`, data);
    }

    getCTDTDetail(id: number): Observable<{ data: CTDTDetail }> {
        return this.http.get<{ data: CTDTDetail }>(`${this.apiUrl}/admin/detail/${id}`);
    }

    addSubject(data: AddSubjectRequest): Observable<any> {
        return this.http.post(`${this.apiUrl}/admin/add-subject`, data);
    }

    removeSubject(id: number): Observable<any> {
        return this.http.delete(`${this.apiUrl}/admin/remove-subject/${id}`);
    }

    addPrerequisite(data: AddPrerequisiteRequest): Observable<any> {
        return this.http.post(`${this.apiUrl}/admin/add-prerequisite`, data);
    }

    getMyCurriculum(): Observable<any> {
        return this.http.get(`${this.apiUrl}/student/my-curriculum`);
    }
}
