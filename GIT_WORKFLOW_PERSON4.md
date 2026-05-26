# Person 4 - Nguyen Vuong - Auth, Profile va Admin Users

Email: Vuong7411@gmail.com

## Vai tro

Nguyen Vuong phu trach dang nhap, dang ky, profile va cac chuc nang lien quan user trong admin.

Pham vi chinh:

- Customer Login, Register, Welcome, Profile.
- AuthenticationBloc va sign in/sign up bloc.
- Firebase/local user repository.
- Admin login, splash, profile.
- Admin users management, upload picture, revenue dashboard.

## Branch su dung

Branch goc khi lam viec:

```bash
git checkout dev
git pull origin dev
```

Branch thuong dung:

```bash
git checkout -b fix/customer-auth-profile
git checkout -b fix/admin-auth-revenue
git checkout -b feature/admin-users-management
```

Dung `fix/...` khi sua flow da co, dung `feature/...` khi them man hinh hoac bloc moi.

## File phu trach

### coffee_app

- `lib/blocs/authentication_bloc/*`
- `lib/screens/auth/blocs/sing_in_bloc/*`
- `lib/screens/auth/blocs/sign_up_bloc/*`
- `lib/screens/auth/views/sign_in_screen.dart`
- `lib/screens/auth/views/sign_up_screen.dart`
- `lib/screens/auth/views/welcome_screen.dart`
- `lib/screens/profile/views/profile_screen.dart`
- `lib/components/my_text_field.dart`
- `lib/components/macro.dart`
- `packages/user_repository/*`

### coffee_admin

- `lib/src/blocs/authentication_bloc/*`
- `lib/src/modules/auth/*`
- `lib/src/modules/splash/views/splash_screen.dart`
- `lib/src/modules/operations/views/profile_screen.dart`
- `lib/src/modules/operations/views/users_screen.dart`
- `lib/src/modules/operations/blocs/users_list_bloc/*`
- `lib/src/modules/operations/blocs/upload_picture_bloc/*`
- `lib/src/modules/operations/views/revenue_bloc.dart`
- `lib/src/modules/operations/views/revenue_event.dart`
- `lib/src/modules/operations/views/revenue_state.dart`
- `lib/src/components/my_text_field.dart`
- `lib/src/modules/operations/components/macro.dart`
- `lib/src/utils/price_formatter.dart`
- `packages/user_repository/*`

## Commit mau

- `Update customer user repository implementation`
- `Update customer authentication bloc`
- `Update customer sign in and sign up blocs`
- `Update customer login register and welcome screens`
- `Update customer profile and shared form components`
- `Update admin authentication login and splash flow`
- `Update admin coffee image upload bloc`
- `Update admin profile and revenue dashboard logic`
- `Add admin users list bloc`
- `Add admin users management screen`

## Checklist test

- [ ] Login/register validate email va password.
- [ ] Loi Firebase hien thong bao de hieu.
- [ ] Local fallback khong lam app crash khi Firebase loi.
- [ ] Profile hien dung thong tin user va dang xuat duoc.
- [ ] Admin login dieu huong dung vao dashboard.
- [ ] Upload anh co loading/error state.
- [ ] Revenue dashboard dung schema order cua Kim Ngan.
- [ ] Neu sua user model, bao Minh Tai va Kim Ngan de kiem tra checkout.
