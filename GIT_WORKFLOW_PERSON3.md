# Person 3 - Kim Ngan - Gio hang, Checkout va Don hang

Email: ngandinhkim262@gmail.com

## Vai tro

Kim Ngan phu trach luong dat hang cua app khach hang va quan ly don trong admin.

Pham vi chinh:

- Cart model, CartBloc va luu gio hang local.
- Cart Screen, Checkout Screen.
- Tao don hang va luu lich su don hang.
- Admin orders, order repository local/Firebase.
- Test cho cart, order history va revenue/order core.

## Branch su dung

Branch goc khi lam viec:

```bash
git checkout dev
git pull origin dev
```

Branch thuong dung:

```bash
git checkout -b fix/customer-cart-orders
git checkout -b fix/admin-orders
git checkout -b fix/test-coverage
```

Dung `feature/...` neu them luong dat hang moi hoan toan.

## File phu trach

### coffee_app

- `lib/models/cart.dart`
- `lib/models/cart_item.dart`
- `lib/models/order.dart`
- `lib/repositories/order_repository.dart`
- `lib/screens/home/blocs/cart_bloc/*`
- `lib/screens/home/views/cart_screen.dart`
- `lib/screens/home/views/checkout_screen.dart`
- `lib/screens/home/views/main_screen.dart` khi lien quan tab cart/order
- `lib/screens/orders/cubit/*`
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
- `lib/src/modules/operations/views/cart_bloc.dart`
- `lib/src/modules/operations/views/cart_event.dart`
- `lib/src/modules/operations/views/cart_state.dart`
- `lib/src/modules/operations/views/cart_screen.dart`
- `test/admin_core_test.dart`

## Commit mau

- `Update cart and order data models`
- `Update customer order repository and price formatter`
- `Implement persistent cart bloc for customer app`
- `Update cart and checkout screens for customer app`
- `Implement order history cubit for customer app`
- `Update admin local and Firebase order repositories`
- `Update admin order management blocs`
- `Update admin orders management screen`
- `Add customer cart and order history tests`

## Checklist test

- [ ] Them mon vao gio hang dung so luong.
- [ ] Tang, giam, xoa item khong sai tong tien.
- [ ] Gio hang con sau khi tat/mo app neu chua checkout.
- [ ] Checkout thanh cong tao order va clear cart.
- [ ] Order history sap xep don moi truoc.
- [ ] Admin update status don hang khong lam sai revenue.
- [ ] Test cart/order pass truoc khi merge.
