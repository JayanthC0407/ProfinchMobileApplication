import 'package:flutter/material.dart';

class LoanEligibilityScreen
    extends StatefulWidget {

  const LoanEligibilityScreen({
    super.key,
  });

  @override
  State<LoanEligibilityScreen>
      createState() =>
          _LoanEligibilityScreenState();
}

class _LoanEligibilityScreenState
    extends State<
        LoanEligibilityScreen> {

  final incomeController =
      TextEditingController();

  final existingEmiController =
      TextEditingController();

  final tenureController =
      TextEditingController();

  double maxEmiCapacity = 0;
  double eligibleLoanAmount = 0;

  void calculateEligibility() {

    if (incomeController.text.isEmpty ||
        existingEmiController.text.isEmpty ||
        tenureController.text.isEmpty) {
      return;
    }

    final monthlyIncome =
        double.parse(
      incomeController.text,
    );

    final existingEmi =
        double.parse(
      existingEmiController.text,
    );

    final tenureMonths =
        int.parse(
      tenureController.text,
    );

    // Bank generally allows 50% of income
    final allowableEmi =
        (monthlyIncome * 0.5) -
            existingEmi;

    if (allowableEmi <= 0) {

      setState(() {

        maxEmiCapacity = 0;
        eligibleLoanAmount = 0;
      });

      return;
    }

    // Approximation
    final loanAmount =
        allowableEmi *
            tenureMonths;

    setState(() {

      maxEmiCapacity =
          allowableEmi;

      eligibleLoanAmount =
          loanAmount;
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Loan Eligibility Calculator",
        ),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          children: [

            TextField(
              controller:
                  incomeController,

              keyboardType:
                  TextInputType.number,

              decoration:
                  const InputDecoration(
                labelText:
                    "Monthly Income",
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            TextField(
              controller:
                  existingEmiController,

              keyboardType:
                  TextInputType.number,

              decoration:
                  const InputDecoration(
                labelText:
                    "Existing EMI",
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
                    "Loan Tenure (Months)",
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
                    calculateEligibility,

                child: const Text(
                  "Check Eligibility",
                ),
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            if (eligibleLoanAmount > 0)

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
                        "Eligibility Result",
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
                          "Maximum EMI Capacity",
                        ),

                        trailing: Text(
                          "₹${maxEmiCapacity.toStringAsFixed(2)}",
                        ),
                      ),

                      ListTile(
                        title: const Text(
                          "Eligible Loan Amount",
                        ),

                        trailing: Text(
                          "₹${eligibleLoanAmount.toStringAsFixed(2)}",
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