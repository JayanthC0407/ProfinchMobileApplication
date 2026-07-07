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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Spending Breakdown', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            SizedBox(
              height: 180,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 4,
                  centerSpaceRadius: 50,
                  sections: _getSections(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: data.keys.map((cat) => _buildLegendItem(cat)).toList(),
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
        radius: 22,
        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();
  }

  Widget _buildLegendItem(TransactionCategory category) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(shape: BoxShape.circle, color: _getCategoryColor(category))),
        const SizedBox(width: 6),
        Text(_cleanCategoryName(category), style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
      ],
    );
  }

  String _cleanCategoryName(TransactionCategory category) {
    String name = category.toString().split('.').last;
    return name[0].toUpperCase() + name.substring(1);
  }

  Color _getCategoryColor(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.food: return Colors.orange;
      case TransactionCategory.shopping: return Colors.purple;
      case TransactionCategory.billPayment: return Colors.redAccent;
      case TransactionCategory.transfer: return AppColors.accent;
      case TransactionCategory.salary: return AppColors.success;
      default: return AppColors.blueButton;
    }
  }
}