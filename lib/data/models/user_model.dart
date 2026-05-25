class UserModel {
  final String id;
  final String username;
  final String email;
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
    required this.phoneNumber,
    required this.panNumber,
    required this.profileImage,
    required this.accountNumber,
    required this.createdAt,
    required this.isKycVerified,
  });
}
