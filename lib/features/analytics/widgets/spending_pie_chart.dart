import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:profinch_mobile_application/core/constants/colors.dart';

class SpendingPieChart extends StatelessWidget {
  final Map<String, double> data;

  const SpendingPieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Card(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(
            child: Text(
              'No spending found for this period.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
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
            const Text(
              'Spending Breakdown',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
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
                  .map((entry) => _buildLegendItem(entry.key, entry.value))
                  .toList(),
            ),
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

  Widget _buildLegendItem(String category, double amount) {
    return SizedBox(
      width: 145,
      child: Row(
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
              category,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
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
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Food':
        return const Color(0xFFFFB74D);
      case 'Shopping':
        return const Color(0xFF9575CD);
      case 'Bills':
        return const Color(0xFFEF528C);
      case 'Transfers':
        return const Color(0xFF42A5F5);
      case 'Loans':
        return const Color(0xFFE57373);
      case 'Cash':
        return const Color(0xFF26A69A);
      case 'Savings':
        return const Color(0xFF66BB6A);
      default:
        return const Color(0xFF26C6DA);
    }
  }
}
