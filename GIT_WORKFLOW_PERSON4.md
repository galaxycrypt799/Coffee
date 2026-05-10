# Người 4: Doanh Thu & Vận Hành + PM

> Bạn phụ trách: Doanh thu, upload ảnh, giao diện (theme), vận hành admin + quản lý tiến độ dự án.

---

## File Bạn Làm Việc

### coffee_app (App khách hàng)
```
coffee_app/lib/
└── theme/app_theme.dart                  ← Theme toàn app (màu sắc, font chữ, style)
```

### coffee_admin (App quản trị)
```
coffee_admin/lib/
├── src/modules/operations/blocs/upload_picture_bloc/ ← BLoC upload ảnh (3 file)
├── src/modules/operations/views/         ← Màn hình vận hành
│   ├── revenue_bloc.dart                 ← BLoC doanh thu
│   ├── revenue_event.dart                ← Sự kiện doanh thu
│   ├── revenue_state.dart                ← Trạng thái doanh thu
│   └── profile_screen.dart               ← Màn hình hồ sơ admin
├── src/modules/operations/components/    ← Component dùng trong operations
│   └── macro.dart
├── src/components/                       ← Component dùng chung
│   └── macro.dart
└── src/utils/price_formatter.dart        ← Định dạng tiền
```

---

## Việc Cần Làm

### 1. Giao diện & Theme (coffee_app)
- [x] Cấu hình màu sắc chủ đạo (tone ấm, thân thiện)
- [x] Định nghĩa font chữ, cỡ chữ
- [x] Style cho button, card, input
- [x] Hỗ trợ light/dark mode
- [x] Các màn hình dùng chung theme nhất quán

### 2. Upload ảnh (coffee_admin)
- [x] BLoC upload ảnh đồ uống (upload_picture_bloc)
- [ ] Chọn ảnh từ thư viện hoặc chụp mới
- [ ] Upload lên Firebase Storage
- [ ] Hiển thị ảnh đã upload
- [ ] Nhãn tiếng Việt: "Thêm ảnh đồ uống"

### 3. Doanh thu (coffee_admin)
- [ ] BLoC thống kê doanh thu (revenue_bloc)
- [ ] Màn hình báo cáo doanh thu
- [ ] Biểu đồ doanh thu theo ngày/tuần/tháng
- [ ] Thống kê đồ uống bán chạy

### 4. Khác (coffee_admin)
- [x] Màn hình hồ sơ admin (profile_screen)
- [ ] Component macro (dinh dưỡng)
- [x] Định dạng tiền (price_formatter)

### 5. PM / Quản lý tiến độ
- [ ] Theo dõi tiến độ từng người
- [ ] Cập nhật checklist dự án
- [ ] Phát hiện blockers, rủi ro
- [ ] Báo cáo tiến độ hàng tuần

---

## Commit Mẫu Cho File Của Bạn

```bash
# Khi thêm theme
git commit -m "feat(theme): cau hinh giao dien DrinkHub

- Dinh nghia bang mau am cung (nau, kem, trang)
- Cau hinh font chu va co chu
- Them style cho button, card, input
- Ho tro light/dark mode

Closes #40"

# Khi thêm upload ảnh
git commit -m "feat(admin): them chuc nang upload anh do uong

- Chon anh tu thu vien hoac may anh
- Upload len Firebase Storage
- Hien thi preview truoc khi luu
- Nhan tieng Viet: Them anh do uong

Closes #35"

# Khi thêm doanh thu
git commit -m "feat(admin): them bang thong ke doanh thu

- Bieu do doanh thu 7 ngay
- Thong ke don hang thanh cong
- Loc theo ngay/tuan/thang

Closes #45"
```

---

## Công Cụ Quản Lý Tiến Độ

### Theo dõi hàng ngày
Mỗi sáng, kiểm tra:
- Hôm qua mỗi người đã làm gì? (xem GitHub commits)
- Hôm nay mỗi người sẽ làm gì?
- Có ai bị blocked không?

### Cập nhật checklist
File `PROJECT_COMPLETENESS_CHECKLIST.md`:
- Đánh dấu [x] khi tính năng hoàn thành
- Đánh dấu [⚠️] nếu đang bị chậm
- Ghi chú ai đang làm gì

### Báo cáo nhanh mỗi ngày
```
HÔM NAY - 10/05:
- Người 1: Đã xong màn hình đăng nhập ✓
- Người 2: Đang làm trang chủ (dự kiến xong chiều nay)
- Người 3: Đang làm giỏ hàng, gặp lỗi Firebase ⚠️
- Người 4 (tôi): Đã xong theme, đang làm upload ảnh

BLOCKERS: Người 3 cần hỗ trợ Firebase Storage
```

---

## Quy Trình Làm Việc Hàng Ngày

```bash
# SÁNG: Lấy code mới nhất
git checkout develop
git pull origin develop

# Kiểm tra tiến độ team
git log --oneline --since="yesterday"

# Tạo nhánh làm việc
git checkout -b feature/theme-app

# TRONG NGÀY: Code và commit
git add .
git commit -m "feat(theme): mo ta cong viec"
git push -u origin feature/theme-app

# CUỐI NGÀY: Cập nhật checklist tiến độ
```

---

Bắt đầu với file đầu tiên: `coffee_app/lib/theme/app_theme.dart`!
