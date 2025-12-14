import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../../environments/environment';

export interface UserDto {
    tenDangNhap: string;
    maVaiTro: string;
    trangThai: boolean;
    ngayTao: string;
    hoTenSV?: string;
    hoTenGV?: string;
    khoaLuc?: string;
}

export interface AuditLogDto {
    logId: number;
    action: string;
    entityTable: string;
    entityId: string;
    oldValue?: string;
    newValue?: string;
    performedBy: string;
    timestamp: string;
    ipAddress?: string;
    status?: string;
    module?: string;
}

@Injectable({
    providedIn: 'root'
})
export class AdminService {
    private apiUrl = `${environment.apiUrl}/Admin`;

    constructor(private http: HttpClient) { }

    getUsers(keyword: string = '', role: string = '', page: number = 1, pageSize: number = 20): Observable<any> {
        let params = new HttpParams()
            .set('keyword', keyword)
            .set('role', role)
            .set('page', page.toString())
            .set('pageSize', pageSize.toString());

        return this.http.get(`${this.apiUrl}/users`, { params });
    }

    createUser(user: any): Observable<any> {
        return this.http.post(`${this.apiUrl}/users`, user);
    }

    updateUserRole(username: string, newRole: string): Observable<any> {
        return this.http.put(`${this.apiUrl}/users/role`, { tenDangNhap: username, newRole: newRole });
    }

    updateUserStatus(username: string, isLocked: boolean, reason: string): Observable<any> {
        return this.http.put(`${this.apiUrl}/users/status`, { tenDangNhap: username, isLocked: isLocked, reason: reason });
    }

    getAuditLogs(keyword: string = '', fromVal: string = '', toVal: string = '', action: string = '', status: string = '', module: string = '', page: number = 1, pageSize: number = 20): Observable<any> {
        let params = new HttpParams()
            .set('keyword', keyword)
            .set('page', page.toString())
            .set('pageSize', pageSize.toString());

        if (fromVal) params = params.set('from', fromVal);
        if (toVal) params = params.set('to', toVal);
        if (action) params = params.set('action', action);
        if (status) params = params.set('status', status);
        if (module) params = params.set('module', module);

        return this.http.get(`${this.apiUrl}/logs`, { params });
    }
}
