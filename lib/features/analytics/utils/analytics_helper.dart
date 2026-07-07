import '../../../data/models/transaction_model.dart';

class AnalyticsHelper {
  AnalyticsHelper._();

  /// Calculates total monthly debit spending
  static double totalSpentThisMonth(List<TransactionModel> transactions) {
    final now = DateTime.now();
    return transactions
        .where((t) =>
            t.type == TransactionType.debit &&
            t.date.month == now.month &&
            t.date.year == now.year)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// Groups debit transactions by their enum category
  static Map<TransactionCategory, double> spendingByCategory(List<TransactionModel> transactions) {
    final Map<TransactionCategory, double> result = {};
    final now = DateTime.now();
    
    final currentMonthDebits = transactions.where((t) =>
        t.type == TransactionType.debit &&
        t.date.month == now.month &&
        t.date.year == now.year);

    for (final t in currentMonthDebits) {
      result[t.category] = (result[t.category] ?? 0) + t.amount;
    }
    return result;
  }

  /// Identifies the category with the highest spending amount
  static MapEntry<TransactionCategory, double>? topCategory(List<TransactionModel> transactions) {
    final grouped = spendingByCategory(transactions);
    if (grouped.isEmpty) return null;
    
    return grouped.entries.reduce((a, b) => a.value > b.value ? a : b);
  }

  /// Count of debit transactions this month
  static int transactionCount(List<TransactionModel> transactions) {
    final now = DateTime.now();
    return transactions.where((t) => 
      t.type == TransactionType.debit && 
      t.date.month == now.month && 
      t.date.year == now.year
    ).length;
  }
}