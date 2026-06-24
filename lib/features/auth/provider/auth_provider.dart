import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/core/services/biometric_service.dart';
import 'package:profinch_mobile_application/data/models/user_model.dart';
import 'package:profinch_mobile_application/data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();

  UserModel? currentUser;
  bool isLoading = false;

  // ── PIN ──────────────────────────────────────────────────────
  String? _pin;
  String? _pinEmail; // remember which user set the PIN

  bool get isPinSet => _pin != null && _pin!.isNotEmpty;

  void setPin(String pin) {
    _pin = pin;
    _pinEmail = currentUser?.email; // store whose PIN this is
    notifyListeners();
  }

  /// Verifies the PIN and restores currentUser from repository if needed.
  bool verifyPin(String pin) {
    if (_pin == null || pin != _pin) return false;
    // Restore currentUser if it was cleared by logout
    if (currentUser == null && _pinEmail != null) {
      currentUser = _repository.getUserByEmail(_pinEmail!);
      notifyListeners();
    }
    return true;
  }

  void clearPin() {
    _pin = null;
    _pinEmail = null;
    notifyListeners();
  }

  // ── Pattern ──────────────────────────────────────────────────
  List<int>? _pattern;
  String? _patternEmail;

  bool get isPatternSet => _pattern != null && _pattern!.isNotEmpty;

  void setPattern(List<int> pattern) {
    _pattern = List<int>.from(pattern);
    _patternEmail = currentUser?.email;
    notifyListeners();
  }

  bool verifyPattern(List<int> pattern) {
    if (_pattern == null || _pattern!.length != pattern.length) return false;
    for (int i = 0; i < pattern.length; i++) {
      if (_pattern![i] != pattern[i]) return false;
    }
    // Restore currentUser if cleared by logout
    if (currentUser == null && _patternEmail != null) {
      currentUser = _repository.getUserByEmail(_patternEmail!);
      notifyListeners();
    }
    return true;
  }

  void clearPattern() {
    _pattern = null;
    _patternEmail = null;
    notifyListeners();
  }

  // ── Biometric ─────────────────────────────────────────────────
  bool _isBiometricEnabled = false;
  bool get isBiometricEnabled => _isBiometricEnabled;

  Future<bool> checkBiometricAvailable() async {
    return await BiometricService.instance.isAvailable();
  }

  Future<bool> authenticateWithBiometric() async {
    return await BiometricService.instance.authenticate();
  }

  void setBiometricEnabled(bool value) {
    _isBiometricEnabled = value;
    notifyListeners();
  }

  // ── Standard login ────────────────────────────────────────────
  void updateUser(UserModel updatedUser) {
    currentUser = updatedUser;
    notifyListeners();
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    final user = _repository.login(email: email, password: password);

    isLoading = false;

    if (user != null) {
      currentUser = user;
      notifyListeners();
      return true;
    }

    notifyListeners();
    return false;
  }

  bool emailExists(String email) => _repository.emailExists(email);

  bool passwordMatches({
    required String email,
    required String password,
  }) =>
      _repository.passwordMatches(email: email, password: password);

  void logout() {
    currentUser = null;
    // PIN/Pattern/Biometric intentionally kept after logout
    // so user can still quick-login on next session
    notifyListeners();
  }
}