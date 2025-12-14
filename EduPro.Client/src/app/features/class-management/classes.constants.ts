/**
 * Class Management Constants
 * Vietnamese Text with UTF-8 Encoding
 */

export const CLASS_MANAGEMENT_MESSAGES = {
  // Success Messages
  CREATE_SUCCESS: 'Mở lớp thành công!',
  UPDATE_SUCCESS: 'Cập nhật lớp thành công!',
  DELETE_SUCCESS: 'Xóa lớp thành công!',

  // Error Messages
  CREATE_ERROR: 'Không thể mở lớp. Vui lòng thử lại.',
  UPDATE_ERROR: 'Không thể cập nhật lớp. Vui lòng thử lại.',
  DELETE_ERROR: 'Không thể xóa lớp. Vui lòng thử lại.',
  GENERIC_ERROR: 'Có lỗi xảy ra. Vui lòng thử lại.',

  // Validation Errors
  CLASS_CODE_EXISTS: 'Mã lớp học phần đã tồn tại.',
  CLASSROOM_CONFLICT: 'Phòng học đã bị trùng lịch trong ngày và ca này.',
  LECTURER_CONFLICT: 'Giảng viên đã có lịch dạy trong ngày và ca này.',
  CLASS_CODE_NOT_FOUND: 'Mã lớp học phần không tồn tại.',
  CANNOT_DELETE_WITH_STUDENTS: 'Không thể xóa lớp học phần đã có sinh viên đăng ký.',

  // Confirmation Messages
  CONFIRM_DELETE: 'Bạn chắc chắn muốn xóa lớp này?',

  // Button Labels
  CLOSE_BUTTON: 'Đóng',
  BUTTON_CREATE: 'MỞ LỚP',
  BUTTON_UPDATE: 'CẬP NHẬT',
  BUTTON_CANCEL: 'HỦY',
  BUTTON_REFRESH: 'Làm mới',
  BUTTON_EDIT: 'Sửa',
  BUTTON_DELETE: 'Xóa',

  // Form Labels
  START_DATE: 'Ngày Bắt Đầu',
  END_DATE: 'Ngày Kết Thúc',
  SESSIONS: 'Số Buổi Học',
  SESSIONS_PER_WEEK: 'Số Buổi/Tuần',
  CLASS_STATUS: 'Trạng Thái Lớp',

  // Tab Labels
  TAB_LIST: 'Danh Sách Lớp',
  TAB_CREATE: 'Mở Lớp Mới',
  TAB_EDIT: 'Sửa Lớp',

  // Section Titles
  SECTION_TIME: '1. Thời Gian',
  SECTION_SUBJECT: '2. Môn Học (Lọc theo Khoa/Ngành)',
  SECTION_RESOURCES: '3. Nguồn Lực (Giảng viên, Phòng, Ca)',

  // Filter Labels
  ACADEMIC_YEAR: 'Năm Học',
  SEMESTER: 'Học Kỳ',
  FACULTY: 'Khoa',
  MAJOR: 'Ngành',
  SUBJECT: 'Học Phần (Môn Học)',
  LECTURER: 'Giảng Viên (theo Khoa)',
  CLASSROOM: 'Phòng Học',
  WEEKDAY: 'Thứ',
  SHIFT: 'Ca Học',
  CAPACITY: 'Sĩ Số Tối Đa',
  CLASS_CODE: 'Mã Lớp Học Phần (Tự đặt)',
  NOTES: 'Ghi Chú',

  // Table Headers
  TABLE_CLASS_CODE: 'Mã Lớp',
  TABLE_SUBJECT_NAME: 'Tên Học Phần',
  TABLE_LECTURER: 'Giảng Viên',
  TABLE_SCHEDULE: 'Lịch Học',
  TABLE_CAPACITY: 'Sĩ Số',
  TABLE_START_DATE: 'Ngày Bắt Đầu',
  TABLE_STATUS: 'Trạng Thái',
  TABLE_ACTION: 'Thao Tác',

  // Tooltips
  TOOLTIP_REFRESH: 'Làm mới',
  TOOLTIP_EDIT: 'Sửa',
  TOOLTIP_DELETE: 'Xóa',

  // Conflict Messages
  CONFLICT_WARNING: 'Cảnh báo: Đã tìm thấy xung đột lịch',
} as const;

export const CLASS_STATUS_OPTIONS = [
  { code: 'PLANNED', label: 'Sắp khai giảng', color: 'status-new' },
  { code: 'ONGOING', label: 'Đang học', color: 'status-active' },
  { code: 'CLOSED', label: 'Kết thúc', color: 'status-closed' },
  { code: 'CANCELED', label: 'Hủy', color: 'status-cancel' },
] as const;

export const CLASS_STATUS_LABEL_BY_CODE: Record<string, string> = CLASS_STATUS_OPTIONS.reduce((acc, cur) => {
  acc[cur.code] = cur.label;
  return acc;
}, {} as Record<string, string>);

export const CLASS_STATUS_CODE_BY_TEXT: Record<string, string> = {
  'Sắp khai giảng': 'PLANNED',
  'Đang học': 'ONGOING',
  'Kết thúc': 'CLOSED',
  'Hủy': 'CANCELED'
};

export const WEEKDAY_OPTIONS = [
  { value: 2, label: 'Thứ 2' },
  { value: 3, label: 'Thứ 3' },
  { value: 4, label: 'Thứ 4' },
  { value: 5, label: 'Thứ 5' },
  { value: 6, label: 'Thứ 6' },
  { value: 7, label: 'Thứ 7' },
] as const;

export const DATE_FORMAT = 'dd/MM/yyyy';
export const SNACKBAR_DURATION = 3000;
