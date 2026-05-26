# Firestore and Storage Rules

Rules deploy được đã được tách ra khỏi file hướng dẫn:

- Firestore: `firestore.rules`
- Storage: `storage.rules`
- Firebase config: `firebase.json`

## Deploy

```powershell
firebase login
firebase use coffee-system-f7757
firebase deploy --only firestore:rules,firestore:indexes,storage
```

## Tạo admin đầu tiên

Trước khi rules mới có hiệu lực đầy đủ, cần có ít nhất một document trong collection `admins`.

1. Mở Firebase Console.
2. Vào **Authentication > Users** và tạo tài khoản email/password dùng để đăng nhập admin app.
3. Copy chính xác **User UID** của tài khoản đó. Không dùng email làm document ID.
4. Vào Firestore Database.
5. Tạo collection `admins`.
6. Tạo document có ID đúng bằng Firebase Auth UID vừa copy.
7. Thêm field gợi ý:

```json
{
  "email": "admin@roastritual.app",
  "role": "admin",
  "createdAt": "server timestamp"
}
```

## Cấu trúc dữ liệu chính

- `users/{uid}`: hồ sơ người dùng. User thường chỉ đọc/ghi hồ sơ của chính mình. Admin đọc danh sách và cập nhật thông tin quản trị.
- `admins/{uid}`: danh sách UID có quyền quản trị. Admin app kiểm tra collection này trước khi vào dashboard.
- `coffees/{coffeeId}`: menu đồ uống. App được đọc công khai để tải catalog trước đăng nhập, chỉ admin được tạo/sửa/xóa.
- `orders/{orderId}`: user chỉ tạo và đọc đơn của mình, admin đọc tất cả và cập nhật trạng thái.
- Storage path `coffee_images/{fileName}`: chỉ admin được upload ảnh, mọi người được đọc ảnh menu. Ảnh tối đa 20 MB và phải có content type `image/*`.

Nếu gặp `permission-denied`, kiểm tra theo thứ tự: tài khoản đã đăng nhập, UID có trong `admins`, đã deploy `firestore.rules` và `storage.rules`, rồi restart app.

Nếu đăng nhập admin app vẫn thất bại, kiểm tra nhanh:

- Email/password phải tồn tại trong **Firebase Authentication**, không chỉ trong Firestore.
- Document trong `admins` phải có ID là **UID**, ví dụ `9aBc...`, không phải `admin@...`.
- App đang kết nối project `coffee-system-f7757`.
- Đã deploy rules mới bằng `firebase deploy --only firestore:rules,firestore:indexes,storage`.
