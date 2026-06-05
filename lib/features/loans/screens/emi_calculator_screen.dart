import 'package:flutter/material.dart';
import 'dart:math';

class EmiCalculatorScreen extends StatefulWidget {
  const EmiCalculatorScreen({super.key});

  @override
  State<EmiCalculatorScreen> createState() => _EmiCalculatorScreenState();
}

class _EmiCalculatorScreenState extends State<EmiCalculatorScreen> {
  final amountController = TextEditingController();

  final rateController = TextEditingController();

  final tenureController = TextEditingController();

  double emi = 0;

  void calculateEmi() {
    final p = double.parse(amountController.text);

    final annualRate = double.parse(rateController.text);

    final n = int.parse(tenureController.text);

    final r = annualRate / 12 / 100;

    final result = p * r * (pow(1 + r, n) / (pow(1 + r, n) - 1));

    setState(() {
      emi = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("EMI Calculator")),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            TextField(
              controller: amountController,

              keyboardType: TextInputType.number,

              decoration: const InputDecoration(labelText: "Loan Amount"),
            ),

            TextField(
              controller: rateController,

              keyboardType: TextInputType.number,

              decoration: const InputDecoration(labelText: "Interest Rate"),
            ),

            TextField(
              controller: tenureController,

              keyboardType: TextInputType.number,

              decoration: const InputDecoration(labelText: "Tenure (Months)"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: calculateEmi,

              child: const Text("Calculate"),
            ),

            const SizedBox(height: 30),

            Text(
              "EMI : ₹${emi.toStringAsFixed(2)}",

              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
