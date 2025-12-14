import { Component, OnDestroy, OnInit } from '@angular/core';
import { AdminService, AuditLogDto } from '../../services/admin.service';
import { MatTableDataSource } from '@angular/material/table';
import { MatSnackBar } from '@angular/material/snack-bar';
import { PageEvent } from '@angular/material/paginator';
import { interval, Subscription } from 'rxjs';

@Component({
    selector: 'app-audit-log',
    templateUrl: './audit-log.component.html',
    styleUrls: ['./audit-log.component.css']
})
export class AuditLogComponent implements OnInit, OnDestroy {
    displayedColumns: string[] = ['timestamp', 'performedBy', 'action', 'module', 'details', 'status', 'ipAddress'];
    dataSource = new MatTableDataSource<AuditLogDto>([]);

    keyword = '';
    fromDate: Date | null = null;
    toDate: Date | null = null;
    actionFilter = '';
    statusFilter = '';
    moduleFilter = '';
    totalRecords = 0;
    pageIndex = 0;
    pageSize = 20;
    pageSizeOptions: number[] = [10, 20, 50, 100];

    isLoading = false;
    isError = false;
    errorMessage = '';
    autoRefresh = true;
    refreshIntervalMs = 15000;
    private refreshSub?: Subscription;

    constructor(private adminService: AdminService, private snackBar: MatSnackBar) { }

    ngOnInit(): void {
        this.loadLogs();
        this.startAutoRefresh();
    }

    ngOnDestroy(): void {
        this.stopAutoRefresh();
    }

    loadLogs(): void {
        this.isLoading = true;
        this.isError = false;
        this.errorMessage = '';
        const fromStr = this.fromDate ? this.fromDate.toISOString() : '';
        const toStr = this.toDate ? this.toDate.toISOString() : '';

        this.adminService.getAuditLogs(this.keyword, fromStr, toStr, this.actionFilter, this.statusFilter, this.moduleFilter, this.pageIndex + 1, this.pageSize).subscribe({
            next: (data) => {
                this.dataSource.data = data;
                if (data && data.length > 0 && data[0].totalRecords) {
                    this.totalRecords = data[0].totalRecords;
                } else {
                    this.totalRecords = 0;
                }
                this.isLoading = false;
            },
            error: (err) => {
                this.isError = true;
                this.errorMessage = err?.error?.message || 'Lỗi tải nhật ký.';
                const msg = (err.status === 401 || err.status === 403)
                    ? 'Bạn không có quyền xem nhật ký hoạt động.'
                    : this.errorMessage;
                this.snackBar.open(msg, 'Đóng', { duration: 4000 });
                this.isLoading = false;
            }
        });
    }

    getDetails(log: AuditLogDto): string {
        return `${log.entityTable}:${log.entityId} (New: ${log.newValue || 'N/A'})`;
    }

    onActionFilterChange(value: string): void {
        this.actionFilter = value;
        this.pageIndex = 0;
        this.loadLogs();
    }

    onStatusFilterChange(value: string): void {
        this.statusFilter = value;
        this.pageIndex = 0;
        this.loadLogs();
    }

    onModuleFilterChange(): void {
        this.pageIndex = 0;
        this.loadLogs();
    }

    clearFilters(): void {
        this.keyword = '';
        this.fromDate = null;
        this.toDate = null;
        this.actionFilter = '';
        this.statusFilter = '';
        this.moduleFilter = '';
        this.pageIndex = 0;
        this.loadLogs();
    }

    onPageChange(event: PageEvent): void {
        this.pageIndex = event.pageIndex;
        this.pageSize = event.pageSize;
        this.loadLogs();
    }

    toggleAutoRefresh(checked: boolean): void {
        this.autoRefresh = checked;
        if (checked) {
            this.startAutoRefresh();
        } else {
            this.stopAutoRefresh();
        }
    }

    private startAutoRefresh(): void {
        this.stopAutoRefresh();
        if (this.autoRefresh) {
            this.refreshSub = interval(this.refreshIntervalMs).subscribe(() => this.loadLogs());
        }
    }

    private stopAutoRefresh(): void {
        if (this.refreshSub) {
            this.refreshSub.unsubscribe();
            this.refreshSub = undefined;
        }
    }
}
