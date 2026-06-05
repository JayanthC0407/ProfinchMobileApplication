import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/core/constants/colors.dart';
import 'package:profinch_mobile_application/core/routes/app_routes.dart';

import '../widgets/loan_type_card.dart';

class LoansScreen extends StatelessWidget {

  const LoansScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.light,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Loans"),
      ),

      body: ListView(
        children: [

          LoanTypeCard(
            title: "My Loans",
            icon: Icons.account_balance,

            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.myLoans,
              );
            },
          ),

          LoanTypeCard(
            title: "Apply Loan",
            icon: Icons.add_circle,

            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.applyLoan,
              );
            },
          ),

          LoanTypeCard(
            title: "EMI Calculator",
            icon: Icons.calculate,

            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.emiCalculator,
              );
            },
          ),

         /* LoanTypeCard(
            title: "Statements",
            icon: Icons.receipt_long,

            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.loanStatements,
              );
            },
          ),*/
        ],
      ),
    );
  }
}