# 🎬 Live Demo Script - Week 4 Presentation

## Demo Duration: 20 minutes
## Presenter: Person 3 (Demo & QA Lead)
## Goal: Show working, functional application with key features

---

## 📋 PRE-DEMO CHECKLIST (30 min before)

- [ ] Test app on emulator/device (full start-to-finish)
- [ ] Verify all features work
- [ ] Check Firebase connection (should show in console)
- [ ] Load test data in Firestore
- [ ] Close all other apps (free up device memory)
- [ ] Set device to airplane mode if needed (prevent notifications)
- [ ] Turn off auto-lock on device
- [ ] Full battery or plugged in
- [ ] Record backup demo video (in case live fails)
- [ ] Test projector/screen sharing
- [ ] Clear browser history/cache
- [ ] Have a backup device ready

---

## 🎯 DEMO FLOW (20 minutes)

### **SEGMENT 1: APP STARTUP & AUTHENTICATION (3 minutes)**

**What to show**:
```
1. [0:00-0:15] Cold Start
   ├─ Show terminal: flutter run
   ├─ App launches
   ├─ Splash screen displays
   └─ Loading indicator shows briefly

2. [0:15-0:45] Login Screen
   ├─ Show professional login UI
   ├─ Display email field placeholder
   ├─ Display password field (masked)
   ├─ Show "Forgot Password" link
   ├─ Show "Sign Up" link

3. [0:45-1:30] Firebase Authentication
   ├─ Enter demo email: guest@roastritual.app
   ├─ Enter demo password: Coffee@123
   ├─ Tap "Sign In" button
   ├─ Show loading indicator
   ├─ Verify Firebase Auth working (check console)
   └─ Navigate to home screen

4. [1:30-3:00] Home Screen
   ├─ Show welcome message: "Welcome, Guest!"
   ├─ Display user profile icon
   ├─ Show bottom navigation (Home, Search, Cart, Profile)
   └─ Explain app layout
```

**Key Points to Mention**:
- "Firebase Authentication is working in real-time"
- "User data is persisted securely"
- "Session will remain even if app is closed"

---

### **SEGMENT 2: BROWSE COFFEE MENU (3 minutes)**

**What to show**:
```
1. [3:00-3:30] Coffee List Screen
   ├─ Show list of coffees loading
   ├─ Scroll through 10+ coffee items
   ├─ Show each item: image, name, price, rating
   ├─ Each coffee card is tappable
   └─ Explain real-time Firestore data loading

2. [3:30-4:00] Coffee Detail View
   ├─ Tap on a coffee (e.g., "Espresso Đen")
   ├─ Show beautiful detail screen:
   │  ├─ Large coffee image
   │  ├─ Coffee name
   │  ├─ Price (e.g., ₫35,000)
   │  ├─ Description
   │  ├─ Rating (e.g., 4.5/5 with reviews)
   │  ├─ Size options (S/M/L)
   │  ├─ Add to cart button
   │  └─ Back button
   └─ Explain product information display

3. [4:00-4:30] Search/Filter (if implemented)
   ├─ Go back to list
   ├─ Tap search icon
   ├─ Type coffee name: "cappuccino"
   ├─ Show filtered results
   ├─ Clear search
   └─ Explain real-time search functionality
```

**Key Points to Mention**:
- "All data loads from Firebase Firestore in real-time"
- "Search is instant and responsive"
- "Images are optimized for fast loading"
- "Product information is complete and professional"

---

### **SEGMENT 3: SHOPPING CART (3 minutes)**

**What to show**:
```
1. [4:30-5:00] Add to Cart
   ├─ Go back to coffee detail
   ├─ Select size (Medium)
   ├─ Tap "Add to Cart" button
   ├─ Show toast notification: "Added to cart"
   └─ Verify cart badge updates

2. [5:00-5:30] Cart Screen
   ├─ Tap cart icon in bottom nav
   ├─ Show added coffee in cart
   ├─ Display:
   │  ├─ Coffee image & name
   │  ├─ Size selected
   │  ├─ Price
   │  ├─ Quantity spinner (+/-)
   │  └─ Subtotal
   ├─ Show subtotal, tax, total
   └─ Explain price calculation

3. [5:30-6:00] Cart Management
   ├─ Increase quantity (tap + button)
   ├─ Show total updates dynamically
   ├─ Add another coffee to cart
   ├─ Show multiple items
   ├─ Remove an item (swipe or delete button)
   ├─ Verify cart updates
   └─ Explain local storage persistence
```

**Key Points to Mention**:
- "Cart data is saved locally using SharedPreferences"
- "Quantities and totals calculate automatically"
- "Cart persists even if app is closed"
- "Professional layout with clear pricing"

---

### **SEGMENT 4: CHECKOUT & ORDER PLACEMENT (3 minutes)**

**What to show**:
```
1. [6:00-6:30] Checkout Flow
   ├─ Tap "Checkout" or "Order Now" button
   ├─ Show order review screen:
   │  ├─ All items listed
   │  ├─ Quantities confirmed
   │  ├─ Total amount shown
   │  ├─ Delivery address field
   │  └─ Delivery instructions (optional)
   ├─ Enter demo address: "123 Nguyen Hue, HCMC"
   └─ Proceed to next step

2. [6:30-7:00] Payment Method Selection (if implemented)
   ├─ Show payment method options:
   │  ├─ Credit/Debit Card
   │  ├─ Mobile Wallet
   │  ├─ Cash on Delivery
   │  └─ Choose: Cash on Delivery
   └─ Proceed to confirm

3. [7:00-7:30] Order Confirmation
   ├─ Tap "Confirm Order" button
   ├─ Show loading indicator
   ├─ Order success screen:
   │  ├─ Order number: ORD-123456
   │  ├─ Order total: ₫XX,XXX
   │  ├─ Estimated delivery time: 30 mins
   │  ├─ Confirmation message
   │  └─ "Track Order" button
   ├─ Verify order created in Firestore
   └─ Explain successful order submission
```

**Key Points to Mention**:
- "Order data is saved to Firebase Firestore in real-time"
- "Order confirmation is instant"
- "Customer receives order number immediately"
- "Backend can see order appear in real-time"

---

### **SEGMENT 5: ORDER HISTORY & TRACKING (2 minutes)**

**What to show**:
```
1. [7:30-8:15] Order History
   ├─ Navigate to Profile tab
   ├─ Tap "My Orders" or go to order list
   ├─ Show all past orders:
   │  ├─ Recent order at top
   │  ├─ Previous orders below
   │  ├─ Each order shows:
   │  │  ├─ Order ID
   │  │  ├─ Order date & time
   │  │  ├─ Total amount
   │  │  └─ Current status (Completed/Pending)
   └─ Scroll through multiple orders

2. [8:15-8:45] Order Details
   ├─ Tap on the order we just created
   ├─ Show full order details:
   │  ├─ Order items with quantities
   │  ├─ Item prices
   │  ├─ Subtotal, tax, total
   │  ├─ Delivery address
   │  ├─ Order status
   │  ├─ Timestamp
   │  └─ Order tracking info
   └─ Explain real-time status updates
```

**Key Points to Mention**:
- "All orders synced in real-time from Firestore"
- "Order history persists across app sessions"
- "Customers can track their orders anytime"

---

### **SEGMENT 6: ADMIN DASHBOARD DEMO (Optional, 2 minutes)**

**If time permits, show admin app**:
```
1. [8:45-9:15] Switch to Admin App
   ├─ Close customer app
   ├─ Open coffee_admin app
   ├─ Login: admin@roastritual.app / Admin@123
   └─ Navigate to dashboard

2. [9:15-9:45] Admin Dashboard
   ├─ Show statistics:
   │  ├─ Total orders: X
   │  ├─ Daily revenue: ₫XX,XXX
   │  ├─ Active orders: X
   │  └─ Popular items: [list]
   ├─ Show "New Order" appeared in real-time
   ├─ Click order to view details
   ├─ Update status: Pending → Ready
   └─ Show status syncs back to customer app
```

**Key Points**:
- "Admin sees new orders in real-time"
- "Order status updates sync instantly"

---

### **SEGMENT 7: TECHNICAL HIGHLIGHTS (2 minutes)**

**Show developers what's working**:
```
1. [9:45-10:00] Firebase Integration
   ├─ Open DevTools or console
   ├─ Show Firestore data being read in real-time
   ├─ Show network requests
   └─ Explain Firebase features used:
      ├─ Firestore real-time database
      ├─ Firebase Auth
      ├─ Data persistence

2. [10:00-10:15] UI/UX Features
   ├─ Show smooth animations
   ├─ Show responsive design
   ├─ Show error handling (trigger error if possible)
   ├─ Show loading states
   └─ Explain user experience features

3. [10:15-10:30] Code Architecture
   ├─ Mention BLoC pattern used
   ├─ Explain Repository pattern
   ├─ Show multi-platform support:
   │  ├─ Android: ✅
   │  ├─ iOS: ✅
   │  ├─ Web: ✅
   │  ├─ Windows/macOS/Linux: ✅
   └─ Explain clean architecture approach
```

---

## 💡 TALKING POINTS

**During Demo**:

```
Opening:
"Today I'll show you Roast & Ritual, a complete coffee management 
system with customer-facing and admin applications."

Features Summary:
"The system has two main apps: coffee_app for customers and 
coffee_admin for staff management, both powered by Firebase."

Highlight Key Features:
1. Real-time authentication and user management
2. Live coffee menu with detailed product information
3. Functional shopping cart with persistent storage
4. Complete order management workflow
5. Real-time data synchronization across all platforms
6. Professional UI/UX with proper error handling
7. Secure Firebase integration

Data Flow:
"When a customer places an order, it's immediately saved to 
Firebase Firestore, and the admin sees it in real-time. When the 
admin updates the order status, the customer sees it instantly."

Closing:
"The app is fully functional with real data, proper authentication,
and complete order-to-delivery workflow. Everything syncs in 
real-time across all platforms using Firebase."
```

---

## 🚨 CONTINGENCY PLANS

### **If emulator/device crashes**:
```
1. Alt device: Have backup phone/emulator ready
2. Video backup: Play pre-recorded demo video
3. Screenshots: Show key feature screenshots
4. Proceed to next segment
```

### **If Firebase connection fails**:
```
1. App has offline fallback
2. Show local data mode working
3. Say: "App gracefully handles network issues"
4. Restart Firebase if possible
```

### **If specific feature crashes**:
```
1. Skip that feature
2. Move to next feature
3. Say: "This feature is in testing phase"
4. Continue with working features
```

### **If app won't start**:
```
1. Play backup demo video
2. Show screenshots
3. Discuss architecture instead
4. Show code on screen
```

---

## 📊 LIVE DEMO CHECKLIST (Day of Presentation)

**1 Hour Before**:
- [ ] Test all features one more time
- [ ] Clear app cache if needed: `flutter clean`
- [ ] Rebuild app: `flutter run`
- [ ] Verify Firebase connection
- [ ] Check device battery/power
- [ ] Close all background apps
- [ ] Test projector/screen sharing
- [ ] Have backup video ready

**30 Minutes Before**:
- [ ] Do complete demo run-through
- [ ] Time each segment
- [ ] Verify all features work
- [ ] Take screenshots for backup

**10 Minutes Before**:
- [ ] Position device/camera optimally
- [ ] Test audio (if recording)
- [ ] Load app and get to home screen
- [ ] Have backup plan ready
- [ ] Deep breaths, you got this! 💪

**During Demo**:
- [ ] Speak clearly and not too fast
- [ ] Show one feature at a time
- [ ] Let app respond (don't tap too fast)
- [ ] Point out key details
- [ ] Ask for questions at end

---

## 📈 Success Metrics

**Demo is successful if**:
- ✅ App runs without crashing
- ✅ All major features work
- ✅ Real data loads and displays
- ✅ Firebase syncing visible
- ✅ UI looks professional
- ✅ Audience understands features
- ✅ Demo stays on schedule (20 min)
- ✅ Audience asks questions (good sign!)

---

## 📝 POST-DEMO

**After presentation**:
- [ ] Thank audience
- [ ] Ask for feedback
- [ ] Note any questions
- [ ] Share demo video if available
- [ ] Update any found issues as bugs

---

**You're ready! Let's show them what we've built! 🚀**

