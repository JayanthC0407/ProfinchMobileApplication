class LoanModel {

  final String id;

  final String userId;

  final String loanType;

  final double principalAmount;

  final double interestRate;

  final int tenureMonths;

  final double emiAmount;

  final double outstandingAmount;

  final DateTime startDate;

  final DateTime endDate;

  final String repaymentAccountId;

  final bool autoPayEnabled;

  final int autoPayDate;

  final String status;

  LoanModel({
    required this.id,
    required this.userId,
    required this.loanType,
    required this.principalAmount,
    required this.interestRate,
    required this.tenureMonths,
    required this.emiAmount,
    required this.outstandingAmount,
    required this.startDate,
    required this.endDate,
    required this.repaymentAccountId,
    required this.autoPayEnabled,
    required this.autoPayDate,
    required this.status,
  });
}