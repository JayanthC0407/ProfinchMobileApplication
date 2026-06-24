import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: unused_import
import 'package:profinch_mobile_application/core/constants/colors.dart';
import 'package:profinch_mobile_application/core/constants/fonts_size.dart';
import 'package:profinch_mobile_application/core/routes/app_routes.dart';
import 'package:profinch_mobile_application/features/auth/provider/auth_provider.dart';
import 'package:profinch_mobile_application/features/dashboard/provider/dashboard_provider.dart';
import 'package:profinch_mobile_application/shared/widgets/background_wrapper.dart';
import 'package:profinch_mobile_application/shared/widgets/logo.dart';

/// Used in two modes:
///   [PinScreenMode.setup]  — first time, shown after login to set a PIN
///   [PinScreenMode.login]  — quick-login using existing PIN
enum PinScreenMode { setup, login }

class PinScreen extends StatefulWidget {
  final PinScreenMode mode;

  const PinScreen({super.key, required this.mode});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  static const int _pinLength = 4;

  String _entered = '';
  String _firstPin = '';   // used in setup mode to store first entry
  bool _confirming = false; // setup mode: second entry phase
  bool _hasError = false;
  String _errorMessage = '';

  void _onKey(String digit) {
    if (_entered.length >= _pinLength) return;
    setState(() {
      _entered += digit;
      _hasError = false;
    });

    if (_entered.length == _pinLength) {
      Future.delayed(const Duration(milliseconds: 150), _handlePinComplete);
    }
  }

  void _onDelete() {
    if (_entered.isEmpty) return;
    setState(() => _entered = _entered.substring(0, _entered.length - 1));
  }

  Future<void> _handlePinComplete() async {
    final authProvider = context.read<AuthProvider>();

    if (widget.mode == PinScreenMode.login) {
      // Verify PIN
      final ok = authProvider.verifyPin(_entered);
      if (ok) {
        final user = authProvider.currentUser!;
        context.read<DashboardProvider>().resetToPrimary(user.primaryAccountId);
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.dashboard, (route) => false);
      } else {
        setState(() {
          _entered = '';
          _hasError = true;
          _errorMessage = 'Incorrect PIN. Try again.';
        });
      }
      return;
    }

    // Setup mode
    if (!_confirming) {
      // First entry — store and ask to confirm
      setState(() {
        _firstPin = _entered;
        _entered = '';
        _confirming = true;
      });
    } else {
      // Second entry — confirm matches
      if (_entered == _firstPin) {
        authProvider.setPin(_entered);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('PIN set successfully!'),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        );
        Navigator.pop(context); // return to wherever setup was triggered
      } else {
        setState(() {
          _entered = '';
          _firstPin = '';
          _confirming = false;
          _hasError = true;
          _errorMessage = 'PINs don\'t match. Please start again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isLogin = widget.mode == PinScreenMode.login;

    final title = isLogin
        ? 'Welcome back'
        : (_confirming ? 'Confirm PIN' : 'Set PIN');

    final subtitle = isLogin
        ? 'Enter your 4-digit PIN to continue'
        : (_confirming
            ? 'Re-enter the same PIN to confirm'
            : 'Choose a 4-digit PIN for quick access');

    return BackgroundWrapper(
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const AppLogo(),
            const SizedBox(height: 32),

            if (isLogin) ...[
              CircleAvatar(
                radius: 34,
                backgroundImage: authProvider.currentUser?.profileImage != null
                    ? AssetImage(authProvider.currentUser!.profileImage)
                    : null,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: authProvider.currentUser?.profileImage == null
                    ? Text(
                        authProvider.currentUser?.username
                                .substring(0, 1)
                                .toUpperCase() ??
                            'U',
                        style: TextStyle(
                            fontSize: AppFontSize.xl(context),
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      )
                    : null,
              ),
              const SizedBox(height: 12),
              Text(
                authProvider.currentUser?.username ?? '',
                style: TextStyle(
                    fontSize: AppFontSize.large(context),
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              const SizedBox(height: 6),
            ],

            Text(title,
                style: TextStyle(
                    fontSize: AppFontSize.xl(context),
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
            const SizedBox(height: 8),
            Text(subtitle,
                style: TextStyle(
                    fontSize: AppFontSize.body(context),
                    color: Colors.white.withValues(alpha: 0.7))),

            const SizedBox(height: 36),

            // PIN dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pinLength, (i) {
                final filled = i < _entered.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _hasError
                        ? Colors.red.shade400
                        : filled
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.3),
                    border: Border.all(
                        color: _hasError
                            ? Colors.red.shade400
                            : Colors.white.withValues(alpha: 0.5)),
                  ),
                );
              }),
            ),

            if (_hasError) ...[
              const SizedBox(height: 12),
              Text(_errorMessage,
                  style: TextStyle(
                      fontSize: AppFontSize.small(context),
                      color: Colors.red.shade300)),
            ],

            const Spacer(),

            // Keypad
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Column(
                children: [
                  _keyRow(['1', '2', '3']),
                  const SizedBox(height: 14),
                  _keyRow(['4', '5', '6']),
                  const SizedBox(height: 14),
                  _keyRow(['7', '8', '9']),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Biometric shortcut (login mode only)
                      if (isLogin && authProvider.isBiometricEnabled)
                        _keyButton(
                          child: Icon(Icons.fingerprint,
                              size: 26, color: Colors.white),
                          onTap: () {/* handled by BiometricService */},
                        )
                      else
                        const SizedBox(width: 72),
                      _keyButton(
                        child: Text('0',
                            style: TextStyle(
                                fontSize: AppFontSize.xl(context),
                                color: Colors.white,
                                fontWeight: FontWeight.w300)),
                        onTap: () => _onKey('0'),
                      ),
                      _keyButton(
                        child: Icon(Icons.backspace_outlined,
                            size: 22, color: Colors.white.withValues(alpha: 0.8)),
                        onTap: _onDelete,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            if (isLogin)
              GestureDetector(
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                    context, AppRoutes.login, (route) => false),
                child: Text(
                  'Use password instead',
                  style: TextStyle(
                      fontSize: AppFontSize.body(context),
                      color: Colors.white.withValues(alpha: 0.65),
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white.withValues(alpha: 0.65)),
                ),
              ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _keyRow(List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: digits
          .map((d) => _keyButton(
                child: Text(d,
                    style: TextStyle(
                        fontSize: AppFontSize.xl(context),
                        color: Colors.white,
                        fontWeight: FontWeight.w300)),
                onTap: () => _onKey(d),
              ))
          .toList(),
    );
  }

  Widget _keyButton({required Widget child, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.1),
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        ),
        child: Center(child: child),
      ),
    );
  }
}