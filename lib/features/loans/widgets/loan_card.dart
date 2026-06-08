import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/loan_model.dart';

class LoanCard extends StatelessWidget {

  final LoanModel loan;
  final VoidCallback onTap;

  const LoanCard({
    super.key,
    required this.loan,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: const EdgeInsets.all(12),
      color: AppColors.lightblue,

      child: ListTile(
        onTap: onTap,

        leading: const CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Icon(
            Icons.currency_rupee,
            color: Colors.white,
          ),
        ),

        title: Text(
          loan.loanType,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Text(
          "Outstanding ₹${loan.outstandingAmount.toStringAsFixed(2)}",
        ),

        trailing: Text(
          loan.status,
        ),
      ),
    );
  }
}