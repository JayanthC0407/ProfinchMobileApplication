import 'package:profinch_mobile_application/data/dummy/dummy_users.dart';
import 'package:profinch_mobile_application/data/models/user_model.dart';

class AuthRepository {

  UserModel? login({
    required String email,
    required String password,
  }) {

    try {

      return DummyUsers.allUsers.firstWhere(
        (user) =>
            user.email == email &&
            user.password == password,
      );

    } catch (e) {
      return null;
    }
  }
}