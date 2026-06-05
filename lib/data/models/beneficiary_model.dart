class BeneficiaryModel {

  final String id;

  final String userId;

  final String nickname;

  final String beneficiaryType;

  final String accountNumber;

  final String bankName;

  final String ifscCode;

  final bool isVerified;
  final String? ibanNumber;
  final String? swiftCode;
  final String? country;

  BeneficiaryModel({
    required this.id,
    required this.userId,
    required this.nickname,
    required this.beneficiaryType,
    required this.accountNumber,
    required this.bankName,
    required this.ifscCode,
    required this.isVerified,
    this.ibanNumber,
    this.swiftCode,
    this.country,
  });
}