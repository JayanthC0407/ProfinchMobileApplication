import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/core/services/biometric_service.dart';
import 'package:profinch_mobile_application/data/models/user_model.dart';
import 'package:profinch_mobile_application/data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();

  UserModel? currentUser;
  bool isLoading = false;

  // ── Pattern ───────────────────────────────────────────────────
  List<int>? _pattern;

  bool get isPatternSet => _pattern != null && _pattern!.isNotEmpty;

  void setPattern(List<int> pattern) {
    _pattern = List<int>.from(pattern);
    notifyListeners();
  }

  bool verifyPattern(List<int> pattern) {
    if (_pattern == null || _pattern!.length != pattern.length) return false;
    for (int i = 0; i < pattern.length; i++) {
      if (_pattern![i] != pattern[i]) return false;
    }
    return true;
  }

  void clearPattern() {
    _pattern = null;
    notifyListeners();
  }

  // ── PIN ───────────────────────────────────────────────────────
  // In a real app, PIN would be stored encrypted via flutter_secure_storage.
  // Here we keep it in memory for the dummy phase.
  String? _pin;

  bool get isPinSet => _pin != null && _pin!.isNotEmpty;

  void setPin(String pin) {
    _pin = pin;
    notifyListeners();
  }

  bool verifyPin(String pin) => pin == _pin;

  void clearPin() {
    _pin = null;
    notifyListeners();
  }

  // ── Biometric ─────────────────────────────────────────────────
  bool _isBiometricEnabled = false;
  bool get isBiometricEnabled => _isBiometricEnabled;

  Future<bool> checkBiometricAvailable() async {
    return await BiometricService.instance.isAvailable();
  }

  Future<bool> authenticateWithBiometric() async {
    final success = await BiometricService.instance.authenticate();
    return success;
  }

  void setBiometricEnabled(bool value) {
    _isBiometricEnabled = value;
    notifyListeners();
  }

  // ── Existing methods ──────────────────────────────────────────
  void updateUser(UserModel updatedUser) {
    currentUser = updatedUser;
    notifyListeners();
  }

  Future<bool> login({required String email, required String password}) async {
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

  bool passwordMatches({required String email, required String password}) =>
      _repository.passwordMatches(email: email, password: password);

  void logout() {
    currentUser = null;
    // Note: PIN and biometric preference intentionally kept on logout
    // so the user can still quick-login with PIN after logging out.
    notifyListeners();
  }
}