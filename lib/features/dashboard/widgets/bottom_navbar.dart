import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/core/routes/app_routes.dart';


class BottomNavBar extends StatelessWidget {

  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(

      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,

      onTap: (index) {

        if (index == 4) {

          Navigator.pushNamed(
            context,
            AppRoutes.profile,
          );
        }
      },

      items: const [

        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long),
          label: "Transactions",
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code_scanner),
          label: "Scan",
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.card_giftcard),
          label: "Offers",
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Profile",
        ),
      ],
    );
  }
}