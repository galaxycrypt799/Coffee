# 📋 Code Review & Pull Request Process

## Overview

This document defines how we handle code reviews and pull requests in the Roast & Ritual project.

---

## 🔄 Pull Request Workflow

### **Step 1: Create PR on GitHub**

```markdown
Title: feat(auth): implement email/password authentication
Base: develop
Compare: feature/123-auth-system

Body:
## Description
Implemented email/password login with Firebase Authentication

## Type of Change
- [x] New feature
- [ ] Bug fix
- [ ] Breaking change

## Changes
- Added login screen UI
- Integrated Firebase Auth
- Implemented email validation
- Added password reset

## Testing Done
- [x] Tested with valid email
- [x] Tested with invalid email  
- [x] Tested with wrong password
- [x] Tested Firebase errors

## Screenshots
[Attach if UI changed]

Closes #123
```

### **Step 2: Automated Checks**

GitHub automatically runs:
- ✅ Dart format check
- ✅ Lint analysis (`flutter analyze`)
- ✅ Unit tests (`flutter test`)
- ✅ Build check

**If any fail**: Push fixes, automated checks re-run automatically

### **Step 3: Request Reviewers**

Request 2 reviewers:
- Primary: Tech Lead (Person 1 or 2)
- Secondary: Another team member

```
Add reviewers on GitHub UI:
→ Right panel: "Reviewers"
→ Select 2 people
→ Notify in Slack: "#roast-ritual-team PR ready for review"
```

### **Step 4: Code Review**

Reviewers check (see checklist below)

Possible responses:
- ✅ **Approve** - Ready to merge
- 🔄 **Request changes** - Fix these issues
- 💬 **Comment** - Question or suggestion

### **Step 5: Address Feedback**

If changes requested:

```bash
# Make changes
git add .
git commit -m "address code review feedback

- Simplified validation logic
- Added better error messages
- Improved code comments"

# Push
git push origin feature/123-auth-system

# Notify reviewers in PR comments:
# "Ready for re-review, addressed all feedback"
```

### **Step 6: Merge**

Once 2 approvals received:

```bash
# On GitHub:
1. Click "Merge pull request"
2. Select "Create a merge commit"
3. Click "Confirm merge"
4. Delete branch (optional, GitHub offers)
```

**Local cleanup**:
```bash
git checkout develop
git pull origin develop
git branch -d feature/123-auth-system
```

---

## ✅ Code Review Checklist

### **For PR Author**

Before requesting review:
- [ ] Feature complete and tested
- [ ] Code formatted: `flutter format .`
- [ ] No lint errors: `flutter analyze`
- [ ] All tests passing: `flutter test`
- [ ] Meaningful commit messages
- [ ] No breaking changes
- [ ] No hardcoded values
- [ ] Error handling implemented
- [ ] Updated documentation
- [ ] Screenshot added (if UI change)

### **For Code Reviewers**

Check all items:

#### **Architecture & Design**
- [ ] Follows clean architecture principles
- [ ] Proper separation of concerns (UI/BLoC/Repository)
- [ ] Uses established patterns (BLoC, Repository)
- [ ] No code duplication (DRY principle)
- [ ] Efficient data structures/algorithms

#### **Code Quality**
- [ ] Code is readable and understandable
- [ ] Proper naming conventions (camelCase, PascalCase)
- [ ] Functions/methods reasonably sized
- [ ] Comments for complex logic
- [ ] No commented-out code
- [ ] No debug print statements

#### **Security**
- [ ] No hardcoded sensitive data
- [ ] Proper Firebase security rules
- [ ] Input validation
- [ ] SQL injection protection (if applicable)
- [ ] Authentication checks
- [ ] Authorization checks

#### **Performance**
- [ ] No unnecessary rebuilds (for widgets)
- [ ] Efficient database queries
- [ ] Proper use of const constructors
- [ ] Lazy loading where appropriate
- [ ] Image optimization
- [ ] No memory leaks

#### **Testing**
- [ ] Unit tests added/updated
- [ ] Widget tests for UI changes
- [ ] Edge cases covered
- [ ] Error handling tested
- [ ] Tests are meaningful (not just coverage)

#### **Error Handling**
- [ ] Try-catch blocks used
- [ ] User-friendly error messages
- [ ] Loading states handled
- [ ] Network errors handled
- [ ] Firebase errors handled
- [ ] No silent failures

#### **Documentation**
- [ ] Code comments where needed
- [ ] Docstrings for public methods
- [ ] README updated if needed
- [ ] Commit messages clear
- [ ] PR description complete

#### **Compatibility**
- [ ] Works on Android
- [ ] Works on iOS
- [ ] Works on Web
- [ ] No breaking changes
- [ ] Backward compatible

---

## 📝 Code Review Comments Template

### **When Requesting Changes**

```markdown
### Architecture Issue
This business logic should be in the BLoC, not the UI layer.

**Suggestion**:
Move the validation logic from login_screen.dart to auth_bloc.dart

**Why**: Keeps UI presentational, logic in BLoC

### Code Quality
This function is 50 lines long. Consider breaking it up.

**Suggestion**:
```dart
// Extract to separate method
void _validateEmail(String email) { ... }
void _validatePassword(String password) { ... }
```

### Potential Bug
What happens if the user cancels the image picker? This will crash.

**Suggestion**:
```dart
if (result != null) {
  // Process image
} else {
  // Show cancel message
}
```

### Performance Concern
Rebuilding this list every time is inefficient.

**Suggestion**:
Use `const` for items that don't change, or use `ListView.builder`

### Security Issue
Never hardcode API keys in the code!

**Suggestion**:
Move to `firebase_options.dart` or environment variables

### Nice to Have
This could be improved, but not required for merge.

**Optional**:
Consider adding loading skeleton for better UX
```

### **When Approving**

```markdown
Looks good! A few minor suggestions (not blocking):

- Consider extracting this to a helper function
- Good error handling 👍
- Tests are comprehensive

Approved ✅
```

---

## 🚫 Merge Requirements

**PR can ONLY be merged if**:

1. ✅ All automated checks pass
   - Format check: PASS
   - Lint analysis: PASS
   - Unit tests: PASS
   - Build: PASS

2. ✅ 2 approvals received
   - Primary reviewer: Approved
   - Secondary reviewer: Approved

3. ✅ No outstanding "Change Requests"
   - All feedback addressed
   - Reviewers re-approved

4. ✅ No merge conflicts
   - Branch is up-to-date with develop
   - No conflicting changes

5. ✅ Feature is complete
   - No "WIP" in title
   - All acceptance criteria met
   - Tested locally

---

## ⏱️ SLA (Service Level Agreement)

| Situation | Max Response Time | Owner |
|-----------|-------------------|-------|
| PR opened | 4 hours | Reviewer |
| Changes requested | 24 hours | Author |
| Re-review requested | 4 hours | Reviewer |
| Ready to merge | 2 hours | Tech Lead |

**Goal**: Merge PRs same day they're opened

---

## 👥 Reviewer Roles

### **Tech Lead (Person 1/2)**
- Architecture review
- Performance check
- Security audit
- Final approval

### **Team Member (Person 3/4)**
- Code style check
- Logic verification
- Testing validation
- Readability review

**Alternate structure**: Pair review
- One senior + one junior
- Knowledge sharing opportunity
- Better code quality

---

## 🎯 Code Review Best Practices

### **For Authors**

```
✅ DO:
✅ Request review when code is ready
✅ Respond to feedback respectfully
✅ Ask questions if feedback unclear
✅ Keep PRs small (<400 lines)
✅ Provide screenshots/video
✅ Test locally before requesting
✅ Rebase before opening PR

❌ DON'T:
❌ Request review for incomplete work
❌ Force push to develop
❌ Argue with reviewers
❌ Ignore feedback
❌ Make huge PRs
❌ Skip testing
```

### **For Reviewers**

```
✅ DO:
✅ Review within 4 hours
✅ Be respectful and constructive
✅ Explain the "why" not just "do this"
✅ Look for security issues
✅ Check performance
✅ Test the changes locally
✅ Approve if it's good

❌ DON'T:
❌ Delay reviews more than 4 hours
❌ Be rude or dismissive
❌ Request unnecessary changes
❌ Approve without testing
❌ Just skim the code
❌ Approve if you don't understand it
```

---

## 📊 Code Review Metrics

**Track these metrics**:

| Metric | Target | How to Track |
|--------|--------|--------------|
| Avg review time | < 4 hours | GitHub insights |
| Merge time | Same day | GitHub timeline |
| Approval rate | > 90% | PR statistics |
| Re-review rate | < 20% | PR comments |
| Rework rate | < 10% | "Change request" count |

---

## 🔗 Pull Request Template

**File**: `.github/pull_request_template.md`

```markdown
## Description
Brief description of what this PR does

## Type of Change
- [ ] New feature
- [ ] Bug fix
- [ ] Breaking change
- [ ] Documentation

## Related Issue
Closes #(issue number)

## Changes
- Change 1
- Change 2
- Change 3

## Testing Done
- [ ] Unit tests added/updated
- [ ] Widget tests added/updated
- [ ] Manual testing on Android
- [ ] Manual testing on iOS
- [ ] Manual testing on Web

## Screenshots/Videos
[If UI changed, add screenshots or videos]

## Checklist
- [ ] Code follows style guidelines
- [ ] No lint errors (`flutter analyze`)
- [ ] Tests pass (`flutter test`)
- [ ] Code formatted (`flutter format .`)
- [ ] Documentation updated
- [ ] No breaking changes

## Additional Notes
Any other context or notes

## Reviewers
@reviewer1 @reviewer2
```

---

## 🚨 Emergency/Hotfix Review

**For critical production bugs (hotfix)**:

### **Fast-track review**:
- 1 approval only (instead of 2)
- Tech lead approval required
- Created against `main` branch
- Merged to both `main` and `develop`

### **Process**:
```
1. Create hotfix/issue-description
2. Create PR to main (not develop)
3. Request tech lead review (URGENT in Slack)
4. Tech lead reviews within 1 hour
5. Merge to main
6. Create PR from main to develop
7. Merge to develop
8. Alert monitoring for deployment
```

---

## 📞 Questions?

Ask in Slack: `#roast-ritual-team`

