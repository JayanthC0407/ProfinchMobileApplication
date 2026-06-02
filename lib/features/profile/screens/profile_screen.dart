import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/core/routes/app_routes.dart';
import 'package:profinch_mobile_application/data/dummy/dummy_accounts.dart';
import 'package:provider/provider.dart';
import '../../auth/provider/auth_provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_info_tile.dart';
import '../widgets/settings_tile.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context);

    final user = authProvider.currentUser!;

    final primaryAccount =
        DummyAccounts.allAccounts.firstWhere(
          (a) => a.id == user.primaryAccountId,
        );

    value:primaryAccount.accountNumber;

    return Scaffold(

      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [

            ProfileHeader(
              username: user.username,
              email: user.email,
            ),

            const SizedBox(height: 25),

            ProfileInfoTile(
              title: "Phone Number",
              value: user.phoneNumber,
              icon: Icons.phone,
            ),

            ProfileInfoTile(
              title: "PAN Number",
              value: user.panNumber,
              icon: Icons.badge,
            ),

            ProfileInfoTile(
              title: "Primary Account",
              value: primaryAccount.accountType,
              icon: Icons.star,
            ),

            ProfileInfoTile(
              title: "KYC Status",
              value: user.isKycVerified
                  ? "Verified"
                  : "Pending",
              icon: Icons.verified_user,
            ),

            const SizedBox(height: 25),

            SettingsTile(
              title: "Edit Profile",
              icon: Icons.edit,
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EditProfileScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            SettingsTile(
              title: "Security",
              icon: Icons.lock,
              onTap: () {},
            ),

            const SizedBox(height: 16),

            SettingsTile(
              title: "Privacy Policy",
              icon: Icons.privacy_tip,
              onTap: () {},
            ),

            const SizedBox(height: 16),

            SettingsTile(
              title: "Logout",
              icon: Icons.logout,
              onTap: () {

                final authProvider =
                    Provider.of<AuthProvider>(
                  context,
                  listen: false,
                );

                authProvider.logout();

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}