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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCX7_nq34NeYzVYIQbjjuub08PvYJgcS0s',
    appId: '1:206589950338:web:21a60c0d2ad0a25e93f79b',
    messagingSenderId: '206589950338',
    projectId: 'mons-finance-game-dev',
    authDomain: 'mons-finance-game-dev.firebaseapp.com',
    storageBucket: 'mons-finance-game-dev.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAXTOq34a1U-jSVdSmUbHRgWucq1AedFGs',
    appId: '1:206589950338:android:6dfae0c90a51fb3893f79b',
    messagingSenderId: '206589950338',
    projectId: 'mons-finance-game-dev',
    storageBucket: 'mons-finance-game-dev.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCXE2QjRgKJtLPHGDC7UoW9QxmexhBcCBk',
    appId: '1:206589950338:ios:8c7b1e53d917920f93f79b',
    messagingSenderId: '206589950338',
    projectId: 'mons-finance-game-dev',
    storageBucket: 'mons-finance-game-dev.firebasestorage.app',
    iosBundleId: 'com.verygoodventures.superDash',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCXE2QjRgKJtLPHGDC7UoW9QxmexhBcCBk',
    appId: '1:206589950338:ios:de0b7e3f48cb994693f79b',
    messagingSenderId: '206589950338',
    projectId: 'mons-finance-game-dev',
    storageBucket: 'mons-finance-game-dev.firebasestorage.app',
    iosBundleId: 'com.example.dashRun',
  );
}
