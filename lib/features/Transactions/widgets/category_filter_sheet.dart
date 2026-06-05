import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/core/constants/colors.dart';
import 'package:profinch_mobile_application/data/models/transaction_model.dart';

class CategoryFilterSheet extends StatelessWidget {
  final TransactionCategory? selected;
  final ValueChanged<TransactionCategory?> onSelected;

  const CategoryFilterSheet({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  static const _categories = [
    (TransactionCategory.salary,      'Salary',     Icons.account_balance_outlined),
    (TransactionCategory.food,        'Food',       Icons.restaurant_outlined),
    (TransactionCategory.shopping,    'Shopping',   Icons.shopping_bag_outlined),
    (TransactionCategory.upi,         'UPI',        Icons.phone_android_outlined),
    (TransactionCategory.billPayment, 'Bills',      Icons.receipt_outlined),
    (TransactionCategory.recharge,    'Recharge',   Icons.sim_card_outlined),
    (TransactionCategory.emi,         'EMI',        Icons.home_outlined),
    (TransactionCategory.atm,         'ATM',        Icons.atm_outlined),
    (TransactionCategory.transfer,    'Transfer',   Icons.swap_horiz_outlined),
    (TransactionCategory.refund,      'Refund',     Icons.replay_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Header ────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter by Category',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              if (selected != null)
                TextButton(
                  onPressed: () {
                    onSelected(null);
                    Navigator.pop(context);
                  },
                  child: const Text('Clear'),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Category grid ─────────────────────────────────────
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.85,
            children: _categories.map((item) {
              final isSelected = selected == item.$1;
              return GestureDetector(
                onTap: () {
                  onSelected(item.$1);
                  Navigator.pop(context);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryDark
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected
                        ? Border.all(color: AppColors.primary, width: 1.5)
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item.$3,
                        size: 22,
                        color: isSelected
                            ? Colors.white
                            : Colors.grey.shade600,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        item.$2,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : Colors.grey.shade700,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}