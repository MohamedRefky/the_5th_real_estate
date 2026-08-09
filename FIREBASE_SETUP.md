# Firebase Setup Checklist — The 5th Real Estate (Admin Dashboard)

The **public website** renders from bundled local data — it works with **no**
Firebase and needs nothing from you.

The **hidden admin dashboard** (`/admin/login`, `/admin/dashboard`) needs a
Firebase project. Do these steps once, in order:

## 1. Create the Firebase project
- Go to <https://console.firebase.google.com> → **Add project** (e.g. `the-5th-real-estate`).
- Add a **Web app** to the project (the Flutter web build uses web platform options).

## 2. Generate `lib/firebase_options.dart`
The repo ships a placeholder that shows a friendly "Firebase is not configured"
message. Generate real config with the FlutterFire CLI:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Pick the web platform and your project. This **overwrites**
`lib/firebase_options.dart` with real keys. Commit the generated file.

## 3. Enable Email/Password auth
Firebase console → **Authentication → Sign-in method** → enable **Email/Password**.

## 4. Create the single admin user
Firebase console → **Authentication → Users → Add user**. Pick a strong
password. Copy the **User UID** of that account.

## 5. Paste the admin UID into the rules
In `firestore.rules` and `storage.rules`, replace `PASTE_YOUR_ADMIN_UID` with
the UID from step 4 (both files). Deploy the rules:

```bash
firebase login
firebase deploy --only firestore:rules,storage:rules
```

> The rules are the **only** security boundary (there is no backend). Every
> read and write to the `properties` collection and `properties/` storage
> paths is locked to the single admin UID.

## 6. Run and test
```bash
flutter run -d chrome
```
Then type the hidden URLs directly in the browser (no public links exist):
- `/admin/login` — sign in with the admin account
- `/admin/dashboard` — add / edit / delete / publish–unpublish properties

Signed-out visitors who type `/admin/dashboard` are redirected to `/admin/login`.

## How it works
- `AuthController` listens to `authStateChanges` and notifies the route guard.
- `AdminRouteGuard` redirects anonymous visitors to login; the real gate is
  the rules, so the UI guard is convenience, not security.
- `PropertyService` is the only class touching Firestore/Storage; the form
  screen uploads picked images and stores their download URLs in the document.
- Each floor of a multi-floor building is a **separate document**; the admin
  adds one listing per floor.
