# Firebase Setup Guide for Task Management App

This guide will help you set up Firebase for your Flutter Task Management app.

---

## Step 1: Get Firebase Configuration File

### Option A: Using Firebase CLI (Recommended)

1. **Install Firebase CLI** (if not already installed):
   
```
bash
   npm install -g firebase-tools
   
```

2. **Login to Firebase**:
   
```
bash
   firebase login
   
```

3. **Download configuration**:
   - Go to: https://studio.firebase.google.com/u/0/taskmanagement-23330016
   - Click on **Project Settings** (gear icon ⚙️)
   - Under "Your apps", click the Android icon (or add a new app)
   - Download `google-services.json`

### Option B: Manual Download

1. Go to: https://studio.firebase.google.com/u/0/taskmanagement-23330016
2. Click **Project Settings** (gear icon ⚙️)
3. Scroll down to "Your apps"
4. Click **Add app** → select Android icon (📱)
5. Register app with:
   - **Android package name**: `com.example.task_management`
6. Download `google-services.json`

---

## Step 2: Place Configuration File

Move the downloaded `google-services.json` to:
```
D:\TaskManagement\android\app\google-services.json
```

---

## Step 3: Configure Android for Firebase

### Edit `android/app/build.gradle.kts`

Find the file at: `android/app/build.gradle.kts`

Add this plugin at the **TOP** of the file (after other plugins):
```
kotlin
plugins {
    id("com.google.gms.google-services")
}
```

### Edit `android/build.gradle.kts`

Find the file at: `android/build.gradle.kts`

Add this in the `dependencies` section:
```
kotlin
classpath("com.google.gms:google-services:4.4.0")
```

---

## Step 4: Enable Firebase Services

In your Firebase Console (https://studio.firebase.google.com/u/0/taskmanagement-23330016):

### Enable Authentication:
1. Go to **Build** → **Authentication**
2. Click **Get Started**
3. Enable **Email/Password** sign-in method

### Enable Firestore Database:
1. Go to **Build** → **Firestore Database**
2. Click **Create Database**
3. Select **Start in test mode** (allows read/write for development)

---

## Step 5: Add Firebase Dependencies

Update `pubspec.yaml` to add Firebase packages:

```
yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^3.8.1
  cloud_firestore: ^5.6.0
  firebase_auth: ^5.3.4
```

Then run:
```
bash
flutter pub get
```

---

## Step 6: Initialize Firebase in Flutter

Update `lib/main.dart` to initialize Firebase:

```
dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'providers/theme_provider.dart';
import 'providers/user_session_provider.dart';
import 'core/routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserSessionProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
```

---

## Step 7: Test the Connection

Run your app:
```
bash
flutter run
```

---

## Troubleshooting

### If you get "Package not found" error:
- Make sure `google-services.json` is in the correct location
- Check that the package name matches: `com.example.task_management`

### If you get "Default FirebaseApp not initialized":
- Make sure `Firebase.initializeApp()` is called before `runApp()`

---

## API Endpoints (For Postman Testing)

Once Firebase is connected, you can test these endpoints:

**Base URL:** Your Firebase project URL (found in Project Settings)

**Firestore Collections:**
- `users` - User data
- `tasks` - Task data

**REST API (via Firebase REST API):**
```
POST https://firestore.googleapis.com/v1/projects/YOUR_PROJECT_ID/databases/(default)/documents/tasks
```

---

## Need Help?

If you need any clarification or help with a specific step, please let me know!
