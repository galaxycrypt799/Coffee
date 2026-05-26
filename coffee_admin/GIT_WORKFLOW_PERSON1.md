# Person 1 - Minh Tai - Nhom truong, Core va GitFlow

Email: taiminh2902@gmail.com

## Vai tro

Minh Tai phu trach dieu phoi chung, review Pull Request, merge code vao `dev` va dua ban on dinh len `main`.

Pham vi chinh:

- Quan ly GitFlow va quy tac commit cua nhom.
- Kiem tra cau truc `coffee_app` va `coffee_admin`.
- Tich hop bootstrap, routing, Firebase config va repository dung chung.
- Chay `flutter analyze`, `flutter test` truoc khi merge.
- Xu ly conflict va sua loi build khi tong hop code cua cac thanh vien.

## Branch su dung

Branch chinh:

- `main`: ban on dinh de nop/demo.
- `dev`: branch tich hop code hang ngay.

Branch lam viec:

- `feature/...`: them file hoac chuc nang moi.
- `fix/...`: sua file da co san hoac dong bo noi dung voi project hien tai.
- `legacy/feature`, `legacy/fix`: luu lai hai branch cu ten `feature` va `fix`.

Vi repo da tung co branch cu ten `feature` va `fix`, nhom dung dang `feature/...` va `fix/...` sau khi da chuyen branch cu sang `legacy/...`.

## File phu trach

### coffee_app

- `pubspec.yaml`, `pubspec.lock`, `analysis_options.yaml`
- `android/`, `web/`, `firebase.json`
- `lib/main.dart`
- `lib/app.dart`
- `lib/app_view.dart`
- `lib/app_bootstrap.dart`
- `lib/firebase_options.dart`
- `lib/simple_bloc_observer.dart`
- `packages/user_repository/*` khi thay doi contract chung
- `packages/coffee_repository/*` khi thay doi contract chung

### coffee_admin

- `pubspec.yaml`, `pubspec.lock`, `analysis_options.yaml`
- `android/`, `web/`, `firebase.json`
- `firestore.rules`, `storage.rules`, `firestore.indexes.json`
- `lib/main.dart`
- `lib/app.dart`
- `lib/app_view.dart`
- `lib/app_bootstrap.dart`
- `lib/firebase_options.dart`
- `lib/simple_bloc_observer.dart`
- `lib/src/routes/routes.dart`

## Quy trinh lam viec

```bash
git checkout dev
git pull origin dev
git checkout -b fix/core-bootstrap
```

Sau khi code xong:

```bash
flutter analyze
flutter test

git add <file-can-commit>
git commit -m "Update customer app bootstrap and providers"
git push -u origin fix/core-bootstrap
```

Sau khi PR da duoc review:

```bash
git checkout dev
git merge --no-ff fix/core-bootstrap
git push origin dev
```

Khi `dev` on dinh:

```bash
git checkout main
git merge --no-ff dev
git push origin main
```

## Commit mau

- `Add customer app Flutter configuration files`
- `Add admin app Flutter and Firebase configuration files`
- `Update customer app bootstrap and providers`
- `Update admin app bootstrap and routing`
- `Clarify feature and fix branch naming in workflow docs`
- `Resolve integration conflicts before release`

## Checklist review

- [ ] Branch bat dau tu `dev`.
- [ ] Ten branch dung `feature/...` hoac `fix/...`.
- [ ] Commit chi gom file lien quan den mot muc dich ro rang.
- [ ] Khong commit `build/`, `.dart_tool/`, `local.properties`, file IDE.
- [ ] `flutter analyze` pass cho app bi anh huong.
- [ ] `flutter test` pass neu sua logic.
- [ ] Main app va admin app van chay duoc sau khi merge.
