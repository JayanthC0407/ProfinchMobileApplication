import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/beneficiary_model.dart';
import '../../auth/provider/auth_provider.dart';
import '../provider/beneficiary_provider.dart';

class AddBeneficiaryScreen extends StatefulWidget {
  final String beneficiaryType;

  const AddBeneficiaryScreen({super.key, required this.beneficiaryType});

  @override
  State<AddBeneficiaryScreen> createState() => _AddBeneficiaryScreenState();
}

class _AddBeneficiaryScreenState extends State<AddBeneficiaryScreen> {
  final nicknameController = TextEditingController();
  final accountController = TextEditingController();
  final bankController = TextEditingController();
  final ifscController = TextEditingController();
  final countryController = TextEditingController();
  final ibanController = TextEditingController();
  final swiftController = TextEditingController();
  String? nicknameError;
  String? accountError;
  String? bankError;
  String? ifscError;
  String? countryError;
  String? ibanError;
  String? swiftError;

  Color get _typeColor {
    switch (widget.beneficiaryType) {
      case 'PBI':
        return const Color(0xFF2563B0);
      case 'LOCAL':
        return const Color(0xFF2563B0);
      case 'INTERNATIONAL':
        return const Color(0xFF2563B0);
      default:
        return const Color(0xFF4338CA);
    }
  }

  // ignore: unused_element
  Color get _typeBg {
    switch (widget.beneficiaryType) {
      case 'PBI':
        return const Color(0xFFDBEAFE);
      case 'LOCAL':
        return const Color(0xFFCCFBF1);
      case 'INTERNATIONAL':
        return const Color(0xFFFEF3C7);
      default:
        return const Color(0xFFE0E7FF);
    }
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? hint,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 36, 34, 34),
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color.fromARGB(255, 90, 91, 92)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 14, color: Color(0xFF111827)),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 18),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              errorText,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  void _addBeneficiary() {
    setState(() {
      nicknameError = null;
      accountError = null;
      bankError = null;
      ifscError = null;
      countryError = null;
      ibanError = null;
      swiftError = null;
    });

    bool isValid = true;

    if (nicknameController.text.trim().isEmpty) {
      nicknameError = "Please enter nickname";
      isValid = false;
    }

    if (accountController.text.trim().isEmpty) {
      accountError = "Please enter account number";
      isValid = false;
    }

    if (widget.beneficiaryType != "PBI" && bankController.text.trim().isEmpty) {
      bankError = "Please enter bank name";
      isValid = false;
    }

    if (widget.beneficiaryType == "LOCAL" &&
        ifscController.text.trim().isEmpty) {
      ifscError = "Please enter IFSC code";
      isValid = false;
    }

    if (widget.beneficiaryType == "INTERNATIONAL") {
      if (countryController.text.trim().isEmpty) {
        countryError = "Please enter country";
        isValid = false;
      }

      if (ibanController.text.trim().isEmpty) {
        ibanError = "Please enter IBAN";
        isValid = false;
      }

      if (swiftController.text.trim().isEmpty) {
        swiftError = "Please enter SWIFT code";
        isValid = false;
      }
    }

    if (!isValid) {
      setState(() {});
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final beneficiaryProvider = Provider.of<BeneficiaryProvider>(
      context,
      listen: false,
    );

    beneficiaryProvider.addBeneficiary(
      BeneficiaryModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),

        userId: authProvider.currentUser!.id,

        nickname: nicknameController.text,

        beneficiaryType: widget.beneficiaryType,

        accountNumber: accountController.text,

        bankName: bankController.text,

        ifscCode: ifscController.text,

        country: countryController.text,

        ibanNumber: ibanController.text,

        swiftCode: swiftController.text,

        isVerified: true,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // ignore: unused_local_variable
    final beneficiaryProvider = Provider.of<BeneficiaryProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,

          child: SizedBox(
            width: double.infinity,

            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _typeColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),

              onPressed: _addBeneficiary,

              child: const Text(
                "Add Beneficiary",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),

      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1A3A6B), Color(0xFF2563B0)],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 8, 0),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
                    child: Text(
                      "Add ${widget.beneficiaryType} Beneficiary",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    child: Text(
                      "Fill in the details below to add",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.65),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _field(
                          controller: nicknameController,
                          errorText: nicknameError,
                          label: "Nickname",
                          icon: Icons.badge_outlined,
                          hint: "e.g. John Doe",
                        ),
                        const SizedBox(height: 16),
                        _field(
                          controller: accountController,
                          errorText: accountError,
                          label: "Account Number",
                          icon: Icons.credit_card_outlined,
                          keyboardType: TextInputType.number,
                          hint: "Enter account number",
                        ),
                        if (widget.beneficiaryType != "PBI") ...[
                          const SizedBox(height: 16),
                          _field(
                            controller: bankController,
                            errorText: bankError,
                            label: "Bank Name",
                            icon: Icons.account_balance_outlined,
                            hint: "e.g. HDFC Bank",
                          ),
                        ],
                        if (widget.beneficiaryType == "LOCAL") ...[
                          const SizedBox(height: 16),
                          _field(
                            controller: ifscController,
                            errorText: ifscError,
                            label: "IFSC Code",
                            icon: Icons.tag_outlined,
                            hint: "e.g. HDFC0001234",
                          ),
                        ],
                        if (widget.beneficiaryType == "INTERNATIONAL") ...[
                          const SizedBox(height: 16),
                          _field(
                            controller: countryController,
                            errorText: countryError,
                            label: "Country",
                            icon: Icons.public_outlined,
                            hint: "e.g. United States",
                          ),
                          const SizedBox(height: 16),
                          _field(
                            controller: ibanController,
                            errorText: ibanError,
                            label: "IBAN Number",
                            icon: Icons.numbers_outlined,
                            hint: "e.g. GB29 NWBK 6016 1331 9268 19",
                          ),
                          const SizedBox(height: 16),
                          _field(
                            controller: swiftController,
                            errorText: swiftError,
                            label: "SWIFT Code",
                            icon: Icons.swap_horiz_outlined,
                            hint: "e.g. CITIUS33",
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
