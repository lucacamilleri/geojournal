// Importing the necessary packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

// Assigning Firebase options for different platforms
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      return ios;
    } else {
      return android;
    }
  }

  // Defining the Firebase options for Android
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: 'YOUR_ANDROID_APP_ID',
    messagingSenderId: 'YOUR_ANDROID_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    databaseURL:
        'https://flutter-b897f-default-rtdb.europe-west1.firebasedatabase.app/',
    storageBucket: 'YOUR_STORAGE_BUCKET',
  );

    // Defining the Firebase options for IOS
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_IOS_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    databaseURL:
        'https://flutter-b897f-default-rtdb.europe-west1.firebasedatabase.app/',
    storageBucket: 'YOUR_STORAGE_BUCKET',
  );
}
