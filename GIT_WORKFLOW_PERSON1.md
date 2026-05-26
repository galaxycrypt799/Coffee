# Person 1 - Minh Tai - Nhom truong, Core Integration

Email: taiminh2902@gmail.com
Vai tro: Nhom truong, Git Lead, kien truc tong the, tich hop Firebase/backend, review va merge PR.

## Ket qua doi chieu GitHub voi workspace hien tai

Repository GitHub `galaxycrypt799/Coffee` tren `main` dang la monorepo Flutter gom `coffee_app/` va `coffee_admin/`, co `GIT_WORKFLOW.md`, `README.md`, cac package repository va mot so man hinh/chuc nang. Tuy nhien GitHub hien thieu `coffee_app/pubspec.yaml`, `coffee_admin/pubspec.yaml`, nhieu platform folder va con nhieu file TODO stub trong `lib`.

Workspace hien tai tai `c:\Users\bogau\AndroidStudioProjects\test` da day du hon GitHub:

- `coffee_app/` co `pubspec.yaml`, Android/iOS/Web/Desktop, Firebase config, app bootstrap, auth, menu, cart, checkout, order history, profile, tests.
- `coffee_admin/` co `pubspec.yaml`, Firebase config, GoRouter, dashboard/orders/products/users/revenue/upload, tests.
- `coffee_app` dang la git repository rieng va co nhieu thay doi chua commit. `coffee_admin` trong workspace hien khong phai git repository rieng.

Ket luan: viec tiep theo cua Minh Tai la chuan hoa GitFlow va dong bo trang thai workspace hoan chinh len GitHub theo PR, khong nen lay GitHub `main` lam co so code hien tai de lam tiep neu chua merge/copy lai cac file dang co trong workspace.

## Branch phu trach

Nen dung sau khi tao/lam moi `dev` tu trang thai workspace da build duoc:

```bash
git checkout dev
git pull origin dev
git checkout -b feature/runtime-project-files hoac fix/core-bootstrap
```

Neu GitHub con branch cu ten `feature`, Git khong tao duoc `feature/...`. Can xu ly mot lan:

```bash
git fetch origin
git checkout -b legacy/feature origin/feature
git push origin legacy/feature
git push origin --delete feature
```

## File phu trach chinh

### coffee_app

- `pubspec.yaml`, `pubspec.lock`, `analysis_options.yaml`
- `android/`, `ios/`, `web/`, `linux/`, `macos/`, `windows/`
- `lib/main.dart`
- `lib/app.dart`
- `lib/app_view.dart`
- `lib/app_bootstrap.dart`
- `lib/firebase_options.dart`
- `lib/simple_bloc_observer.dart`
- `lib/blocs/authentication_bloc/*`
- `lib/screens/auth/blocs/*`
- `packages/user_repository/*`
- `packages/coffee_repository/*` khi thay doi contract chung

### coffee_admin

- `pubspec.yaml`, `pubspec.lock`, `analysis_options.yaml`
- `android/`, `ios/`, `web/`, `linux/`, `macos/`, `windows/`
- `lib/main.dart`
- `lib/app.dart`
- `lib/app_view.dart`
- `lib/app_bootstrap.dart`
- `lib/firebase_options.dart`
- `lib/simple_bloc_observer.dart`
- `lib/src/routes/routes.dart`
- `lib/src/blocs/authentication_bloc/*`
- `packages/user_repository/*`
- `packages/coffee_repository/*` khi thay doi contract chung

## Viec can lam tiep

- [ ] Tao `dev` tu ban code workspace da build duoc, khong tao tu GitHub `main` dang thieu file.
- [ ] Dong bo `coffee_app/pubspec.yaml`, `coffee_admin/pubspec.yaml` va platform folders len GitHub.
- [ ] Kiem tra lai remote branch cu: `dev`, `feature`, `fix`; doi `dev` thanh `dev` hoac merge vao `dev` roi dong bang.
- [ ] Them `.github/PULL_REQUEST_TEMPLATE.md` va `.github/ISSUE_TEMPLATE/`.
- [ ] Cai branch protection: `main` chi merge tu `release/*` hoac `hotfix/*`; `dev` chi merge qua PR.
- [ ] Chay bat buoc truoc khi merge: `flutter analyze`, `flutter test` cho ca `coffee_app` va `coffee_admin`.
- [ ] Tich hop Firebase Auth/Firestore/Storage theo fallback local khi Firebase loi.
- [ ] Review tat ca PR cua Person 2, 3, 4 va merge theo thu tu uu tien.
- [ ] Chuan bi `release/1.0.0` khi day du luong khach hang va admin.

## Commit plan de Minh Tai thuc hien

Nen commit nho, moi commit mot nhom thay doi ro rang:

| Thu tu | File/Pham vi | Commit message |
|---|---|---|
| 1 | `.gitignore`, `.github/*`, README/GitFlow | `chore: configure GitFlow repository workflow` |
| 2 | `coffee_app/pubspec.yaml`, `coffee_admin/pubspec.yaml` | `chore: restore Flutter app dependency manifests` |
| 3 | platform folders | `chore: add Flutter platform project files` |
| 4 | app bootstrap customer | `refactor(app): wire customer bootstrap and providers` |
| 5 | app bootstrap admin | `refactor(admin): wire admin bootstrap and routing` |
| 6 | Firebase options/fallback | `feat(core): configure Firebase fallback bootstrap` |
| 7 | auth/global bloc integration | `feat(auth): connect authentication state across apps` |
| 8 | CI/checklist docs | `docs: document team review and release workflow` |
| 9 | merge fixes | `fix: resolve integration build issues` |
| 10 | release prep | `chore: prepare release 1.0.0` |

Minh Tai nen co nhieu commit nhat vi la nguoi gom code, sua conflict, tich hop build va release.

## Lenh Git hang ngay

```bash
git checkout dev
git pull origin dev
git checkout -b feature/runtime-project-files hoac fix/core-bootstrap

flutter analyze
flutter test

git add .
git commit -m "refactor(app): wire customer bootstrap and providers"
git push -u origin feature/runtime-project-files hoac fix/core-bootstrap
```

## Checklist review PR

- [ ] PR base vao `dev`.
- [ ] Ten branch dung `feature/...` cho file moi va `fix/...` cho file cu can sua.
- [ ] Commit message dung Conventional Commits.
- [ ] Khong sua file ngoai pham vi neu khong co ly do.
- [ ] Chay duoc `flutter analyze`.
- [ ] Co test cho logic quan trong: auth, cart, order, repository.
- [ ] Khong commit file build, secret Firebase that, hoac file local IDE.
