import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/data/models/loan_statement_model.dart';

import '../../../data/dummy/dummy_loans.dart';
import '../../../data/models/loan_model.dart';

class LoanProvider extends ChangeNotifier {
  final List<LoanModel> _loans = List.from(DummyLoans.loans);

  final List<LoanStatementModel> _statements = [];

  List<LoanModel> getLoansByUser(String userId) {
    return _loans.where((loan) => loan.userId == userId).toList();
  }

  void addLoan(LoanModel loan) {
    _loans.add(loan);

    notifyListeners();
  }

  void repayLoan(String loanId, double emiAmount) {
    final index = _loans.indexWhere((loan) => loan.id == loanId);

    if (index == -1) return;

    final loan = _loans[index];

    final principalComponent = emiAmount * 0.7;

    final interestComponent = emiAmount * 0.3;

    final updatedOutstanding = loan.outstandingAmount - principalComponent;

    _statements.add(
      LoanStatementModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),

        loanId: loan.id,

        paymentDate: DateTime.now(),

        emiAmount: emiAmount,

        principalComponent: principalComponent,

        interestComponent: interestComponent,

        remainingOutstanding: updatedOutstanding,

        status: "PAID",
      ),
    );

    _loans[index] = LoanModel(
      id: loan.id,
      userId: loan.userId,
      loanType: loan.loanType,
      principalAmount: loan.principalAmount,
      interestRate: loan.interestRate,
      tenureMonths: loan.tenureMonths,
      emiAmount: loan.emiAmount,

      outstandingAmount: updatedOutstanding <= 0 ? 0 : updatedOutstanding,

      startDate: loan.startDate,

      endDate: loan.endDate,

      repaymentAccountId: loan.repaymentAccountId,

      autoPayEnabled: loan.autoPayEnabled,

      autoPayDate: loan.autoPayDate,

      status: updatedOutstanding <= 0 ? "CLOSED" : "ACTIVE",
    );

    notifyListeners();
  }

  LoanModel? getLoanById(String loanId) {
    try {
      return _loans.firstWhere((loan) => loan.id == loanId);
    } catch (_) {
      return null;
    }
  }

  List<LoanStatementModel> getStatementsByLoan(String loanId) {
    return _statements
        .where((statement) => statement.loanId == loanId)
        .toList();
  }
}
