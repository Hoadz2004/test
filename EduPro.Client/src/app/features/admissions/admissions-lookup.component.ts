import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormBuilder, Validators } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';
import { AdmissionsService, AdmissionDto } from './admissions.service';

@Component({
  selector: 'app-admissions-lookup',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, MatFormFieldModule, MatInputModule, MatButtonModule],
  templateUrl: './admissions-lookup.component.html',
  styleUrls: ['./admissions-lookup.component.scss']
})
export class AdmissionsLookupComponent {
  result?: AdmissionDto;
  notFound = false;
  form = this.fb.group({
    code: ['', Validators.required]
  });

  constructor(private fb: FormBuilder, private service: AdmissionsService) {}

  lookup() {
    if (this.form.invalid) return;
    this.service.lookup(this.form.value.code!).subscribe({
      next: res => {
        this.result = res;
        this.notFound = false;
      },
      error: () => {
        this.result = undefined;
        this.notFound = true;
      }
    });
  }
}
