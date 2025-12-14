import { Component, OnInit, ViewChild, ElementRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatTabsModule } from '@angular/material/tabs';
import { MatTableModule } from '@angular/material/table';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatSelectModule, MatSelect } from '@angular/material/select';
import { MatInputModule } from '@angular/material/input';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatCardModule } from '@angular/material/card';
import { MatSnackBar, MatSnackBarModule } from '@angular/material/snack-bar';
import { MatDatepickerModule, MatDatepicker } from '@angular/material/datepicker';
import { MatNativeDateModule } from '@angular/material/core';
import { MatTooltipModule } from '@angular/material/tooltip';
import { MatPaginatorModule, PageEvent } from '@angular/material/paginator';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { HostListener } from '@angular/core';
import { forkJoin } from 'rxjs';

import { ClassManagementService, ClassDto, CreateClassDto, UpdateClassDto } from '../../core/services/class-management.service';
import { MasterDataService, MasterDataDto } from '../../core/services/master-data.service';
import { CLASS_MANAGEMENT_MESSAGES, CLASS_STATUS_OPTIONS, CLASS_STATUS_LABEL_BY_CODE, CLASS_STATUS_CODE_BY_TEXT, SNACKBAR_DURATION, DATE_FORMAT } from './classes.constants';
import { TuitionAdminService, HocPhiCatalog } from '../admin/services/tuition-admin.service';

@Component({
    selector: 'app-class-management',
    standalone: true,
    imports: [
        CommonModule, FormsModule,
        ReactiveFormsModule,
        MatTabsModule, MatTableModule, MatButtonModule, MatIconModule,
        MatSelectModule, MatInputModule, MatFormFieldModule, MatCardModule, MatSnackBarModule,
        MatDatepickerModule, MatNativeDateModule, MatTooltipModule, MatPaginatorModule, MatProgressBarModule, MatProgressSpinnerModule
    ],
    templateUrl: './class-management.component.html',
    styleUrls: ['./class-management.component.scss']
})
export class ClassManagementComponent implements OnInit {
    // Constants
    readonly MESSAGES = CLASS_MANAGEMENT_MESSAGES;
    readonly STATUS_OPTIONS = CLASS_STATUS_OPTIONS;
    readonly SNACKBAR_DURATION = SNACKBAR_DURATION;
    readonly DATE_FORMAT = DATE_FORMAT;

    // Data for View
    classes: ClassDto[] = [];
    selectedTabIndex = 0;
    displayedColumns: string[] = ['maLHP', 'tenHP', 'giangVien', 'lichHoc', 'siSo', 'ngayBatDau', 'trangThaiLop', 'action'];
    totalRecords = 0;
    pageIndex = 0;
    pageSize = 10;
    pageSizeOptions = [5, 10, 20, 50];
    selectedStatusCode: string = CLASS_STATUS_OPTIONS[0].code;
    isLoadingList = false;
    isSaving = false;
    filterKeyword = '';
    filterStatusCode = '';

    // Master Data
    years: MasterDataDto[] = [];
    semesters: MasterDataDto[] = [];
    faculties: MasterDataDto[] = [];
    majors: MasterDataDto[] = [];
    subjects: MasterDataDto[] = [];
    classrooms: MasterDataDto[] = [];
    shifts: MasterDataDto[] = [];

    // Filter Data
    filteredMajors: MasterDataDto[] = [];
    filteredSubjects: MasterDataDto[] = [];
    filteredLecturers: MasterDataDto[] = [];

    // Selection state
    selectedYearId: string = '';
    selectedSemesterId: string = '';
    selectedFacultyId: string = '';
    selectedMajorId: string = '';

    // Edit Mode
    isEditMode: boolean = false;
    editingClassId: string = '';
    validationMessage: string = '';
    dateError: string = '';
    isDirty: boolean = false;

    // Fee info
    feeInfo?: HocPhiCatalog;

    // Room busy info
    busyRooms: Record<string, string> = {};
    isCheckingRooms = false;

    // Auto-advance focus
    autoAdvance = true;
    @ViewChild('semesterSel') semesterSel?: MatSelect;
    @ViewChild('startInput') startInput?: ElementRef<HTMLInputElement>;
    @ViewChild('endInput') endInput?: ElementRef<HTMLInputElement>;
    @ViewChild('facultySel') facultySel?: MatSelect;
    @ViewChild('majorSel') majorSel?: MatSelect;
    @ViewChild('subjectSel') subjectSel?: MatSelect;
    @ViewChild('lecturerSel') lecturerSel?: MatSelect;
    @ViewChild('roomSel') roomSel?: MatSelect;
    @ViewChild('weekdaySel') weekdaySel?: MatSelect;
    @ViewChild('shiftSel') shiftSel?: MatSelect;
    @ViewChild('capacityInput') capacityInput?: ElementRef<HTMLInputElement>;

    classForm!: FormGroup;
    get fv() { return this.classForm.controls; }
    get formValue() { return this.classForm.value; }

    constructor(
        private classService: ClassManagementService,
        private masterData: MasterDataService,
        private snackBar: MatSnackBar,
        private tuitionService: TuitionAdminService,
        private fb: FormBuilder
    ) { }

    ngOnInit(): void {
        this.buildForm();
        this.loadMasterData();
    }

    buildForm() {
        this.classForm = this.fb.group({
            maLHP: ['', [Validators.required, Validators.pattern(/^[A-Za-z0-9_-]+$/)]],
            maHP: ['', Validators.required],
            maHK: ['', Validators.required],
            maNam: ['', Validators.required],
            maGV: ['', Validators.required],
            maPhong: ['', Validators.required],
            maCa: ['', Validators.required],
            thuTrongTuan: [null, Validators.required],
            siSoToiDa: [40, [Validators.required, Validators.min(1)]],
            ghiChu: [''],
            ngayBatDau: [null],
            ngayKetThuc: [null],
            soBuoiHoc: [13, [Validators.required, Validators.min(1)]],
            soBuoiTrongTuan: [1, [Validators.required, Validators.min(1), Validators.max(7)]],
            trangThaiLop: ['Sắp khai giảng'],
            trangThaiCode: [CLASS_STATUS_OPTIONS[0].code, Validators.required]
        });
        this.classForm.get('trangThaiCode')?.valueChanges.subscribe(val => {
            this.selectedStatusCode = val || CLASS_STATUS_OPTIONS[0].code;
            const label = CLASS_STATUS_LABEL_BY_CODE[this.selectedStatusCode] || 'Sắp khai giảng';
            this.classForm.patchValue({ trangThaiLop: label }, { emitEvent: false });
        });
    }

    loadMasterData() {
        this.masterData.getAcademicYears().subscribe(d => {
            // Loại bỏ trùng năm học và sắp xếp giảm dần
            const seen = new Set<string>();
            this.years = d
                .map(y => ({ ...y, ma: y.ma.trim(), ten: y.ten.trim() }))
                .filter(y => {
                    const key = y.ma.toUpperCase();
                    if (seen.has(key)) return false;
                    seen.add(key);
                    return true;
                })
                .sort((a, b) => b.ma.localeCompare(a.ma));

            if (this.years.length > 0) {
                this.selectedYearId = this.years[0].ma;
                this.classForm.patchValue({ maNam: this.selectedYearId });
            }
        });
        this.masterData.getSemesters().subscribe(d => {
            this.semesters = d;
            if (d.length > 0) {
                this.selectedSemesterId = d[0].ma;
                this.classForm.patchValue({ maHK: this.selectedSemesterId });
            }
            this.loadClasses(); // Initial load
        });
        this.masterData.getFaculties().subscribe(d => {
            this.faculties = d;
            if (d.length > 0) {
                this.selectedFacultyId = d[0].ma;
            }
        });
        this.masterData.getMajors().subscribe(d => {
            this.majors = d;
            // Prefill majors filtered by selected faculty if available
            if (this.selectedFacultyId) {
                this.filteredMajors = this.majors.filter(m => m.maKhoa === this.selectedFacultyId);
            } else {
                this.filteredMajors = this.majors;
            }
            if (this.filteredMajors.length > 0) {
                this.selectedMajorId = this.filteredMajors[0].ma;
            }
            this.filteredSubjects = this.subjects;
        });
        this.masterData.getSubjects().subscribe(d => this.subjects = d);
        this.masterData.getClassrooms().subscribe(d => {
            this.classrooms = d;
            // Prefill default room when creating (after classrooms loaded)
            if (this.classrooms.length > 0 && !this.classForm.value.maPhong) {
                this.classForm.patchValue({ maPhong: this.classrooms[0].ma });
            }
            this.refreshRoomStatus();
        });
        this.masterData.getShifts().subscribe(d => this.shifts = d);
    }

    loadClasses() {
        this.isLoadingList = true;
        const pageNumber = this.pageIndex + 1;
        this.classService.getClasses(this.selectedYearId, this.selectedSemesterId, pageNumber, this.pageSize)
            .subscribe(d => {
                this.classes = d;
                this.totalRecords = d.length > 0 && d[0].totalRecords ? d[0].totalRecords : 0;
                this.isLoadingList = false;
            }, _ => {
                this.isLoadingList = false;
            });
    }

    get filteredClasses(): ClassDto[] {
        const keyword = this.filterKeyword.trim().toLowerCase();
        const status = this.filterStatusCode;
        return this.classes.filter(c => {
            const matchKeyword = !keyword ||
                c.maLHP.toLowerCase().includes(keyword) ||
                c.tenHP.toLowerCase().includes(keyword) ||
                c.tenGV.toLowerCase().includes(keyword);
            const code = this.getStatusCode(c);
            const matchStatus = !status || code === status;
            return matchKeyword && matchStatus;
        });
    }

    onFilterChanged() {
        this.pageIndex = 0;
        this.loadClasses();
    }

    onPageChange(event: PageEvent) {
        this.pageIndex = event.pageIndex;
        this.pageSize = event.pageSize;
        this.loadClasses();
    }

    onFacultyChange() {
        this.markDirty();
        // Filter majors by faculty (Assuming 'maKhoa' is available in Major DTO logic, but simple filtering by prefix or ID if aligned)
        // Here we use the 'maKhoa' property we added to MasterDataDto earlier
        this.filteredMajors = this.majors.filter(m => m.maKhoa === this.selectedFacultyId);
        this.selectedMajorId = '';
        this.filteredSubjects = [];

        // Fetch lecturers for this faculty
        this.classService.getLecturers(this.selectedFacultyId).subscribe(
            data => this.filteredLecturers = data
        );
        this.classForm.patchValue({ maGV: '', maPhong: '', maHP: '' });
        if (this.autoAdvance && this.majorSel) {
            setTimeout(() => this.majorSel?.open());
        }
    }

    onMajorChange() {
        this.markDirty();
        // In a real system, subjects belong to a Curriculum (Khung chuong trinh) of a Major.
        // For this simulation, we will show ALL subjects, OR filter structurally if we had that data.
        // Let's just show all subjects for now as Proof of Concept, or filter partially.
        this.filteredSubjects = this.subjects;
        // Optimized: In real life, filter by curriculum.
        this.classForm.patchValue({ maHP: '' });

        // Load fee info for major/semester
        const maHK = this.classForm.value.maHK;
        if (this.selectedMajorId && maHK) {
            this.tuitionService.getFeeByMajorSemester(this.selectedMajorId, maHK)
                .subscribe(fee => this.feeInfo = fee || undefined);
        }
        if (this.autoAdvance && this.subjectSel) {
            setTimeout(() => this.subjectSel?.open());
        }
    }

    onFacultyClosed() {
        if (!this.autoAdvance || !this.majorSel) return;
        setTimeout(() => this.majorSel?.open());
    }

    createClass() {
        if (!this.validateInputs()) return;
        this.isSaving = true;
        const formVal = this.classForm.value;
        const statusCode = formVal.trangThaiCode || this.selectedStatusCode;
        const statusLabel = CLASS_STATUS_LABEL_BY_CODE[statusCode] || formVal.trangThaiLop;
        const payload: CreateClassDto = {
            ...formVal,
            trangThaiCode: statusCode,
            trangThaiLop: statusLabel
        };

        this.classService.createClass(payload).subscribe({
            next: () => {
                this.snackBar.open(this.MESSAGES.CREATE_SUCCESS, this.MESSAGES.CLOSE_BUTTON, { duration: this.SNACKBAR_DURATION });
                this.loadClasses();
                this.focusYear();
                this.selectedTabIndex = 0;
                this.isSaving = false;
                this.isDirty = false;
                this.resetCreateForm();
                setTimeout(() => {
                    if (this.startInput) {
                        this.startInput.nativeElement.focus();
                    }
                }, 150);
            },
            error: (err) => {
                this.snackBar.open(err.error?.message || this.MESSAGES.CREATE_ERROR, this.MESSAGES.CLOSE_BUTTON, { duration: this.SNACKBAR_DURATION });
                this.isSaving = false;
            }
        });
    }

    editClass(classData: ClassDto) {
        this.isEditMode = true;
        this.selectedTabIndex = 1;
        // Prefill filters/lists for edit mode
        this.selectedYearId = classData.maNam || this.selectedYearId;
        this.selectedSemesterId = classData.maHK || this.selectedSemesterId;
        // Try preselect faculty/major if class data provides them (optional fields)
        const classFaculty = (classData as any).maKhoa as string | undefined;
        const classMajor = (classData as any).maNganh as string | undefined;
        if (classFaculty) {
            this.selectedFacultyId = classFaculty;
        }
        this.filteredMajors = this.selectedFacultyId
            ? this.majors.filter(m => m.maKhoa === this.selectedFacultyId)
            : this.majors;
        if (classMajor) {
            this.selectedMajorId = classMajor;
        }
        this.filteredSubjects = this.subjects; // enable subject select when editing existing class
        // Load lecturers (all or by faculty if available)
        this.classService.getLecturers(this.selectedFacultyId || undefined).subscribe(
            data => {
                this.filteredLecturers = data;
            }
        );
        this.editingClassId = (classData.maLHP || '').trim();
        this.selectedStatusCode = classData.trangThaiCode || this.toStatusCode(classData.trangThaiLop);
        this.classForm.patchValue({
            maLHP: this.editingClassId,
            maHP: classData.maHP,
            maHK: classData.maHK,
            maNam: classData.maNam,
            maGV: classData.maGV,
            maPhong: classData.maPhong,
            maCa: classData.maCa,
            thuTrongTuan: classData.thuTrongTuan,
            siSoToiDa: classData.siSoToiDa,
            ghiChu: classData.ghiChu || '',
            ngayBatDau: classData.ngayBatDau || null,
            ngayKetThuc: classData.ngayKetThuc || null,
            soBuoiHoc: classData.soBuoiHoc,
            soBuoiTrongTuan: classData.soBuoiTrongTuan,
            trangThaiLop: classData.trangThaiLop,
            trangThaiCode: classData.trangThaiCode || this.selectedStatusCode
        });
        this.isDirty = false;
    }

    updateClass() {
        if (!this.validateInputs()) return;
        this.isSaving = true;
        const formVal = this.classForm.value;
        const updateDto: UpdateClassDto = { ...(formVal as UpdateClassDto) };
        // Bảo đảm mã lớp trong payload khớp với param và được trim
        updateDto.maLHP = (this.editingClassId || '').trim();
        this.classForm.patchValue({ maLHP: updateDto.maLHP });
        const statusCode = formVal.trangThaiCode || this.selectedStatusCode;
        const statusLabel = CLASS_STATUS_LABEL_BY_CODE[statusCode] || formVal.trangThaiLop;
        updateDto.trangThaiCode = statusCode;
        updateDto.trangThaiLop = statusLabel;
        this.classService.updateClass(this.editingClassId, updateDto).subscribe({
            next: () => {
                this.snackBar.open(this.MESSAGES.UPDATE_SUCCESS, this.MESSAGES.CLOSE_BUTTON, { duration: this.SNACKBAR_DURATION });
                this.cancelEdit();
                this.loadClasses();
                this.isSaving = false;
                this.isDirty = false;
            },
            error: (err) => {
                this.snackBar.open(err.error?.message || this.MESSAGES.UPDATE_ERROR, this.MESSAGES.CLOSE_BUTTON, { duration: this.SNACKBAR_DURATION });
                this.isSaving = false;
            }
        });
    }

    cancelEdit() {
        this.isEditMode = false;
        this.selectedTabIndex = 0;
        this.editingClassId = '';
        this.resetCreateForm();
    }

    deleteClass(id: string) {
        if (!confirm(this.MESSAGES.CONFIRM_DELETE)) return;
        this.classService.deleteClass(id).subscribe({
            next: () => {
                this.snackBar.open(this.MESSAGES.DELETE_SUCCESS, this.MESSAGES.CLOSE_BUTTON, { duration: this.SNACKBAR_DURATION });
                this.loadClasses();
            },
            error: (err) => this.snackBar.open(err.error?.message || this.MESSAGES.DELETE_ERROR, this.MESSAGES.CLOSE_BUTTON, { duration: this.SNACKBAR_DURATION })
        });
    }

    isValidClass() {
        const hasRequired = this.classForm.valid && !this.conflictMessage;
        const dateOk = this.isDateRangeValid();
        return hasRequired && dateOk;
    }

    private openSelect(select?: MatSelect) {
        if (!this.autoAdvance || !select) return;
        setTimeout(() => select.open());
    }

    private focusInput(el?: ElementRef<HTMLInputElement>) {
        if (!this.autoAdvance || !el) return;
        setTimeout(() => el.nativeElement.focus());
    }

    focusYear() {
        // intentionally empty placeholder if needed later; sequence starts at semester after year
    }

    // Auto advance handlers
    onYearSelected() {
        this.markDirty();
        this.openSelect(this.semesterSel);
    }

    onSemesterSelected() {
        this.markDirty();
        this.focusInput(this.startInput);
    }

    onStartDateSelected() {
        this.markDirty();
        this.focusInput(this.endInput);
        this.updateDateValidation();
    }

    onEndDateSelected() {
        this.markDirty();
        this.openSelect(this.facultySel);
        this.updateDateValidation();
    }

    onSubjectSelected() {
        this.markDirty();
        this.openSelect(this.lecturerSel);
    }

    onLecturerSelected() {
        this.markDirty();
        this.openSelect(this.weekdaySel);
    }

    onRoomSelected() {
        this.markDirty();
    }

    onWeekdaySelected() {
        this.markDirty();
        this.classForm.patchValue({ maPhong: '' });
        this.openSelect(this.shiftSel);
        this.refreshRoomStatus();
    }

    onShiftSelected() {
        this.markDirty();
        this.classForm.patchValue({ maPhong: '' });
        // Sau khi chọn Ca, chuyển qua chọn Phòng
        this.refreshRoomStatus();
        this.openSelect(this.roomSel);
    }

    toStatusCode(textOrCode?: string): string {
        if (!textOrCode) return CLASS_STATUS_OPTIONS[0].code;
        if (CLASS_STATUS_LABEL_BY_CODE[textOrCode]) return textOrCode; // already code
        return CLASS_STATUS_CODE_BY_TEXT[textOrCode] || CLASS_STATUS_OPTIONS[0].code;
    }

    displayStatus(textOrCode?: string): string {
        if (!textOrCode) return CLASS_STATUS_LABEL_BY_CODE[CLASS_STATUS_OPTIONS[0].code];
        if (CLASS_STATUS_LABEL_BY_CODE[textOrCode]) return CLASS_STATUS_LABEL_BY_CODE[textOrCode];
        const code = CLASS_STATUS_CODE_BY_TEXT[textOrCode];
        if (code && CLASS_STATUS_LABEL_BY_CODE[code]) return CLASS_STATUS_LABEL_BY_CODE[code];
        return textOrCode;
    }

    getStatusCode(item: ClassDto): string {
        const rawCode = (item.trangThaiCode || '').trim();
        const rawText = (item.trangThaiLop || '').trim();
        const derivedFromText = rawText ? CLASS_STATUS_CODE_BY_TEXT[rawText] : '';

        // Nếu code hợp lệ, dùng code
        if (rawCode && CLASS_STATUS_LABEL_BY_CODE[rawCode]) {
            // Nhưng nếu code đang là PLANNED trong khi text khác, ưu tiên text để hiển thị đúng
            if (rawCode === CLASS_STATUS_OPTIONS[0].code && derivedFromText && derivedFromText !== rawCode) {
                return derivedFromText;
            }
            return rawCode;
        }

        // Nếu code không hợp lệ hoặc thiếu, suy ra từ text
        if (derivedFromText) return derivedFromText;

        return CLASS_STATUS_OPTIONS[0].code;
    }

    getStatusLabel(item: ClassDto): string {
        const code = this.getStatusCode(item);
        return CLASS_STATUS_LABEL_BY_CODE[code] || item.trangThaiLop || CLASS_STATUS_LABEL_BY_CODE[CLASS_STATUS_OPTIONS[0].code];
    }

    private isDateRangeValid(): boolean {
        const start = this.classForm.value.ngayBatDau;
        const end = this.classForm.value.ngayKetThuc;
        if (!start || !end) return true;
        return new Date(start) <= new Date(end);
    }

    private updateDateValidation(): void {
        const formVal = this.classForm.value;
        if (!formVal.ngayBatDau || !formVal.ngayKetThuc) {
            this.dateError = '';
            return;
        }
        if (!this.isDateRangeValid()) {
            this.dateError = 'Ngày bắt đầu phải trước hoặc bằng ngày kết thúc.';
        } else {
            this.dateError = '';
        }
        // Khi thay đổi ngày, refresh phòng trống
        this.refreshRoomStatus();
    }

    private validateInputs(): boolean {
        if (!this.classForm.valid) {
            this.classForm.markAllAsTouched();
            this.snackBar.open('Vui lòng điền đủ thông tin và kiểm tra ngày hợp lệ.', this.MESSAGES.CLOSE_BUTTON, { duration: this.SNACKBAR_DURATION });
            return false;
        }
        if (!this.isDateRangeValid()) {
            this.snackBar.open('Ngày bắt đầu phải trước hoặc bằng ngày kết thúc.', this.MESSAGES.CLOSE_BUTTON, { duration: this.SNACKBAR_DURATION });
            return false;
        }
        const code = (this.classForm.value.maLHP || '').toLowerCase();
        const duplicate = this.classes.some(
            c => c.maLHP.toLowerCase() === code && c.maLHP !== this.editingClassId
        );
        if (duplicate) {
            this.snackBar.open('Mã lớp đã tồn tại, vui lòng chọn mã khác.', this.MESSAGES.CLOSE_BUTTON, { duration: this.SNACKBAR_DURATION });
            return false;
        }
        return true;
    }

    // Conflict Detection
    conflictMessage: string = '';

    checkConflict() {
        this.markDirty();
        const formVal = this.classForm.value;
        // Only check if minimal info is present
        if (!formVal.maNam || !formVal.maHK || !formVal.maCa || !formVal.thuTrongTuan) {
            this.conflictMessage = '';
            return;
        }
        // At least Room or Lecturer must be selected
        if (!formVal.maPhong && !formVal.maGV) {
            this.conflictMessage = '';
            return;
        }

        const request = {
            maLHP: this.editingClassId || formVal.maLHP,
            maNam: formVal.maNam,
            maHK: formVal.maHK,
            thu: formVal.thuTrongTuan,
            maCa: formVal.maCa,
            maPhong: formVal.maPhong || null,
            maGV: formVal.maGV || null
        };

        this.classService.checkConflict(request).subscribe(res => {
            if (res.isConflict) {
                this.conflictMessage = res.conflictMessage;
            } else {
                this.conflictMessage = '';
            }
        });
    }

    markDirty() {
        if (this.isSaving) return;
        this.isDirty = true;
        if (this.classForm) {
            this.classForm.markAsDirty();
        }
    }

    refreshRoomStatus() {
        const formVal = this.classForm.value;
        // Cần đủ thông tin tối thiểu
        if (!formVal.maNam || !formVal.maHK || !formVal.maCa || !formVal.thuTrongTuan) {
            this.busyRooms = {};
            return;
        }
        if (!this.classrooms || this.classrooms.length === 0) return;

        this.isCheckingRooms = true;
        const requests = this.classrooms.map(room =>
            this.classService.checkConflict({
                maLHP: this.editingClassId || formVal.maLHP,
                maNam: formVal.maNam,
                maHK: formVal.maHK,
                thu: formVal.thuTrongTuan,
                maCa: formVal.maCa,
                maPhong: room.ma,
                // Khi kiểm tra danh sách phòng rảnh, chỉ check trùng phòng để không bị trùng do giảng viên
                maGV: null
            }).pipe(
                // Nếu không đủ info trả về rỗng
                // nhưng ở đây đã kiểm nên không cần thêm catch
            )
        );

        forkJoin(requests).subscribe({
            next: (results) => {
                const map: Record<string, string> = {};
                results.forEach((res, idx) => {
                    if (res && res.isConflict) {
                        map[this.classrooms[idx].ma] = res.conflictMessage || 'Bận';
                    }
                });
                this.busyRooms = map;
                // Nếu phòng đang chọn trở nên bận thì clear để tránh gửi sai
                const currentRoom = this.classForm.value.maPhong;
                if (currentRoom && this.busyRooms[currentRoom]) {
                    this.classForm.patchValue({ maPhong: '' });
                }
                this.isCheckingRooms = false;
            },
            error: () => {
                // Nếu lỗi, giữ danh sách cũ để tránh chặn toàn bộ
                this.isCheckingRooms = false;
            }
        });
    }

    @HostListener('window:beforeunload', ['$event'])
    unloadNotification($event: any) {
        if (this.isDirty && !this.isSaving) {
            $event.returnValue = true;
        }
    }

    onTabChange(index: number) {
        this.selectedTabIndex = index;
        // Khi chuyển sang tab Mở Lớp Mới (index 1) mà không ở chế độ sửa, reset form để tránh dữ liệu cũ
        if (index === 1 && !this.isEditMode) {
            this.resetCreateForm();
            this.isEditMode = false;
            this.editingClassId = '';
            this.selectedTabIndex = 1; // giữ nguyên tab tạo mới
        }
    }

    private resetCreateForm() {
        this.classForm.reset({
            maLHP: '',
            maHP: '',
            maHK: this.selectedSemesterId || '',
            maNam: this.selectedYearId || '',
            maGV: '',
            maPhong: '',
            maCa: '',
            thuTrongTuan: null,
            siSoToiDa: 40,
            ghiChu: '',
            ngayBatDau: null,
            ngayKetThuc: null,
            soBuoiHoc: 13,
            soBuoiTrongTuan: 1,
            trangThaiLop: 'Sắp khai giảng',
            trangThaiCode: CLASS_STATUS_OPTIONS[0].code
        });
        this.selectedStatusCode = CLASS_STATUS_OPTIONS[0].code;
        this.selectedFacultyId = '';
        this.selectedMajorId = '';
        this.feeInfo = undefined;
        this.isDirty = false;
    }
}
