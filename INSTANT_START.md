# ⚡ INSTANT START SCRIPT

**Purpose**: Copy-paste these commands to get running in 2 minutes.

---

## 🚀 SETUP COFFEE_APP (Copy & Paste)

```bash
# 1. Navigate to project
cd c:\Users\bogau\AndroidStudioProjects\test1\coffee_app

# 2. Get dependencies (takes ~1-2 minutes)
flutter pub get

# 3. Analyze code
flutter analyze

# 4. Run on Chrome
flutter run -d chrome

# 5. Wait for app to load, then you should see login screen!
```

**Expected Output**:
```
Launching lib/main.dart on Chrome in debug mode...
✓ Built instance
Roast & Ritual app loaded in Chrome
```

---

## 🔧 SETUP COFFEE_ADMIN (In New Terminal)

```bash
# 1. Navigate to project
cd c:\Users\bogau\AndroidStudioProjects\test1\coffee_admin

# 2. Get dependencies
flutter pub get

# 3. Run on different port (so it doesn't conflict)
flutter run -d chrome --web-port 3001

# 4. Wait for app to load!
```

---

## 🔐 LOGIN CREDENTIALS

**coffee_app** (Customer):
```
Email:    guest@roastritual.app
Password: Coffee@123
```

**coffee_admin** (Admin):
```
Email:    admin@roastritual.app
Password: Admin@123
```

---

## ✅ VERIFY IT WORKS

### coffee_app Should Show:
- [ ] Login screen with email/password fields
- [ ] Can login with above credentials
- [ ] Menu screen with coffee items
- [ ] Can add to cart
- [ ] Can view profile

### coffee_admin Should Show:
- [ ] Admin login screen
- [ ] Can login with admin credentials
- [ ] Dashboard with analytics
- [ ] Coffee management section
- [ ] Orders section

---

## 🐛 IF SOMETHING DOESN'T WORK

### `flutter: command not found`
```bash
# Check if Flutter is installed
flutter --version

# If not installed, install from:
# https://flutter.dev/docs/get-started/install
```

### `Packages not found error`
```bash
# Clear cache and reinstall
flutter clean
flutter pub get
```

### `Port already in use`
```bash
# Use different port for admin
flutter run -d chrome --web-port 3001
```

### `Firebase errors`
- Check [FIREBASE_SETUP.md](FIREBASE_SETUP.md)
- Verify demo accounts exist in Firebase

### `Still not working?`
- Check [COMPLETE_SETUP_GUIDE.md](COMPLETE_SETUP_GUIDE.md#troubleshooting)
- Contact Person 1 (Git Lead)

---

## 📱 RUN ON DIFFERENT DEVICES

### Android Emulator
```bash
flutter run -d emulator-5554
```

### iOS (Mac only)
```bash
flutter run -d ios
```

### Physical Android Device (connected via USB)
```bash
flutter devices  # See list of devices
flutter run -d <device_id>
```

### Web (Different browsers)
```bash
# Chrome (default)
flutter run -d chrome

# Firefox
flutter run -d firefox

# Safari (Mac)
flutter run -d macos
```

---

## 📊 ONCE APPS ARE RUNNING

**Next steps**:
1. ✅ Explore the apps
2. ✅ Try different features
3. ✅ Check [DEMO_SCRIPT.md](DEMO_SCRIPT.md) for what to demo
4. ✅ Read [GIT_WORKFLOW.md](GIT_WORKFLOW.md) to start contributing
5. ✅ Check [CODE_REVIEW_PROCESS.md](CODE_REVIEW_PROCESS.md) for PR rules

---

## 🔄 DAILY WORKFLOW

Once setup, daily workflow is:

```bash
# Get latest code
git checkout develop
git pull origin develop

# Create feature branch
git checkout -b feature/123-description

# Make changes, then run to test
flutter run

# When done, commit and push
git add .
git commit -m "feat(scope): description"
git push -u origin feature/123-description

# Create PR on GitHub
# → Wait for review
# → Merge when approved
```

---

**That's it! You're ready to develop!** 🎉

Questions? See [COMPLETE_SETUP_GUIDE.md](COMPLETE_SETUP_GUIDE.md)

