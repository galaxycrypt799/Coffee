# Person 4 - Nguyen Vuong - Auth/Profile, Admin Operations, PM

Email: Vuong7411@gmail.com
Vai tro: Dang nhap/dang ky/profile, Firebase Authentication, thong bao loi, admin operations, theo doi tien do.

## Ket qua doi chieu GitHub voi workspace hien tai

GitHub `main` co user repository va mot so man hinh auth/profile/admin, nhung nhieu BLoC auth van la TODO stub. Workspace hien tai da co auth flow, profile, Firebase/local repo, admin users/profile/revenue/upload day du hon.

Ket luan: Nguyen Vuong nen tap trung kiem tra lai auth/profile theo workspace hien tai, viet validation/test va dong bo len GitHub qua PR. Phan PM can cap nhat tien do dua tren 4 file GitFlow nay.

## Branch phu trach

```bash
git checkout dev
git pull origin dev
git checkout -b fix/customer-auth-profile hoac feature/admin-users-management
```

## File phu trach chinh

### coffee_app

- `lib/screens/auth/views/sign_in_screen.dart`
- `lib/screens/auth/views/sign_up_screen.dart`
- `lib/screens/auth/views/welcome_screen.dart`
- `lib/screens/auth/blocs/sing_in_bloc/*`
- `lib/screens/auth/blocs/sign_up_bloc/*`
- `lib/blocs/authentication_bloc/*` khi phoi hop Minh Tai
- `lib/screens/profile/views/profile_screen.dart`
- `lib/components/my_text_field.dart`
- `packages/user_repository/lib/src/user_repo.dart`
- `packages/user_repository/lib/src/firebase_user_repo.dart`
- `packages/user_repository/lib/src/local_user_repo.dart`
- `packages/user_repository/lib/src/models/user.dart`
- `packages/user_repository/lib/src/entities/user_entity.dart`

### coffee_admin

- `lib/src/modules/auth/views/login_screen.dart`
- `lib/src/modules/auth/blocs/sing_in_bloc/*`
- `lib/src/blocs/authentication_bloc/*` khi phoi hop Minh Tai
- `lib/src/modules/operations/views/profile_screen.dart`
- `lib/src/modules/operations/views/users_screen.dart`
- `lib/src/modules/operations/blocs/users_list_bloc/*`
- `lib/src/modules/operations/blocs/upload_picture_bloc/*`
- `lib/src/modules/operations/views/revenue_bloc.dart`
- `lib/src/modules/operations/views/revenue_event.dart`
- `lib/src/modules/operations/views/revenue_state.dart`
- `lib/src/modules/operations/components/macro.dart`
- `lib/src/utils/price_formatter.dart`

## Viec can lam tiep

- [ ] Kiem tra lai login/register customer voi Firebase va local fallback.
- [ ] Map FirebaseAuthException sang thong bao tieng Viet ro rang.
- [ ] Validate email, password, ten, so dien thoai.
- [ ] Hoan thien profile customer: thong tin tai khoan, backend mode, dang xuat, shortcut order history.
- [ ] Hoan thien admin login va users/profile neu dung vai tro admin.
- [ ] Kiem tra update user spent/loyalty sau checkout voi Person 3.
- [ ] Kiem tra upload image: validate file rong, content type, preview, loi Firebase Storage.
- [ ] Kiem tra dashboard revenue doc dung schema order cua Person 3.
- [ ] Cap nhat tien do hang ngay trong checklist/PR description.

## Commit plan theo file

| File/Pham vi | Commit message |
|---|---|
| customer sign-in/sign-up bloc | `feat(auth): implement customer sign in and sign up blocs` |
| customer auth views | `feat(auth): complete customer login and register screens` |
| Firebase/local user repo | `feat(auth): connect Firebase and local user repositories` |
| auth error handling | `fix(auth): show readable Firebase auth errors` |
| profile customer | `feat(profile): complete customer account screen` |
| admin login bloc/view | `feat(admin-auth): implement admin login flow` |
| admin users/profile | `feat(admin-users): add user management profile view` |
| upload picture bloc | `feat(admin-media): handle coffee image uploads` |
| revenue bloc/state | `feat(admin-revenue): calculate dashboard revenue stats` |
| PM docs/checklist | `docs: update team progress checklist` |

## Quy tac phoi hop

- Auth/global state dung chung voi Minh Tai, khong doi contract `AuthenticationState` ma khong bao.
- User model co lien quan checkout loyalty/spent cua Person 3.
- Revenue doc order schema cua Person 3, khong tu them field khac neu chua thong nhat.
- Product image upload lien quan Create Coffee cua Person 2.

## Lenh lam viec

```bash
git checkout dev
git pull origin dev
git checkout -b fix/customer-auth-profile hoac feature/admin-users-management

flutter analyze
flutter test

git add coffee_app/lib/screens/auth coffee_app/lib/screens/profile coffee_app/packages/user_repository
git commit -m "feat(auth): complete customer login and register screens"
git push -u origin fix/customer-auth-profile hoac feature/admin-users-management
```

## Checklist PM hang ngay

- [ ] Moi nguoi co branch rieng tu `dev`.
- [ ] Moi PR co mo ta, screenshot neu la UI, va checklist test.
- [ ] Minh Tai review/merge, khong merge thang vao `main`.
- [ ] Theo doi blockers: Firebase config, conflict schema order/user, UI overflow, build Android/Web.
- [ ] Cuoi ngay tong hop: commit da co, PR dang cho review, loi can sua.
