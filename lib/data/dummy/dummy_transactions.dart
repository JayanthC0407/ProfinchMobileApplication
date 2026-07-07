import 'package:profinch_mobile_application/data/models/transaction_model.dart';

class DummyTransactions {
  DummyTransactions._();

  // ── Starter data ────────────────────────────────────────────────
  // Intentionally only 2 entries. This is what a first-time login
  // should show on the Dashboard and in Transaction History — nothing
  // more. Every transaction performed afterwards (UPI, transfer,
  // withdrawal, EMI, loan, term deposit, etc.) is added on top of
  // this through TransactionProvider.instance.addTransaction(...).
  static final List<TransactionModel> allTransactions = [
    TransactionModel(
      id: 'TXN001',
      accountId: 'ACC001',
      title: 'Salary Credit',
      description: 'Monthly salary from ProFinch Solutions',
      amount: 65000.00,
      type: TransactionType.credit,
      category: TransactionCategory.salary,
      date: DateTime(2026, 6, 15, 9, 0),
      referenceNumber: 'REF20260615001',
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
      date: DateTime(2026, 6, 16, 13, 30),
      referenceNumber: 'REF20260616002',
      balanceAfter: 125000.75,
      receiverName: 'Swiggy',
      receiverAccount: null,
    ),
    TransactionModel(
      id: 'TXN022',
      accountId: 'ACC001',
      title: 'Amazon Shopping',
      description: 'Online shopping',
      amount: 2300.00,
      type: TransactionType.debit,
      category: TransactionCategory.shopping,
      date: DateTime(2026, 7, 2, 10, 0),
      referenceNumber: 'REF20260702001',
      balanceAfter: 87320.00,
    ),
    TransactionModel(
    id: 'TXN026',
    accountId: 'ACC001',
    title: 'Uber Ride',
    description: 'Cab booking',
    amount: 340.00,
    type: TransactionType.debit,
    category: TransactionCategory.transfer,
    date: DateTime(2026, 7, 6, 8, 30),
    referenceNumber: 'REF20260706001',
    balanceAfter: 83160.00,
  ),
  TransactionModel(
    id: 'TXN027',
    accountId: 'ACC001',
    title: 'Netflix Subscription',
    description: 'Monthly subscription',
    amount: 649.00,
    type: TransactionType.debit,
    category: TransactionCategory.recharge,
    date: DateTime(2026, 7, 7, 10, 0),
    referenceNumber: 'REF20260707001',
    balanceAfter: 82511.00,
  ),

  // ── April 2026 week 1 (for comparison) ────────────────────
TransactionModel(
  id: 'TXN030',
  accountId: 'ACC001',
  title: 'Zomato - Food Order',
  description: 'Online food delivery',
  amount: 420.00,
  type: TransactionType.debit,
  category: TransactionCategory.food,
  date: DateTime(2026, 4, 1, 13, 0),
  referenceNumber: 'REF20260401001',
  balanceAfter: 95000.00,
),
TransactionModel(
  id: 'TXN031',
  accountId: 'ACC001',
  title: 'Amazon Shopping',
  description: 'Online shopping',
  amount: 1800.00,
  type: TransactionType.debit,
  category: TransactionCategory.shopping,
  date: DateTime(2026, 4, 2, 10, 0),
  referenceNumber: 'REF20260402001',
  balanceAfter: 93200.00,
),
TransactionModel(
  id: 'TXN032',
  accountId: 'ACC001',
  title: 'Electricity Bill',
  description: 'BESCOM monthly bill',
  amount: 1650.00,
  type: TransactionType.debit,
  category: TransactionCategory.billPayment,
  date: DateTime(2026, 4, 3, 11, 0),
  referenceNumber: 'REF20260403001',
  balanceAfter: 91550.00,
),
TransactionModel(
  id: 'TXN033',
  accountId: 'ACC001',
  title: 'UPI Transfer',
  description: 'Sent to friend',
  amount: 1200.00,
  type: TransactionType.debit,
  category: TransactionCategory.upi,
  date: DateTime(2026, 4, 5, 15, 0),
  referenceNumber: 'REF20260405001',
  balanceAfter: 90350.00,
),

// ── May 2026 week 1 (for comparison) ──────────────────────
TransactionModel(
  id: 'TXN040',
  accountId: 'ACC001',
  title: 'Swiggy - Food Order',
  description: 'Online food delivery',
  amount: 390.00,
  type: TransactionType.debit,
  category: TransactionCategory.food,
  date: DateTime(2026, 5, 1, 13, 0),
  referenceNumber: 'REF20260501001',
  balanceAfter: 88000.00,
),
TransactionModel(
  id: 'TXN041',
  accountId: 'ACC001',
  title: 'Flipkart Shopping',
  description: 'Online shopping',
  amount: 2100.00,
  type: TransactionType.debit,
  category: TransactionCategory.shopping,
  date: DateTime(2026, 5, 2, 10, 0),
  referenceNumber: 'REF20260502001',
  balanceAfter: 85900.00,
),
TransactionModel(
  id: 'TXN042',
  accountId: 'ACC001',
  title: 'Electricity Bill',
  description: 'BESCOM monthly bill',
  amount: 1700.00,
  type: TransactionType.debit,
  category: TransactionCategory.billPayment,
  date: DateTime(2026, 5, 3, 11, 0),
  referenceNumber: 'REF20260503001',
  balanceAfter: 84200.00,
),

// ── June 2026 week 1 (for comparison) ─────────────────────
TransactionModel(
  id: 'TXN050',
  accountId: 'ACC001',
  title: 'Haldirams',
  description: 'Restaurant dining',
  amount: 460.00,
  type: TransactionType.debit,
  category: TransactionCategory.food,
  date: DateTime(2026, 6, 1, 13, 0),
  referenceNumber: 'REF20260601001',
  balanceAfter: 82000.00,
),
TransactionModel(
  id: 'TXN051',
  accountId: 'ACC001',
  title: 'Amazon Shopping',
  description: 'Online shopping',
  amount: 1950.00,
  type: TransactionType.debit,
  category: TransactionCategory.shopping,
  date: DateTime(2026, 6, 2, 10, 0),
  referenceNumber: 'REF20260602001',
  balanceAfter: 80050.00,
),
TransactionModel(
  id: 'TXN052',
  accountId: 'ACC001',
  title: 'Electricity Bill',
  description: 'BESCOM monthly bill',
  amount: 1750.00,
  type: TransactionType.debit,
  category: TransactionCategory.billPayment,
  date: DateTime(2026, 6, 3, 11, 0),
  referenceNumber: 'REF20260603001',
  balanceAfter: 78300.00,
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