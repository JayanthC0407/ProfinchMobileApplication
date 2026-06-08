import 'package:flutter/material.dart';

class CurrencyConverterScreen
    extends StatefulWidget {

  const CurrencyConverterScreen({
    super.key,
  });

  @override
  State<CurrencyConverterScreen>
      createState() =>
          _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState
    extends State<
        CurrencyConverterScreen> {

  final amountController =
      TextEditingController();

  String fromCurrency = "USD";
  String toCurrency = "INR";

  double convertedAmount = 0;

  final Map<String, double> rates = {
    "USD": 83.50,
    "EUR": 91.20,
    "GBP": 106.00,
    "AED": 22.70,
    "INR": 1.0,
  };

  void calculateForex() {

    if (amountController.text.isEmpty) {
      return;
    }

    final amount =
        double.parse(
      amountController.text,
    );

    final amountInInr =
        amount * rates[fromCurrency]!;

    final converted =
        amountInInr /
            rates[toCurrency]!;

    setState(() {

      convertedAmount =
          converted;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Currency Converter",
        ),
      ),

      body: Padding(
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
                    "Amount",
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            DropdownButtonFormField<String>(
              initialValue:
                  fromCurrency,

              decoration:
                  const InputDecoration(
                labelText:
                    "From Currency",
              ),

              items:
                  rates.keys.map(
                (currency) {

                  return DropdownMenuItem(
                    value:
                        currency,

                    child:
                        Text(currency),
                  );
                },
              ).toList(),

              onChanged:
                  (value) {

                setState(() {

                  fromCurrency =
                      value!;
                });
              },
            ),

            const SizedBox(
              height: 16,
            ),

            DropdownButtonFormField<String>(
              initialValue:
                  toCurrency,

              decoration:
                  const InputDecoration(
                labelText:
                    "To Currency",
              ),

              items:
                  rates.keys.map(
                (currency) {

                  return DropdownMenuItem(
                    value:
                        currency,

                    child:
                        Text(currency),
                  );
                },
              ).toList(),

              onChanged:
                  (value) {

                setState(() {

                  toCurrency =
                      value!;
                });
              },
            ),

            const SizedBox(
              height: 24,
            ),

            SizedBox(
              width:
                  double.infinity,

              child: ElevatedButton(
                onPressed:
                    calculateForex,

                child: const Text(
                  "Convert",
                ),
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            if (convertedAmount > 0)

              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.all(
                    20,
                  ),

                  child: Column(
                    children: [

                      const Text(
                        "Converted Amount",
                        style:
                            TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Text(
                        "${convertedAmount.toStringAsFixed(2)} $toCurrency",

                        style:
                            const TextStyle(
                          fontSize: 24,
                          fontWeight:
                              FontWeight.bold,
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