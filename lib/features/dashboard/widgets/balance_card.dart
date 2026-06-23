import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/core/constants/colors.dart';
import 'package:profinch_mobile_application/core/constants/text_styles.dart';
import 'package:profinch_mobile_application/core/utils/responsive_text.dart';

class BalanceCard extends StatelessWidget {
  final String accountNumber;
  final String accountType;
  final double balance;
  final List accounts;
  final String selectedAccountId;
  final bool isBalanceHidden;
  final VoidCallback onToggleVisibility;
  final Function(String?) onChanged;

  const BalanceCard({
    super.key,
    required this.accountNumber,
    required this.accountType,
    required this.balance,
    required this.accounts,
    required this.selectedAccountId,
    required this.isBalanceHidden,
    required this.onToggleVisibility,
    required this.onChanged,
  });

  // Card-specific colours — these purples/navies are unique to this widget
  // and don't belong in AppColors.
  static const _cardGradientEnd    = Color.fromARGB(255, 205, 211, 233);
  static const _labelColor         = Color.fromARGB(179, 4, 27, 107);
  static const _amountColor        = Color.fromARGB(255, 31, 4, 122);
  static const _dropdownBg         = Color.fromARGB(255, 8, 18, 162);
  static const _accountNumberColor = Color.fromARGB(179, 55, 3, 133);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [AppColors.light, _cardGradientEnd],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Balance",
                style: AppTextStyles.title(context, color: _labelColor),
              ),

              // 👁 Eye toggle button
              GestureDetector(
                onTap: onToggleVisibility,
                child: Icon(
                  isBalanceHidden ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Text(
            isBalanceHidden ? '₹ ••••••' : '₹ ${balance.toStringAsFixed(2)}',
            style: TextStyle(
              color: _amountColor,
              fontSize: RT.fs(context, 34),   // display size — kept as RT.fs
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: _dropdownBg.withValues(alpha: 0.15),
            ),
            child: DropdownButton<String>(
              value: selectedAccountId,
              underline: const SizedBox(),
              items: accounts.map<DropdownMenuItem<String>>((account) {
                return DropdownMenuItem<String>(
                  value: account.id,
                  child: Text(account.accountType),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            isBalanceHidden
                ? '•••• •••• ${accountNumber.substring(accountNumber.length - 4)}'
                : accountNumber,
            style: AppTextStyles.body(context, color: _accountNumberColor),
          ),
        ],
      ),
    );
  }
}