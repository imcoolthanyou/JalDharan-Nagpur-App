/*
╔════════════════════════════════════════════════════════════════════════════╗
║                    GOOGLE SIGN IN TROUBLESHOOTING GUIDE                    ║
║                          For Jal Dharan App                                ║
╚════════════════════════════════════════════════════════════════════════════╝

ERROR: Platform Exception sign in failed

ROOT CAUSE:
The "sign_in_failed" error happens when there's a mismatch between:
1. The SHA1 certificate hash in your Android app
2. The SHA1 certificate hash registered in Google Firebase Console

═══════════════════════════════════════════════════════════════════════════════

SOLUTION STEPS:

STEP 1: GET YOUR ACTUAL SHA1 CERTIFICATE HASH
─────────────────────────────────────────────

Open Terminal in Android Studio or PowerShell and run:

Windows (PowerShell):
  cd C:\Users\hmsga\AndroidStudioProjects\jal_dharan
  .\android\gradlew.bat signingReport

Or run from Android folder:
  cd android
  .\gradlew signingReport

Expected Output:
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  APK debugKeystore:
    SHA1: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX

  Look for the SHA1 value (it will be 40 characters like):
  Example: d51b24db5e0b1a0fa96793b6615026afde262b81

STEP 2: UPDATE FIREBASE CONSOLE
─────────────────────────────────

1. Go to: https://console.firebase.google.com
2. Select Project: "jaldharan"
3. Click "Project Settings" (gear icon, top left)
4. Click "Apps" tab
5. Click on "jal_dharan" Android app
6. Scroll down to "SHA certificate fingerprints"
7. Click "Add fingerprint"
8. Paste the SHA1 you got from STEP 1 (without colons)
   Example: d51b24db5e0b1a0fa96793b6615026afde262b81
9. Click "Save"
10. Download the updated google-services.json file

STEP 3: REPLACE google-services.json
──────────────────────────────────────

1. Download the google-services.json from Firebase Console
2. Copy it to: C:\Users\hmsga\AndroidStudioProjects\jal_dharan\android\app\
3. Replace the existing google-services.json file

STEP 4: CLEAN AND REBUILD
──────────────────────────

Run these commands:

  cd C:\Users\hmsga\AndroidStudioProjects\jal_dharan
  flutter clean
  flutter pub get
  flutter run

═══════════════════════════════════════════════════════════════════════════════

ADDITIONAL CHECKS:

✓ Verify your package name matches:
  - Expected: com.litsquad.projects.jal_dharan
  - Check in: android/app/build.gradle.kts
  - Line: applicationId = "com.litsquad.projects.jal_dharan"

✓ Verify AndroidManifest.xml has permissions:
  - ✓ <uses-permission android:name="android.permission.INTERNET" />
  - ✓ <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />

✓ Verify build.gradle.kts has Google Services plugin:
  - ✓ id("com.google.gms.google-services")

✓ Check Firebase is initialized in main.dart:
  - ✓ await Firebase.initializeApp();

═══════════════════════════════════════════════════════════════════════════════

DEBUG OUTPUT:

When you try to sign in with Google, watch the Flutter console for output like:

  === Google Sign In Debug Info ===
  Platform: Android
  Is signed in: false
  Current account: None
  Firebase user: None
  ================================

This indicates the setup was logged properly.

═══════════════════════════════════════════════════════════════════════════════

COMMON ISSUES & SOLUTIONS:

Issue: SHA1 hash still doesn't work
→ Solution: Make sure to use the debug.keystore SHA1 for development
           Use release.keystore SHA1 when building for production

Issue: "Operation not allowed" error
→ Solution: Google Sign In might be disabled in Firebase Console
           Go to Firebase > Authentication > Sign-in methods
           Enable "Google"

Issue: "Client ID mismatch"
→ Solution: Make sure google-services.json was updated and
           contains your app's package name and SHA1

Issue: App still crashes after updating SHA1
→ Solution: 1. Run: flutter clean
           2. Delete android/.gradle folder
           3. Delete build/ folder
           4. Run: flutter pub get
           5. Run: flutter run

═══════════════════════════════════════════════════════════════════════════════

TESTING:

After completing all steps:
1. Clear app data: Settings > Apps > Jal Dharan > Clear Storage
2. Run the app
3. Go to Login screen
4. Click Google Sign In button
5. Select your Google account
6. You should be redirected to home screen

═══════════════════════════════════════════════════════════════════════════════

Need more help? Check Firebase docs:
https://firebase.google.com/docs/auth/android/google-signin

*/
