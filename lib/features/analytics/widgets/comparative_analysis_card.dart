import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:profinch_mobile_application/core/constants/colors.dart';
import 'package:profinch_mobile_application/core/constants/text_styles.dart';
import '../screens/analytics_screen.dart';

class ComparativeAnalysisCard extends StatelessWidget {
  final Map<String, List<double>> chartData;
  final AnalyticsPeriod period;
  final String insight;

  const ComparativeAnalysisCard({
    super.key,
    required this.chartData,
    required this.period,
    required this.insight,
  });

  String get _comparisonLabel {
    switch (period) {
      case AnalyticsPeriod.month:
        return '3M Avg';
      case AnalyticsPeriod.threeMonths:
        return 'Last Year';
      case AnalyticsPeriod.year:
        return 'Last Year';
    }
  }

  String get _currentLabel {
    switch (period) {
      case AnalyticsPeriod.month:
        return 'This Month';
      case AnalyticsPeriod.threeMonths:
        return 'This Period';
      case AnalyticsPeriod.year:
        return 'This Year';
    }
  }

  String get _cardTitle {
    switch (period) {
      case AnalyticsPeriod.month:
        return 'Weekly Breakdown vs 3-Month Avg';
      case AnalyticsPeriod.threeMonths:
        return 'Monthly Breakdown vs Last Year';
      case AnalyticsPeriod.year:
        return 'Monthly Breakdown vs Last Year';
    }
  }

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,##,##0', 'en_IN');
    final entries = chartData.entries.toList();

    // Calculate totals for status badge
    double currentTotal = 0;
    double compTotal = 0;
    for (final e in chartData.values) {
      currentTotal += e[0];
      compTotal += e[1];
    }
    final isOver = currentTotal > compTotal;
    final isUnder = currentTotal < compTotal;
    final percent = compTotal > 0
        ? ((currentTotal - compTotal).abs() / compTotal * 100).round()
        : 0;

    final maxVal = chartData.values.fold(0.0, (max, e) {
      final m = e[0] > e[1] ? e[0] : e[1];
      return m > max ? m : max;
    });

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.light,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title ─────────────────────────────────────────
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.compare_arrows_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Spending Comparison',
                      style: AppTextStyles.labelBold(context),
                    ),
                    Text(_cardTitle, style: AppTextStyles.caption(context)),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ── Status badge ──────────────────────────────────
          if (compTotal > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isOver
                    ? AppColors.errorLight
                    : isUnder
                    ? AppColors.successLight
                    : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isOver
                        ? Icons.trending_up_rounded
                        : isUnder
                        ? Icons.trending_down_rounded
                        : Icons.trending_flat_rounded,
                    size: 14,
                    color: isOver
                        ? AppColors.error
                        : isUnder
                        ? AppColors.success
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isOver
                        ? '$percent% above $_comparisonLabel'
                        : isUnder
                        ? '$percent% below $_comparisonLabel'
                        : 'On par with $_comparisonLabel',
                    style: AppTextStyles.smallBold(
                      context,
                      color: isOver
                          ? AppColors.error
                          : isUnder
                          ? AppColors.success
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 20),

          // ── Bar chart ─────────────────────────────────────
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                maxY: maxVal > 0 ? maxVal * 1.3 : 100,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxVal > 0 ? maxVal / 4 : 25,
                  getDrawingHorizontalLine: (_) =>
                      FlLine(color: Colors.grey.shade100, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, _) {
                        final index = value.toInt();
                        if (index < 0 || index >= entries.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            entries[index].key,
                            style: AppTextStyles.caption(context),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(entries.length, (i) {
                  final current = entries[i].value[0];
                  final comp = entries[i].value[1];
                  return BarChartGroupData(
                    x: i,
                    groupVertically: false,
                    barRods: [
                      BarChartRodData(
                        toY: current,
                        color: current > comp
                            ? AppColors.error
                            : AppColors.primary,
                        width: period == AnalyticsPeriod.year ? 8 : 14,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                      BarChartRodData(
                        toY: comp,
                        color: Colors.grey.shade300,
                        width: period == AnalyticsPeriod.year ? 8 : 14,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final label = entries[groupIndex].key;
                      final isCurrentRod = rodIndex == 0;
                      return BarTooltipItem(
                        '${isCurrentRod ? _currentLabel : _comparisonLabel} ($label)\n'
                        '₹ ${fmt.format(rod.toY)}',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ── Legend ────────────────────────────────────────
          Row(
            children: [
              _legendDot(AppColors.primary),
              const SizedBox(width: 6),
              Text(_currentLabel, style: AppTextStyles.small(context)),
              const SizedBox(width: 16),
              _legendDot(Colors.grey.shade300),
              const SizedBox(width: 6),
              Text(_comparisonLabel, style: AppTextStyles.small(context)),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(color: AppColors.surfaceLight),
          const SizedBox(height: 14),

          // ── Prescriptive insight ──────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.lightbulb_outline_rounded,
                color: AppColors.warning,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  insight,
                  style: AppTextStyles.bodySecondary(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color) => Container(
    width: 10,
    height: 10,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );
}
