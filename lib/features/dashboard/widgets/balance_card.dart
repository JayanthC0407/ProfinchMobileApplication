import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {

  final double balance;

  const BalanceCard({
    super.key,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [
            Color(0xff001F8B),
            Color(0xff0052FF),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [

              Text(
                "Total Balance",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),

              Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            ],
          ),

          const SizedBox(height: 18),

          Text(
            "₹${balance.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white.withValues(alpha: 0.15),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [

                Text(
                  "Savings Account",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),

                SizedBox(width: 8),

                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                )
              ],
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            "Account No. 1234 5678 9012",
            style: TextStyle(
              color: Colors.white70,
            ),
          )
        ],
      ),
    );
  }
}