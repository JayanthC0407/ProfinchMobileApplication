import 'package:profinch_mobile_application/data/dummy/dummy_users.dart';
import 'package:profinch_mobile_application/data/models/user_model.dart';

class AuthRepository {
  UserModel? login({required String username, required String password}) {
    try {
      return DummyUsers.allUsers.firstWhere(
        (user) => user.username.toLowerCase() == username.trim().toLowerCase() && user.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  bool emailExists(String email) {
    return DummyUsers.allUsers.any((user) => user.email == email);
  }

  bool usernameExists(String username) {
    return DummyUsers.allUsers.any(
      (user) => user.username.toLowerCase() == username.trim().toLowerCase(),
    );
  }

  bool passwordMatches({required String email, required String password}) {
    return DummyUsers.allUsers.any(
      (user) => user.email == email && user.password == password,
    );
  }

  /// Looks up a user by email — used to restore session after PIN/Pattern login.
  UserModel? getUserByEmail(String email) {
    try {
      return DummyUsers.allUsers.firstWhere((u) => u.email == email);
    } catch (_) {
      return null;
    }
  }
}