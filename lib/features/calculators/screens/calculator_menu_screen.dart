import 'package:flutter/material.dart';

import '../widgets/calculator_card.dart';

class CalculatorMenuScreen
    extends StatelessWidget {

  const CalculatorMenuScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Financial Calculators",
        ),
      ),

      body: ListView(
        padding:
            const EdgeInsets.all(12),

        children: [

          CalculatorCard(
            title:
                "EMI Calculator",

            icon:
                Icons.calculate,

            onTap: () {

              Navigator.pushNamed(
                context,
                '/emiCalculator',
              );
            },
          ),

          CalculatorCard(
            title:
                "Loan Eligibility Calculator",

            icon:
                Icons.account_balance,

            onTap: () {

              Navigator.pushNamed(
                context,
                '/loanEligibility',
              );
            },
          ),

          CalculatorCard(
            title:
                "Term Deposit Calculator",

            icon:
                Icons.savings,

            onTap: () {

              Navigator.pushNamed(
                context,
                '/tdCalculator',
              );
            },
          ),

          CalculatorCard(
            title:
                "Currency Converter",

            icon:
                Icons.swap_horiz,

            onTap: () {

              Navigator.pushNamed(
                context,
                '/currencyConverter',
              );
            },
          ),

          CalculatorCard(
            title:
                "SIP Calculator",

            icon:
                Icons.trending_up,

            onTap: () {

              Navigator.pushNamed(
                context,
                '/sipCalculator',
              );
            },
          ),
        ],
      ),
    );
  }
}