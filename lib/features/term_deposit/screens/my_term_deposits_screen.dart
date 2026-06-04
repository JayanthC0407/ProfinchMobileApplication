import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/core/constants/colors.dart';
import 'package:provider/provider.dart';

import '../../auth/provider/auth_provider.dart';
import '../provider/term_deposit_provider.dart';

import '../../accounts/provider/account_provider.dart';
import 'term_deposit_details_screen.dart';

class MyTermDepositsScreen
    extends StatelessWidget {

  const MyTermDepositsScreen({
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

    final accountProvider =
        Provider.of<AccountProvider>(
      context,
    );

    return Scaffold(
       backgroundColor: AppColors.lightblue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title:
            const Text("My Deposits"),
      ),

      body: ListView.builder(
        itemCount: deposits.length,

        itemBuilder:
            (context, index) {

          final deposit =
              deposits[index];
          
          final account =
              accountProvider.getAccountById(
            deposit.sourceAccountId,
          );

          return Card(
            margin:
                const EdgeInsets.all(12),
            color: AppColors.light, // light blue
            child: ListTile(

                onTap: () {

                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (_) =>
                          TermDepositDetailsScreen(
                        deposit: deposit,
                        account: account,
                      ),
                    ),
                  );
                },

                title: Text(
                  "₹${deposit.principalAmount.toStringAsFixed(2)}",
                ),

                subtitle: Text(
                  "${deposit.tenureMonths} Months",
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