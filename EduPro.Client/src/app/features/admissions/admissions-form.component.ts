import { Component, ViewChild } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormBuilder, Validators } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';
import { MatSelectModule } from '@angular/material/select';
import { AdmissionsService, AdmissionRequirement } from './admissions.service';
import { MasterDataService, MasterDataDto } from '../../core/services/master-data.service';
import { MatSelect } from '@angular/material/select';

@Component({
  selector: 'app-admissions-form',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, MatFormFieldModule, MatInputModule, MatButtonModule, MatSelectModule],
  templateUrl: './admissions-form.component.html',
  styleUrls: ['./admissions-form.component.scss']
})
export class AdmissionsFormComponent {
  submitted = false;
  trackingCode = '';
  years: MasterDataDto[] = [];
  semesters: MasterDataDto[] = [];
  majors: MasterDataDto[] = [];
  autoAdvance = true;
  requirement?: AdmissionRequirement;
  @ViewChild('hkSel') hkSel?: MatSelect;
  @ViewChild('majorSel') majorSel?: MatSelect;

  form = this.fb.group({
    fullName: ['', Validators.required],
    email: [''],
    phone: [''],
    cccd: [''],
    ngaySinh: [''],
    diaChi: [''],
    maNam: ['', Validators.required],
    maHK: ['', Validators.required],
    maNganh: ['', Validators.required],
    ghiChu: [''],
    diem1: [null],
    diem2: [null],
    diem3: [null]
  });

  constructor(private fb: FormBuilder, private service: AdmissionsService, private master: MasterDataService) {
    this.master.getAcademicYears().subscribe(res => this.years = res);
    this.master.getSemesters().subscribe(res => this.semesters = res);
    this.master.getMajors().subscribe(res => this.majors = res);
  }

  submit() {
    if (this.form.invalid) return;
    const v = this.form.value;
    const payload: any = {
      fullName: v.fullName!,
      email: v.email || undefined,
      phone: v.phone || undefined,
      cccd: v.cccd || undefined,
      ngaySinh: v.ngaySinh || undefined,
      diaChi: v.diaChi || undefined,
      maNam: v.maNam,
      maHK: v.maHK,
      maNganh: v.maNganh,
      ghiChu: v.ghiChu || undefined
    };

    if (this.requirement) {
      payload.mon1 = this.requirement.mon1;
      payload.mon2 = this.requirement.mon2;
      payload.mon3 = this.requirement.mon3;
      payload.diem1 = v.diem1 ?? 0;
      payload.diem2 = v.diem2 ?? 0;
      payload.diem3 = v.diem3 ?? 0;
    }

    this.service.create(payload).subscribe(res => {
      this.submitted = true;
      this.trackingCode = res.maTraCuu;
    });
  }

  onYearSelected() {
    if (this.autoAdvance && this.hkSel) setTimeout(() => this.hkSel?.open());
  }

  onSemesterSelected() {
    if (this.autoAdvance && this.majorSel) setTimeout(() => this.majorSel?.open());
  }

  onMajorSelected() {
    const maNganh = this.form.value.maNganh!;
    if (!maNganh) return;
    this.service.getRequirement(maNganh).subscribe({
      next: (req) => {
        this.requirement = req;
        this.setScoreValidators(true);
      },
      error: () => {
        this.requirement = undefined;
        this.setScoreValidators(false);
      }
    });
  }

  private setScoreValidators(required: boolean) {
    const validators = required ? [Validators.required] : [];
    this.form.get('diem1')?.setValidators(validators);
    this.form.get('diem2')?.setValidators(validators);
    this.form.get('diem3')?.setValidators(validators);
    this.form.get('diem1')?.updateValueAndValidity();
    this.form.get('diem2')?.updateValueAndValidity();
    this.form.get('diem3')?.updateValueAndValidity();
  }
}
