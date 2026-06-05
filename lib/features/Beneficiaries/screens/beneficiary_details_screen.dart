import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/beneficiary_model.dart';
import '../provider/beneficiary_provider.dart';

class BeneficiaryDetailsScreen
    extends StatelessWidget {

  final BeneficiaryModel
      beneficiary;

  const BeneficiaryDetailsScreen({
    super.key,
    required this.beneficiary,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Beneficiary Details",
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          children: [

            ListTile(
              title:
                  const Text("Name"),

              subtitle: Text(
                beneficiary.nickname,
              ),
            ),

            ListTile(
              title:
                  const Text("Type"),

              subtitle: Text(
                beneficiary
                    .beneficiaryType,
              ),
            ),

            ListTile(
              title: const Text(
                "Account Number",
              ),

              subtitle: Text(
                beneficiary
                    .accountNumber,
              ),
            ),

            ListTile(
              title:
                  const Text("Bank"),

              subtitle: Text(
                beneficiary.bankName,
              ),
            ),

            ListTile(
              title:
                  const Text("IFSC"),

              subtitle: Text(
                beneficiary.ifscCode,
              ),
            ),

            const Spacer(),

            ElevatedButton.icon(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red,
              ),

              onPressed: () {

                Provider.of<
                    BeneficiaryProvider>(
                  context,
                  listen: false,
                ).removeBeneficiary(
                  beneficiary.id,
                );

                Navigator.pop(
                  context,
                );
              },

              icon: const Icon(
                Icons.delete,
              ),

              label: const Text(
                "Remove Beneficiary",
              ),
            ),
          ],
        ),
      ),
    );
  }
}