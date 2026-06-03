class AccountModel {

  final String id;
  final String userId;
  final String accountNumber;
  final String iban;
  final String ifscCode;
  final String branchCode;
  final String branchName;
  final String accountType;
  final String currencyCode;
  final double balance;
  final double availableBalance;
  final double currentBalance;
  final double holdAmount;

  final bool isActive;

  final String partyName;

  final DateTime openingDate;

  final bool hasChequeBook;
  final bool hasATMFacility;
  final bool hasOverDraftFacility;

  final double overDraftLimit;

  final bool nomineeRegistered;

  AccountModel({
    required this.id,
    required this.userId,
    required this.accountNumber,
    required this.iban,
    required this.ifscCode,
    required this.branchCode,
    required this.branchName,
    required this.accountType,
    required this.currencyCode,
    required this.balance,
    required this.availableBalance,
    required this.currentBalance,
    required this.holdAmount,
    required this.isActive,
    required this.partyName,
    required this.openingDate,
    required this.hasChequeBook,
    required this.hasATMFacility,
    required this.hasOverDraftFacility,
    required this.overDraftLimit,
    required this.nomineeRegistered,
  });
}