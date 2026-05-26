# Person 2 - Minh Toan - Customer UI, Home/Menu/Product

Email: minhtoan17022004@icloud.com
Vai tro: Giao dien khach hang, Home Screen, Menu Screen, Product Detail, responsive UI/UX.

## Ket qua doi chieu GitHub voi workspace hien tai

GitHub `main` co cau truc `coffee_app/lib/screens/home/...` nhung nhieu file UI/BLoC van la TODO stub, vi du `coffee_card.dart`, `get_coffee_bloc/*`. Workspace hien tai da co ban day du hon: Home, Menu, Details, Product Detail, coffee image, coffee card, highlight tile, theme va assets coffee.

Ket luan: Minh Toan nen lam tiep tren workspace hien tai, sau do PR vao `dev` de dong bo len GitHub. Khong nen viet lai UI tu dau theo GitHub `main` cu.

## Branch phu trach

```bash
git checkout dev
git pull origin dev
git checkout -b fix/customer-menu-ui hoac fix/admin-product-management
```

## File phu trach chinh

### coffee_app

- `lib/screens/home/blocs/get_coffee_bloc/get_coffee_bloc.dart`
- `lib/screens/home/blocs/get_coffee_bloc/get_coffee_event.dart`
- `lib/screens/home/blocs/get_coffee_bloc/get_coffee_state.dart`
- `lib/screens/home/views/home_screen.dart`
- `lib/screens/home/views/menu_screen.dart`
- `lib/screens/home/views/details_screen.dart`
- `lib/screens/home/views/product_detail_screen.dart`
- `lib/screens/home/widgets/coffee_card.dart`
- `lib/screens/home/widgets/brew_highlight_tile.dart`
- `lib/components/coffee_image.dart`
- `lib/screens/onboarding/views/onboarding_screen.dart`
- `assets/coffee/*`
- `assets/branding/*`

### coffee_admin phan lien quan UI san pham

- `lib/src/modules/base/views/base_screen.dart`
- `lib/src/modules/home/views/home_screen.dart`
- `lib/src/modules/operations/views/create_coffee_screen.dart`
- `lib/src/modules/operations/blocs/create_coffee_bloc/*`

## Viec can lam tiep

- [ ] Kiem tra lai Home/Menu tren mobile nho, tablet, web.
- [ ] Dam bao text khong tran trong card, chip, nut, bottom navigation.
- [ ] Chuan hoa CoffeeCard dung chung giua Home va Menu neu hop ly.
- [ ] Hoan thien empty/loading/error UI cho menu.
- [ ] Toi uu anh san pham: kich thuoc co dinh, `cacheWidth/cacheHeight` khi can.
- [ ] Kiem tra Product Detail co nut them vao gio va chuyen sang Cart dung state cua Person 3.
- [ ] Lam UI admin dashboard khop so lieu RevenueBloc cua Person 4.
- [ ] Viet widget test co fake coffee list cho Home/Menu/Product Detail.

## Commit plan theo file

| File/Pham vi | Commit message |
|---|---|
| `get_coffee_bloc/*` | `feat(menu): implement coffee loading bloc` |
| `home_screen.dart` | `feat(home): polish customer home sections` |
| `menu_screen.dart` | `feat(menu): improve search and category filters` |
| `details_screen.dart`, `product_detail_screen.dart` | `feat(product): complete drink detail experience` |
| `coffee_card.dart`, `brew_highlight_tile.dart` | `feat(home): add reusable coffee display widgets` |
| `coffee_image.dart` | `perf(images): optimize coffee image rendering` |
| `onboarding_screen.dart` | `style(onboarding): align onboarding with coffee branding` |
| `create_coffee_screen.dart` | `style(admin): improve product management layout` |
| UI overflow fixes | `fix(ui): prevent layout overflow on small screens` |
| widget tests | `test(menu): add customer menu rendering tests` |

## Quy tac phoi hop

- Khong sua logic tinh tien/gio hang trong pham vi Person 3 neu khong can.
- Neu can them field trong `Coffee`, bao Minh Tai va Person 3 vi anh huong repository va cart item.
- Neu thay doi route/tab trong `main_screen.dart`, thong bao Person 3 vi file nay dung chung voi bottom navigation/cart/order.

## Lenh lam viec

```bash
git checkout dev
git pull origin dev
git checkout -b fix/customer-menu-ui hoac fix/admin-product-management

flutter analyze
flutter test

git add coffee_app/lib/screens/home coffee_app/lib/components/coffee_image.dart
git commit -m "feat(menu): improve search and category filters"
git push -u origin fix/customer-menu-ui hoac fix/admin-product-management
```

## Checklist truoc PR

- [ ] UI dung mau/theme chung, khong them palette lech tong.
- [ ] List dung builder/sliver khi co nhieu item.
- [ ] Anh co fallback khi loi.
- [ ] Search/filter khong crash voi chu rong.
- [ ] Khong hardcode du lieu neu repository da co.
- [ ] Co screenshot demo cho Home/Menu/Product Detail trong mo ta PR.
