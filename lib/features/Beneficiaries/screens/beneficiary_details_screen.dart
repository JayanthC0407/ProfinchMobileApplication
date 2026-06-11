import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/beneficiary_model.dart';
import '../provider/beneficiary_provider.dart';

class BeneficiaryDetailsScreen extends StatelessWidget {
  final BeneficiaryModel beneficiary;

  const BeneficiaryDetailsScreen({super.key, required this.beneficiary});

  Color get _typeColor {
    switch (beneficiary.beneficiaryType) {
      case 'PBI': return const Color(0xFF2563B0);
      case 'LOCAL': return const Color(0xFF0D9488);
      case 'INTERNATIONAL': return const Color(0xFFB45309);
      default: return const Color(0xFF4338CA);
    }
  }

  Color get _typeBg {
    switch (beneficiary.beneficiaryType) {
      case 'PBI': return const Color(0xFFDBEAFE);
      case 'LOCAL': return const Color(0xFFCCFBF1);
      case 'INTERNATIONAL': return const Color(0xFFFEF3C7);
      default: return const Color(0xFFE0E7FF);
    }
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.isEmpty ? "—" : value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          // Header with avatar
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_typeColor.withOpacity(0.85), _typeColor],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 4, 8, 0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Spacer(),
                        const Text(
                          "Details",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        beneficiary.nickname[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    beneficiary.nickname,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      beneficiary.beneficiaryType,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Details card
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _detailRow(
                          "Account Number",
                          "••••  ••••  ••••  ${beneficiary.accountNumber.substring(beneficiary.accountNumber.length > 4 ? beneficiary.accountNumber.length - 4 : 0)}",
                        ),
                        const Divider(height: 1, color: Color(0xFFF3F4F6)),
                        _detailRow("Bank", beneficiary.bankName),
                        const Divider(height: 1, color: Color(0xFFF3F4F6)),
                        _detailRow("IFSC Code", beneficiary.ifscCode),
                        const Divider(height: 1, color: Color(0xFFF3F4F6)),
                        _detailRow(
                          "Verified",
                          beneficiary.isVerified ? "✓ Verified" : "Pending",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red.shade600,
                        side: BorderSide(color: Colors.red.shade200),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)),
                            title: const Text("Remove Beneficiary"),
                            content: Text(
                              "Are you sure you want to remove ${beneficiary.nickname}?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Provider.of<BeneficiaryProvider>(context,
                                          listen: false)
                                      .removeBeneficiary(beneficiary.id);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.red),
                                child: const Text("Remove"),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text(
                        "Remove Beneficiary",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}