import 'package:flutter/material.dart';
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

      appBar: AppBar(
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
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [

                  const Text(
                    "Total Balance",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "₹ ${totalBalance.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
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