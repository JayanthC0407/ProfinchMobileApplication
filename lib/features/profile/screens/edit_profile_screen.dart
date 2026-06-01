import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/provider/auth_provider.dart';

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
  }

  @override
  Widget build(BuildContext context) {

    final authProvider =
        Provider.of<AuthProvider>(context);

    final user = authProvider.currentUser!;

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

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(

                onPressed: () {

                  final updatedUser = user.copyWith(
                    username:
                        usernameController.text.trim(),

                    email:
                        emailController.text.trim(),

                    phoneNumber:
                        phoneController.text.trim(),
                  );

                  authProvider.updateUser(updatedUser);

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