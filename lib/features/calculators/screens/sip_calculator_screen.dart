import 'dart:math';

import 'package:flutter/material.dart';

class SipCalculatorScreen extends StatefulWidget {
  const SipCalculatorScreen({super.key});

  @override
  State<SipCalculatorScreen> createState() => _SipCalculatorScreenState();
}

class _SipCalculatorScreenState extends State<SipCalculatorScreen> {
  final sipController = TextEditingController();
  final returnController = TextEditingController();
  final yearsController = TextEditingController();

  double investedAmount = 0;
  double estimatedReturns = 0;
  double futureValue = 0;

  void calculateSip() {
    if (sipController.text.isEmpty ||
        returnController.text.isEmpty ||
        yearsController.text.isEmpty) {
      return;
    }

    final monthlySip = double.parse(sipController.text);
    final annualReturn = double.parse(returnController.text);
    final years = int.parse(yearsController.text);

    final monthlyRate = annualReturn / 12 / 100;
    final months = years * 12;

    final maturityAmount = monthlySip *
        ((pow(1 + monthlyRate, months) - 1) / monthlyRate) *
        (1 + monthlyRate);

    final invested = monthlySip * months;

    setState(() {
      investedAmount = invested;
      futureValue = maturityAmount;
      estimatedReturns = futureValue - investedAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F0FE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: Color(0xFF1565C0),
              ),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        title: const Padding(
          padding: EdgeInsets.only(left: 8),
          child: Text(
            "SIP Calculator",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0D1B3E),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info banner
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F0FE),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: const [
                  Icon(Icons.trending_up_rounded,
                      size: 16, color: Color(0xFF1565C0)),
                  SizedBox(width: 8),
                  Text(
                    "Start small, grow big — estimate your SIP returns",
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF1565C0),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Input card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1A3A6B).withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Investment Details",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0D1B3E),
                    ),
                  ),
                  const SizedBox(height: 18),
                  _buildInputField(
                    controller: sipController,
                    label: "Monthly SIP Amount",
                    hint: "e.g. 5000",
                    icon: Icons.account_balance_wallet_outlined,
                    prefix: "₹",
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    controller: returnController,
                    label: "Expected Annual Return",
                    hint: "e.g. 12",
                    icon: Icons.percent_rounded,
                    suffix: "%",
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    controller: yearsController,
                    label: "Investment Period",
                    hint: "e.g. 10",
                    icon: Icons.calendar_month_outlined,
                    suffix: "Years",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: calculateSip,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "Calculate SIP",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),

            if (futureValue > 0) ...[
              const SizedBox(height: 24),

              // Gradient result card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0D47A1).withOpacity(0.30),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Investment Summary",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildResultRow(
                      label: "Invested Amount",
                      value: "₹${investedAmount.toStringAsFixed(2)}",
                      icon: Icons.savings_outlined,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: Colors.white24, height: 1),
                    ),
                    _buildResultRow(
                      label: "Estimated Returns",
                      value: "₹${estimatedReturns.toStringAsFixed(2)}",
                      icon: Icons.show_chart_rounded,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: Colors.white24, height: 1),
                    ),
                    _buildResultRow(
                      label: "Future Value",
                      value: "₹${futureValue.toStringAsFixed(2)}",
                      icon: Icons.emoji_events_outlined,
                      highlight: true,
                    ),

                    // Progress bar showing return ratio
                    const SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: investedAmount / futureValue,
                        backgroundColor: Colors.white24,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.white),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Principal",
                            style: TextStyle(
                                color: Colors.white60, fontSize: 11)),
                        Text(
                          "${((investedAmount / futureValue) * 100).toStringAsFixed(1)}% of total",
                          style: const TextStyle(
                              color: Colors.white60, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? prefix,
    String? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF7A8BAD),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0D1B3E),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
                color: Color(0xFFBDCAE5), fontWeight: FontWeight.w400),
            prefixIcon: Icon(icon, color: const Color(0xFF1565C0), size: 20),
            prefixText: prefix != null ? "$prefix " : null,
            prefixStyle: const TextStyle(
              color: Color(0xFF0D1B3E),
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
            suffixText: suffix,
            suffixStyle: const TextStyle(
              color: Color(0xFF7A8BAD),
              fontSize: 13,
            ),
            filled: true,
            fillColor: const Color(0xFFF8FAFF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: Color(0xFF1565C0), width: 1.5),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildResultRow({
    required String label,
    required String value,
    required IconData icon,
    bool highlight = false,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.80),
              fontSize: 13,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: highlight ? 18 : 15,
            fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}