# Person 3 - Kim Ngan - Cart, Checkout, Orders, QA

Email: ngandinhkim262@gmail.com
Vai tro: Gio hang, thanh toan, lich su don hang, quan ly don trong admin, QA/Test.

## Ket qua doi chieu GitHub voi workspace hien tai

GitHub `main` da co nhieu file cart/order nhung mot so file quan trong van la TODO stub, dac biet `coffee_app/lib/screens/home/blocs/cart_bloc/*`. Workspace hien tai da co day du hon: cart model, cart item, order model, CartBloc co persistence, Cart Screen, Checkout Screen, OrderHistoryCubit, OrderRepository va tests.

Ket luan: Kim Ngan nen tiep tuc hoan thien va test luong dat hang tren workspace hien tai, sau do PR vao `dev` de dong bo len GitHub.

## Branch phu trach

```bash
git checkout dev
git pull origin dev
git checkout -b fix/customer-cart-orders hoac fix/admin-orders
```

## File phu trach chinh

### coffee_app

- `lib/models/cart.dart`
- `lib/models/cart_item.dart`
- `lib/models/order.dart`
- `lib/repositories/order_repository.dart`
- `lib/screens/home/blocs/cart_bloc/cart_bloc.dart`
- `lib/screens/home/blocs/cart_bloc/cart_event.dart`
- `lib/screens/home/blocs/cart_bloc/cart_state.dart`
- `lib/screens/home/views/cart_screen.dart`
- `lib/screens/home/views/checkout_screen.dart`
- `lib/screens/home/views/main_screen.dart` khi lien quan bottom nav/cart/orders
- `lib/screens/orders/cubit/order_history_cubit.dart`
- `lib/screens/orders/cubit/order_history_state.dart`
- `lib/screens/orders/views/order_history_screen.dart`
- `lib/utils/price_formatter.dart`
- `test/cart_test.dart`
- `test/order_history_cubit_test.dart`
- `test/order_repository_persistence_test.dart`

### coffee_admin

- `lib/src/modules/operations/views/order.dart`
- `lib/src/modules/operations/views/order_item.dart`
- `lib/src/modules/operations/views/order_repo.dart`
- `lib/src/modules/operations/views/firebase_order_repo.dart`
- `lib/src/modules/operations/views/local_order_repo.dart`
- `lib/src/modules/operations/views/orders_bloc.dart`
- `lib/src/modules/operations/views/orders_event.dart`
- `lib/src/modules/operations/views/orders_state.dart`
- `lib/src/modules/operations/views/orders_screen.dart`
- `lib/src/modules/operations/views/my_orders_bloc.dart`
- `test/admin_core_test.dart`

## Viec can lam tiep

- [ ] Kiem tra CartBloc persist/load gio hang dung khi tat mo app.
- [ ] Dam bao add/remove/update quantity khong tao duplicate sai.
- [ ] Checkout validate ten, so dien thoai, dia chi khi giao hang.
- [ ] Chan double submit khi dang tao don.
- [ ] Sau khi place order thanh cong, gio hang clear va order history cap nhat ngay.
- [ ] Dong bo schema order giua customer va admin: `id/orderId`, `userId`, `items`, `totalPrice`, `status`, `paymentMethod`, `createdAt`.
- [ ] Toi uu Firestore query order: orderBy `createdAt`, limit, cache fallback.
- [ ] Giam polling admin orders neu qua day request.
- [ ] Them test cho local repository, Firebase fallback mock, cart math.
- [ ] Lap checklist QA demo cho luong: login -> menu -> add cart -> checkout -> order history -> admin update status.

## Commit plan theo file

| File/Pham vi | Commit message |
|---|---|
| `models/cart.dart`, `models/cart_item.dart` | `feat(cart): add serializable cart models` |
| `cart_bloc/*` | `feat(cart): persist cart state locally` |
| `cart_screen.dart` | `feat(cart): complete cart management screen` |
| `checkout_screen.dart` | `feat(checkout): implement order submission flow` |
| `order.dart`, `order_repository.dart` | `feat(orders): add customer order repository` |
| `order_history_cubit.dart`, `order_history_screen.dart` | `feat(orders): show customer order history` |
| `admin order models/repo` | `feat(admin-orders): add order repository integration` |
| `orders_bloc.dart`, `orders_screen.dart` | `feat(admin-orders): manage order status updates` |
| Firestore query/performance | `perf(orders): cache and limit order history queries` |
| bug tinh tien | `fix(cart): correct total price calculation` |
| tests | `test(orders): add cart and order persistence tests` |

## Quy tac phoi hop

- Neu doi format `Order.toMap()`, bao Minh Tai va Person 4 vi lien quan Firebase/Admin/Revenue.
- Neu doi UI Product Detail add-to-cart, phoi hop Person 2.
- Khong sua auth/profile ngoai validate user id can cho order.
- Moi thay doi checkout phai co test hoac checklist manual.

## Lenh lam viec

```bash
git checkout dev
git pull origin dev
git checkout -b fix/customer-cart-orders hoac fix/admin-orders

flutter test
flutter analyze

git add coffee_app/lib/models coffee_app/lib/repositories coffee_app/lib/screens/home/blocs/cart_bloc coffee_app/lib/screens/orders
git commit -m "feat(orders): show customer order history"
git push -u origin fix/customer-cart-orders hoac fix/admin-orders
```

## Checklist QA

- [ ] Them 1 mon vao gio, tang/giam so luong dung.
- [ ] Xoa item va clear cart dung.
- [ ] Tat/mo app, gio hang van con neu chua checkout.
- [ ] Checkout thanh cong tao order co tong tien dung.
- [ ] Order history sap xep moi nhat truoc.
- [ ] Admin thay doi status, customer/doc Firestore nhan dung status.
- [ ] Offline/local fallback khong crash.
