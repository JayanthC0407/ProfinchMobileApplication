import 'dart:math';

import 'package:flutter/material.dart';

class SipCalculatorScreen extends StatefulWidget {

  const SipCalculatorScreen({
    super.key,
  });

  @override
  State<SipCalculatorScreen> createState() =>
      _SipCalculatorScreenState();
}

class _SipCalculatorScreenState
    extends State<SipCalculatorScreen> {

  final sipController =
      TextEditingController();

  final returnController =
      TextEditingController();

  final yearsController =
      TextEditingController();

  double investedAmount = 0;
  double estimatedReturns = 0;
  double futureValue = 0;

  void calculateSip() {

    if (sipController.text.isEmpty ||
        returnController.text.isEmpty ||
        yearsController.text.isEmpty) {
      return;
    }

    final monthlySip =
        double.parse(
      sipController.text,
    );

    final annualReturn =
        double.parse(
      returnController.text,
    );

    final years =
        int.parse(
      yearsController.text,
    );

    final monthlyRate =
        annualReturn / 12 / 100;

    final months =
        years * 12;

    final maturityAmount =
        monthlySip *
            ((pow(
                      1 + monthlyRate,
                      months,
                    ) -
                    1) /
                monthlyRate) *
            (1 + monthlyRate);

    final invested =
        monthlySip * months;

    setState(() {

      investedAmount =
          invested;

      futureValue =
          maturityAmount;

      estimatedReturns =
          futureValue -
              investedAmount;
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "SIP Calculator",
        ),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          children: [

            TextField(
              controller:
                  sipController,

              keyboardType:
                  TextInputType.number,

              decoration:
                  const InputDecoration(
                labelText:
                    "Monthly SIP Amount",
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            TextField(
              controller:
                  returnController,

              keyboardType:
                  TextInputType.number,

              decoration:
                  const InputDecoration(
                labelText:
                    "Expected Annual Return (%)",
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            TextField(
              controller:
                  yearsController,

              keyboardType:
                  TextInputType.number,

              decoration:
                  const InputDecoration(
                labelText:
                    "Investment Period (Years)",
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
                    calculateSip,

                child: const Text(
                  "Calculate SIP",
                ),
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            if (futureValue > 0)

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
                        "Investment Summary",
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
                          "Invested Amount",
                        ),

                        trailing: Text(
                          "₹${investedAmount.toStringAsFixed(2)}",
                        ),
                      ),

                      ListTile(
                        title: const Text(
                          "Estimated Returns",
                        ),

                        trailing: Text(
                          "₹${estimatedReturns.toStringAsFixed(2)}",
                        ),
                      ),

                      const Divider(),

                      ListTile(
                        title: const Text(
                          "Future Value",
                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        trailing: Text(
                          "₹${futureValue.toStringAsFixed(2)}",

                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight.bold,
                            fontSize: 18,
                          ),
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