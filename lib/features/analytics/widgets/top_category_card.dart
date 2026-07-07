import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:profinch_mobile_application/core/constants/colors.dart';
import '../../../data/models/transaction_model.dart';

class TopCategoryCard extends StatelessWidget {
  final TransactionCategory category;
  final double amount;

  const TopCategoryCard({Key? key, required this.category, required this.amount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: 'AED ', decimalDigits: 2);
    String catName = category.toString().split('.').last.toUpperCase();

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.iconBackground, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.stars, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('HIGHEST EXPENSE', style: TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(catName, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Text(currencyFormat.format(amount), style: const TextStyle(color: AppColors.error, fontSize: 16, fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }
}