# 🚀 COMPLETE SETUP GUIDE - Chạy Project Ngay Lập Tức

**Mục tiêu**: Sau khi clone project, bạn có thể chạy `flutter run` ngay mà không cần cấu hình gì thêm.

---

## 📋 TABLE OF CONTENTS

1. [Prerequisites](#prerequisites) - Cài đặt trước
2. [Project Structure](#project-structure) - Cấu trúc dự án
3. [Setup coffee_app](#setup-coffee_app) - Setup app khách hàng
4. [Setup coffee_admin](#setup-coffee_admin) - Setup app admin
5. [Troubleshooting](#troubleshooting) - Xử lý lỗi
6. [Demo Credentials](#demo-credentials) - Tài khoản demo

---

## 📦 PREREQUISITES

### **Bước 1: Cài đặt Flutter SDK**

**Windows**:
```bash
# Download Flutter từ: https://flutter.dev/docs/get-started/install/windows
# Hoặc dùng Chocolatey:
choco install flutter

# Verify installation
flutter --version
# Expected: Flutter 3.2.3 hoặc cao hơn
```

**Mac**:
```bash
# Dùng Homebrew:
brew install flutter

flutter --version
```

### **Bước 2: Cài đặt Android Studio / Xcode (Optional)**

- **Android**: Cài Android Studio (https://developer.android.com/studio)
- **iOS**: Xcode (chỉ trên Mac)
- **Web**: Tự động support khi cài Flutter

### **Bước 3: Kiểm tra môi trường**

```bash
# Run this command to see what's missing
flutter doctor

# Expected output:
# ✓ Flutter (Channel stable, ...)
# ✓ Android toolchain
# ✓ Chrome (for web)
```

### **Bước 4: Cài đặt Git**

```bash
git --version

# Nếu chưa cài:
# Windows: https://git-scm.com/download/win
# Mac: brew install git
```

### **Bước 5: Clone Project**

```bash
# Clone từ GitHub
git clone https://github.com/YOUR_USERNAME/roast-ritual.git
cd roast-ritual

# Hoặc nếu đã có folder
cd c:\Users\bogau\AndroidStudioProjects\test1
```

---

## 📂 PROJECT STRUCTURE

```
roast-ritual/
├── coffee_app/                 # ☕ App khách hàng
│   ├── lib/
│   │   ├── main.dart          # Entry point
│   │   ├── firebase_options.dart
│   │   ├── app_bootstrap.dart
│   │   ├── screens/           # UI screens
│   │   ├── blocs/             # Business logic
│   │   └── repositories/      # Data access
│   ├── packages/              # Shared packages
│   │   ├── user_repository/
│   │   └── coffee_repository/
│   ├── pubspec.yaml           # Dependencies
│   ├── android/               # Android build
│   ├── ios/                   # iOS build
│   ├── web/                   # Web build
│   └── README.md
│
├── coffee_admin/              # 🔧 App admin/staff
│   ├── lib/
│   │   ├── main.dart
│   │   ├── firebase_options.dart
│   │   ├── src/               # Admin screens
│   │   └── blocs/
│   ├── packages/              # Same as coffee_app
│   ├── pubspec.yaml
│   ├── android/
│   ├── ios/
│   └── README.md
│
├── .github/                   # GitHub workflows
├── FIREBASE_SETUP.md          # Firebase guide
├── GIT_WORKFLOW.md            # Git guide
├── COMPLETE_SETUP_GUIDE.md    # This file
├── README.md                  # Main readme
└── .gitignore                 # Git ignore rules
```

**Key Point**: Mỗi app (coffee_app, coffee_admin) là một **Flutter project độc lập** nhưng chia sẻ **packages** (user_repository, coffee_repository).

---

## ☕ SETUP COFFEE_APP

### **Step 1: Navigate to coffee_app**

```bash
cd coffee_app
```

### **Step 2: Get dependencies**

```bash
# Download tất cả packages
flutter pub get

# Expected output:
# Running: flutter pub get
# pub get: Package in XXX cached
# pub get: XXX packages in ...
```

### **Step 3: Check if it builds**

```bash
# Analyze code
flutter analyze

# Expected: No errors (warnings okay)
```

### **Step 4: Run on device/emulator**

```bash
# Nếu chưa có device, tạo Android emulator:
flutter emulators

# List available devices:
flutter devices

# Run on first device
flutter run

# Run on specific device:
flutter run -d <device-id>

# Run on web (debug):
flutter run -d web-server

# Run on Chrome:
flutter run -d chrome
```

### **Expected Output**:
```
Launching lib/main.dart on Chrome in debug mode...
✓ Built instance
✓ Chrome is ready to connect via Chrome DevTools
The Dart VM service is listening on http://127.0.0.1:12345/abcdef=

You can now use DevTools at http://127.0.0.1:9100
To stop, press "q".
```

### **After App Starts**:
- ✅ You see Roast & Ritual login screen
- ✅ Try login with demo credentials (see below)
- ✅ If you see menu screen → success! ✅

---

## 🔧 SETUP COFFEE_ADMIN

### **Step 1: Navigate to coffee_admin**

```bash
# From root folder:
cd coffee_admin

# Or from coffee_app:
cd ../coffee_admin
```

### **Step 2: Get dependencies**

```bash
flutter pub get
```

### **Step 3: Run**

```bash
flutter run

# Or on specific device:
flutter run -d chrome
```

### **Expected Output**:
- ✅ Admin login screen appears
- ✅ Try admin credentials
- ✅ See dashboard with analytics

---

## 🚨 TROUBLESHOOTING

### **Problem 1: "Flutter not found"**

**Solution**:
```bash
# Add Flutter to PATH
# Windows: Edit environment variables
# Add: C:\path\to\flutter\bin

# Verify:
flutter --version
```

### **Problem 2: "Android SDK not found"**

**Solution**:
```bash
flutter doctor --android-licenses

# Accept all licenses:
y
```

### **Problem 3: "Podfile.lock corruption" (iOS)**

**Solution**:
```bash
cd coffee_app

# Clean everything
flutter clean

# Delete locks
rm -rf pubspec.lock ios/Podfile.lock

# Reinstall
flutter pub get
cd ios
pod install --repo-update
cd ..

flutter run
```

### **Problem 4: "Gradle build failed" (Android)**

**Solution**:
```bash
# Clean gradle cache
cd coffee_app/android
./gradlew clean

# Go back and try again
cd ../..
flutter clean
flutter pub get
flutter run
```

### **Problem 5: "Cannot resolve packages in coffee_repository"**

**Solution**:
```bash
# Packages are local, need to be accessible
# Verify structure:
ls coffee_app/packages/
# Should show: coffee_repository  user_repository

# If not, manually create symlinks or copy packages to root:
# Windows:
mklink /D packages coffee_app\packages
```

### **Problem 6: "Firebase Error: No matching rules found"**

**Solution**:
This is a Firestore security rule error. It means:
1. Firebase is not configured correctly
2. Or Firestore security rules are too strict

**See**: [FIREBASE_SETUP.md](FIREBASE_SETUP.md)

### **Problem 7: "Hot reload not working"**

**Solution**:
```bash
# Stop running app (Press 'q')

# Rebuild and run
flutter clean
flutter pub get
flutter run
```

---

## 🔐 DEMO CREDENTIALS

### **coffee_app (Customer)**

```
Email:    guest@roastritual.app
Password: Coffee@123
```

**What you can do**:
- ✅ Browse coffee menu
- ✅ Add items to cart
- ✅ Checkout and place order
- ✅ View order history
- ✅ Edit profile

---

### **coffee_admin (Admin/Staff)**

```
Email:    admin@roastritual.app  
Password: Admin@123
```

**What you can do**:
- ✅ View dashboard with analytics
- ✅ Manage coffee menu (create, edit, delete)
- ✅ Manage orders (change status, etc.)
- ✅ View sales metrics

---

## ✅ VERIFICATION CHECKLIST

After running both apps, verify:

### **coffee_app (Customer)**
- [ ] Login screen appears
- [ ] Can login with guest@roastritual.app / Coffee@123
- [ ] Menu loads with coffee items
- [ ] Can add items to cart
- [ ] Cart shows selected items
- [ ] Can view profile
- [ ] Can logout

### **coffee_admin (Admin)**
- [ ] Admin login screen appears
- [ ] Can login with admin@roastritual.app / Admin@123
- [ ] Dashboard shows analytics
- [ ] Can view coffee menu management
- [ ] Can view order list
- [ ] Can change order status

---

## 🔄 DAILY DEVELOPMENT WORKFLOW

After initial setup, daily workflow is:

```bash
# Start of day
cd coffee_app
git checkout develop
git pull origin develop

# Create feature branch
git checkout -b feature/123-description

# Make changes
# ... edit files ...

# Get latest dependencies if others added
flutter pub get

# Run app to test
flutter run

# Commit changes
git add .
git commit -m "feat(scope): description"

# Push
git push -u origin feature/123-description

# Create PR on GitHub
# → Wait for review
# → Merge when approved
```

---

## 📊 DEVELOPMENT TOOLS

### **VS Code Setup** (Recommended)

```bash
# Install extensions:
# 1. Flutter (by Dart Code)
# 2. Dart (by Dart Code)
# 3. Awesome Flutter Snippets
# 4. GitLens
```

### **Android Studio Setup**

```bash
# Open project:
File > Open > select coffee_app folder

# Select devices:
AVD Manager > Create virtual device
```

### **Running with hot reload**

```bash
# Start app
flutter run

# While running, press:
# r    - Hot reload (fastest)
# R    - Hot restart (if hot reload fails)
# q    - Quit app
```

---

## 🌍 MULTI-PLATFORM SUPPORT

Both apps support multiple platforms:

### **Android**
```bash
flutter run -d android
```

### **iOS** (Mac only)
```bash
flutter run -d ios
```

### **Web**
```bash
flutter run -d chrome
# or
flutter run -d firefox
```

### **Windows** (Windows only)
```bash
flutter run -d windows
```

### **macOS** (Mac only)
```bash
flutter run -d macos
```

### **Linux** (Linux only)
```bash
flutter run -d linux
```

---

## 📝 IMPORTANT FILES

| File | Purpose |
|------|---------|
| `lib/main.dart` | App entry point |
| `lib/firebase_options.dart` | Firebase config |
| `lib/app_bootstrap.dart` | App initialization |
| `pubspec.yaml` | Dependencies & assets |
| `packages/` | Shared code (repositories) |
| `.github/pull_request_template.md` | PR template |

---

## 🔗 RELATED DOCUMENTS

- **[FIREBASE_SETUP.md](../FIREBASE_SETUP.md)** - Firebase configuration guide
- **[GIT_WORKFLOW.md](../GIT_WORKFLOW.md)** - Git & GitHub workflow
- **[CODE_REVIEW_PROCESS.md](../CODE_REVIEW_PROCESS.md)** - Code review process
- **[DEMO_SCRIPT.md](../DEMO_SCRIPT.md)** - Demo script for Week 4

---

## 💡 TIPS FOR SUCCESS

1. **Always** `flutter pub get` after pulling new code
2. **Use** `flutter clean` if you get weird errors
3. **Test** on actual device if possible (not just emulator)
4. **Read** error messages carefully - they usually tell you the problem
5. **Ask** for help in team Slack if stuck
6. **Check** [FIREBASE_SETUP.md](../FIREBASE_SETUP.md) if Firebase errors

---

## 🚀 YOU'RE READY!

**To run the project**:

```bash
# Terminal 1: coffee_app
cd coffee_app
flutter run

# Terminal 2: coffee_admin  
cd ../coffee_admin
flutter run
```

**That's it!** Both apps should now be running. 🎉

---

## ❓ QUICK FAQ

**Q: Can I run both apps at the same time?**  
A: Yes! Open 2 terminals, one for each app.

**Q: What if I get "plugin not found" error?**  
A: Run `flutter pub get` in that app's directory.

**Q: How do I debug?**  
A: Use `flutter run -v` for verbose output, or use DevTools.

**Q: Can I change the port?**  
A: Yes, for web: `flutter run -d web-server --web-port 3000`

**Q: How do I build for production?**  
A: See [FIREBASE_SETUP.md](../FIREBASE_SETUP.md) for build instructions.

---

**Version**: 1.0  
**Last Updated**: May 9, 2026  
**Status**: ✅ Ready to use

