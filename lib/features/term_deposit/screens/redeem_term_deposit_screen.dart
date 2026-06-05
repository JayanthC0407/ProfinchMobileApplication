import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/core/constants/colors.dart';
import 'package:provider/provider.dart';

import '../../accounts/provider/account_provider.dart';
import '../../auth/provider/auth_provider.dart';
import '../provider/term_deposit_provider.dart';

class RedeemTermDepositScreen
    extends StatelessWidget {

  const RedeemTermDepositScreen({
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

    final accountProvider =
        Provider.of<AccountProvider>(
      context,
      listen: false,
    );

    final user =
        authProvider.currentUser!;

    final deposits =
        tdProvider.getActiveDeposits(
      user.id,
    );

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Redeem Deposit",
        ),
      ),

      body: ListView.builder(
        itemCount: deposits.length,

        itemBuilder:
            (context, index) {

          final deposit =
              deposits[index];

          return Card(
            color: AppColors.lightblue, // light blue
            elevation: 4,
            margin:
                const EdgeInsets.all(12),

            child: ListTile(
              title: Text(
                "₹${deposit.principalAmount.toStringAsFixed(2)}",
              ),

              subtitle: Text(
                "Maturity ₹${deposit.maturityAmount.toStringAsFixed(2)}",
              ),

              trailing:
                  ElevatedButton(
                onPressed: () async {

                  final shouldRedeem =
                      await showDialog<bool>(
                    context: context,

                    builder: (context) {

                      return AlertDialog(
                        title: const Text(
                          "Redeem Term Deposit",
                        ),

                        content: Column(
                          mainAxisSize:
                              MainAxisSize.min,

                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            Text(
                              "Principal Amount: ₹${deposit.principalAmount.toStringAsFixed(2)}",
                            ),

                            const SizedBox(height: 8),

                            Text(
                              "Interest Rate: ${deposit.interestRate}%",
                            ),

                            const SizedBox(height: 8),

                            Text(
                              "Tenure: ${deposit.tenureMonths} Months",
                            ),

                            const SizedBox(height: 12),

                            Text(
                              "Maturity Amount: ₹${deposit.maturityAmount.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 16),

                            const Text(
                              "Do you really want to redeem this term deposit?",
                            ),
                          ],
                        ),

                        actions: [

                          TextButton(
                            onPressed: () {
                              Navigator.pop(
                                context,
                                false,
                              );
                            },
                            child:
                                const Text("No"),
                          ),

                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(
                                context,
                                true,
                              );
                            },
                            child:
                                const Text("Yes"),
                          ),
                        ],
                      );
                    },
                  );

                  if (shouldRedeem != true) {
                    return;
                  }

                  accountProvider.creditAccount(
                    deposit.sourceAccountId,
                    deposit.maturityAmount,
                  );

                  tdProvider.redeemDeposit(
                    deposit.id,
                  );

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content: Text(
                        "₹${deposit.maturityAmount.toStringAsFixed(2)} redeemed successfully",
                      ),
                    ),
                  );
                },
                child:
                    const Text(
                  "Redeem",
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}