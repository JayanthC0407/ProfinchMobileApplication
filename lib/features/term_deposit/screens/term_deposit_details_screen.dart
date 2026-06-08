import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/core/constants/colors.dart';

import '../../../data/models/term_deposit_model.dart';
import '../../../data/models/account_model.dart';

class TermDepositDetailsScreen
    extends StatelessWidget {

  final TermDepositModel deposit;

  final AccountModel account;

  const TermDepositDetailsScreen({
    super.key,
    required this.deposit,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {

    Widget sectionTitle(
        String title,
      ) {
        return Padding(
          padding:
              const EdgeInsets.only(
            bottom: 10,
          ),

          child: Text(
            title,

            style: const TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        );
      }

      Widget detailRow(
          String label,
          String value,
        ) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(
              vertical: 8,
            ),

            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,

              children: [

                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),

                Flexible(
                  child: Text(
                    value,

                    textAlign:
                        TextAlign.right,

                    style:
                        const TextStyle(
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

    return Scaffold(
        backgroundColor: AppColors.light,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Deposit Details",
        ),
      ),

      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  gradient: LinearGradient(
                  colors: [
                    AppColors.primaryDark,
                    AppColors.primary,
                  ], 
                ),

                  borderRadius:
                      BorderRadius.circular(20),
                ),

                child: Column(
                  children: [

                    Text(
                      "₹${deposit.maturityAmount.toStringAsFixed(2)}",

                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight:
                            FontWeight.bold,
                        color: AppColors.light, // light blue
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Maturity Amount",
                    ),

                    const SizedBox(height: 16),

                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),

                      decoration: BoxDecoration(
                        color: deposit.status ==
                                "ACTIVE"
                            ? Colors.green
                            : Colors.grey,

                        borderRadius:
                            BorderRadius.circular(
                          20,
                        ),
                      ),

                      child: Text(
                        deposit.status,

                        style: const TextStyle(
                          color: Color.fromARGB(255, 252, 255, 252),
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              sectionTitle(
                "Deposit Information",
              ),

              detailRow(
                "Deposit ID",
                deposit.id,
              ),

              detailRow(
                "Principal Amount",
                "₹${deposit.principalAmount.toStringAsFixed(2)}",
              ),

              detailRow(
                "Interest Rate",
                "${deposit.interestRate}%",
              ),

              detailRow(
                "Tenure",
                "${deposit.tenureMonths} Months",
              ),

              const SizedBox(height: 25),

              sectionTitle("Timeline"),

              detailRow(
                "Opening Date",
                deposit.startDate
                    .toString()
                    .split(" ")
                    .first,
              ),

              detailRow(
                "Maturity Date",
                deposit.maturityDate
                    .toString()
                    .split(" ")
                    .first,
              ),

              const SizedBox(height: 25),

              sectionTitle(
                "Funding Account",
              ),

              detailRow(
                "Account Type",
                account.accountType,
              ),

              detailRow(
                "Account Number",
                account.accountNumber,
              ),

              const SizedBox(height: 25),

              sectionTitle(
                "Interest Earned",
              ),

              Text(
                "₹${(deposit.maturityAmount - deposit.principalAmount).toStringAsFixed(2)}",

                style: const TextStyle(
                  fontSize: 26,
                  fontWeight:
                      FontWeight.bold,
                  color:
                      Colors.green,
                ),
              ),
            ],
          ),
        ),
    );
  }
}