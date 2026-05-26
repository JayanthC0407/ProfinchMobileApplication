enum LoanType { home, education, car, gold, personal }

enum LoanStatus { active, closed, pending, rejected }

class LoanModel {
  final String id;
  final String userId;
  final LoanType loanType;
  final LoanStatus status;
  final double principalAmount;
  final double interestRate;     // annual %
  final int tenureMonths;
  final double emiAmount;
  final double outstandingAmount;
  final int paidEmis;
  final DateTime startDate;
  final DateTime nextEmiDate;

  LoanModel({
    required this.id,
    required this.userId,
    required this.loanType,
    required this.status,
    required this.principalAmount,
    required this.interestRate,
    required this.tenureMonths,
    required this.emiAmount,
    required this.outstandingAmount,
    required this.paidEmis,
    required this.startDate,
    required this.nextEmiDate,
  });

  int get remainingEmis => tenureMonths - paidEmis;

  String get loanTypeName {
    switch (loanType) {
      case LoanType.home:       return 'Home Loan';
      case LoanType.education:  return 'Education Loan';
      case LoanType.car:        return 'Car Loan';
      case LoanType.gold:       return 'Gold Loan';
      case LoanType.personal:   return 'Personal Loan';
    }
  }
}
