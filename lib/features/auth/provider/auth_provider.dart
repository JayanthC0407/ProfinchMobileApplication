import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/data/models/user_model.dart';
import 'package:profinch_mobile_application/data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();

  UserModel? currentUser;

  bool isLoading = false;

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

  bool emailExists(String email) {
    return _repository.emailExists(email);
  }

  bool passwordMatches({required String email, required String password}) {
    return _repository.passwordMatches(email: email, password: password);
  }

  void logout() {
    currentUser = null;

    notifyListeners();
  }
}
