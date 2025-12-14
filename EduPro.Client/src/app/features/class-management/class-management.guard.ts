import { Injectable } from '@angular/core';
import { CanDeactivate } from '@angular/router';
import { ClassManagementComponent } from './class-management.component';

@Injectable({ providedIn: 'root' })
export class ClassManagementDeactivateGuard implements CanDeactivate<ClassManagementComponent> {
  canDeactivate(component: ClassManagementComponent): boolean {
    if (component.isDirty && !component['isSaving']) {
      return confirm('Bạn có chắc muốn rời trang? Thay đổi sẽ không được lưu.');
    }
    return true;
  }
}
