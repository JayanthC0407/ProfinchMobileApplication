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
  AccountModel copyWith({
  double? balance,
  double? availableBalance,
  }) {
    return AccountModel(
      id: id,
      userId: userId,
      accountNumber: accountNumber,
      iban: iban,
      ifscCode: ifscCode,
      branchCode: branchCode,
      branchName: branchName,
      accountType: accountType,
      currencyCode: currencyCode,
      balance: balance ?? this.balance,
      availableBalance:
          availableBalance ?? this.availableBalance,
      currentBalance: currentBalance,
      holdAmount: holdAmount,
      isActive: isActive,
      partyName: partyName,
      openingDate: openingDate,
      hasChequeBook: hasChequeBook,
      hasATMFacility: hasATMFacility,
      hasOverDraftFacility: hasOverDraftFacility,
      overDraftLimit: overDraftLimit,
      nomineeRegistered: nomineeRegistered,
    );
  }
}