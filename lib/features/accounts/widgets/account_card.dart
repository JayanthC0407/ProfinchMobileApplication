import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/core/constants/colors.dart';
import 'package:profinch_mobile_application/data/models/account_model.dart';
import 'package:profinch_mobile_application/core/constants/fonts_size.dart';

class AccountCard extends StatelessWidget {

  final AccountModel account;
  final VoidCallback onTap;

  const AccountCard({
    super.key,
    required this.account,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
// ... inside your AccountCard class build method
return InkWell(
  onTap: onTap,
  child: Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: AppColors.light, 
      borderRadius: BorderRadius.circular(20),
    ),
    // Use a Row layout to position things side-by-side
    child: Row(
      children: [
        // Wrap everything on the left inside an Expanded block
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                account.accountType,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppFontSize.large(context),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                account.accountNumber,
              ),
              const SizedBox(height: 10),
              Text(
                "₹ ${account.availableBalance.toStringAsFixed(2)}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: account.availableBalance < 0 ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
        ),
        // The arrow icon remains perfectly centered on the right edge
        Icon(
          Icons.chevron_right,
          color: Colors.grey.shade400,
          size: 24,
        ),
      ],
    ),
  ),
);

  }
}