import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/core/constants/colors.dart';
import 'package:provider/provider.dart';

import '../../auth/provider/auth_provider.dart';
import '../provider/term_deposit_provider.dart';

class TermDepositStatementScreen
    extends StatelessWidget {

  const TermDepositStatementScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final authProvider =
        Provider.of<AuthProvider>(
      context,
    );

    final tdProvider =
        Provider.of<TermDepositProvider>(
      context,
    );

    final user =
        authProvider.currentUser!;

    final deposits =
        tdProvider.getDepositsByUserId(
      user.id,
    );

    return Scaffold(

       backgroundColor: AppColors.lightblue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Deposit Statements",
        ),
      ),

      body: ListView.builder(
        itemCount: deposits.length,

        itemBuilder:
            (context, index) {

          final deposit =
              deposits[index];

          return Card(
            margin:
                const EdgeInsets.all(12),

            child: ListTile(
              title: Text(
                "FD ${deposit.id}",
              ),

              subtitle: Text(
                "Principal ₹${deposit.principalAmount.toStringAsFixed(2)}"
                "\nMaturity ₹${deposit.maturityAmount.toStringAsFixed(2)}",
              ),

              trailing: Text(
                deposit.status,
              ),
            ),
          );
        },
      ),
    );
  }
}