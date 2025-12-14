import { Component, OnInit, ViewChild } from '@angular/core';
import { AdminService, UserDto } from '../../services/admin.service';
import { MatPaginator } from '@angular/material/paginator';
import { MatTableDataSource } from '@angular/material/table';
import { MatSnackBar } from '@angular/material/snack-bar';

@Component({
    selector: 'app-user-management',
    templateUrl:dot './user-management.component.html',
    styleUrls: ['./user-management.component.css']
})
export class UserManagementComponent implements OnInit {
    displayedColumns: string[] = ['tenDangNhap', 'hoTen', 'maVaiTro', 'trangThai', 'ngayTao', 'actions'];
    dataSource = new MatTableDataSource<UserDto>([]);
    totalRecords = 0;
    isLoading = false;

    filterKeyword = '';
    filterRole = '';

    isCreating = false;
    newUser = {
        tenDangNhap: '',
        matKhau: '',
        maVaiTro: 'SINHVIEN',
        hoTen: '',
        email: '',
        dienThoai: ''
    };

    @ViewChild(MatPaginator) paginator!: MatPaginator;

    constructor(private adminService: AdminService, private snackBar: MatSnackBar) { }

    ngOnInit(): void {
        this.loadUsers();
    }

    loadUsers(page: number = 1): void {
        this.isLoading = true;
        this.adminService.getUsers(this.filterKeyword, this.filterRole, page, 20).subscribe({
            next: (data: any) => {
                this.dataSource.data = data;
                if (data.length > 0) {
                    this.totalRecords = data[0].totalRecords;
                }
                this.isLoading = false;
            },
            error: () => {
                this.snackBar.open('Lỗi tải danh sách', 'Đóng', { duration: 3000 });
                this.isLoading = false;
            }
        });
    }

    applyFilter(): void {
        this.loadUsers(1);
    }

    toggleStatus(user: UserDto): void {
        const isLocked = !this.isLocked(user);
        if (!confirm(`Bạn có chắc muốn ${isLocked ? 'KHÓA' : 'MỞ KHÓA'} tài khoản ${user.tenDangNhap}?`)) return;

        this.adminService.updateUserStatus(user.tenDangNhap, isLocked, isLocked ? 'Admin locked' : 'Unlocked').subscribe({
            next: () => {
                this.snackBar.open('Cập nhật thành công', 'Đóng', { duration: 2000 });
                this.loadUsers();
            },
            error: () => this.snackBar.open('Lỗi cập nhật', 'Đóng', { duration: 3000 })
        });
    }

    isLocked(user: UserDto): boolean {
        return !!user.khoaLuc && new Date(user.khoaLuc) > new Date();
    }

    getDisplayName(user: UserDto): string {
        return user.hoTenSV || user.hoTenGV || 'N/A';
    }

    createUser(): void {
        if (!this.newUser.tenDangNhap || !this.newUser.matKhau || !this.newUser.hoTen) {
            this.snackBar.open('Vui lòng nhập Username, Password và Họ Tên', 'Đóng', { duration: 2000 });
            return;
        }

        this.adminService.createUser(this.newUser).subscribe({
            next: () => {
                this.snackBar.open('Tạo tài khoản thành công!', 'Đóng', { duration: 2000 });
                this.isCreating = false;
                this.newUser = { tenDangNhap: '', matKhau: '', maVaiTro: 'SINHVIEN', hoTen: '', email: '', dienThoai: '' };
                this.loadUsers();
            },
            error: (err) => {
                this.snackBar.open('Lỗi: ' + (err.error?.message || 'Không xác định'), 'Đóng', { duration: 5000 });
            }
        });
    }
}
