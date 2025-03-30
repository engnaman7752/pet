// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA5TKyvtPXfh6JRbSRwDgKj3kOt99xbf4A',
    appId: '1:290596072455:web:2e60da530574d6f2048ea2',
    messagingSenderId: '290596072455',
    projectId: 'myfirst-f4d70',
    authDomain: 'myfirst-f4d70.firebaseapp.com',
    storageBucket: 'myfirst-f4d70.firebasestorage.app',
    measurementId: 'G-1HPFDJNDNQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAGguITQT7OpSXf7-ZBSU2buWEXYqighNc',
    appId: '1:290596072455:android:958b100ee8239e94048ea2',
    messagingSenderId: '290596072455',
    projectId: 'myfirst-f4d70',
    storageBucket: 'myfirst-f4d70.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBik7bGsyBy-0GU_TYDTPVWFZn8YjJD06s',
    appId: '1:290596072455:ios:13eb8d3801139ecc048ea2',
    messagingSenderId: '290596072455',
    projectId: 'myfirst-f4d70',
    storageBucket: 'myfirst-f4d70.firebasestorage.app',
    iosBundleId: 'com.example.pet',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBik7bGsyBy-0GU_TYDTPVWFZn8YjJD06s',
    appId: '1:290596072455:ios:13eb8d3801139ecc048ea2',
    messagingSenderId: '290596072455',
    projectId: 'myfirst-f4d70',
    storageBucket: 'myfirst-f4d70.firebasestorage.app',
    iosBundleId: 'com.example.pet',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA5TKyvtPXfh6JRbSRwDgKj3kOt99xbf4A',
    appId: '1:290596072455:web:c722e2277d5869b5048ea2',
    messagingSenderId: '290596072455',
    projectId: 'myfirst-f4d70',
    authDomain: 'myfirst-f4d70.firebaseapp.com',
    storageBucket: 'myfirst-f4d70.firebasestorage.app',
    measurementId: 'G-BV9QPDVFXQ',
  );
}
