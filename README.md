# Flutter Lab Sheet 10

Firebase Authentication and Cloud Firestore — 15 programs.

## Packages
- firebase_core
- firebase_auth
- cloud_firestore

## Quick run
This repository uses Firebase's supported `demoProjectId` initialization so every file is self-contained and compiles without a generated `firebase_options.dart`.

```bash
flutter pub get
flutter run -d chrome -t lib/program_01.dart
```

Change `01` through `15` for the remaining programs.

## For live Firebase Authentication and Cloud Firestore
Create/select a Firebase project, enable **Email/Password Authentication** and **Cloud Firestore**, then run:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

FlutterFire generates `lib/firebase_options.dart`. Replace the demo initializer in `lib/firebase_setup.dart` with:

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

and import `firebase_options.dart`.

> Authentication/Firestore write operations need either a real configured Firebase project or the Firebase Emulator Suite.
