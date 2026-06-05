import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/core/constants/colors.dart';
import '../../../core/routes/app_routes.dart';

class TermDepositScreen
    extends StatelessWidget {

  const TermDepositScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

       backgroundColor: AppColors.lightblue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Term Deposits",
        ),
      ),

      body: ListView(
        children: [

             Card(
              elevation: 4,
              color: AppColors.primary,// light blue

              child: ListTile(
                leading: const Icon(
                  Icons.account_balance,
                  color: Color.fromARGB(255, 243, 244, 245),
                ),

                title: const Text(
                  "My Deposits",
                  style: TextStyle(
                    color: Color.fromARGB(255, 4, 4, 5),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color:Color.fromARGB(255, 243, 244, 245),
                ),

                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.myDeposits,
                  );
                },
              ),
            ),

              Card(
              elevation: 4,
              color: AppColors.primary,// light blue

              child: ListTile(
                leading: const Icon(
                  Icons.add_circle,
                  color: Color.fromARGB(255, 243, 244, 245),
                ),

                title: const Text(
                  "Open New Deposit",
                  style: TextStyle(
                    color: Color.fromARGB(255, 4, 4, 5),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Color.fromARGB(255, 243, 244, 245),
                ),

                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.openDeposit,
                  );
                },
              ),
            ),

          Card(
           elevation: 4,
           color: AppColors.primary,// light blue

          child: ListTile(
            leading: const Icon(
              Icons.currency_exchange,
              color: Color.fromARGB(255, 243, 244, 245),
            ),

            title: const Text(
              "Redeem Deposits",
              style: TextStyle(
                color: Color.fromARGB(255, 4, 4, 5),
                fontWeight: FontWeight.bold,
              ),
            ),

            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Color.fromARGB(255, 243, 244, 245),
            ),

            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.redeemDeposit,
              );
            },
          ),
        ),

         Card(
           elevation: 4,
           color: AppColors.primary, // light blue

          child: ListTile(
            leading: const Icon(
              Icons.receipt_long,
              color: Color.fromARGB(255, 243, 244, 245),
            ),

            title: const Text(
              "Statements",
              style: TextStyle(
                color: Color.fromARGB(255, 4, 4, 5),
                fontWeight: FontWeight.bold,
              ),
            ),

            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Color.fromARGB(255, 243, 244, 245),
            ),

            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.depositStatements,
              );
            },
          ),
        ),
        ],
      ),
    );
  }
}