import { Component, OnInit } from "@angular/core";
import { CommonModule } from "@angular/common";
import { ActivatedRoute } from "@angular/router";
import { FormsModule } from "@angular/forms";
import { MatCardModule } from "@angular/material/card";
import { MatButtonModule } from "@angular/material/button";
import { MatFormFieldModule } from "@angular/material/form-field";
import { MatSelectModule } from "@angular/material/select";
import { MatSnackBar, MatSnackBarModule } from "@angular/material/snack-bar";
import { AdmissionsService, AdmissionDto } from "../../../admissions/admissions.service";

@Component({
  standalone: true,
  selector: "app-admissions-detail",
  imports: [CommonModule, FormsModule, MatCardModule, MatButtonModule, MatFormFieldModule, MatSelectModule, MatSnackBarModule],
  templateUrl: "./admissions-detail.component.html",
  styleUrls: ["./admissions-detail.component.scss"]
})
export class AdmissionsDetailComponent implements OnInit {
  admission?: AdmissionDto;
  statuses = [
    "Đã nộp",
    "Đủ hồ sơ",
    "Thiếu hồ sơ",
    "Mời phỏng vấn",
    "Đủ điều kiện",
    "Đậu",
    "Rớt",
    "Đã nhập học",
    "Chưa đạt"
  ];

  constructor(
    private route: ActivatedRoute,
    private service: AdmissionsService,
    private snack: MatSnackBar
  ) {}

  ngOnInit(): void {
    const code = this.route.snapshot.paramMap.get("code");
    if (code) {
      this.service.lookup(code).subscribe(ad => (this.admission = ad));
    }
  }

  updateStatus() {
    if (!this.admission) return;
    this.service
      .updateStatus({ id: this.admission.id, trangThai: this.admission.trangThai, ghiChu: this.admission.ghiChu })
      .subscribe({
        next: () => this.snack.open("Đã lưu và gửi email.", "Đóng", { duration: 2500 }),
        error: () => this.snack.open("Lưu trạng thái thất bại.", "Đóng", { duration: 2500 })
      });
  }
}
