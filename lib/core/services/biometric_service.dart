import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

/// Wraps local_auth for fingerprint / face ID authentication.
///
/// Setup in pubspec.yaml:
///   dependencies:
///     local_auth: ^2.3.0
///
/// Android — add to android/app/src/main/AndroidManifest.xml:
///   <uses-permission android:name="android.permission.USE_BIOMETRIC"/>
///   Change FlutterActivity → FlutterFragmentActivity in MainActivity.kt
///
/// iOS — add to ios/Runner/Info.plist:
///   <key>NSFaceIDUsageDescription</key>
///   <string>ProFinch Bank uses Face ID for secure quick login</string>
class BiometricService {
  BiometricService._();
  static final BiometricService instance = BiometricService._();

  final LocalAuthentication _auth = LocalAuthentication();

  /// Returns true if the device supports biometrics AND has enrolled credentials.
  Future<bool> isAvailable() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isDeviceSupported = await _auth.isDeviceSupported();
      if (!canCheck || !isDeviceSupported) return false;

      final enrolled = await _auth.getAvailableBiometrics();
      return enrolled.isNotEmpty;
    } on PlatformException {
      return false;
    }
  }

  /// Returns the type of biometric available on the device.
  Future<BiometricType?> availableType() async {
    try {
      final enrolled = await _auth.getAvailableBiometrics();
      if (enrolled.contains(BiometricType.face)) return BiometricType.face;
      if (enrolled.contains(BiometricType.fingerprint)) return BiometricType.fingerprint;
      return null;
    } on PlatformException {
      return null;
    }
  }

  /// Prompts the user to authenticate.
  /// Returns true on success, false on failure or cancellation.
  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Authenticate to access ProFinch Bank',
        options: const AuthenticationOptions(
          biometricOnly: false,   // allow device PIN as fallback
          stickyAuth: true,       // keeps prompt alive if app goes background
          useErrorDialogs: true,
        ),
      );
    } on PlatformException catch (e) {
      // Common errors:
      // NotAvailable   — biometrics not set up on device
      // NotEnrolled    — no biometrics registered
      // LockedOut      — too many failed attempts
      // PermanentlyLockedOut — device requires PIN/password to unlock
      debugPrint('BiometricService error: ${e.code} — ${e.message}');
      return false;
    }
  }
}

// ignore: avoid_print
void debugPrint(String s) => print(s);