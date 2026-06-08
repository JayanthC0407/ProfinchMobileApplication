import 'dart:math';

import 'package:flutter/material.dart';

class TermDepositCalculatorScreen
    extends StatefulWidget {

  const TermDepositCalculatorScreen({
    super.key,
  });

  @override
  State<TermDepositCalculatorScreen>
      createState() =>
          _TermDepositCalculatorScreenState();
}

class _TermDepositCalculatorScreenState
    extends State<
        TermDepositCalculatorScreen> {

  final amountController =
      TextEditingController();

  final rateController =
      TextEditingController();

  final tenureController =
      TextEditingController();

  double maturityAmount = 0;
  double interestEarned = 0;

  void calculate() {

    if (amountController.text.isEmpty ||
        rateController.text.isEmpty ||
        tenureController.text.isEmpty) {
      return;
    }

    final principal =
        double.parse(
      amountController.text,
    );

    final annualRate =
        double.parse(
      rateController.text,
    );

    final months =
        int.parse(
      tenureController.text,
    );

    final years =
        months / 12;

    final maturity =
        principal *
            pow(
              (1 + annualRate / 100),
              years,
            );

    setState(() {

      maturityAmount =
          maturity.toDouble();

      interestEarned =
          maturityAmount -
              principal;
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Term Deposit Calculator",
        ),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          children: [

            TextField(
              controller:
                  amountController,

              keyboardType:
                  TextInputType.number,

              decoration:
                  const InputDecoration(
                labelText:
                    "Deposit Amount",
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            TextField(
              controller:
                  rateController,

              keyboardType:
                  TextInputType.number,

              decoration:
                  const InputDecoration(
                labelText:
                    "Interest Rate (%)",
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            TextField(
              controller:
                  tenureController,

              keyboardType:
                  TextInputType.number,

              decoration:
                  const InputDecoration(
                labelText:
                    "Tenure (Months)",
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            SizedBox(
              width:
                  double.infinity,

              child: ElevatedButton(
                onPressed:
                    calculate,

                child: const Text(
                  "Calculate",
                ),
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            if (maturityAmount > 0)

              Card(
                elevation: 4,

                child: Padding(
                  padding:
                      const EdgeInsets.all(
                    20,
                  ),

                  child: Column(
                    children: [

                      const Text(
                        "Calculation Result",
                        style:
                            TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      ListTile(
                        title: const Text(
                          "Interest Earned",
                        ),

                        trailing: Text(
                          "₹${interestEarned.toStringAsFixed(2)}",
                        ),
                      ),

                      ListTile(
                        title: const Text(
                          "Maturity Amount",
                        ),

                        trailing: Text(
                          "₹${maturityAmount.toStringAsFixed(2)}",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}