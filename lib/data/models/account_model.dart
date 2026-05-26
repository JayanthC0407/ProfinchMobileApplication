class AccountModel {
  final String id;
  final String userId;
  final String accountNumber;
  final String ifscCode;
  final String branchName;
  final String accountType; // Savings / Current / Salary
  final double balance;
  final double availableBalance;
  final bool isActive;

  AccountModel({
    required this.id,
    required this.userId,
    required this.accountNumber,
    required this.ifscCode,
    required this.branchName,
    required this.accountType,
    required this.balance,
    required this.availableBalance,
    required this.isActive,
  });
}
