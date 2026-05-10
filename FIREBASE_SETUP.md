# Firebase Setup Cho Cả Hệ Thống

Tài liệu này áp dụng cho cả `coffee_app` và `coffee_admin`. Hai app phải dùng chung **một Firebase project** để menu, tài khoản và đơn hàng đồng bộ đúng.

## 1. Kiến trúc đồng bộ

- `coffee_app` ghi user vào `users`, đọc menu từ `coffees`, tạo đơn vào `orders`.
- `coffee_admin` đọc `coffees` để quản lý menu, đọc và cập nhật `orders`, đồng thời xem cùng dữ liệu `users`.
- Ảnh món mới từ admin được upload vào Firebase Storage, thư mục `coffee_images/`.

## 2. App ID hiện tại

### `coffee_app`

- Android package: `com.example.coffee_app`
- iOS bundle id: `com.example.coffeeApp`
- macOS bundle id: `com.example.coffeeApp`

### `coffee_admin`

- Android package: `com.example.coffee_admin`
- iOS bundle id: `com.example.coffee_admin`
- macOS bundle id: `com.example.coffee_admin`

Nếu bạn đổi package/bundle id, hãy đổi trong project native trước rồi chạy lại `flutterfire configure`.

## 3. Tạo một Firebase project duy nhất

1. Mở Firebase Console và tạo một project mới hoặc dùng project hiện có.
2. Bật `Authentication` với phương thức `Email/Password`.
3. Tạo `Cloud Firestore`.
4. Bật `Firebase Storage`.

## 4. Cấu hình FlutterFire cho từng app

### Trong `coffee_app`

```powershell
cd coffee_app
dart pub global activate flutterfire_cli
flutterfire configure
```

Chọn đúng Firebase project dùng chung và các platform bạn muốn build.

### Trong `coffee_admin`

```powershell
cd coffee_admin
flutterfire configure
```

Tiếp tục chọn **chính cùng project Firebase đó**.

Sau 2 lệnh trên, mỗi app sẽ có `lib/firebase_options.dart` riêng nhưng cùng trỏ về một backend.

## 5. Dấu hiệu cấu hình chưa xong

Nếu `lib/firebase_options.dart` còn các giá trị như:

- `YOUR_PROJECT_ID`
- `YOUR_ANDROID_APP_ID`
- `YOUR_WEB_APP_ID`
- `YOUR_IOS_APP_ID`

thì app sẽ tự rơi về chế độ local demo.

## 6. Schema Firestore dùng chung

### Collection `users`

Document id: `uid` từ Firebase Auth

```json
{
  "userId": "firebase-auth-uid",
  "email": "demo@drinkhub.app",
  "name": "Nguyen Van A",
  "hasActiveCart": false
}
```

### Collection `coffees`

Document id: `coffeeId`

```json
{
  "sortOrder": 1715300000000,
  "coffeeId": "phin-sua-da-signature",
  "picture": "https://...",
  "name": "Phin Sữa Đá Signature",
  "tagline": "Robusta đậm vị, sữa đặc và lớp foam mềm.",
  "description": "Mô tả món",
  "category": "signature",
  "origin": "Cầu Đất x Đắk Lắk",
  "roastLevel": "Đậm vừa",
  "intensity": 3,
  "brewMinutes": 4,
  "volumeMl": 320,
  "rating": 4.5,
  "price": 49000,
  "discount": 10,
  "tastingNotes": [],
  "macros": {
    "calories": 210,
    "proteins": 8,
    "fat": 8,
    "carbs": 23
  }
}
```

### Collection `orders`

Document id: `id` hoặc `orderId`

```json
{
  "id": "order_1715300000000",
  "orderId": "order_1715300000000",
  "userId": "firebase-auth-uid",
  "customerName": "Nguyen Van A",
  "customerPhone": "0900000000",
  "customerEmail": "demo@drinkhub.app",
  "items": [
    {
      "id": "phin-sua-da-signature",
      "coffeeId": "phin-sua-da-signature",
      "name": "Phin Sữa Đá Signature",
      "imageUrl": "https://...",
      "picture": "https://...",
      "price": 49000,
      "category": "signature",
      "quantity": 2
    }
  ],
  "totalPrice": 98000,
  "status": "pending",
  "paymentMethod": "cash",
  "createdAt": "2026-05-09T10:00:00.000Z",
  "deliveryAddress": "123 Nguyen Trai",
  "notes": "Ít đá"
}
```

## 7. Vòng đời trạng thái đơn hàng

Admin nên dùng đúng các trạng thái sau để 2 app hiểu giống nhau:

- `pending`
- `confirmed`
- `preparing`
- `ready`
- `delivered`
- `cancelled`

## 8. Firestore rules gợi ý cho bản demo

```text
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    match /coffees/{coffeeId} {
      allow read: if true;
      allow write: if request.auth != null;
    }

    match /orders/{orderId} {
      allow create: if request.auth != null;
      allow read: if request.auth != null;
      allow update: if request.auth != null;
    }
  }
}
```

## 9. Storage rules gợi ý cho ảnh menu

```text
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /coffee_images/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

## 10. Checklist kiểm tra sau khi nối Firebase

1. Mở `coffee_app`, đăng ký hoặc đăng nhập bằng Firebase Auth.
2. Kiểm tra Firestore có document mới trong `users`.
3. Mở `coffee_admin`, đăng nhập bằng tài khoản admin đã có trong Firebase Auth.
4. Tạo một món mới trong admin và kiểm tra Firestore có document mới trong `coffees`.
5. Quay lại `coffee_app`, tải lại menu và xác nhận món mới hiển thị đúng, kể cả ảnh URL.
6. Tạo một đơn từ `coffee_app`.
7. Mở `coffee_admin`, xác nhận đơn xuất hiện trong `orders`.
8. Đổi trạng thái đơn trong admin và kiểm tra app khách đọc lại đúng lịch sử đơn.
