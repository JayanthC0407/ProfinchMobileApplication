import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/core/constants/colors.dart';
import 'package:provider/provider.dart';

import '../../../data/models/term_deposit_model.dart';
import '../../accounts/provider/account_provider.dart';
import '../../auth/provider/auth_provider.dart';
import '../provider/term_deposit_provider.dart';

class OpenTermDepositScreen
    extends StatefulWidget {

  const OpenTermDepositScreen({
    super.key,
  });

  @override
  State<OpenTermDepositScreen>
      createState() =>
          _OpenTermDepositScreenState();
}

class _OpenTermDepositScreenState
    extends State<
        OpenTermDepositScreen> {

  String? selectedAccountId;

  int tenureMonths = 12;

  final amountController =
      TextEditingController();

  double getInterestRate() {

    switch (tenureMonths) {
      case 3:
        return 5.5;

      case 6:
        return 6.0;

      case 12:
        return 7.0;

      case 24:
        return 7.5;

      default:
        return 8.0;
    }
  }

  @override
  Widget build(BuildContext context) {

    final authProvider =
        Provider.of<AuthProvider>(
      context,
    );

    final accountProvider =
        Provider.of<AccountProvider>(
      context,
    );

    final tdProvider =
        Provider.of<TermDepositProvider>(
      context,
      listen: false,
    );

    final user =
        authProvider.currentUser!;

    final accounts =
        accountProvider
            .getAccountsByUserId(
      user.id,
    );

    selectedAccountId ??=
        accounts.first.id;

    return Scaffold(

       backgroundColor: Colors.white, // light background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title:
            const Text("Open Deposit"),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          children: [

            DropdownButtonFormField<
                String>(
              initialValue:
                  selectedAccountId,

              items:
                  accounts.map((a) {

                return DropdownMenuItem(
                  value: a.id,
                  child: Text(
                    "${a.accountType} • ${a.accountNumber.substring(a.accountNumber.length - 4)}",
                  ),
                );
              }).toList(),

              onChanged: (value) {

                setState(() {
                  selectedAccountId =
                      value;
                });
              },
            ),

            const SizedBox(height: 20),

            TextField(
              controller:
                  amountController,

              keyboardType:
                  TextInputType.number,

              decoration:
                  const InputDecoration(
                labelText:
                    "Deposit Amount",
              ),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<int>(
              initialValue:
                  tenureMonths,

              items: const [

                DropdownMenuItem(
                  value: 3,
                  child: Text(
                    "3 Months",
                  ),
                ),

                DropdownMenuItem(
                  value: 6,
                  child: Text(
                    "6 Months",
                  ),
                ),

                DropdownMenuItem(
                  value: 12,
                  child: Text(
                    "12 Months",
                  ),
                ),

                DropdownMenuItem(
                  value: 24,
                  child: Text(
                    "24 Months",
                  ),
                ),
              ],

              onChanged: (value) {

                setState(() {
                  tenureMonths =
                      value!;
                });
              },
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {

                final amount =
                    double.tryParse(
                          amountController
                              .text,
                        ) ??
                        0;

                if (amount <= 0) {
                  return;
                }

                final rate =
                    getInterestRate();

                final maturity =
                    amount +
                        (amount *
                            rate /
                            100);

                accountProvider
                    .debitAccount(
                  selectedAccountId!,
                  amount,
                );

                tdProvider
                    .addDeposit(
                  TermDepositModel(
                    id:
                        "TD${DateTime.now().millisecondsSinceEpoch}",
                    userId:
                        user.id,
                    sourceAccountId:
                        selectedAccountId!,
                    principalAmount:
                        amount,
                    interestRate:
                        rate,
                    tenureMonths:
                        tenureMonths,
                    startDate:
                        DateTime.now(),
                    maturityDate:
                        DateTime.now()
                            .add(
                      Duration(
                        days:
                            tenureMonths *
                                30,
                      ),
                    ),
                    maturityAmount:
                        maturity,
                    status:
                        "ACTIVE",
                  ),
                );

                Navigator.pop(
                    context);
              },
              child: const Text(
                "Open Deposit",
              ),
            ),
          ],
        ),
      ),
    );
  }
}