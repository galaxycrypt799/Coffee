# Person 2 - Minh Toan - UI khach hang va san pham

Email: minhtoan17022004@icloud.com

## Vai tro

Minh Toan phu trach giao dien khach hang va phan quan ly san pham trong admin.

Pham vi chinh:

- Home Screen, Menu Screen, Product Detail.
- Onboarding va cac widget hien thi do uong.
- Coffee repository khi can hien thi them thong tin san pham.
- Admin dashboard layout va man hinh them/sua san pham.
- Kiem tra responsive tren mobile va web.

## Branch su dung

Branch goc khi lam viec:

```bash
git checkout dev
git pull origin dev
```

Branch de sua file UI da co:

```bash
git checkout -b fix/customer-menu-ui
```

Branch de sua phan san pham admin:

```bash
git checkout -b fix/admin-product-management
```

Neu them man hinh hoac widget moi hoan toan thi dung `feature/...`.

## File phu trach

### coffee_app

- `lib/screens/home/blocs/get_coffee_bloc/*`
- `lib/screens/home/views/home_screen.dart`
- `lib/screens/home/views/menu_screen.dart`
- `lib/screens/home/views/details_screen.dart`
- `lib/screens/home/views/product_detail_screen.dart`
- `lib/screens/home/widgets/coffee_card.dart`
- `lib/screens/home/widgets/brew_highlight_tile.dart`
- `lib/components/coffee_image.dart`
- `lib/screens/onboarding/views/onboarding_screen.dart`
- `lib/theme/app_theme.dart`
- `assets/coffee/*`
- `assets/branding/*`
- `assets/fonts/*`
- `packages/coffee_repository/*` khi lien quan UI san pham

### coffee_admin

- `lib/src/modules/base/views/base_screen.dart`
- `lib/src/modules/home/views/home_screen.dart`
- `lib/src/modules/operations/views/create_coffee_screen.dart`
- `lib/src/modules/operations/blocs/create_coffee_bloc/*`
- `packages/coffee_repository/*`

## Commit mau

- `Update customer coffee repository data model`
- `Implement coffee loading bloc for menu screen`
- `Update customer theme onboarding and coffee image widget`
- `Update reusable coffee display widgets`
- `Update customer home menu and product detail screens`
- `Update admin base layout and dashboard screen`
- `Implement create coffee management bloc`
- `Update create coffee management screen`

## Checklist truoc khi push

- [ ] Man hinh khong bi overflow tren mobile nho.
- [ ] Anh san pham co fallback khi duong dan loi.
- [ ] Search/filter menu khong crash voi chuoi rong.
- [ ] Product Detail them duoc mon vao gio hang cua Person 3.
- [ ] Mau sac va font dung theme chung.
- [ ] Admin create coffee co loading, success va error state.
- [ ] Neu sua model `Coffee`, bao Minh Tai va Kim Ngan de kiem tra cart.
