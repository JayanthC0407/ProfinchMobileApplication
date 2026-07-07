import '../../../data/models/transaction_model.dart';
import '../../../features/analytics/screens/analytics_screen.dart';
import 'package:intl/intl.dart';

class AnalyticsHelper {
  AnalyticsHelper._();

  static List<TransactionModel> filterByPeriod(
    List<TransactionModel> transactions,
    AnalyticsPeriod period,
  ) {
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

  static Map<String, double> spendingByCategory(
    List<TransactionModel> transactions,
  ) {
    final Map<String, double> result = {};
    for (final t in transactions.where(
      (t) => t.type == TransactionType.debit,
    )) {
      final category = _analyticsCategoryLabel(t.category);
      result[category] = (result[category] ?? 0) + t.amount;
    }
    return result;
  }

  static MapEntry<String, double>? topCategory(
    List<TransactionModel> transactions,
  ) {
    final grouped = spendingByCategory(transactions);
    if (grouped.isEmpty) return null;
    return grouped.entries.reduce((a, b) => a.value > b.value ? a : b);
  }

  static int transactionCount(List<TransactionModel> transactions) {
    return transactions.where((t) => t.type == TransactionType.debit).length;
  }

  static List<TransactionModel> topTransactions(
    List<TransactionModel> transactions,
  ) {
    final debits =
        transactions.where((t) => t.type == TransactionType.debit).toList()
          ..sort((a, b) => b.amount.compareTo(a.amount));
    return debits.take(5).toList();
  }

  // Returns last 6 months spending as map of month label → amount
  static Map<String, List<double>> comparativeData(
    List<TransactionModel> all,
    AnalyticsPeriod period,
  ) {
    final now = DateTime.now();
    final Map<String, List<double>> result = {};
    // result[label] = [currentValue, comparisonValue]

    switch (period) {
      case AnalyticsPeriod.month:
        // 4 weeks of current month vs avg of same week across prev 3 months
        for (int week = 1; week <= 4; week++) {
          final currentWeekTotal = _weekSpendingForMonth(
            all,
            now.year,
            now.month,
            week,
          );
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
          final lastYearTotal = _monthSpending(
            all,
            month.year - 1,
            month.month,
          );
          const monthNames = [
            '',
            'Jan',
            'Feb',
            'Mar',
            'Apr',
            'May',
            'Jun',
            'Jul',
            'Aug',
            'Sep',
            'Oct',
            'Nov',
            'Dec',
          ];
          result[monthNames[month.month]] = [currentTotal, lastYearTotal];
        }
        break;

      case AnalyticsPeriod.year:
        // All 12 months: this year vs last year
        const monthNames = [
          '',
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
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
    List<TransactionModel> transactions,
    int year,
    int month,
    int weekNum,
  ) {
    return transactions
        .where(
          (t) =>
              t.type == TransactionType.debit &&
              t.date.year == year &&
              t.date.month == month &&
              _weekOfMonth(t.date) == weekNum,
        )
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  static double _monthSpending(
    List<TransactionModel> transactions,
    int year,
    int month,
  ) {
    return transactions
        .where(
          (t) =>
              t.type == TransactionType.debit &&
              t.date.year == year &&
              t.date.month == month,
        )
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  static int _weekOfMonth(DateTime date) {
    return ((date.day - 1) / 7).floor() + 1;
  }

  /// Short comparison insight for the selected analytics period.
  static String generateInsight(
    List<TransactionModel> allTransactions,
    AnalyticsPeriod period,
    Map<String, double> groupedData,
    double totalSpent,
  ) {
    final fmt = NumberFormat('#,##,##0', 'en_IN');

    if (totalSpent == 0) {
      return 'No spending yet for this period.';
    }

    final top = groupedData.entries.reduce((a, b) => a.value > b.value ? a : b);
    final previousTotal = _previousPeriodSpending(allTransactions, period);
    final comparisonLabel = _comparisonLabel(period);

    if (previousTotal == 0) {
      return 'Not enough $comparisonLabel data yet. Biggest area: ${top.key}.';
    }

    final difference = totalSpent - previousTotal;
    if (difference == 0) {
      return 'You spent the same as $comparisonLabel. Biggest area: ${top.key}.';
    }

    final direction = difference > 0 ? 'more' : 'less';
    return 'You spent ₹${fmt.format(difference.abs())} $direction than '
        '$comparisonLabel. Biggest area: ${top.key}.';
  }

  static double _previousPeriodSpending(
    List<TransactionModel> transactions,
    AnalyticsPeriod period,
  ) {
    final now = DateTime.now();
    return transactions
        .where((t) {
          if (t.type != TransactionType.debit) return false;

          switch (period) {
            case AnalyticsPeriod.month:
              final lastMonth = DateTime(now.year, now.month - 1);
              return t.date.year == lastMonth.year &&
                  t.date.month == lastMonth.month;
            case AnalyticsPeriod.threeMonths:
              final start = DateTime(now.year, now.month - 5, 1);
              final end = DateTime(now.year, now.month - 2, 1);
              return !t.date.isBefore(start) && t.date.isBefore(end);
            case AnalyticsPeriod.year:
              return t.date.year == now.year - 1;
          }
        })
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  static String _comparisonLabel(AnalyticsPeriod period) {
    switch (period) {
      case AnalyticsPeriod.month:
        return 'last month';
      case AnalyticsPeriod.threeMonths:
        return 'the previous 3 months';
      case AnalyticsPeriod.year:
        return 'last year';
    }
  }

  static String _analyticsCategoryLabel(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.food:
        return 'Food';
      case TransactionCategory.shopping:
        return 'Shopping';
      case TransactionCategory.billPayment:
      case TransactionCategory.recharge:
      case TransactionCategory.insurance:
        return 'Bills';
      case TransactionCategory.transfer:
      case TransactionCategory.upi:
      case TransactionCategory.wallet:
        return 'Transfers';
      case TransactionCategory.emi:
      case TransactionCategory.loan:
        return 'Loans';
      case TransactionCategory.atm:
        return 'Cash';
      case TransactionCategory.termDeposit:
        return 'Savings';
      case TransactionCategory.salary:
      case TransactionCategory.refund:
        return 'Income';
    }
  }
}
