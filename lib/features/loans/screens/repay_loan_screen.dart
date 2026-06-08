import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/features/auth/provider/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/colors.dart';
import '../../../data/models/loan_model.dart';
import '../../accounts/provider/account_provider.dart';
import '../provider/loan_provider.dart';

class RepayLoanScreen extends StatefulWidget {
  final LoanModel loan;

  const RepayLoanScreen({super.key, required this.loan});

  @override
  State<RepayLoanScreen> createState() => _RepayLoanScreenState();
}

class _RepayLoanScreenState extends State<RepayLoanScreen> {
  String? selectedAccountId;

  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(context);

    final authProvider = Provider.of<AuthProvider>(context);

    final loanProvider = Provider.of<LoanProvider>(context, listen: false);

    final user = authProvider.currentUser!;

    final accounts = accountProvider.getAccountsByUserId(user.id);

    return Scaffold(
      backgroundColor: AppColors.light,

      appBar: AppBar(
        backgroundColor: Colors.transparent,

        title: const Text("Repay EMI"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Container(
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: AppColors.lightblue,

                borderRadius: BorderRadius.circular(12),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    widget.loan.loanType,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text("EMI: ₹${widget.loan.emiAmount.toStringAsFixed(2)}"),

                  Text(
                    "Outstanding: ₹${widget.loan.outstandingAmount.toStringAsFixed(2)}",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: selectedAccountId,

              items: accounts.map((account) {
                return DropdownMenuItem(
                  value: account.id,

                  child: Text(
                    "${account.accountType} • ${account.accountNumber.substring(account.accountNumber.length - 4)}",
                  ),
                );
              }).toList(),

              onChanged: (value) {
                setState(() {
                  selectedAccountId = value;
                });
              },
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: () {
                  if (selectedAccountId == null) {
                    return;
                  }

                  final selectedAccount = accountProvider.accounts.firstWhere(
                    (account) => account.id == selectedAccountId,
                  );

                  if (selectedAccount.availableBalance <
                      widget.loan.emiAmount) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Insufficient Balance")),
                    );

                    return;
                  }

                  accountProvider.debitAccount(
                    selectedAccountId!,
                    widget.loan.emiAmount,
                  );

                  loanProvider.repayLoan(widget.loan.id, widget.loan.emiAmount);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("EMI Paid Successfully")),
                  );

                  Navigator.pop(context);
                },

                child: const Text("Pay EMI"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
