import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/features/dashboard/provider/dashboard_provider.dart';
import 'package:provider/provider.dart';
import '../../auth/provider/auth_provider.dart';
import '../../../data/dummy/dummy_accounts.dart';

class EditProfileScreen extends StatefulWidget {

  const EditProfileScreen({super.key});
  

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {

  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  
  String? selectedPrimaryAccountId;
 
 
  @override
  void initState() {
    super.initState();

    final user = Provider.of<AuthProvider>(
      context,
      listen: false,
    ).currentUser!;

    usernameController =
        TextEditingController(text: user.username);

    emailController =
        TextEditingController(text: user.email);

    phoneController =
        TextEditingController(text: user.phoneNumber);
    
    selectedPrimaryAccountId =user.primaryAccountId;
    
  }

  @override
  Widget build(BuildContext context) {

    final authProvider =
        Provider.of<AuthProvider>(context);

    final user = authProvider.currentUser!;

    final accounts =
    DummyAccounts.allAccounts
        .where((a) => a.userId == user.id)
        .toList();

    return Scaffold(

      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [

            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: "Username",
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: "Phone Number",
              ),
            ),

            const SizedBox(height: 40),

            DropdownButtonFormField<String>(
              value: selectedPrimaryAccountId,
              decoration: const InputDecoration(
                labelText: 'Primary Account',
              ),
              items: accounts.map((account) {

                return DropdownMenuItem(
                  value: account.id,
                  child: Text(
                    "${account.accountType} • ${account.accountNumber.substring(account.accountNumber.length - 4)}",
                  ),
                );

              }).toList(),
              onChanged: (value) {

                setState(() {
                  selectedPrimaryAccountId = value;
                });
              },
            ),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(

                onPressed: () {

                  final updatedUser = user.copyWith(
                    username: usernameController.text.trim(),
                    email: emailController.text.trim(),
                    phoneNumber: phoneController.text.trim(),
                    primaryAccountId: selectedPrimaryAccountId,
                  );

                  authProvider.updateUser(updatedUser);

                    Provider.of<DashboardProvider>(
                      context,
                      listen: false,
                    ).resetToPrimary(
                      selectedPrimaryAccountId!,
                    );

                    Navigator.pop(context);
                },

                child: const Text(
                  "Save Changes",
                ),
              ),
            )
            
          ],
        ),
      ),
    );
  }
}