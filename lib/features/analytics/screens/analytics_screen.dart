import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/core/constants/colors.dart';
import 'package:profinch_mobile_application/features/analytics/utils/analytics_helper.dart';
import 'package:provider/provider.dart';
import '../../Transactions/provider/transaction_provider.dart'; 
import '../widgets/analytics_summary_card.dart';
import '../widgets/spending_pie_chart.dart';
import '../widgets/top_category_card.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Accessing your exact singleton context via Provider
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final transactions = transactionProvider.allTransactionsSorted; 

    final totalSpent = AnalyticsHelper.totalSpentThisMonth(transactions);
    final txCount = AnalyticsHelper.transactionCount(transactions);
    final groupedData = AnalyticsHelper.spendingByCategory(transactions);
    final highestExpense = AnalyticsHelper.topCategory(transactions);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Insights & Analytics', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnalyticsSummaryCard(totalAmount: totalSpent, count: txCount),
              const SizedBox(height: 20),
              SpendingPieChart(data: groupedData),
              const SizedBox(height: 20),
              if (highestExpense != null)
                TopCategoryCard(category: highestExpense.key, amount: highestExpense.value),
            ],
          ),
        ),
      ),
    );
  }
}
