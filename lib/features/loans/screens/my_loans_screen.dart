import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/provider/auth_provider.dart';
import '../provider/loan_provider.dart';
import '../widgets/loan_card.dart';
import 'loan_details_screen.dart';

class MyLoansScreen extends StatelessWidget {

  const MyLoansScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final authProvider =
        Provider.of<AuthProvider>(
      context,
    );

    final loanProvider =
        Provider.of<LoanProvider>(
      context,
    );

    final user =
        authProvider.currentUser!;

    final loans =
        loanProvider.getLoansByUser(
      user.id,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Loans",
        ),
      ),

      body: ListView.builder(
        itemCount: loans.length,

        itemBuilder:
            (context, index) {

          final loan =
              loans[index];

          return LoanCard(
            loan: loan,

            onTap: () {

              Navigator.push(
                context,

                MaterialPageRoute(
                  builder: (_) =>
                      LoanDetailsScreen(
                    loan: loan,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}