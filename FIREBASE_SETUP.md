# Firebase Setup

Hai app dùng chung project `coffee-system-f7757`.

## Customer app

```powershell
cd coffee_app
flutter pub get
flutter run
```

## Admin app

```powershell
cd coffee_admin
flutter pub get
flutter run
```

## Firestore và Storage

Rules nằm trong `coffee_admin`:

- `coffee_admin/firestore.rules`
- `coffee_admin/storage.rules`
- `coffee_admin/firestore.indexes.json`

Deploy:

```powershell
cd coffee_admin
firebase login
firebase use coffee-system-f7757
firebase deploy --only firestore:rules,firestore:indexes,storage
```

## Kết nối Firebase Storage cho upload ảnh

Admin app đã dùng `firebase_storage` trong `packages/coffee_repository/lib/src/firebase_coffee_repo.dart`.

Điều kiện để upload hoạt động:

1. Firebase Storage đã được bật trong Firebase Console.
2. Tài khoản đăng nhập admin có document `admins/{uid}` trong Firestore.
3. `storage.rules` đã được deploy.
4. Ảnh upload nhỏ hơn 20 MB và có content type `image/*`.

Ảnh được upload vào path `coffee_images/`, cho phép đọc công khai để Coffee App hiển thị menu, và URL trả về được lưu vào document `coffees/{coffeeId}`.
