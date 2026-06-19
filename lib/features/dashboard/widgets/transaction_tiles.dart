import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/core/constants/fonts_size.dart';

class TransactionTile extends StatelessWidget {

  final String title;
  final String subtitle;
  final String amount;
  final Color amountColor;
  final IconData icon;
  final Color iconBg;

  const TransactionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.amountColor,
    required this.icon,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Row(
        children: [

          CircleAvatar(
            radius: 24,
            backgroundColor: iconBg,
            child: Icon(
              icon,
              color: Colors.black87,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppFontSize.large(context),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 90, 87, 87),
                  ),
                )
              ],
            ),
          ),

          Text(
            amount,
            style: TextStyle(
              color: amountColor,
              fontWeight: FontWeight.bold,
              fontSize: AppFontSize.medium(context),
            ),
          )
        ],
      ),
    );
  }
}