import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:profinch_mobile_application/core/constants/colors.dart';
import 'package:profinch_mobile_application/core/constants/fonts_size.dart';
import 'package:profinch_mobile_application/features/auth/provider/auth_provider.dart';
import 'package:profinch_mobile_application/features/auth/screens/pin_screen.dart';
import 'package:profinch_mobile_application/features/auth/screens/pattern_screen.dart';
import 'change_password_screen.dart';

class SecuritySettingsScreen extends StatelessWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Security',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Quick login section ──────────────────────────────
            _sectionLabel(context, 'Quick Login'),
            const SizedBox(height: 10),

            // PIN
            _SecurityTile(
              icon: Icons.pin_outlined,
              iconColor: const Color(0xFF185FA5),
              title: 'PIN Login',
              subtitle: authProvider.isPinSet
                  ? 'PIN is set — tap to change'
                  : 'Set a 4-digit PIN for quick access',
              trailing: authProvider.isPinSet
                  ? _statusBadge('Active', Colors.green)
                  : _statusBadge('Not set', Colors.grey),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PinScreen(mode: PinScreenMode.setup),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Pattern
            _SecurityTile(
              icon: Icons.grid_view_rounded,
              iconColor: const Color(0xFF7C3AED),
              title: 'Pattern Login',
              subtitle: authProvider.isPatternSet
                  ? 'Pattern is set — tap to change'
                  : 'Draw a pattern for quick access',
              trailing: authProvider.isPatternSet
                  ? _statusBadge('Active', Colors.green)
                  : _statusBadge('Not set', Colors.grey),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const PatternScreen(mode: PatternScreenMode.setup),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Biometric
            _BiometricTile(authProvider: authProvider),

            const SizedBox(height: 28),

            // ── Password section ─────────────────────────────────
            _sectionLabel(context, 'Password'),
            const SizedBox(height: 10),

            _SecurityTile(
              icon: Icons.lock_outline_rounded,
              iconColor: const Color(0xFF0F6E56),
              title: 'Change Password',
              subtitle: 'Update your account password',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ChangePasswordScreen()),
              ),
            ),

            const SizedBox(height: 28),

            // ── Danger zone ──────────────────────────────────────
            _sectionLabel(context, 'Reset'),
            const SizedBox(height: 10),

            if (authProvider.isPinSet)
              _SecurityTile(
                icon: Icons.pin_outlined,
                iconColor: Colors.red.shade600,
                title: 'Remove PIN',
                subtitle: 'Disable PIN login',
                onTap: () => _confirmRemove(
                  context,
                  title: 'Remove PIN?',
                  message:
                      'You will no longer be able to log in with PIN. You can set it again later.',
                  onConfirm: () => authProvider.clearPin(),
                ),
              ),

            if (authProvider.isPinSet) const SizedBox(height: 12),

            if (authProvider.isPatternSet)
              _SecurityTile(
                icon: Icons.grid_view_rounded,
                iconColor: Colors.red.shade600,
                title: 'Remove Pattern',
                subtitle: 'Disable pattern login',
                onTap: () => _confirmRemove(
                  context,
                  title: 'Remove Pattern?',
                  message:
                      'You will no longer be able to log in with pattern. You can set it again later.',
                  onConfirm: () => authProvider.clearPattern(),
                ),
              ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String label) => Text(
        label,
        style: TextStyle(
          fontSize: AppFontSize.small(context),
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade600,
          letterSpacing: 0.5,
        ),
      );

  Widget _statusBadge(String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color == Colors.green ? Colors.green.shade700 : Colors.grey.shade600),
        ),
      );

  void _confirmRemove(
    BuildContext context, {
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.warning_amber_rounded,
                  color: Colors.red.shade600, size: 26),
            ),
            const SizedBox(height: 14),
            Text(title,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(color: AppColors.primary),
                      minimumSize: const Size(0, 48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      onConfirm();
                      Navigator.pop(context);
                      Navigator.pop(context); // back to profile
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Remove',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ── Biometric tile with async availability check ───────────────
class _BiometricTile extends StatefulWidget {
  final AuthProvider authProvider;

  const _BiometricTile({required this.authProvider});

  @override
  State<_BiometricTile> createState() => _BiometricTileState();
}

class _BiometricTileState extends State<_BiometricTile> {
  bool? _available;

  @override
  void initState() {
    super.initState();
    widget.authProvider.checkBiometricAvailable().then((v) {
      if (mounted) setState(() => _available = v);
    });
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.authProvider.isBiometricEnabled;

    return _SecurityTile(
      icon: Icons.fingerprint_rounded,
      iconColor: const Color(0xFF0EA5E9),
      title: 'Biometric Login',
      subtitle: _available == null
          ? 'Checking device support...'
          : _available!
              ? enabled
                  ? 'Biometric login is enabled'
                  : 'Use fingerprint or Face ID to login'
              : 'Not available on this device',
      trailing: _available == true
          ? Switch(
              value: enabled,
              activeColor: AppColors.primary,
              onChanged: (v) => widget.authProvider.setBiometricEnabled(v),
            )
          : null,
      onTap: _available == true
          ? () => widget.authProvider
              .setBiometricEnabled(!widget.authProvider.isBiometricEnabled)
          : null,
    );
  }
}

// ── Reusable security tile ─────────────────────────────────────
class _SecurityTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SecurityTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      tileColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: iconColor.withValues(alpha: 0.1),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title,
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
      subtitle: Text(subtitle,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
      trailing: trailing ??
          (onTap != null
              ? const Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: Colors.grey)
              : null),
      onTap: onTap,
    );
  }
}