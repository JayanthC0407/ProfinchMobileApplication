import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/data/models/account_model.dart';

class AccountDetailsScreen extends StatelessWidget {

  final AccountModel account;

  const AccountDetailsScreen({
    super.key,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Account Details"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            ListTile(
              title: const Text("Account Number"),
              subtitle: Text(account.accountNumber),
            ),

            ListTile(
              title: const Text("Account Type"),
              subtitle: Text(account.accountType),
            ),

            ListTile(
              title: const Text("Branch"),
              subtitle: Text(account.branchName),
            ),

            ListTile(
              title: const Text("IFSC"),
              subtitle: Text(account.ifscCode),
            ),

            ListTile(
              title: const Text("Balance"),
              subtitle: Text(
                "₹ ${account.balance}",
              ),
            ),

            ListTile(
              title: const Text("Available Balance"),
              subtitle: Text(
                "₹ ${account.availableBalance}",
              ),
            ),

            ListTile(
              title: const Text("Status"),
              subtitle: Text(
                account.isActive
                    ? "Active"
                    : "Inactive",
              ),
            ),
          ],
        ),
      ),
    );
  }
}