import 'package:profinch_mobile_application/data/models/transaction_model.dart';

class DummyTransactions {
  DummyTransactions._();

  static final List<TransactionModel> allTransactions = [

    // ── May 2026 ───────────────────────────────────────────────
    TransactionModel(
      id: 'TXN001',
      accountId: 'ACC001',
      title: 'Salary Credit',
      description: 'Monthly salary from ProFinch Solutions',
      amount: 65000.00,
      type: TransactionType.credit,
      category: TransactionCategory.salary,
      date: DateTime(2026, 5, 1, 9, 0),
      referenceNumber: 'REF20260501001',
      balanceAfter: 125450.75,
      receiverName: null,
      receiverAccount: null,
    ),
    TransactionModel(
      id: 'TXN002',
      accountId: 'ACC001',
      title: 'Swiggy - Food Order',
      description: 'Online food delivery',
      amount: 450.00,
      type: TransactionType.debit,
      category: TransactionCategory.food,
      date: DateTime(2026, 5, 3, 13, 30),
      referenceNumber: 'REF20260503002',
      balanceAfter: 125000.75,
      receiverName: 'Swiggy',
      receiverAccount: null,
    ),
    TransactionModel(
      id: 'TXN003',
      accountId: 'ACC001',
      title: 'Amazon Shopping',
      description: 'Online shopping - electronics',
      amount: 3200.00,
      type: TransactionType.debit,
      category: TransactionCategory.shopping,
      date: DateTime(2026, 5, 5, 16, 45),
      referenceNumber: 'REF20260505003',
      balanceAfter: 121800.75,
      receiverName: 'Amazon India',
      receiverAccount: null,
    ),
    TransactionModel(
      id: 'TXN004',
      accountId: 'ACC001',
      title: 'UPI Transfer',
      description: 'Sent to Priya Nair',
      amount: 2000.00,
      type: TransactionType.debit,
      category: TransactionCategory.upi,
      date: DateTime(2026, 5, 8, 11, 15),
      referenceNumber: 'REF20260508004',
      balanceAfter: 119800.75,
      receiverName: 'Priya Nair',
      receiverAccount: '9876543210',
    ),
    TransactionModel(
      id: 'TXN005',
      accountId: 'ACC001',
      title: 'Electricity Bill',
      description: 'BESCOM electricity payment',
      amount: 1850.00,
      type: TransactionType.debit,
      category: TransactionCategory.billPayment,
      date: DateTime(2026, 5, 10, 10, 0),
      referenceNumber: 'REF20260510005',
      balanceAfter: 117950.75,
      receiverName: 'BESCOM',
      receiverAccount: null,
    ),
    TransactionModel(
      id: 'TXN006',
      accountId: 'ACC001',
      title: 'Mobile Recharge',
      description: 'Airtel prepaid recharge',
      amount: 599.00,
      type: TransactionType.debit,
      category: TransactionCategory.recharge,
      date: DateTime(2026, 5, 12, 9, 30),
      referenceNumber: 'REF20260512006',
      balanceAfter: 117351.75,
      receiverName: 'Airtel',
      receiverAccount: null,
    ),
    TransactionModel(
      id: 'TXN007',
      accountId: 'ACC001',
      title: 'Home Loan EMI',
      description: 'Monthly EMI deduction',
      amount: 18500.00,
      type: TransactionType.debit,
      category: TransactionCategory.emi,
      date: DateTime(2026, 5, 15, 8, 0),
      referenceNumber: 'REF20260515007',
      balanceAfter: 98851.75,
      receiverName: null,
      receiverAccount: null,
    ),
    TransactionModel(
      id: 'TXN008',
      accountId: 'ACC001',
      title: 'UPI Received',
      description: 'Received from Rahul Mehta',
      amount: 5000.00,
      type: TransactionType.credit,
      category: TransactionCategory.upi,
      date: DateTime(2026, 5, 18, 14, 20),
      referenceNumber: 'REF20260518008',
      balanceAfter: 103851.75,
      receiverName: null,
      receiverAccount: null,
    ),
    TransactionModel(
      id: 'TXN009',
      accountId: 'ACC001',
      title: 'ATM Withdrawal',
      description: 'Cash withdrawal at ATM',
      amount: 5000.00,
      type: TransactionType.debit,
      category: TransactionCategory.atm,
      date: DateTime(2026, 5, 20, 17, 0),
      referenceNumber: 'REF20260520009',
      balanceAfter: 98851.75,
      receiverName: null,
      receiverAccount: null,
    ),
    TransactionModel(
      id: 'TXN010',
      accountId: 'ACC001',
      title: 'Amazon Refund',
      description: 'Refund for returned item',
      amount: 1200.00,
      type: TransactionType.credit,
      category: TransactionCategory.refund,
      date: DateTime(2026, 5, 22, 12, 0),
      referenceNumber: 'REF20260522010',
      balanceAfter: 100051.75,
      receiverName: null,
      receiverAccount: null,
    ),
  ];

  // ── Helpers ────────────────────────────────────────────────────

  /// Get transactions for a specific account
  static List<TransactionModel> forAccount(String accountId) {
    return allTransactions
        .where((t) => t.accountId == accountId)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// Get recent N transactions
  static List<TransactionModel> recent({int count = 5}) {
    final sorted = List<TransactionModel>.from(allTransactions)
      ..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(count).toList();
  }

  /// Get total spending this month (debits)
  static double totalSpentThisMonth() {
    final now = DateTime.now();
    return allTransactions
        .where((t) =>
            t.type == TransactionType.debit &&
            t.date.month == now.month &&
            t.date.year == now.year)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// Get spending grouped by category for chart
  static Map<TransactionCategory, double> spendingByCategory() {
    final Map<TransactionCategory, double> result = {};
    for (final t in allTransactions.where(
        (t) => t.type == TransactionType.debit)) {
      result[t.category] = (result[t.category] ?? 0) + t.amount;
    }
    return result;
  }
}
