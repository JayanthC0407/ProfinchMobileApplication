import '../../../data/models/transaction_model.dart';
import '../../../features/analytics/screens/analytics_screen.dart';
import 'package:intl/intl.dart';

class AnalyticsHelper {
  AnalyticsHelper._();

  static List<TransactionModel> filterByPeriod(
      List<TransactionModel> transactions, AnalyticsPeriod period) {
    final now = DateTime.now();
    return transactions.where((t) {
      switch (period) {
        case AnalyticsPeriod.month:
          return t.date.month == now.month && t.date.year == now.year;
        case AnalyticsPeriod.threeMonths:
          final threeMonthsAgo = DateTime(now.year, now.month - 2, 1);
          return t.date.isAfter(threeMonthsAgo);
        case AnalyticsPeriod.year:
          return t.date.year == now.year;
      }
    }).toList();
  }

  static double totalSpent(List<TransactionModel> transactions) {
    return transactions
        .where((t) => t.type == TransactionType.debit)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  static double totalIncome(List<TransactionModel> transactions) {
    return transactions
        .where((t) => t.type == TransactionType.credit)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  static Map<TransactionCategory, double> spendingByCategory(
      List<TransactionModel> transactions) {
    final Map<TransactionCategory, double> result = {};
    for (final t in transactions.where((t) => t.type == TransactionType.debit)) {
      result[t.category] = (result[t.category] ?? 0) + t.amount;
    }
    return result;
  }

  static MapEntry<TransactionCategory, double>? topCategory(
      List<TransactionModel> transactions) {
    final grouped = spendingByCategory(transactions);
    if (grouped.isEmpty) return null;
    return grouped.entries.reduce((a, b) => a.value > b.value ? a : b);
  }

  static int transactionCount(List<TransactionModel> transactions) {
    return transactions.where((t) => t.type == TransactionType.debit).length;
  }

  static List<TransactionModel> topTransactions(
      List<TransactionModel> transactions) {
    final debits = transactions
        .where((t) => t.type == TransactionType.debit)
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));
    return debits.take(5).toList();
  }

  // Returns last 6 months spending as map of month label → amount
  static Map<String, List<double>> comparativeData(
      List<TransactionModel> all, AnalyticsPeriod period) {
    final now = DateTime.now();
    final Map<String, List<double>> result = {};
    // result[label] = [currentValue, comparisonValue]

    switch (period) {
      case AnalyticsPeriod.month:
        // 4 weeks of current month vs avg of same week across prev 3 months
        for (int week = 1; week <= 4; week++) {
          final currentWeekTotal = _weekSpendingForMonth(
              all, now.year, now.month, week);
          double avgTotal = 0.0;
          for (int i = 1; i <= 3; i++) {
            final past = DateTime(now.year, now.month - i);
            avgTotal += _weekSpendingForMonth(all, past.year, past.month, week);
          }
          result['W$week'] = [currentWeekTotal, avgTotal / 3];
        }
        break;

      case AnalyticsPeriod.threeMonths:
        // Last 3 months: each month current year vs same month last year
        for (int i = 2; i >= 0; i--) {
          final month = DateTime(now.year, now.month - i);
          final currentTotal = _monthSpending(all, month.year, month.month);
          final lastYearTotal =
              _monthSpending(all, month.year - 1, month.month);
          const monthNames = [
            '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
            'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
          ];
          result[monthNames[month.month]] = [currentTotal, lastYearTotal];
        }
        break;

        case AnalyticsPeriod.threeMonths:
        // Last 3 months: each month current year vs same month last year
        for (int i = 2; i >= 0; i--) {
          final month = DateTime(now.year, now.month - i);
          final currentTotal = _monthSpending(all, month.year, month.month);
          final lastYearTotal =
              _monthSpending(all, month.year - 1, month.month);
          const monthNames = [
            '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
            'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
          ];
          result[monthNames[month.month]] = [currentTotal, lastYearTotal];
        }
        break;

      case AnalyticsPeriod.year:
        // All 12 months: this year vs last year
        const monthNames = [
          '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
        ];
        for (int m = 1; m <= 12; m++) {
          final currentTotal = _monthSpending(all, now.year, m);
          final lastYearTotal = _monthSpending(all, now.year - 1, m);
          result[monthNames[m]] = [currentTotal, lastYearTotal];
        }
        break;
    }
    return result;
  }

  static double _weekSpendingForMonth(
      List<TransactionModel> transactions, int year, int month, int weekNum) {
    return transactions
        .where((t) =>
            t.type == TransactionType.debit &&
            t.date.year == year &&
            t.date.month == month &&
            _weekOfMonth(t.date) == weekNum)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  static double _monthSpending(
      List<TransactionModel> transactions, int year, int month) {
    return transactions
        .where((t) =>
            t.type == TransactionType.debit &&
            t.date.year == year &&
            t.date.month == month)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  static int _weekOfMonth(DateTime date) {
    return ((date.day - 1) / 7).floor() + 1;
  }

  /// Simple prescriptive insight — no exclamation marks, plain language
  static String generateInsight(
      Map<String, List<double>> chartData,
      AnalyticsPeriod period,
      double totalSpent,
      double totalIncome) {
    final fmt = NumberFormat('#,##,##0', 'en_IN');

    // Sum up current vs comparison totals from chart data
    double currentTotal = 0;
    double compTotal = 0;
    for (final entry in chartData.values) {
      currentTotal += entry[0];
      compTotal += entry[1];
    }

    final savingsRate = totalIncome > 0
        ? ((totalIncome - totalSpent) / totalIncome * 100).round()
        : 0;

    final compLabel = period == AnalyticsPeriod.month
        ? '3-month weekly average'
        : period == AnalyticsPeriod.threeMonths
            ? 'the same period last year'
            : 'last year';

    if (compTotal == 0) {
      return 'No comparison data available for this period.';
    }

    final diff = currentTotal - compTotal;
    final percent = (diff.abs() / compTotal * 100).round();

    if (diff > 0) {
      return 'Spending is $percent% higher than $compLabel '
          '(₹${fmt.format(currentTotal)} vs ₹${fmt.format(compTotal)}). '
          'Savings rate this period: $savingsRate%.';
    } else if (diff < 0) {
      return 'Spending is $percent% lower than $compLabel '
          '(₹${fmt.format(currentTotal)} vs ₹${fmt.format(compTotal)}). '
          'Savings rate this period: $savingsRate%.';
    } else {
      return 'Spending is on par with $compLabel. '
          'Savings rate this period: $savingsRate%.';
    }
  }
}