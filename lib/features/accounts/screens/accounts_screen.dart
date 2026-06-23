import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/core/constants/colors.dart';
import 'package:profinch_mobile_application/core/constants/fonts_size.dart';
import 'package:provider/provider.dart';

import '../../auth/provider/auth_provider.dart';
import '../provider/account_provider.dart';
import '../widgets/account_card.dart';
import 'account_details_screen.dart';

class AccountsScreen extends StatelessWidget {

  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final authProvider =
        Provider.of<AuthProvider>(context);

    final accountProvider =
        Provider.of<AccountProvider>(context);

    final user = authProvider.currentUser!;

    final accounts =
        accountProvider.getAccountsByUserId(user.id);

    final totalBalance =
        accountProvider.getTotalBalance(user.id);

    return Scaffold(
       backgroundColor: AppColors.lightBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('My Accounts'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryDark,
                    AppColors.primary,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [

                  const Text(
                    "Total Balance",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "₹ ${totalBalance.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppFontSize.xxl(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: accounts.length,
                itemBuilder: (_, index) { 
                  final account = accounts[index];

                  return AccountCard(
                    // light blue
                    account: account,
                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AccountDetailsScreen(
                                account: account,
                              ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}