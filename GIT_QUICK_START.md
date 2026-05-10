# ⚡ Git Quick Start - 5 Phút

> Hướng dẫn cơ bản nhất cho tất cả team

---

## 🚀 Setup Lần Đầu (1 lần)

```bash
# Thiết lập tên & email
git config --global user.name "Tên Bạn"
git config --global user.email "email@example.com"

# Đi tới project
cd c:\Users\bogau\AndroidStudioProjects\test1

# Kiểm tra
git branch
git status
```

---

## 📝 Quy Trình Hàng Ngày

### Sáng (Đầu ngày)
```bash
# Cập nhật latest code
git checkout develop
git pull origin develop
```

### Làm việc
```bash
# Tạo feature branch (lần đầu)
git checkout -b feature/123-short-name

# Hoặc switch lại nhánh cũ
git checkout feature/123-short-name

# Thay đổi files → Edit code

# Commit (1-2 lần/ngày)
git add .
git commit -m "feat(scope): what you did"

# Ví dụ: 
git commit -m "feat(auth): add email validation"
```

### Trước khi rời đi (Chiều)
```bash
# Push work
git push origin feature/123-short-name

# Verify trên GitHub (nên thấy "Compare & pull request")
```

---

## 📋 Format Commit (Cơ bản)

```
<type>(<scope>): <subject>
```

**Types**: `feat` | `fix` | `docs` | `style` | `refactor` | `test` | `chore`

**Scopes**: `auth` | `coffee` | `orders` | `admin` | `ui` | `api`

**Ví dụ**:
- ✅ `feat(auth): add password validation`
- ✅ `fix(orders): prevent duplicate submission`
- ✅ `test(coffee): add menu filtering tests`
- ❌ `fixed bug` (xấu)
- ❌ `WIP` (không commit WIP)

---

## 🌲 Branch Types

| Type | Tạo từ | Dùng cho | Ví dụ |
|------|--------|----------|-------|
| **feature/** | develop | Tính năng mới | `feature/123-login` |
| **bugfix/** | develop | Sửa lỗi | `bugfix/456-cart` |
| **hotfix/** | main | Lỗi khẩn cấp | `hotfix/789-crash` |

---

## 🔄 Pull Request (PR)

1. Push branch: `git push -u origin feature/123-name`
2. Vào GitHub → Click "Compare & pull request"
3. Set: Base = `develop`, Compare = `feature/123-name`
4. Chờ Người 2 (Code Review) phê duyệt
5. Merge & xóa branch

---

## 💡 Nguyên Tắc Vàng

✅ **LUÔN LUÔN**:
- Commit hàng ngày
- Push trước khi rời
- Tạo PR trước khi merge
- Chờ phê duyệt (Người 2)
- Giữ commits focused

❌ **KHÔNG BAO GIỜ**:
- Commit vào `main` hoặc `develop`
- Force push lên shared branches
- Merge PR của chính mình
- Để uncommitted changes qua ngày

---

## 🆘 Cần Giúp?

- **Lỗi Git / Conflicts?** → Hỏi **Người 1** (Git Lead)
- **Code review / Standards?** → Hỏi **Người 2** (Code Review Lead)
- **Testing / QA?** → Hỏi **Người 3** (Demo Lead)
- **Timeline / Planning?** → Hỏi **Người 4** (PM Lead)

---

**Sẵn sàng? Hãy xem file của chính bạn:**
- 👤 Người 1 → [GIT_WORKFLOW_PERSON1.md](GIT_WORKFLOW_PERSON1.md)
- 👤 Người 2 → [GIT_WORKFLOW_PERSON2.md](GIT_WORKFLOW_PERSON2.md)
- 👤 Người 3 → [GIT_WORKFLOW_PERSON3.md](GIT_WORKFLOW_PERSON3.md)
- 👤 Người 4 → [GIT_WORKFLOW_PERSON4.md](GIT_WORKFLOW_PERSON4.md)
