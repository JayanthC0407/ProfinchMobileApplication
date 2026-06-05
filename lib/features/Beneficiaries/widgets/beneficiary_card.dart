import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/core/constants/colors.dart';

class BeneficiaryCard extends StatelessWidget {

  final String name;
  final String accountNumber;
  final String type;
  final VoidCallback onTap;

  const BeneficiaryCard({
    super.key,
    required this.name,
    required this.accountNumber,
    required this.type,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      color: AppColors.lightblue,
      elevation: 3,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),

      child: ListTile(
        onTap: onTap,

        leading: CircleAvatar(
          backgroundColor:
              Colors.blue.shade100,

          child: Icon(
            Icons.person,
            color: Colors.blue.shade800,
          ),
        ),

        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Text(
          "••••${accountNumber.substring(accountNumber.length - 4)}",
        ),

        trailing: Container(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 4,
          ),

          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius:
                BorderRadius.circular(12),
          ),

          child: Text(
            type,
            style: TextStyle(
              color: Colors.blue.shade800,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}