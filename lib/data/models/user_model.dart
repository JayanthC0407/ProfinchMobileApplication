class UserModel {
  final String id;
  final String username;
  final String email;
  final String password;
  final String phoneNumber;
  final String panNumber;
  final String profileImage;
  final String accountNumber;
  final DateTime createdAt;
  final bool isKycVerified;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.panNumber,
    required this.profileImage,
    required this.accountNumber,
    required this.createdAt,
    required this.isKycVerified,
  });

  UserModel copyWith({
  String? username,
  String? email,
  String? phoneNumber,
}) {

  return UserModel(
    id: id,
    username: username ?? this.username,
    email: email ?? this.email,
    password: password,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    panNumber: panNumber,
    profileImage: profileImage,
    accountNumber: accountNumber,
    createdAt: createdAt,
    isKycVerified: isKycVerified,
  );
}
}