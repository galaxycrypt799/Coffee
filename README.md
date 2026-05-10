# DrinkHub - Hệ Thống Đặt & Quản Lý Đồ Uống

Dự án Flutter monorepo cho hệ thống đặt đồ uống **DrinkHub**, gồm 2 ứng dụng:

| App | Mục đích | Nền tảng |
|-----|----------|----------|
| `coffee_app/` | App khách hàng — duyệt menu, đặt đồ uống, thanh toán | iOS, Android, Web |
| `coffee_admin/` | App quản trị — dashboard, quản lý đơn, doanh thu, upload | iOS, Android, Web |

## Cấu Trúc Dự Án

```
drinkhub/
├── coffee_app/                  # App khách hàng (Flutter)
│   ├── lib/
│   │   ├── blocs/               # BLoC quản lý state toàn cục
│   │   ├── components/          # Widget dùng chung
│   │   ├── models/              # Data models
│   │   ├── repositories/        # Data repositories
│   │   ├── screens/             # Màn hình theo module
│   │   │   ├── auth/            # Đăng nhập / Đăng ký
│   │   │   ├── home/            # Trang chủ, Menu, Chi tiết
│   │   │   ├── onboarding/      # Giới thiệu app
│   │   │   ├── orders/          # Lịch sử đơn hàng
│   │   │   └── profile/         # Hồ sơ người dùng
│   │   ├── theme/               # Theme (Light/Dark)
│   │   └── utils/               # Helper functions
│   ├── packages/
│   │   ├── coffee_repository/   # Shared package: quản lý đồ uống
│   │   └── user_repository/     # Shared package: quản lý người dùng
│   ├── assets/
│   │   ├── branding/            # Logo, splash assets
│   │   ├── coffee/              # Ảnh đồ uống
│   │   └── fonts/               # Font chữ (DMSans, DMSerifDisplay)
│   └── test/                    # Unit & widget tests
│
├── coffee_admin/                # App quản trị (Flutter)
│   ├── lib/
│   │   └── src/
│   │       ├── blocs/           # BLoC authentication
│   │       ├── components/      # Widget dùng chung
│   │       ├── modules/
│   │       │   ├── auth/        # Đăng nhập admin
│   │       │   ├── base/        # Layout + sidebar nav
│   │       │   ├── home/        # Dashboard
│   │       │   ├── operations/  # CRUD đồ uống, đơn hàng, doanh thu
│   │       │   └── splash/      # Màn hình splash
│   │       ├── routes/          # GoRouter config
│   │       └── utils/           # Helper functions
│   ├── packages/                # Shared packages (giống coffee_app)
│   └── assets/
│
├── .github/                     # GitHub templates & CI
│   ├── PULL_REQUEST_TEMPLATE.md
│   └── ISSUE_TEMPLATE.md
├── .gitignore
├── GIT_WORKFLOW.md              # Hướng dẫn Git cho team
└── README.md                    # File này
```

## Công Nghệ Sử Dụng

- **Framework:** Flutter (SDK >=3.2.3 <4.0.0)
- **State Management:** BLoC / flutter_bloc
- **Backend:** Firebase (Auth, Firestore, Storage)
- **Navigation:** GoRouter (admin), Navigator 2.0 (app)
- **Charts:** fl_chart (admin dashboard)
- **Theme:** DMSans + DMSerifDisplay fonts

## Cài Đặt & Chạy

### Yêu cầu
- Flutter SDK >=3.2.3
- Firebase project (cần file `google-services.json` và `GoogleService-Info.plist`)
- Android Studio / VS Code

### Các bước

```bash
# Clone repo
git clone <repo-url>
cd drinkhub

# Cài dependencies cho cả 2 app
cd coffee_app && flutter pub get && cd ..
cd coffee_admin && flutter pub get && cd ..

# Chạy app khách hàng
cd coffee_app && flutter run

# Chạy app admin
cd coffee_admin && flutter run -d chrome
```

## Quy Trình Làm Việc

1. Tạo nhánh feature từ `develop`
2. Code + commit theo [quy ước commit](GIT_WORKFLOW.md)
3. Push và tạo Pull Request
4. Chờ review trước khi merge

Xem chi tiết tại [GIT_WORKFLOW.md](GIT_WORKFLOW.md)

## Team

| Vai Trò | Người | Phụ Trách |
|---------|-------|-----------|
| Auth & App Core | Người 1 | Xác thực, splash, routes, Git Lead |
| Đồ uống & Home | Người 2 | Home, Menu, Onboarding, Code Review |
| Giỏ hàng & Đơn | Người 3 | Cart, Orders, Checkout, QA/Test |
| Vận hành & Media | Người 4 | Revenue, Upload, Theme, PM |

## License

Internal — DrinkHub Team
