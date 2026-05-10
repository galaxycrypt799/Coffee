# Week 3 — Git Workflow & Engineering Practices

## Slide 1 — Title

**DRINKHUB** — Hệ thống đặt đồ uống

Week 3: Professional Git Workflow

Team 4 người | 2 Flutter Apps | Monorepo

---

## Slide 2 — What / Who / When

```
┌──────────────────────────────────────────────────────────┐
│                    DRINKHUB                               │
│                                                          │
│   ┌──────────────┐          ┌──────────────────────┐     │
│   │  coffee_app  │          │    coffee_admin      │     │
│   │  (Khách)     │◄────────►│    (Quản trị)         │     │
│   │              │  Firebase│                      │     │
│   └──────────────┘          └──────────────────────┘     │
│                                                          │
│   Người 1: Auth + Splash + Git Lead                      │
│   Người 2: Menu + Home + Onboarding + Code Review        │
│   Người 3: Cart + Orders + Checkout + QA                 │
│   Người 4: Revenue + Upload + Theme + PM                 │
│                                                          │
│   Timeline: ████░░░░  (Week 3/4 — đang tích hợp)         │
└──────────────────────────────────────────────────────────┘
```

---

## Slide 3 — 1. Git Branching Strategy: Git Flow

```
                        GIT FLOW — DRINKHUB

                    ┌──────────────┐
                    │     MAIN     │  ← Production (chưa release)
                    └──────┬───────┘
                           │ merge khi release
                    ┌──────▼───────┐
                    │   DEVELOP    │  ← Tích hợp chung, base cho mọi feature
                    └──────┬───────┘
                           │
          ┌────────────────┼────────────────┬──────────────┐
          │                │                │              │
   ┌──────▼──────┐  ┌──────▼──────┐  ┌──────▼──────┐  ┌──▼──────────┐
   │ feature/    │  │ feature/    │  │ feature/    │  │ feature/    │
   │ auth-core   │  │ home-menu   │  │ cart-order  │  │ theme-      │
   │             │  │             │  │             │  │ revenue     │
   │ (Người 1)   │  │ (Người 2)   │  │ (Người 3)   │  │ (Người 4)   │
   └─────────────┘  └─────────────┘  └─────────────┘  └─────────────┘

   [Tương lai] release/v1.0  ← tách từ develop, merge vào main
   [Tương lai] hotfix/xxx    ← tách từ main, merge vào main + develop
```

**Mỗi nhánh dùng để làm gì:**

| Nhánh | Mục đích | Ai push? | Bảo vệ? |
|-------|----------|----------|---------|
| `main` | Production — code đã test kỹ, sẵn sàng release | Chỉ qua PR từ develop | 2 approvals |
| `develop` | Tích hợp — nơi hội tụ code của cả team | Chỉ qua PR từ feature | 1 approval |
| `feature/*` | Phát triển tính năng mới | Mỗi người tự push lên nhánh của mình | Không |
| `release/*` | Chuẩn bị release, chỉ sửa bug | Tách từ develop | 1 approval |
| `hotfix/*` | Sửa lỗi khẩn cấp trên production | Tách từ main | 2 approvals |

**Tại sao chọn Git Flow?**

Team 4 người cùng code 2 app trong 1 repo → cần phân nhánh rõ ràng, tránh đụng code nhau. Git Flow cho phép mỗi người làm việc độc lập trên feature branch, tích hợp có kiểm soát qua develop, và có nhánh release riêng khi cần test trước production.

---

## Slide 4 — Merge Flow: Từ Feature → Develop → Main

```
  NGƯỜI 1            NGƯỜI 2            NGƯỜI 3            NGƯỜI 4
  ────────           ────────           ────────           ────────

feature/auth      feature/home       feature/cart       feature/theme
     │                  │                  │                  │
     ├─ commit 1        ├─ commit 1        ├─ commit 1        ├─ commit 1
     ├─ commit 2        ├─ commit 2        ├─ commit 2        ├─ commit 2
     │       │          │       │          │       │          │       │
     └───────┼──────────┴───────┼──────────┴───────┼──────────┴──────┼──────
             │                  │                  │                  │
             ▼                  ▼                  ▼                  ▼
     ┌───────────────────────────────────────────────────────────────────┐
     │                         PULL REQUEST                              │
     │                                                                   │
     │   Base: develop  ◄──  Compare: feature/xxx                        │
     │                                                                   │
     │   ┌─────────────┐    ┌──────────────────────┐                     │
     │   │ Người 2     │───►│ 1. Check commit msg  │                     │
     │   │ (Reviewer)   │    │ 2. Check code style  │                     │
     │   └─────────────┘    │ 3. Check logic       │                     │
     │                      │ 4. Approve / Reject  │                     │
     │                      └──────────┬───────────┘                     │
     │                                 │                                 │
     │                          ┌──────▼──────┐                          │
     │                          │   MERGE     │                          │
     │                          │ vào develop │                          │
     │                          └─────────────┘                          │
     └───────────────────────────────────────────────────────────────────┘
                                     │
                                     │ (khi đủ tính năng + test xong)
                                     ▼
                              release/v1.0.0
                                     │
                                     │ (test pass)
                                     ▼
                                   main
```

**Quy tắc merge:**
1. Rebasse feature lên develop trước khi tạo PR
2. Người 2 review → approve → squash merge vào develop
3. Xóa feature branch sau merge
4. Tuyệt đối không merge thẳng vào main

---

## Slide 5 — 2. Commit Message Guidelines

**Chuẩn: Conventional Commits**

```
         ┌── Loại commit (feat, fix, docs, refactor, chore)
         │
         │     ┌── Phạm vi (auth, menu, cart, theme, admin...)
         │     │
         ▼     ▼
   feat(home): them tim kiem va loc do uong theo danh muc
   │                                                    │
   └── Dòng đầu ≤ 72 ký tự, tiếng Việt, mô tả ngắn gọn  ┘

   - Them thanh tim kiem realtime            ← Thân commit: bullet points
   - Loc theo danh muc: tra, ca phe, sinh to     mô tả CHI TIẾT thay đổi
   - Hien thi gia giam gia
   - Fix empty state khi khong co ket qua

   Closes #38                                 ← Gắn issue (nếu có)
```

**Bảng loại commit:**

| Type | Khi dùng | Ví dụ |
|------|----------|-------|
| `feat` | Tính năng mới | `feat(cart): luu gio hang vao SharedPreferences` |
| `fix` | Sửa lỗi | `fix(auth): sua loi khong hien thi thong bao dang nhap` |
| `docs` | Tài liệu | `docs(readme): cap nhat huong dan cai dat Firebase` |
| `refactor` | Cải thiện code | `refactor(cart): tach logic tinh tien ra ham rieng` |
| `chore` | Linh tinh | `chore(build): nang cap flutter_bloc len 9.0` |

**TỐT vs XẤU:**

```
TỐT:                                XẤU:
feat(menu): them tim kiem 🚀        update code
fix(auth): validate email           sua loi
refactor(cart): tach persist        123
docs(guide): them git workflow      abcxyz
```

**Quy tắc bắt buộc:**
- Dòng đầu ≤ 72 ký tự
- Viết bằng tiếng Việt (team người Việt)
- Thân commit ghi rõ: đã làm gì, tại sao, ảnh hưởng gì
- Gắn `Closes #n` nếu có issue tương ứng

---

## Slide 6 — 3. Code Review & Pull Request Process

```
   DEVELOPER                          REVIEWER (Người 2)
   ─────────                          ──────────────────

   1. Code xong, test local
   2. git rebase develop
   3. git push
   4. Tạo PR trên GitHub ─────────►  5. Nhận notification
       (base: develop)

                                     6. Review checklist:
                                     ┌─────────────────────────────┐
                                     │ □ Tên branch đúng chuẩn?   │
                                     │ □ Commit message rõ ràng?  │
                                     │ □ Đúng file phạm vi?       │
                                     │ □ Không console.log?       │
                                     │ □ Có xử lý lỗi?            │
                                     │ □ Logic đúng, security OK? │
                                     │ □ Đặt tên biến/hàm rõ nghĩa│
                                     └─────────────────────────────┘
                                                │
                                    ┌───────────┴───────────┐
                                    ▼                       ▼
                                APPROVE              REQUEST CHANGES
                              "LGTM! 🚀"            "Gợi ý: tách hàm
                                    │                validate ra riêng
                                    │                cho gọn hơn nhé"
                                    ▼                       │
   7. Merge vào develop ◄───────────┘               Developer:
   8. Xóa feature branch                               Sửa → push lại
                                                       → Re-review
```

**Ai review?**

Người 2 (Code Review Lead) review TẤT CẢ PR. Người 1 (Git Lead) review PR liên quan đến auth và cấu trúc app. Những người khác có thể review chéo.

**Issue tracking:**

GitHub Issues để track task + bug. Mỗi tính năng = 1 Issue. Gắn label: `feature`, `bug`, `documentation`. Link issue trong PR description. Đóng issue tự động khi merge PR (`Closes #n`).

---

## Slide 7 — 4. Conflict Handling Strategy

```
PHÒNG NGỪA                          KHI CONFLICT XẢY RA
──────────                          ─────────────────────

┌──────────────────────┐            ┌──────────────────────┐
│ 1. PHÂN FILE RÕ RÀNG │            │ Bước 1: git status   │
│                      │            │ → Xem file conflict  │
│  Mỗi người code      │            │                      │
│  trong thư mục riêng │            │ Bước 2: Mở file      │
│  → ít khi đụng file  │            │ → VS Code hiển thị:  │
│                      │            │                      │
│ 2. PR NHỎ, MERGE     │            │ <<<<<<< HEAD        │
│    THƯỜNG XUYÊN      │            │ code cũ             │
│  → Mỗi PR ≤ 300 dòng │            │ =======             │
│                      │            │ code mới            │
│ 3. SYNC MỖI SÁNG     │            │ >>>>>>> feature/xxx │
│                      │            │                      │
│  git checkout develop│            │ Bước 3: Chọn         │
│  git pull            │            │ Accept Current (mình)│
│  git checkout feat/x │            │ Accept Incoming (bạn)│
│  git rebase develop  │            │ Accept Both          │
│                      │            │                      │
│ 4. KHÔNG CODE CHUNG  │            │ Bước 4: Save → Add   │
│    FILE NẾU KHÔNG    │            │ git add file          │
│    TRAO ĐỔI TRƯỚC   │            │ git rebase --continue │
└──────────────────────┘            └──────────────────────┘
```

**Công cụ:**

| Công cụ | Dùng cho |
|---------|----------|
| **VS Code Merge Editor** | Phần lớn conflict — 3-way view, dễ chọn |
| **GitHub Conflict Editor** | Conflict đơn giản, sửa ngay trên web |
| **Android Studio** | Conflict phức tạp trong code Dart/Flutter |

**Team rules (BẤT DI BẤT DỊCH):**

```
✅ LUÔN LÀM:                     ❌ TUYỆT ĐỐI KHÔNG:
git pull develop mỗi sáng       git push --force (lên main/develop)
Tạo PR nhỏ, merge nhanh         Tự merge PR không cần review
Push code trước khi về          Commit thẳng vào main/develop
Báo team nếu sửa file chung     Giữ code local qua đêm
Xóa feature branch sau merge    git reset --hard rồi push
```

---

## Slide 8 — 5. Live Git Demonstration

**Phần 1: Show GitHub Repository**

```
GitHub: github.com/[username]/drinkhub

Cần show:
┌─────────────────────────────────────────────────────────┐
│ 1. Tab Code: Cây thư mục monorepo                      │
│    coffee_app/   coffee_admin/   packages/              │
│                                                         │
│ 2. Branches: dropdown chọn branch                       │
│    main (default)                                       │
│    develop (active)                                     │
│    feature/auth-core (Người 1)                          │
│    feature/home-menu (Người 2)                          │
│    feature/cart-order (Người 3)                         │
│    feature/theme-revenue (Người 4)                      │
│                                                         │
│ 3. Tab Pull Requests: danh sách PR                      │
│    Open:   feature/cart-order → develop                 │
│    Merged: feature/home-menu → develop ✓                │
│    Merged: feature/auth-core → develop ✓                │
│                                                         │
│ 4. Chọn 1 merged PR → show:                             │
│    - Commit history trong PR (gọn, rõ ràng)             │
│    - Review comments (Người 2 feedback)                 │
│    - "Merged by Người 2" → evidence of review           │
└─────────────────────────────────────────────────────────┘
```

**Phần 2: Show 1 Commit Message Điển Hình**

```
Chọn 1 commit trong PR, show nội dung:

   feat(menu): them tim kiem va loc do uong theo danh muc

   - Them SearchBar realtime tim theo ten, tagline, mo ta
   - Them FilterChip loc theo category (Tra, Ca phe, Sinh to...)
   - Hien thi gia giam gia va % discount
   - Fix empty state khi khong tim thay ket qua
   - Su dung const BorderSide tranh rebuild khong can thiet

   Closes #38

→ Đây là commit CHUẨN: đủ type, scope, mô tả ngắn, thân chi tiết, link issue
```

**Phần 3: Demo Conflict Resolution (Live)**

```bash
# Bước 1: Tạo conflict giả lập
git checkout develop
git checkout -b demo/conflict-a
# Sửa dòng 124 trong menu_screen.dart:
#   title: const Text('Thực đơn đồ uống - Phiên bản A'),
git add . && git commit -m "demo: thay doi tieu de menu - phien ban A"
git push -u origin demo/conflict-a

git checkout develop
git checkout -b demo/conflict-b
# Sửa CÙNG dòng 124:
#   title: const Text('Menu đồ uống DrinkHub'),
git add . && git commit -m "demo: thay doi tieu de menu - phien ban B"

# Bước 2: Merge conflict-a vào develop (OK)
git checkout develop
git merge demo/conflict-a   # → OK, không conflict

# Bước 3: Merge conflict-b → CONFLICT!
git merge demo/conflict-b   # → CONFLICT! menu_screen.dart:124

# Bước 4: Mở VS Code → Merge Editor
#   <<<<<<< HEAD (develop)
#   title: const Text('Thực đơn đồ uống - Phiên bản A'),
#   =======
#   title: const Text('Menu đồ uống DrinkHub'),
#   >>>>>>> demo/conflict-b

# Bước 5: Chọn "Accept Incoming" → giữ code mới
#   git add lib/screens/home/views/menu_screen.dart
#   git merge --continue
# → Conflict resolved!
```

---

## Slide 9 — Tổng kết: Engineering Workflow Đã Đạt Được

```
┌────────────────────────────────────────────────────────────┐
│              ENGINEERING WORKFLOW — DRINKHUB               │
│                                                            │
│                                                              │
│   ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────┐ │
│   │  BRANCH  │───►│  COMMIT  │───►│ PULL REQ │───►│MERGE │ │
│   │  STRATEGY│    │  CONVENT │    │ +REVIEW  │    │      │ │
│   └──────────┘    └──────────┘    └──────────┘    └──────┘ │
│                                                            │
│   Git Flow           Conventional    Người 2 review     Squash
│   main/dev/feature   Commits         Checklist 6 món    merge
│                                                            │
│   ───────────────────────────────────────────────────────  │
│                                                            │
│   ✅ Đã có:                                                │
│   • 4 feature branches hoạt động song song                │
│   • Commit message đồng bộ toàn team                      │
│   • Code review qua PR trước khi merge                    │
│   • Chiến lược conflict rõ ràng (phòng ngừa + xử lý)      │
│   • Phân file theo người → giảm 80% conflict              │
│   • Git Lead + Code Review Lead rõ vai trò                │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

---

## Slide 10 — Q&A

**DRINKHUB**

Sẵn sàng demo chi tiết:

- Sơ đồ Git Flow + merge thực tế
- Lịch sử commit + PR đã merge
- Cách team xử lý conflict
- Quy trình review code
- App chạy thật trên máy
