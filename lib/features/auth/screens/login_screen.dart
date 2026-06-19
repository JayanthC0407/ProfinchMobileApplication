import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/features/auth/screens/signup_screen.dart';
import 'package:profinch_mobile_application/features/dashboard/provider/dashboard_provider.dart';
import 'package:profinch_mobile_application/shared/widgets/background_wrapper.dart';
import 'package:profinch_mobile_application/shared/widgets/logo.dart';
import 'package:profinch_mobile_application/features/auth/widgets/sign_in_widgets/signin_header.dart';
import 'package:profinch_mobile_application/features/auth/widgets/sign_in_widgets/signin_form.dart';
import 'package:profinch_mobile_application/features/auth/widgets/sign_in_widgets/remember_forgot_row.dart';
import 'package:profinch_mobile_application/features/auth/widgets/sign_in_widgets/sign_in_button.dart';
import 'package:profinch_mobile_application/features/auth/widgets/sign_in_widgets/biometric_button.dart';
import 'package:profinch_mobile_application/shared/widgets/security_badge.dart';
import 'package:profinch_mobile_application/features/auth/widgets/sign_in_widgets/sign_up_button.dart';
import 'package:provider/provider.dart';
import 'package:profinch_mobile_application/core/routes/app_routes.dart';
import 'package:profinch_mobile_application/features/auth/provider/auth_provider.dart';
import 'package:profinch_mobile_application/features/auth/screens/otp_screen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final bool _isLoading = false;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── Handlers ───────────────────────────────────────────────────
  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _emailError = null;
      _passwordError = null;
    });

  final authProvider = Provider.of<AuthProvider>(
    context,
    listen: false,
  );

  final success = await authProvider.login(
    email: _emailController.text.trim(),
    password: _passwordController.text.trim(),
  );

  if (!mounted) return;

  if (success) {

    final phone = authProvider.currentUser!.phoneNumber;
    final masked = phone.length >= 4
        ? '+91 ${'•' * (phone.length - 4)}${phone.substring(phone.length - 4)}'
        : phone;

    final verified = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => OtpScreen(
          maskedDestination: masked,
          onVerified: (otp) async {
            // TODO: replace with real OTP verification API call.
            // Dummy rule for now: any 6-digit OTP equal to "111111" passes.
            await Future.delayed(const Duration(milliseconds: 800));
            return otp == '111111';
          },
          onResend: () async {
            // TODO: trigger real OTP resend API call.
            await Future.delayed(const Duration(milliseconds: 500));
          },
        ),
      ),
    );

    if (!mounted) return;

    if (verified != true) {
      // User backed out of OTP screen without verifying — stay on login.
      return;
    }

    Provider.of<DashboardProvider>(
      context,
      listen: false,
    ).resetToPrimary(
      authProvider.currentUser!.primaryAccountId,
    );

    final email = _emailController.text.trim();

    final password = _passwordController.text.trim();

    final emailExists = authProvider.emailExists(email);

    if (!emailExists) {
      setState(() {
        _emailError = "Invalid email address";
      });

      return;
    }

    final passwordValid = authProvider.passwordMatches(
      email: email,
      password: password,
    );

    if (!passwordValid) {
      setState(() {
        _passwordError = "Incorrect password";
      });

      return;
    }

    final success = await authProvider.login(email: email, password: password);

    if (!mounted) return;

    if (success) {
      Provider.of<DashboardProvider>(
        context,
        listen: false,
      ).resetToPrimary(authProvider.currentUser!.primaryAccountId);

      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    }
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

                    emailError: _emailError,
                    passwordError: _passwordError,
                  ),

                  const SizedBox(height: 20),
                  RememberForgotRow(onForgotPassword: _handleForgotPassword),
                  const SizedBox(height: 24),

                  SignInButton(isLoading: _isLoading, onPressed: _handleSignIn),
                  const SizedBox(height: 20),

                  BiometricButton(onPressed: _handleBiometric),
                  const SizedBox(height: 28),

                  SignUpRow(
                    onSignUp: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => const SignUpScreen(),
                        ),
                      );
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