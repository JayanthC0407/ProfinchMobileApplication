import 'package:profinch_mobile_application/data/models/loan_model.dart';

class DummyLoans {
  DummyLoans._();

  static final List<LoanModel> allLoans = [
    LoanModel(
      id: 'LN001',
      userId: 'USR001',
      loanType: LoanType.home,
      status: LoanStatus.active,
      principalAmount: 2500000,
      interestRate: 8.5,
      tenureMonths: 240,
      emiAmount: 18500,
      outstandingAmount: 2180000,
      paidEmis: 18,
      startDate: DateTime(2024, 11, 1),
      nextEmiDate: DateTime(2026, 6, 1),
    ),
    LoanModel(
      id: 'LN002',
      userId: 'USR001',
      loanType: LoanType.personal,
      status: LoanStatus.active,
      principalAmount: 100000,
      interestRate: 12.0,
      tenureMonths: 24,
      emiAmount: 4707,
      outstandingAmount: 56484,
      paidEmis: 12,
      startDate: DateTime(2025, 5, 1),
      nextEmiDate: DateTime(2026, 6, 1),
    ),
  ];

  /// Total outstanding across all active loans
  static double get totalOutstanding {
    return allLoans
        .where((l) => l.status == LoanStatus.active)
        .fold(0.0, (sum, l) => sum + l.outstandingAmount);
  }

  /// Next EMI due (earliest date)
  static LoanModel? get nextEmiDue {
    final active = allLoans.where((l) => l.status == LoanStatus.active).toList()
      ..sort((a, b) => a.nextEmiDate.compareTo(b.nextEmiDate));
    return active.isNotEmpty ? active.first : null;
  }
}
