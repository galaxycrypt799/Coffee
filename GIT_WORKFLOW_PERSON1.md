# Người 1: Auth & App Core + Git Lead

> Bạn phụ trách: Xác thực người dùng, khởi tạo app (cả 2 app coffee_app + coffee_admin), quản lý Git.

---

## File Bạn Làm Việc

### coffee_app (App khách hàng)
```
coffee_app/lib/
├── main.dart                          ← Entry point app khách hàng
├── app.dart                           ← Cấu hình app
├── app_view.dart                      ← Giao diện chính của app
├── app_bootstrap.dart                 ← Khởi tạo ban đầu
├── firebase_options.dart              ← Cấu hình Firebase
├── simple_bloc_observer.dart          ← Theo dõi BLoC
├── blocs/authentication_bloc/         ← BLoC xác thực (3 file)
├── screens/auth/                      ← Màn hình đăng nhập/đăng ký/welcome
│   ├── blocs/sing_in_bloc/            ← BLoC đăng nhập (3 file)
│   ├── blocs/sign_up_bloc/            ← BLoC đăng ký (3 file)
│   └── views/                         ← sign_in_screen, sign_up_screen, welcome_screen
└── components/my_text_field.dart      ← Ô nhập liệu dùng chung
```

### coffee_admin (App quản trị)
```
coffee_admin/lib/
├── main.dart                          ← Entry point app admin
├── app.dart, app_view.dart            ← Cấu hình app admin
├── app_bootstrap.dart                 ← Khởi tạo ban đầu
├── firebase_options.dart              ← Cấu hình Firebase
├── simple_bloc_observer.dart          ← Theo dõi BLoC
├── src/blocs/authentication_bloc/     ← BLoC xác thực (3 file)
├── src/modules/auth/                  ← Màn hình đăng nhập admin
│   ├── blocs/sing_in_bloc/            ← BLoC đăng nhập (3 file)
│   └── views/login_screen.dart
├── src/modules/splash/                ← Màn hình splash
│   └── views/splash_screen.dart
└── src/routes/routes.dart             ← Điều hướng trong app admin
```

---

## Việc Cần Làm

### 1. Xác thực (coffee_app)
- [x] Màn hình đăng nhập (sign_in_screen) — có chế độ Firebase + demo
- [x] Màn hình đăng ký (sign_up_screen)
- [x] Màn hình chào mừng (welcome_screen) với thương hiệu DrinkHub
- [x] BLoC đăng nhập (sign_in_bloc)
- [x] BLoC đăng ký (sign_up_bloc)
- [x] BLoC xác thực tổng (authentication_bloc)
- [x] Validate email, mật khẩu
- [x] Xử lý lỗi đăng nhập
- [x] Ô nhập liệu my_text_field
- [x] Tài khoản demo: demo@drinkhub.app / DrinkHub@123
- [x] Nút "Điền sẵn tài khoản demo" cho chế độ không Firebase

### 2. Xác thực (coffee_admin)
- [x] Màn hình đăng nhập admin
- [x] BLoC đăng nhập admin
- [x] BLoC xác thực admin
- [x] Màn hình splash với logo DrinkHub + tên app + "Admin"
- [x] Splash tự động chuyển trang theo trạng thái auth (đã đăng nhập → /home, chưa → /login)
- [x] Cấu hình routes (GoRouter)

### 3. Khởi tạo App (cả 2)
- [x] main.dart cho cả 2 app
- [x] Cấu hình Firebase (firebase_options.dart)
- [x] Khởi tạo bootstrap với tên "DrinkHub" / "DrinkHub Admin"
- [x] Cấu hình BLoC observer
- [x] Tiêu đề app: "DrinkHub - Đặt đồ uống" (customer), "DrinkHub Admin" (admin)

### 4. Web (coffee_app)
- [x] web/index.html — tiêu đề "DrinkHub - Đặt đồ uống", meta description tiếng Việt

### 5. Git Lead
- [ ] Tạo GitHub repository
- [ ] Push code lần đầu
- [ ] Tạo nhánh main và develop
- [ ] Cấu hình bảo vệ nhánh
- [ ] Hỗ trợ team khi gặp lỗi Git

---

## Commit Mẫu Cho File Của Bạn

```bash
# Khi thêm màn hình đăng nhập
git commit -m "feat(auth): them man hinh dang nhap

- Them giao dien dang nhap voi email/mat khau
- Validate form nhap lieu
- Hien thi loi khi dang nhap that bai

Closes #1"

# Khi sửa lỗi xác thực
git commit -m "fix(auth): sua loi khong hien thi thong bao loi

- Nguyen nhan: thieu StreamSubscription
- Cach sua: them lang nghe su kien loi

Fixes #5"

# Khi thêm splash screen
git commit -m "feat(admin): them man hinh splash cho coffee_admin

- Hien thi logo DrinkHub, ten app va chu Admin
- Tu dong chuyen huong theo trang thai dang nhap
- Dung BlocListener lang nghe auth state

Closes #10"
```

---

## Quy Trình Làm Việc Hàng Ngày

```bash
# SÁNG: Lấy code mới nhất
git checkout develop
git pull origin develop

# Tạo nhánh làm việc
git checkout -b feature/auth-dang-nhap

# TRONG NGÀY: Code và commit
git add .
git commit -m "feat(auth): mo ta cong viec"

# Push code
git push -u origin feature/auth-dang-nhap
```

---

## Trách Nhiệm Git Lead

### Setup lần đầu
```bash
# Cấu hình Git
git config --global user.name "Ten Cua Ban"
git config --global user.email "email@example.com"

# Tạo repo trên GitHub → thêm remote
git remote add origin https://github.com/galaxycrypt799/Mobile.git

# Push code lần đầu
git branch -M main
git push -u origin main

# Tạo nhánh develop
git checkout -b develop
git push -u origin develop
```

### Cấu hình bảo vệ nhánh (trên GitHub)
- **main**: Cần 2 người approve, bắt buộc PR
- **develop**: Cần 1 người approve, bắt buộc PR

### Khi team gặp conflict
Hướng dẫn team:
1. Mở file bị conflict trong VS Code
2. Chọn "Accept Current" (giữ code mình) hoặc "Accept Incoming" (lấy code bạn)
3. Lưu file → `git add ten-file` → `git rebase --continue`

---

## Lệnh Git Hữu Ích

```bash
git status                          # Xem trạng thái
git branch                          # Xem danh sách nhánh
git log --oneline -10              # Xem 10 commit gần nhất
git diff                            # Xem thay đổi
git stash                           # Lưu tạm code chưa commit
git stash pop                       # Lấy lại code đã lưu tạm
```

---

Bắt đầu với file đầu tiên: `coffee_app/lib/main.dart`!
