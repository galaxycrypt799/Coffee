# Người 3: Giỏ Hàng & Đơn Hàng + QA/Test

> Bạn phụ trách: Giỏ hàng, thanh toán, đơn hàng (cả 2 app coffee_app + coffee_admin), kiểm thử và bắt lỗi.

---

## File Bạn Làm Việc

### coffee_app (App khách hàng)
```
coffee_app/lib/
├── screens/home/blocs/cart_bloc/         ← BLoC giỏ hàng (3 file: bloc, event, state)
├── screens/home/views/                   ← Màn hình đặt hàng
│   ├── cart_screen.dart                  ← Màn hình giỏ hàng
│   ├── checkout_screen.dart              ← Màn hình thanh toán
│   └── main_screen.dart                  ← Màn hình tổng (có bottom nav)
├── screens/orders/                       ← Đơn hàng
│   ├── cubit/order_history_cubit.dart    ← Cubit lịch sử đơn
│   ├── cubit/order_history_state.dart    ← State lịch sử đơn
│   └── views/order_history_screen.dart   ← Màn hình lịch sử đơn
├── models/                               ← Model dữ liệu
│   ├── cart.dart                         ← Giỏ hàng (có toJson/fromJson)
│   ├── cart_item.dart                    ← Mục trong giỏ (có toJson/fromJson)
│   └── order.dart                        ← Đơn hàng
├── repositories/order_repository.dart    ← Kho dữ liệu đơn hàng
└── utils/price_formatter.dart            ← Định dạng tiền
```

### coffee_admin (App quản trị)
```
coffee_admin/lib/src/modules/operations/views/
├── cart_bloc.dart                        ← BLoC giỏ hàng admin
├── cart_event.dart                       ← Sự kiện giỏ hàng
├── cart_state.dart                       ← Trạng thái giỏ hàng
├── cart_screen.dart                      ← Màn hình giỏ hàng admin
├── orders_bloc.dart                      ← BLoC quản lý đơn hàng
├── orders_event.dart                     ← Sự kiện đơn hàng
├── orders_state.dart                     ← Trạng thái đơn hàng
├── orders_screen.dart                    ← Màn hình danh sách đơn
├── my_orders_bloc.dart                   ← BLoC đơn hàng của tôi
├── order.dart                            ← Model đơn hàng
├── order_item.dart                       ← Model chi tiết đơn
├── order_repo.dart                       ← Interface kho đơn hàng
├── firebase_order_repo.dart              ← Kho đơn hàng Firebase
└── local_order_repo.dart                 ← Kho đơn hàng local
```

---

## Việc Cần Làm

### 1. Giỏ hàng (coffee_app)
- [x] BLoC giỏ hàng (thêm, xóa, tăng/giảm số lượng)
- [x] Màn hình giỏ hàng (cart_screen) — icon đồ uống khi giỏ trống
- [x] Hiển thị danh sách đồ uống trong giỏ
- [x] Tính tổng tiền
- [x] **Lưu giỏ hàng khi tắt app** — SharedPreferences với key `drinkhub_cart`
- [x] **Cart model: thêm toJson() / fromJson()** để serialize ra JSON
- [x] **CartItem model: thêm toJson() / fromJson()** để serialize ra JSON
- [x] **CartBloc: tự động persist** sau mỗi thao tác thêm/xóa/cập nhật/xóa hết
- [x] **CartBloc: load từ SharedPreferences** khi mở app (`LoadCartEvent`)

### 2. Thanh toán & Đơn hàng (coffee_app)
- [ ] Màn hình thanh toán (checkout_screen)
- [x] Màn hình chính có bottom nav (main_screen) — tab "Menu" trỏ đến MenuScreen
- [ ] Màn hình lịch sử đơn hàng (order_history_screen)
- [ ] Cubit quản lý lịch sử đơn
- [x] Model: cart, cart_item, order
- [ ] Repository đơn hàng
- [x] Định dạng tiền (price_formatter)

### 3. Quản lý đơn hàng (coffee_admin)
- [x] BLoC giỏ hàng admin
- [x] Màn hình giỏ hàng admin — icon đồ uống khi giỏ trống
- [ ] Màn hình danh sách đơn hàng
- [ ] BLoC quản lý đơn (orders_bloc)
- [ ] Kho đơn hàng Firebase + Local
- [ ] Cập nhật trạng thái đơn hàng

### 4. QA / Kiểm thử
- [ ] Test tính năng mới trên app
- [ ] Báo cáo lỗi chi tiết
- [ ] Chụp ảnh màn hình minh họa
- [ ] Chuẩn bị demo

---

## Chi Tiết Kỹ Thuật Giỏ Hàng

### Cấu trúc lưu trữ
```dart
// Key trong SharedPreferences
static const _cartKey = 'drinkhub_cart';

// JSON lưu trữ
{
  "items": [
    {
      "id": "coffee_001",
      "name": "Trà sữa trân châu",
      "imageUrl": "https://...",
      "price": 45000,
      "category": "Trà",
      "quantity": 2
    }
  ]
}
```

### Các event trong CartBloc
| Event | Chức năng | Có persist? |
|-------|----------|-------------|
| `AddToCartEvent` | Thêm đồ uống vào giỏ | ✓ |
| `RemoveFromCartEvent` | Xóa 1 món khỏi giỏ | ✓ |
| `UpdateQuantityEvent` | Tăng/giảm số lượng | ✓ |
| `ClearCartEvent` | Xóa toàn bộ giỏ | ✓ |
| `LoadCartEvent` | Đọc giỏ từ bộ nhớ | - |

### Các state trong CartBloc
| State | Mô tả |
|-------|-------|
| `CartInitial` | Trạng thái khởi tạo |
| `CartLoading` | Đang đọc dữ liệu |
| `CartLoaded` | Đã load xong |
| `CartUpdated` | Giỏ vừa được cập nhật |
| `CartError` | Có lỗi xảy ra |

---

## Commit Mẫu Cho File Của Bạn

```bash
# Khi thêm giỏ hàng
git commit -m "feat(cart): them man hinh gio hang

- Hien thi danh sach do uong trong gio
- Nut tang/giam so luong
- Nut xoa san pham
- Hien thi tong tien

Closes #20"

# Khi thêm lưu giỏ hàng
git commit -m "feat(cart): luu gio hang vao SharedPreferences

- Cart va CartItem co toJson/fromJson
- CartBloc tu dong persist sau moi thao tac
- Tu dong load gio hang khi mo app
- Key luu tru: drinkhub_cart

Closes #22"

# Khi sửa lỗi giỏ hàng
git commit -m "fix(cart): sua loi tinh sai tong tien

- Nguyen nhan: khong tinh gia giam
- Cach sua: them logic tinh gia khuyen mai

Fixes #25"
```

---

## Cách Test Và Báo Cáo Lỗi

### Khi test một tính năng mới
```bash
git fetch origin
git checkout feature/ten-nhanh
flutter clean
flutter pub get
flutter run
```

### Checklist test
- [ ] Chức năng hoạt động đúng mô tả?
- [ ] Giao diện đẹp trên điện thoại? Máy tính bảng?
- [ ] Loading hiển thị mượt mà?
- [ ] Thông báo lỗi rõ ràng?
- [ ] App có bị crash không?
- [ ] Thử xoay màn hình, tắt mở app?
- [ ] **Giỏ hàng có giữ nguyên sau khi tắt mở app?**

### Mẫu báo cáo lỗi
```
LỖI: Không hiển thị tổng tiền trong giỏ hàng

Cách tạo lại:
1. Mở app, đăng nhập
2. Thêm 2 đồ uống vào giỏ
3. Mở màn hình giỏ hàng

Kết quả mong đợi: Hiển thị tổng tiền ở cuối màn hình
Kết quả thực tế: Không thấy tổng tiền

Thiết bị: Pixel 4, Android 12
Mức độ: CAO
```

---

## Quy Trình Làm Việc Hàng Ngày

```bash
# SÁNG: Lấy code mới nhất
git checkout develop
git pull origin develop

# Tạo nhánh làm việc
git checkout -b feature/gio-hang

# TRONG NGÀY: Code và commit
git add .
git commit -m "feat(cart): mo ta cong viec"
git push -u origin feature/gio-hang

# CUỐI NGÀY: Test các PR của team, báo cáo lỗi
```

---

Bắt đầu với file đầu tiên: `coffee_app/lib/models/cart.dart`!
