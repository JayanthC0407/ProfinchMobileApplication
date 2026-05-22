import 'package:flutter/material.dart';
import 'package:mobileproject/constants/colors.dart';

class SignUpScreen extends StatelessWidget{
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: AppColors.primaryDark,
      ),
      body: const Center(
        child: Text(
          'Sign-up screen coming soon!',
          style: TextStyle(fontSize: 18, color: AppColors.primaryDark),
        ),
      ),
    );
  }
}