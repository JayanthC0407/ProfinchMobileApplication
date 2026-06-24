import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:profinch_mobile_application/core/constants/fonts_size.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  bool biometricsEnabled = true;
  bool twoFactorEnabled = false;
  bool appLockEnabled = true;
  bool transactionPinEnabled = true;
  bool loginAlertsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F1322),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0F1322),
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2640),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF2E3A57)),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
          title: Text(
            'Security Settings',
            style: TextStyle(
              color: Colors.white,
              fontSize: AppFontSize.large(context),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Security score banner ────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E3A6E), Color(0xFF1A2F5A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: const Color(0xFF4A90D9).withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(
                            value: 0.72,
                            strokeWidth: 5,
                            backgroundColor:
                                const Color(0xFF4A90D9).withOpacity(0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF4A90D9)),
                          ),
                        ),
                        const Text('72',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800)),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Security Score',
                              style: TextStyle(
                                  color: Color(0xFF8A9BB5), fontSize: 12)),
                          const SizedBox(height: 4),
                          const Text('Good — Enable 2FA to reach Excellent',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  height: 1.3)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Authentication ───────────────────────────────
              _sectionLabel('AUTHENTICATION', context),
              const SizedBox(height: 10),

              _switchTile(
                title: 'Biometric Login',
                subtitle: 'Use fingerprint or Face ID to sign in',
                icon: Icons.fingerprint_rounded,
                iconColor: const Color(0xFF4A90D9),
                value: biometricsEnabled,
                onChanged: (v) => setState(() => biometricsEnabled = v),
              ),

              _switchTile(
                title: 'Two-Factor Authentication',
                subtitle: 'OTP sent to your registered mobile',
                icon: Icons.security_rounded,
                iconColor: const Color(0xFF10B981),
                value: twoFactorEnabled,
                onChanged: (v) => setState(() {
                  twoFactorEnabled = v;
                  if (v) _show2FASetup(context);
                }),
              ),

              _actionTile(
                title: 'Change Login PIN',
                subtitle: '4-digit login PIN',
                icon: Icons.dialpad_rounded,
                iconColor: const Color(0xFF9B59B6),
                onTap: () => _showChangePinSheet(context, 'Login PIN'),
              ),

              const SizedBox(height: 24),

              // ── Transaction security ─────────────────────────
              _sectionLabel('TRANSACTION SECURITY', context),
              const SizedBox(height: 10),

              _switchTile(
                title: 'Transaction PIN',
                subtitle: 'Required for every fund transfer',
                icon: Icons.pin_rounded,
                iconColor: const Color(0xFFF59E0B),
                value: transactionPinEnabled,
                onChanged: (v) => setState(() => transactionPinEnabled = v),
              ),

              _actionTile(
                title: 'Change Transaction PIN',
                subtitle: '6-digit MPIN for payments',
                icon: Icons.lock_rounded,
                iconColor: const Color(0xFF0EA5E9),
                onTap: () => _showChangePinSheet(context, 'Transaction PIN'),
              ),

              _actionTile(
                title: 'Transaction Limits',
                subtitle: 'Daily: ₹1,00,000 per transaction',
                icon: Icons.price_check_rounded,
                iconColor: const Color(0xFFEF4444),
                onTap: () => _showTransactionLimits(context),
              ),

              const SizedBox(height: 24),

              // ── App security ─────────────────────────────────
              _sectionLabel('APP SECURITY', context),
              const SizedBox(height: 10),

              _switchTile(
                title: 'App Lock',
                subtitle: 'Lock app when minimised',
                icon: Icons.lock_outline_rounded,
                iconColor: const Color(0xFF4A90D9),
                value: appLockEnabled,
                onChanged: (v) => setState(() => appLockEnabled = v),
              ),

              _switchTile(
                title: 'Login Alerts',
                subtitle: 'Notify on new sign-in attempts',
                icon: Icons.notifications_active_rounded,
                iconColor: const Color(0xFFF59E0B),
                value: loginAlertsEnabled,
                onChanged: (v) => setState(() => loginAlertsEnabled = v),
              ),

              _actionTile(
                title: 'Blocked Merchants',
                subtitle: 'Manage blocked merchant categories',
                icon: Icons.block_rounded,
                iconColor: const Color(0xFFEF4444),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Widgets ─────────────────────────────────────────────────────

  Widget _sectionLabel(String label, BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: const Color(0xFF8A9BB5),
        fontSize: AppFontSize.xs(context),
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _switchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2640),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2E3A57)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: iconColor.withOpacity(0.25)),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(
                        color: Color(0xFF8A9BB5), fontSize: 11)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF4A90D9),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  Widget _actionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2640),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2E3A57)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: iconColor.withOpacity(0.25)),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          color: Color(0xFF8A9BB5), fontSize: 11)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: Color(0xFF8A9BB5)),
          ],
        ),
      ),
    );
  }

  // ── Sheets ───────────────────────────────────────────────────────

  void _showChangePinSheet(BuildContext context, String pinType) {
    final controllers = List.generate(6, (_) => TextEditingController());
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E2640),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 24, right: 24, top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Change $pinType',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('Enter your new $pinType',
                style: const TextStyle(
                    color: Color(0xFF8A9BB5), fontSize: 13)),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (i) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: 44,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F1322),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF4A90D9)),
                  ),
                  child: TextField(
                    controller: controllers[i],
                    maxLength: 1,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      counterText: '',
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90D9),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Confirm',
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _show2FASetup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E2640),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enable 2FA',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            const Text(
              'An OTP will be sent to your registered mobile number (+91 98765 43210) every time you sign in.',
              style: TextStyle(
                  color: Color(0xFF8A9BB5), fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() => twoFactorEnabled = false);
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFF2E3A57)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Enable',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showTransactionLimits(BuildContext context) {
    final limits = [
      {'label': 'UPI (per transaction)', 'value': '₹1,00,000', 'icon': Icons.phone_android_rounded},
      {'label': 'NEFT / IMPS (daily)', 'value': '₹5,00,000', 'icon': Icons.swap_horiz_rounded},
      {'label': 'International transfer', 'value': '₹2,00,000', 'icon': Icons.public_rounded},
      {'label': 'ATM withdrawal (daily)', 'value': '₹25,000', 'icon': Icons.atm_rounded},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E2640),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Transaction Limits',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),
            ...limits.map((l) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF0F1322),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF2E3A57)),
              ),
              child: Row(
                children: [
                  Icon(l['icon'] as IconData,
                      color: const Color(0xFF4A90D9), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Text(l['label'] as String,
                          style: const TextStyle(
                              color: Color(0xFF8A9BB5), fontSize: 13))),
                  Text(l['value'] as String,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}