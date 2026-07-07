import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:profinch_mobile_application/core/constants/colors.dart';
import '../../../data/models/transaction_model.dart';

class SpendingPieChart extends StatelessWidget {
  final Map<TransactionCategory, double> data;

  const SpendingPieChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Card(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: Text('No debit history found for this month.', style: TextStyle(color: AppColors.textSecondary))),
        ),
      );
    }

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Spending Breakdown', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            SizedBox(
              height: 230,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 3,
                  centerSpaceRadius: 38,
                  sections: _getSections(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: data.entries
                  .map(
                    (entry) => _buildLegendItem(
                      entry.key,
                      entry.value,
                    ),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _getSections() {
    final total = data.values.fold(0.0, (sum, v) => sum + v);
    return data.entries.map((entry) {
      final percentage = total > 0 ? (entry.value / total) * 100 : 0.0;
      return PieChartSectionData(
        color: _getCategoryColor(entry.key),
        value: entry.value,
        title: '${percentage.toStringAsFixed(0)}%',
        radius: 55,
        titleStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      );
    }).toList();
  }

Widget _buildLegendItem(
  TransactionCategory category,
  double amount,
) {
  return Row(
    children: [
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _getCategoryColor(category),
        ),
      ),
      const SizedBox(width: 8),

      Expanded(
        child: Text(
          _cleanCategoryName(category),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      Text(
        '₹${amount.toStringAsFixed(0)}',
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

  String _cleanCategoryName(TransactionCategory category) {
    String name = category.toString().split('.').last;
    return name[0].toUpperCase() + name.substring(1);
  }

  Color _getCategoryColor(TransactionCategory category) {
    switch (category) {
        case TransactionCategory.food:
      return const Color(0xFFFFB74D);

    case TransactionCategory.shopping:
      return const Color(0xFF9575CD);

    case TransactionCategory.billPayment:
      return const Color.fromARGB(255, 239, 82, 140);

    case TransactionCategory.transfer:
      return const Color(0xFF42A5F5);

    case TransactionCategory.salary:
      return const Color(0xFF66BB6A);

    default:
      return const Color(0xFF26C6DA);
    }
  }
}