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
            Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(255, 205, 211, 233),
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
                  color: Color.fromARGB(179, 4, 27, 107),
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
              color: Color.fromARGB(255, 31, 4, 122),
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
              color: const Color.fromARGB(255, 8, 18, 162).withValues(alpha: 0.15),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [

                Text(
                  "Savings Account",
                  style: TextStyle(
                    color: Color.fromARGB(255, 51, 3, 141),
                  ),
                ),

                SizedBox(width: 8),

                Icon(
                  Icons.keyboard_arrow_down,
                  color: Color.fromARGB(255, 18, 3, 101),
                )
              ],
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            "Account No. 1234 5678 9012",
            style: TextStyle(
              color: Color.fromARGB(179, 55, 3, 133),
            ),
          )
        ],
      ),
    );
  }
}