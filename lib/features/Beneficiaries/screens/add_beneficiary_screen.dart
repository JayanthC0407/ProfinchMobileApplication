import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/core/constants/colors.dart';
import 'package:provider/provider.dart';

import '../../../data/models/beneficiary_model.dart';
import '../../auth/provider/auth_provider.dart';
import '../provider/beneficiary_provider.dart';

class AddBeneficiaryScreen
    extends StatefulWidget {

  final String beneficiaryType;

  const AddBeneficiaryScreen({
    super.key,
    required this.beneficiaryType,
  });

  @override
  State<AddBeneficiaryScreen>
      createState() =>
          _AddBeneficiaryScreenState();
}

class _AddBeneficiaryScreenState
    extends State<
        AddBeneficiaryScreen> {

  final nicknameController =
      TextEditingController();

  final accountController =
      TextEditingController();

  final bankController =
      TextEditingController();

  final ifscController =
      TextEditingController();
  
  final countryController =
    TextEditingController();

  final ibanController =
    TextEditingController();

  final swiftController =
    TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authProvider =
        Provider.of<AuthProvider>(
      context,
      listen: false,
    );

    final beneficiaryProvider =
        Provider.of<
            BeneficiaryProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(    
        backgroundColor: Colors.transparent,  
        title: Text(
          "Add ${widget.beneficiaryType}",
        ),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          children: [

            TextField(
              controller:
                  nicknameController,

              decoration:
                  const InputDecoration(
                labelText:
                    "Nickname",
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller:
                  accountController,

              decoration:
                  const InputDecoration(
                labelText:
                    "Account Number",
              ),
            ),

            const SizedBox(height: 16),

            if (widget.beneficiaryType != "PBI")
              TextField(
                controller: bankController,
                decoration: const InputDecoration(
                  labelText: "Bank Name",
                ),
              ),

            if (widget.beneficiaryType != "PBI")
              const SizedBox(height: 16),

            if (widget.beneficiaryType == "LOCAL")
              TextField(
                controller: ifscController,
                decoration: const InputDecoration(
                  labelText: "IFSC Code",
                ),
              ),

            if (widget.beneficiaryType == "LOCAL")
              const SizedBox(height: 16),

            if (widget.beneficiaryType ==
                    "INTERNATIONAL")
                  TextField(
                    controller: countryController,
                    decoration: const InputDecoration(
                      labelText: "Country",
                    ),
                  ),

                if (widget.beneficiaryType ==
                    "INTERNATIONAL")
                  const SizedBox(height: 16),

                if (widget.beneficiaryType ==
                    "INTERNATIONAL")
                  TextField(
                    controller: ibanController,
                    decoration: const InputDecoration(
                      labelText: "IBAN Number",
                    ),
                  ),

                if (widget.beneficiaryType ==
                    "INTERNATIONAL")
                  const SizedBox(height: 16),

                if (widget.beneficiaryType ==
                    "INTERNATIONAL")
                  TextField(
                    controller: swiftController,
                    decoration: const InputDecoration(
                      labelText: "SWIFT Code",
                    ),
                  ),

                if (widget.beneficiaryType ==
                    "INTERNATIONAL")
                  const SizedBox(height: 16),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {

                beneficiaryProvider
                    .addBeneficiary(

                  BeneficiaryModel(
                    id:
                        DateTime.now()
                            .millisecondsSinceEpoch
                            .toString(),

                    userId:
                        authProvider
                            .currentUser!
                            .id,

                    nickname:
                        nicknameController
                            .text,

                    beneficiaryType:
                        widget
                            .beneficiaryType,

                    accountNumber:
                        accountController
                            .text,

                    bankName:
                        bankController
                            .text,

                    ifscCode:
                        ifscController
                            .text,

                    isVerified:
                        true,
                  ),
                );

                Navigator.popUntil(
                  context,
                  (route) =>
                      route.isFirst,
                );
              },

              child: const Text(
                "Add Beneficiary",
              ),
            ),
          ],
        ),
      ),
    );
  }
}