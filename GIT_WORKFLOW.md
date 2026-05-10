# Hướng Dẫn Git - Dự Án DrinkHub

> Dự án gồm 2 app: **coffee_app** (App khách hàng đặt đồ uống) và **coffee_admin** (App quản trị) — 4 người làm đồng đều trên cả 2 app.

---

## Chọn File Của Bạn

| Người | Vai Trò Chính | File Hướng Dẫn | Phụ Trách |
|--------|---------------|----------------|-----------|
| **Người 1** | Auth & App Core | [GIT_WORKFLOW_PERSON1.md](GIT_WORKFLOW_PERSON1.md) | Xác thực, khởi tạo app, splash, routes, Git Lead |
| **Người 2** | Đồ uống & Home | [GIT_WORKFLOW_PERSON2.md](GIT_WORKFLOW_PERSON2.md) | Home, Menu, Onboarding, Profile, Code Review |
| **Người 3** | Giỏ hàng & Đơn | [GIT_WORKFLOW_PERSON3.md](GIT_WORKFLOW_PERSON3.md) | Cart, Orders, Checkout, Models, QA/Test |
| **Người 4** | Vận hành & Media | [GIT_WORKFLOW_PERSON4.md](GIT_WORKFLOW_PERSON4.md) | Revenue, Upload, Theme, Dashboard, PM |

---

## Phân Công File Theo Người

### Người 1: Auth & App Core
```
coffee_app/lib/
├── main.dart, app.dart, app_view.dart, app_bootstrap.dart
├── firebase_options.dart, simple_bloc_observer.dart
├── blocs/authentication_bloc/              (3 file)
├── screens/auth/                            (blocs + views: sign_in, sign_up, welcome)
└── components/my_text_field.dart

coffee_admin/lib/
├── main.dart, app.dart, app_view.dart, app_bootstrap.dart
├── firebase_options.dart, simple_bloc_observer.dart
├── src/blocs/authentication_bloc/           (3 file)
├── src/modules/auth/                        (login + sign_in_bloc)
├── src/modules/splash/                      (splash_screen với logo DrinkHub)
└── src/routes/routes.dart
```

### Người 2: Đồ uống & Trang chủ
```
coffee_app/lib/
├── screens/home/blocs/get_coffee_bloc/     (3 file)
├── screens/home/views/                     (home, menu, details, product_detail)
├── screens/home/widgets/                   (coffee_card, brew_highlight_tile)
├── screens/onboarding/views/               (onboarding - giới thiệu DrinkHub)
├── screens/profile/views/                  (profile_screen)
└── components/coffee_image.dart

coffee_admin/lib/
├── src/modules/home/views/                 (home_screen - dashboard)
├── src/modules/base/views/                 (base_screen - sidebar nav)
├── src/modules/operations/blocs/create_coffee_bloc/ (3 file)
└── src/modules/operations/views/           (create_coffee_screen)
```

### Người 3: Giỏ hàng & Đơn hàng
```
coffee_app/lib/
├── screens/home/blocs/cart_bloc/           (3 file + cart persistence)
├── screens/home/views/                     (cart, checkout, main_screen)
├── screens/orders/                         (cubit + order_history_screen)
├── models/                                 (cart, cart_item, order)
├── repositories/order_repository.dart
└── utils/price_formatter.dart

coffee_admin/lib/
└── src/modules/operations/views/
    ├── cart_bloc, cart_event, cart_state, cart_screen
    ├── orders_bloc, orders_event, orders_state, orders_screen
    ├── my_orders_bloc, order, order_item
    └── order_repo, firebase_order_repo, local_order_repo
```

### Người 4: Doanh thu & Vận hành
```
coffee_app/lib/
└── theme/app_theme.dart                    (light + dark theme)

coffee_admin/lib/
├── src/modules/operations/blocs/upload_picture_bloc/ (3 file)
├── src/modules/operations/views/           (revenue*, profile_screen)
├── src/modules/operations/components/      (macro)
├── src/components/                         (macro)
└── src/utils/price_formatter.dart
```

---

## Quy Trình Git Hàng Ngày

### Đầu ngày (tất cả mọi người)
```bash
git checkout develop
git pull origin develop
git checkout -b feature/ten-tinh-nang
```

### Trong ngày
```bash
git add .
git commit -m "feat(scope): mo ta ngan gon"
git push -u origin feature/ten-tinh-nang
```

### Cuối ngày
```bash
git status
git push origin feature/ten-tinh-nang
```

### Tạo Pull Request
1. Lên GitHub, bấm "Compare & pull request"
2. Base: `develop`, Compare: nhánh của bạn
3. Điền mô tả, bấm "Create pull request"
4. Chờ Người 2 review

---

## Quy Tắc Git (Bắt Buộc)

**TUYỆT ĐỐI KHÔNG:**
- Commit trực tiếp vào `main` hoặc `develop`
- Force push lên `main` hoặc `develop`
- Tự merge PR của mình khi chưa có review
- Để code chưa commit qua đêm

**LUÔN LUÔN:**
- Tạo nhánh riêng từ `develop`
- Push code trước khi rời đi
- Viết commit message rõ ràng
- Sync develop mỗi sáng

---

## Định Dạng Commit Message

```
<loại>(<phạm vi>): <mô tả ngắn>

<chi tiết>

Closes #<mã-issue>
```

**Loại:** feat (tính năng mới), fix (sửa lỗi), docs (tài liệu), refactor (cải thiện code), chore (linh tinh)

**Ví dụ:**
```
feat(menu): them tim kiem va loc do uong

- Them thanh tim kiem
- Loc theo danh muc (tra, ca phe, sinh to...)
- Hien thi gia giam gia

Closes #15
```

---

## Sơ Đồ Git Flow

```
main (Production)
  ↑
develop (Tích hợp chung)
  ↑
feature/xxx (Nhánh làm việc của từng người)
```

---

## Vai Trò Đặc Biệt

| Vai Trò | Người Phụ Trách | Công Việc |
|---------|----------------|-----------|
| **Git Lead** | Người 1 | Setup repo, xử lý conflict, cấu hình bảo vệ nhánh |
| **Code Review** | Người 2 | Review tất cả PR, đảm bảo chất lượng code |
| **QA/Test** | Người 3 | Test tính năng, bắt lỗi, chuẩn bị demo |
| **PM** | Người 4 | Theo dõi tiến độ, lập kế hoạch, quản lý timeline |

---

## Tính Năng Hiện Có

| Tính năng | coffee_app | coffee_admin | Người phụ trách |
|-----------|-----------|--------------|-----------------|
| Đăng nhập/Đăng ký | ✓ | ✓ | Người 1 |
| Onboarding (3 trang) | ✓ | - | Người 2 |
| Trang chủ (featured) | ✓ | ✓ (dashboard) | Người 2 |
| Thực đơn (tìm kiếm + lọc) | ✓ | - | Người 2 |
| Chi tiết đồ uống | ✓ | - | Người 2 |
| Tạo/sửa đồ uống | - | ✓ | Người 2 |
| Giỏ hàng (có lưu) | ✓ | ✓ | Người 3 |
| Thanh toán | ✓ | - | Người 3 |
| Lịch sử đơn hàng | ✓ | ✓ | Người 3 |
| Quản lý đơn (admin) | - | ✓ | Người 3 |
| Hồ sơ người dùng | ✓ | ✓ | Người 2, 4 |
| Doanh thu + biểu đồ | - | ✓ | Người 4 |
| Upload ảnh | - | ✓ | Người 4 |
| Light/Dark theme | ✓ | ✓ | Người 4 |
| Splash screen | - | ✓ | Người 1 |

---

Bắt đầu: đọc file của bạn ở trên và làm theo hướng dẫn!
