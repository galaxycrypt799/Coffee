# ☕ Roast & Ritual - Coffee Management System

**Hệ thống quản lý cà phê toàn diện** với ứng dụng khách hàng và ứng dụng quản trị.

## 📱 Project Overview

Dự án này gồm **2 ứng dụng Flutter** chạy trên **Firebase** backend:

| App | Mục đích | Users |
|-----|---------|-------|
| **coffee_app** | 🛍️ Khách hàng order cà phê | Customers |
| **coffee_admin** | 🔧 Quản trị & bán hàng | Staff/Admin |

Cả 2 app **chia sẻ cùng 1 Firebase project** và **chia sẻ 2 packages**:
- `user_repository` - User auth & profile
- `coffee_repository` - Coffee menu data

---

## 🚀 QUICK START (30 seconds)

```bash
# 1. Clone project
git clone https://github.com/galaxycrypt799/Mobile.git
cd roast-ritual

# 2. Setup coffee_app
cd coffee_app
flutter pub get
flutter run -d chrome

# 3. In another terminal, setup coffee_admin
cd coffee_admin
flutter pub get
flutter run -d chrome
```

**Demo Credentials**:
- Customer: `guest@roastritual.app` / `Coffee@123`
- Admin: `admin@roastritual.app` / `Admin@123`

✅ Both apps should now be running!

---

## 📂 PROJECT STRUCTURE

```
roast-ritual/                           # 🔴 Root workspace
├── ☕ coffee_app/                      # Customer app
│   ├── lib/
│   │   ├── main.dart                  # Entry point
│   │   ├── firebase_options.dart      # Firebase config
│   │   ├── app_bootstrap.dart         # Bootstrap & init
│   │   ├── screens/                   # UI screens
│   │   │   ├── login_screen.dart
│   │   │   ├── menu_screen.dart
│   │   │   ├── cart_screen.dart
│   │   │   ├── checkout_screen.dart
│   │   │   ├── order_history_screen.dart
│   │   │   └── profile_screen.dart
│   │   ├── blocs/                     # Business logic
│   │   │   ├── auth_bloc.dart
│   │   │   ├── coffee_bloc.dart
│   │   │   ├── cart_bloc.dart
│   │   │   └── order_bloc.dart
│   │   ├── repositories/              # Data access
│   │   ├── models/                    # Data models
│   │   ├── components/                # Reusable widgets
│   │   ├── utils/                     # Helper functions
│   │   └── theme/                     # App theme
│   ├── packages/                      # 📦 Shared packages
│   │   ├── user_repository/           # User auth (Firebase + local)
│   │   │   ├── lib/src/
│   │   │   │   ├── models/user_model.dart
│   │   │   │   ├── entities/user.dart
│   │   │   │   ├── user_repo.dart (interface)
│   │   │   │   ├── firebase_user_repo.dart
│   │   │   │   └── local_user_repo.dart
│   │   │   └── pubspec.yaml
│   │   └── coffee_repository/         # Coffee menu (Firestore)
│   │       ├── lib/src/
│   │       │   ├── models/coffee_model.dart
│   │       │   ├── entities/coffee.dart
│   │       │   └── coffee_repo.dart
│   │       └── pubspec.yaml
│   ├── pubspec.yaml                   # Dependencies
│   ├── android/                       # Android build files
│   ├── ios/                           # iOS build files
│   ├── web/                           # Web build files
│   ├── windows/                       # Windows build files
│   ├── linux/                         # Linux build files
│   ├── macos/                         # macOS build files
│   ├── assets/                        # Images & fonts
│   ├── analysis_options.yaml          # Lint rules
│   ├── README.md                      # App README
│   └── FIREBASE_SETUP.md              # Firebase guide
│
├── 🔧 coffee_admin/                   # Admin app
│   ├── lib/
│   │   ├── main.dart
│   │   ├── firebase_options.dart
│   │   ├── app_bootstrap.dart
│   │   ├── src/
│   │   │   ├── screens/
│   │   │   │   ├── admin_dashboard.dart
│   │   │   │   ├── order_management.dart
│   │   │   │   ├── coffee_management.dart
│   │   │   │   └── analytics_screen.dart
│   │   │   └── blocs/
│   │   │       └── admin_bloc.dart
│   │   ├── components/
│   │   ├── theme/
│   │   └── utils/
│   ├── packages/                      # Same as coffee_app
│   │   ├── user_repository/
│   │   └── coffee_repository/
│   ├── pubspec.yaml
│   ├── android/
│   ├── ios/
│   ├── web/
│   ├── windows/
│   ├── linux/
│   ├── macos/
│   ├── assets/
│   ├── README.md
│   └── FIREBASE_SETUP.md
│
├── 📖 DOCUMENTATION FILES
│   ├── COMPLETE_SETUP_GUIDE.md    ← 👈 **READ THIS FIRST**
│   ├── FIREBASE_SETUP.md          ← Firebase configuration
│   ├── GIT_WORKFLOW.md            ← Git & GitHub guide
│   ├── CODE_REVIEW_PROCESS.md     ← Code review rules
│   ├── DEMO_SCRIPT.md             ← Live demo script
│   ├── GAP_ANALYSIS_TEMPLATE.md   ← Progress tracking
│   ├── WEEK3_4_PRESENTATION_PLAN.md ← Presentation guide
│   └── START_HERE_WEEK3_4.md      ← Week 3-4 quick start
│
├── 🔗 .github/
│   └── pull_request_template.md   # GitHub PR template
│
├── .gitignore                     # Git ignore rules
└── README.md                      # This file
```

---

## 🏗️ ARCHITECTURE

Both apps use **Clean Architecture + BLoC Pattern**:

```
┌──────────────────────────────────────────┐
│           Presentation Layer             │
│     (Screens, Widgets, Components)       │
└────────────┬─────────────────────────────┘
             │ uses
             ▼
┌──────────────────────────────────────────┐
│           Business Logic Layer           │
│        (BLoCs, State Management)         │
└────────────┬─────────────────────────────┘
             │ uses
             ▼
┌──────────────────────────────────────────┐
│          Repository Layer                │
│    (Data abstraction, both local        │
│     and Firebase implementations)        │
└────────────┬─────────────────────────────┘
             │ uses
             ▼
┌──────────────────────────────────────────┐
│           Data Layer                     │
│  (Firebase, Local Storage, APIs)         │
└──────────────────────────────────────────┘
```

**Key Packages**:
- `flutter_bloc` - State management
- `go_router` - Navigation
- `firebase_core`, `firebase_auth`, `cloud_firestore` - Backend
- `shared_preferences` - Local storage
- `equatable` - Value comparison

---

## 🗄️ DATABASE SCHEMA (Firestore)

### **Collection: users**
```json
{
  "userId": {
    "email": "guest@roastritual.app",
    "displayName": "Guest User",
    "avatar": "https://...",
    "phone": "+84912345678",
    "address": "123 Main St",
    "createdAt": "2026-01-01T10:00:00Z"
  }
}
```

### **Collection: coffees**
```json
{
  "coffeeId": {
    "name": "Espresso",
    "description": "Classic Italian espresso",
    "price": 3.50,
    "image": "https://...",
    "category": "espresso",
    "available": true,
    "createdAt": "2026-01-01T10:00:00Z"
  }
}
```

### **Collection: orders**
```json
{
  "orderId": {
    "userId": "user123",
    "items": [
      {
        "coffeeId": "coffee123",
        "quantity": 2,
        "price": 3.50
      }
    ],
    "totalAmount": 7.00,
    "status": "pending",
    "createdAt": "2026-05-09T10:00:00Z",
    "updatedAt": "2026-05-09T10:05:00Z"
  }
}
```

---

## 🚀 HOW TO RUN

### **Option 1: Run on Android Emulator**

```bash
# Start Android emulator first
android avd

# Then:
cd coffee_app
flutter run -d emulator-5554
```

### **Option 2: Run on Chrome (Web)**

```bash
cd coffee_app
flutter run -d chrome
```

### **Option 3: Run on iOS (Mac only)**

```bash
cd coffee_app
flutter run -d ios
```

### **Option 4: Run on Physical Device**

```bash
# Connect device via USB
adb devices

# Run
cd coffee_app
flutter run -d <device_id>
```

### **Run Both Apps Simultaneously**

```bash
# Terminal 1:
cd coffee_app
flutter run -d chrome

# Terminal 2 (in new terminal):
cd coffee_admin
flutter run -d chrome --web-port 3001
```

---

## 🔐 FEATURES

### **coffee_app (Customer)**
- ✅ Email/Password authentication (Firebase Auth)
- ✅ Browse coffee menu with images
- ✅ Add items to shopping cart
- ✅ Checkout and place orders
- ✅ View order history
- ✅ Edit profile (name, phone, address)
- ✅ Real-time order status updates
- ✅ Offline mode with local sync

### **coffee_admin (Admin)**
- ✅ Admin/Staff authentication
- ✅ Dashboard with analytics
- ✅ Sales metrics & revenue tracking
- ✅ Order management (view, update status)
- ✅ Coffee menu CRUD (Create, Read, Update, Delete)
- ✅ Upload coffee images
- ✅ Real-time notifications
- ✅ Staff role management

---

## 📚 DOCUMENTATION

| Document | Purpose |
|----------|---------|
| **[COMPLETE_SETUP_GUIDE.md](COMPLETE_SETUP_GUIDE.md)** | 🚀 **START HERE** - Complete setup instructions |
| **[FIREBASE_SETUP.md](FIREBASE_SETUP.md)** | 🔥 Firebase configuration & security rules |
| **[GIT_WORKFLOW.md](GIT_WORKFLOW.md)** | 🌳 Git branching & commit standards |
| **[CODE_REVIEW_PROCESS.md](CODE_REVIEW_PROCESS.md)** | 📝 Code review procedures |
| **[DEMO_SCRIPT.md](DEMO_SCRIPT.md)** | 🎬 Live demo presentation script |
| **[GAP_ANALYSIS_TEMPLATE.md](GAP_ANALYSIS_TEMPLATE.md)** | 📊 Progress tracking & risk assessment |

---

## 👥 TEAM STRUCTURE (4 People)

| # | Name/Role | Responsibilities | Files |
|---|-----------|-----------------|-------|
| **1** | Git Lead | GitHub setup, branch rules, Git Flow | Setup & monitoring |
| **2** | Code Review | PR review, code quality, checklist | CODE_REVIEW_PROCESS.md |
| **3** | Demo Lead | Testing, demo prep, feature showcase | DEMO_SCRIPT.md |
| **4** | PM | Progress tracking, risk mgmt, planning | GAP_ANALYSIS_TEMPLATE.md |

---

## 🎯 DEMO CREDENTIALS

### **Customer Account**
```
Email:    guest@roastritual.app
Password: Coffee@123
```

### **Admin Account**
```
Email:    admin@roastritual.app
Password: Admin@123
```

---

## 🔧 DEVELOPMENT SETUP

### **Requirements**
- Flutter 3.2.3 or higher
- Dart 3.0+
- Android Studio / Xcode (optional, for native debugging)
- VS Code with Flutter extension (recommended)
- Git

### **Installation**

1. **Install Flutter**:
   - Download from https://flutter.dev
   - Add to PATH

2. **Clone Repository**:
   ```bash
   git clone https://github.com/galaxycrypt799/Mobile.git
   cd roast-ritual
   ```

3. **Setup coffee_app**:
   ```bash
   cd coffee_app
   flutter pub get
   flutter run
   ```

4. **Setup coffee_admin** (in new terminal):
   ```bash
   cd coffee_admin
   flutter pub get
   flutter run -d chrome --web-port 3001
   ```

---

## 🐛 TROUBLESHOOTING

**Problem**: `Flutter not found`  
**Solution**: Add Flutter to your PATH. See [COMPLETE_SETUP_GUIDE.md](COMPLETE_SETUP_GUIDE.md#troubleshooting)

**Problem**: `Packages not found`  
**Solution**: Run `flutter pub get` in each app directory

**Problem**: `Firebase errors`  
**Solution**: See [FIREBASE_SETUP.md](FIREBASE_SETUP.md)

**Problem**: `Git conflicts`  
**Solution**: See [GIT_WORKFLOW.md](GIT_WORKFLOW.md)

---

## 📊 PROJECT STATUS

| Component | Status | Progress |
|-----------|--------|----------|
| User Authentication | ✅ Complete | 100% |
| Coffee Menu | ✅ Complete | 100% |
| Shopping Cart | ✅ Complete | 95% |
| Order Management | ✅ Complete | 90% |
| Admin Dashboard | 🔄 In Progress | 80% |
| Offline Sync | 🔄 In Progress | 40% |
| Push Notifications | ⏳ Planned | 0% |
| Analytics | ✅ Complete | 85% |

**Overall Progress**: 🟢 **65% Complete** (Target: 90% by Week 5)

---

## 🗓️ TIMELINE

- **Week 1-2**: Core features (auth, menu, cart, orders)
- **Week 3**: Git workflow presentation
- **Week 4**: Live demo & gap analysis
- **Week 5**: Final sprint, polish, deployment

---

## 📞 SUPPORT

**Questions?** Check these documents in order:
1. [COMPLETE_SETUP_GUIDE.md](COMPLETE_SETUP_GUIDE.md)
2. [FIREBASE_SETUP.md](FIREBASE_SETUP.md)
3. [GIT_WORKFLOW.md](GIT_WORKFLOW.md)
4. [CODE_REVIEW_PROCESS.md](CODE_REVIEW_PROCESS.md)

---

## 📜 LICENSE

Private project - Team use only

---

**Version**: 1.0  
**Last Updated**: May 9, 2026  
**Status**: ✅ Ready for development  

**Next Step**: 👉 Read [COMPLETE_SETUP_GUIDE.md](COMPLETE_SETUP_GUIDE.md) and run `flutter run`!
```

Nếu `lib/firebase_options.dart` còn placeholder `YOUR_*`, app sẽ tự chạy ở chế độ local fallback.

## Firebase

Xem hướng dẫn chung cho cả hệ thống trong [FIREBASE_SETUP.md](FIREBASE_SETUP.md).
