import 'package:flutter/material.dart';
import 'package:mobileproject/screens/signup_screen.dart';
import 'package:mobileproject/widgets/background/background_wrapper.dart';
import 'package:mobileproject/widgets/background/logo.dart';
import 'package:mobileproject/widgets/sign_in_widgets/signin_header.dart';
import 'package:mobileproject/widgets/sign_in_widgets/signin_form.dart';
import 'package:mobileproject/widgets/sign_in_widgets/remember_forgot_row.dart';
import 'package:mobileproject/widgets/sign_in_widgets/sign_in_button.dart';
import 'package:mobileproject/widgets/sign_in_widgets/biometric_button.dart';
import 'package:mobileproject/widgets/background/security_badge.dart';
import 'package:mobileproject/widgets/sign_in_widgets/sign_up_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── Handlers ───────────────────────────────────────────────────
  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    // TODO: Replace with your actual auth API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Sign-in successful!'),
        backgroundColor: const Color(0xFF0F6E56),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _handleForgotPassword() {
    // TODO: Navigate to forgot-password screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Forgot password flow — coming soon!')),
    );
  }

  void _handleBiometric() {
    // TODO: Integrate local_auth package
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Biometric auth — coming soon!')),
    );
  }

  // ── Build ──────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppLogo(),
                    const SizedBox(height: 32),

                    const LoginHeader(),
                    const SizedBox(height: 28),

                    LoginForm(
                      formKey: _formKey,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      onSubmit: _handleSignIn,
                    ),

                    const SizedBox(height: 20),
                    RememberForgotRow(onForgotPassword: _handleForgotPassword),
                    const SizedBox(height: 24),

                    SignInButton(
                      isLoading: _isLoading,
                      onPressed: _handleSignIn,
                    ),
                    const SizedBox(height: 20),

                    BiometricButton(onPressed: _handleBiometric),
                    const SizedBox(height: 28),

                    SignUpRow(
                      onSignUp: () {
                        Navigator.push(context, MaterialPageRoute(builder: (ctx) => const SignUpScreen()));
                      },
                    ),
                    const SizedBox(height: 20),
                    
                    const SecurityBadge(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
  }
}
