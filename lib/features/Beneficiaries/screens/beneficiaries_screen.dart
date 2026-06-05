import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/core/constants/colors.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../auth/provider/auth_provider.dart';
import '../provider/beneficiary_provider.dart';
import '../widgets/beneficiary_card.dart';
import 'beneficiary_details_screen.dart';

class BeneficiariesScreen
    extends StatelessWidget {

  const BeneficiariesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final authProvider =
        Provider.of<AuthProvider>(
      context,
    );

    final beneficiaryProvider =
        Provider.of<
            BeneficiaryProvider>(
      context,
    );

    final user =
        authProvider.currentUser!;

    final beneficiaries =
        beneficiaryProvider
            .getBeneficiariesByUserId(
      user.id,
    );

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title:
            const Text("Beneficiaries"),
      ),

      floatingActionButton:
          FloatingActionButton(
            backgroundColor: AppColors.lightblue,
        onPressed: () {

          Navigator.pushNamed(
            context,
            AppRoutes.beneficiaryType,
          );
        },

        child: const Icon(
          Icons.add,
        ),
      ),

      body: beneficiaries.isEmpty

          ? const Center(
              child: Text(
                "No Beneficiaries Found",
              ),
            )

          : ListView.builder(
              itemCount:
                  beneficiaries.length,

              itemBuilder:
                  (context, index) {

                final beneficiary =
                    beneficiaries[
                        index];

                return BeneficiaryCard(
                  name:
                      beneficiary.nickname,

                  accountNumber:
                      beneficiary
                          .accountNumber,

                  type:
                      beneficiary
                          .beneficiaryType,

                  onTap: () {

                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) =>
                            BeneficiaryDetailsScreen(
                          beneficiary:
                              beneficiary,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}