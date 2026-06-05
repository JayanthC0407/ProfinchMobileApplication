import 'package:flutter/material.dart';

import 'add_beneficiary_screen.dart';

class BeneficiaryTypeScreen
    extends StatelessWidget {

  const BeneficiaryTypeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select Beneficiary Type",
        ),
      ),

      body: ListView(
        padding:
            const EdgeInsets.all(16),

        children: [

          _buildTypeCard(
            context,
            "PBI",
            "ProFinch Bank",
            Icons.account_balance,
          ),

          _buildTypeCard(
            context,
            "LOCAL",
            "Other Indian Bank",
            Icons.location_city,
          ),

          _buildTypeCard(
            context,
            "INTERNATIONAL",
            "Foreign Bank",
            Icons.public,
          ),
        ],
      ),
    );
  }

  Widget _buildTypeCard(
    BuildContext context,
    String type,
    String subtitle,
    IconData icon,
  ) {

    return Card(
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.blue,
        ),

        title: Text(type),

        subtitle: Text(
          subtitle,
        ),

        trailing: const Icon(
          Icons.arrow_forward_ios,
        ),

        onTap: () {

          Navigator.push(
            context,

            MaterialPageRoute(
              builder: (_) =>
                  AddBeneficiaryScreen(
                beneficiaryType:
                    type,
              ),
            ),
          );
        },
      ),
    );
  }
}