# Người 2: Đồ Uống & Trang Chủ + Code Review

> Bạn phụ trách: Hiển thị danh sách đồ uống, trang chủ, hồ sơ, giới thiệu app (cả 2 app coffee_app + coffee_admin), review code của team.

---

## File Bạn Làm Việc

### coffee_app (App khách hàng)
```
coffee_app/lib/
├── screens/home/blocs/get_coffee_bloc/   ← BLoC lấy danh sách đồ uống (3 file)
├── screens/home/views/                   ← Màn hình chính
│   ├── home_screen.dart                  ← Trang chủ hiển thị đồ uống nổi bật
│   ├── menu_screen.dart                  ← Thực đơn đầy đủ (tìm kiếm + lọc)
│   ├── details_screen.dart               ← Chi tiết từng món
│   ├── product_detail_screen.dart        ← Trang chi tiết sản phẩm
│   ├── cart_screen.dart                  ← (dùng chung với Người 3)
│   └── main_screen.dart                  ← (dùng chung với Người 3)
├── screens/home/widgets/                 ← Widget con
│   ├── coffee_card.dart                  ← Thẻ hiển thị đồ uống
│   └── brew_highlight_tile.dart          ← Tile tiện ích nhanh
├── screens/onboarding/views/             ← Màn hình giới thiệu app
│   └── onboarding_screen.dart            ← Giới thiệu về DrinkHub
├── screens/profile/views/                ← Màn hình hồ sơ
│   └── profile_screen.dart
└── components/coffee_image.dart          ← Ảnh đồ uống dùng chung
```

### coffee_admin (App quản trị)
```
coffee_admin/lib/
├── src/modules/home/views/               ← Trang chủ admin
│   └── home_screen.dart                  ← Dashboard DrinkHub Admin
├── src/modules/base/views/               ← Màn hình nền (có menu điều hướng)
│   └── base_screen.dart
├── src/modules/operations/blocs/create_coffee_bloc/ ← BLoC tạo đồ uống (3 file)
└── src/modules/operations/views/         ← Màn hình quản lý đồ uống
    └── create_coffee_screen.dart
```

---

## Việc Cần Làm

### 1. Đồ uống (coffee_app)
- [x] BLoC lấy danh sách đồ uống (get_coffee_bloc)
- [x] Trang chủ hiển thị đồ uống nổi bật (home_screen) — ngôn ngữ chung về đồ uống
- [x] Màn hình thực đơn đầy đủ (menu_screen) — có thanh tìm kiếm, lọc theo danh mục
- [x] Trang chi tiết đồ uống (details_screen, product_detail_screen) — hiển thị xuất xứ, dung tích, mô tả
- [x] Widget thẻ đồ uống (coffee_card) — hiển thị giá gốc + giá giảm
- [x] Widget tiện ích nhanh (brew_highlight_tile)
- [x] Component ảnh đồ uống (coffee_image)
- [x] Tìm kiếm đồ uống theo tên
- [x] Lọc đồ uống theo danh mục (trà, cà phê, sinh tố, nước ép...)

### 2. Giới thiệu & Hồ sơ (coffee_app)
- [x] Màn hình giới thiệu app DrinkHub (onboarding_screen) — 3 trang:
  - Trang 1: "Thức uống đa dạng" — từ cà phê, trà, sinh tố đến nước ép
  - Trang 2: "Đặt món siêu nhanh" — order trước, nhận tại quầy
  - Trang 3: "Thưởng thức mọi lúc" — giao hàng tận nơi, tiện lợi
- [x] Màn hình hồ sơ người dùng (profile_screen) — tên mặc định "Khách"

### 3. Quản lý đồ uống (coffee_admin)
- [x] Trang chủ admin (home_screen) — "Chào mừng DrinkHub Admin!"
- [x] Màn hình nền có menu (base_screen) — sidebar tiếng Việt
- [x] Màn hình thêm/sửa đồ uống (create_coffee_screen) — nhãn "Tên đồ uống", "Tạo đồ uống"
- [x] BLoC tạo đồ uống (create_coffee_bloc)

### 4. Code Review
- [ ] Review tất cả PR của team
- [ ] Kiểm tra commit message đúng định dạng
- [ ] Đảm bảo code sạch, dễ đọc
- [ ] Approve hoặc yêu cầu sửa

---

## Commit Mẫu Cho File Của Bạn

```bash
# Khi thêm trang chủ
git commit -m "feat(home): them trang chu hien thi danh sach do uong

- Hien thi do uong dang luoi
- Them tim kiem va loc theo danh muc
- Click vao xem chi tiet

Closes #15"

# Khi thêm màn hình tạo đồ uống (admin)
git commit -m "feat(admin): them man hinh tao do uong moi

- Form nhap ten, gia, mo ta
- Upload anh do uong
- Luu vao Firebase

Closes #30"

# Khi thêm onboarding
git commit -m "feat(onboarding): them man hinh gioi thieu DrinkHub

- 3 trang gioi thieu: da dang do uong, dat mon nhanh, thuong thuc moi luc
- Icon drinkhub cho tung trang

Closes #35"

# Khi thêm tìm kiếm & lọc trong menu
git commit -m "feat(menu): them tim kiem va loc do uong theo danh muc

- Thanh tim kiem realtime theo ten do uong
- Loc theo danh muc: tra, ca phe, sinh to, nuoc ep...
- Hien thi gia giam gia (neu co)

Closes #38"
```

---

## Quy Trình Code Review

### Hàng ngày
1. Vào GitHub → tab "Pull Requests"
2. Với mỗi PR, kiểm tra:

**Checklist review:**
- [ ] Tên nhánh đúng định dạng? (`feature/xxx`)
- [ ] Commit message rõ ràng, đúng chuẩn?
- [ ] Code sạch, không console.log?
- [ ] Có xử lý lỗi đầy đủ?
- [ ] File đúng phạm vi được giao?

**Nếu OK:** Bấm "Approve" + ghi chú "LGTM!" (Looks Good To Me)

**Nếu cần sửa:** Bấm "Request changes" + ghi rõ cần sửa gì

### Cách ghi nhận xét
```
TỐT: "Gợi ý: dùng ListView.builder thay vì Column để tối ưu hiệu năng nhé"
TỐT: "Phần validation nên tách ra hàm riêng cho gọn hơn"
TRÁNH: "Code này tệ quá"
TRÁNH: "Sửa lại đi"
```

---

## Quy Trình Làm Việc Hàng Ngày

```bash
# SÁNG: Lấy code mới nhất
git checkout develop
git pull origin develop

# Tạo nhánh làm việc
git checkout -b feature/home-page

# TRONG NGÀY: Code và commit
git add .
git commit -m "feat(home): mo ta cong viec"

# Push code
git push -u origin feature/home-page

# CUỐI NGÀY: Review PR của team trên GitHub
```

---

Bắt đầu với file đầu tiên: `coffee_app/lib/screens/home/views/home_screen.dart`!
