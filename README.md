# 🍽️ CampusBite - Canteen Food Ordering System Mobile App

A modern, responsive, full-featured Canteen Food Ordering System mobile application built with **Flutter**, **Dart**, **Material 3**, and **Firebase**. 

Designed specifically for college campuses, schools, and corporate cafeterias to streamline food discovery, queue-less ordering, quick payments, and live kitchen tracking.

---

## 📱 Features Overview

### 👥 Dual User Roles
1. **Student / Customer:**
   - Browse canteen menu by category (Breakfast, Lunch, Snacks, Beverages, Fast Food, Desserts)
   - Real-time search with instant text filtering
   - Price and availability filters (show in-stock only)
   - Detailed food screen with preparation times, ratings, and special kitchen instructions
   - Shopping cart with promo/discount coupon support (`WELCOME10`, `CAMPUS20`)
   - Flexible checkout: **Pay at Counter** or **Mock Online Payment**
   - Live order tracking with progress stepper (Placed → Accepted → Preparing → Ready for Pickup → Completed)
   - Order history with reorder capabilities
   - Profile management with Dark/Light theme toggle & Push notifications preference

2. **Canteen Staff / Admin:**
   - Comprehensive dashboard showing today's revenue, active kitchen orders, completed orders, and food items
   - Food menu manager: Add, edit, delete dishes, update prices, change prep times, and toggle in-stock availability instantly
   - Category management: Create and organize canteen food categories
   - Live incoming orders monitor with 1-tap status transition buttons (*Accept* → *Start Cooking* → *Ready for Pickup* → *Mark Completed*)
   - Destructive order cancellation with confirmation modals
   - Access to customer phone numbers and special dietary notes

---

## 🏗️ Architecture & Project Structure

The project strictly adheres to clean architecture principles separating presentation, business logic, data models, and services:

```
canteen_food_ordering_app/
├── assets/
│   ├── icons/
│   └── images/
├── firestore.rules               # Production-grade Firestore role-based security rules
├── pubspec.yaml                  # Dependencies and app metadata
├── README.md                     # Documentation & setup guide
└── lib/
    ├── core/
    │   ├── constants/
    │   │   ├── app_colors.dart       # Material 3 color palette (Orange, Crimson, Amber)
    │   │   ├── app_constants.dart    # Roles, Order statuses, coupons, tax rates
    │   │   └── app_text_styles.dart  # Typography definitions
    │   ├── theme/
    │   │   └── app_theme.dart        # Material 3 Light & Dark themes
    │   ├── utils/
    │   │   ├── formatters.dart       # Currency, date-time, order ID formatters
    │   │   ├── validators.dart       # Form validation logic
    │   │   └── notification_helper.dart # Floating snackbars & confirmation dialogs
    │   └── widgets/
    │       ├── custom_button.dart    # Buttons with loading states
    │       ├── custom_text_field.dart# Styled input with password visibility toggles
    │       ├── food_card.dart        # Responsive vertical and horizontal food cards
    │       ├── category_card.dart    # Animated category selection pills
    │       ├── cart_item_tile.dart   # Cart row with quantity controls
    │       ├── order_card.dart       # Order summary card with status badges
    │       ├── quantity_selector.dart# Increment/decrement controls
    │       ├── status_badge.dart     # Color-coded badges for order lifecycle
    │       ├── loading_widget.dart   # Loading indicator
    │       ├── empty_state_widget.dart # Friendly empty states
    │       └── error_state_widget.dart # Error recovery card
    ├── models/
    │   ├── user_model.dart           # Customer & Admin model
    │   ├── category_model.dart       # Food category model
    │   ├── food_item_model.dart      # Menu food dish model
    │   ├── cart_item_model.dart      # Cart line item model
    │   └── order_model.dart          # Full order and order item models
    ├── services/
    │   ├── sample_data.dart          # Preloaded realistic canteen menu & test users
    │   ├── auth_service.dart         # Firebase Auth + Local fallback session
    │   ├── firestore_service.dart    # Cloud Firestore CRUD & reactive streams
    │   ├── storage_service.dart      # Firebase Storage handler
    │   ├── notification_service.dart # FCM & in-app live status broadcaster
    │   └── payment_service.dart      # Payment gateway abstraction (Cash & Online)
    ├── repositories/
    │   ├── auth_repository.dart
    │   ├── food_repository.dart
    │   └── order_repository.dart
    ├── providers/
    │   ├── auth_provider.dart        # User session & authentication state
    │   ├── food_provider.dart        # Food menu, categories & dynamic filtering
    │   ├── cart_provider.dart        # Cart totals, item quantities & promo codes
    │   ├── order_provider.dart       # Order placement & active tracking
    │   ├── admin_provider.dart       # Kitchen dashboard analytics & admin controls
    │   └── theme_provider.dart       # Dark/Light theme & local settings persistence
    ├── routes/
    │   └── app_router.dart           # Declarative GoRouter with role-based guards
    ├── firebase_options.dart         # FlutterFire options template
    └── main.dart                     # App entry point with MultiProvider setup
```

---

## 🚀 Quick Start & Instant Testing (Zero Setup Required)

The application includes an **intelligent fallback mode**: If Firebase is not yet linked to Google Cloud, the app automatically runs in a fully functional **Standalone Interactive Demo Mode**! All operations (login, registration, menu browsing, search, cart, checkout, payment simulation, and admin order fulfillment) work smoothly out of the box.

### 🔑 Test Credentials (Included on the Login Screen with 1-Tap Buttons)
| Role | Email | Password |
|---|---|---|
| **Canteen Admin / Staff** | `admin@canteen.com` | `admin123` |
| **Student / Customer** | `student@campus.edu` | `student123` |

You can also register a brand new account and select either **Customer** or **Staff / Admin** on the registration screen.

---

## 🛠️ Step-by-Step Firebase Integration

When you are ready to link the app to your production Firebase project:

### 1. Install FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
```

### 2. Configure Firebase in the Project
Run the following command inside `canteen_food_ordering_app/`:
```bash
flutterfire configure
```
Select your Firebase project and platforms (Android, iOS, Web, macOS, Windows). This will overwrite `lib/firebase_options.dart` with your active API keys.

### 3. Enable Firebase Services in the Firebase Console
1. **Authentication:**
   - Enable **Email/Password** sign-in provider.
2. **Cloud Firestore:**
   - Create a Firestore database in your preferred region.
   - Deploy `firestore.rules` using the Firebase CLI:
     ```bash
     firebase deploy --only firestore:rules
     ```
3. **Firebase Storage:**
   - Enable default storage bucket for food item and profile photo uploads.
4. **Cloud Messaging (FCM):**
   - Enable Cloud Messaging for push notifications on Android & iOS.

---

## 💳 Payment Gateway Abstraction

The payment system is designed using the **Strategy Pattern** via `PaymentGateway` and `PaymentService` (`lib/services/payment_service.dart`):

```dart
abstract class PaymentGateway {
  Future<PaymentResult> processPayment({
    required double amount,
    required String orderId,
    required String customerName,
    Map<String, dynamic>? extraData,
  });
}
```

To integrate a real gateway like **Stripe**, **Razorpay**, or **Square**, simply implement `PaymentGateway` and register it with `PaymentService`:

```dart
class StripePaymentGateway implements PaymentGateway {
  @override
  Future<PaymentResult> processPayment({...}) async {
    // Call Stripe SDK / backend PaymentIntent
  }
}

// In main.dart or bootstrap:
PaymentService().registerGateway('Stripe', StripePaymentGateway());
```

---

## 🔒 Security Highlights
- **Role-Based Routing:** GoRouter automatically intercepts navigation. Non-admin users attempting to open `/admin/*` routes are redirected to `/home`.
- **Firestore Security Rules:** `firestore.rules` prevents customers from tampering with prices, altering food menu items, or modifying other users' orders.
- **Zero Card Data Stored:** Sensitive card numbers or CVVs are never written to Firestore.

---

## 📦 How to Run the App
```bash
# Get dependencies
flutter pub get

# Run on your emulator, browser, or connected physical device
flutter run
```
