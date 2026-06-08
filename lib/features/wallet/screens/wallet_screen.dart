import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/features/upi/screens/scan_qr_screen.dart';
import 'package:profinch_mobile_application/features/upi/screens/send_money_screen.dart';
import 'package:profinch_mobile_application/features/upi/provider/upi_provider.dart';
import 'package:provider/provider.dart';

import 'package:profinch_mobile_application/core/constants/colors.dart';
import 'package:profinch_mobile_application/features/accounts/provider/account_provider.dart';
import 'package:profinch_mobile_application/features/auth/provider/auth_provider.dart';
import '../provider/wallet_provider.dart';
import '../widgets/wallet_balance_card.dart';
import '../widgets/wallet_transaction_tile.dart';
import '../widgets/top_up_sheet.dart';
import '../widgets/transfer_to_bank_sheet.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) =>
          WalletProvider(ctx.read<AuthProvider>(), ctx.read<AccountProvider>()),
      child: const _WalletView(),
    );
  }
}

class _WalletView extends StatelessWidget {
  const _WalletView();

  void _showTopUp(
    BuildContext context,
    WalletProvider provider,
    AccountProvider accountProvider,
    AuthProvider authProvider,
  ) {
    final userId = authProvider.currentUser?.id ?? '';
    final accounts = accountProvider.getAccountsByUserId(userId);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TopUpSheet(
        accounts: accounts,
        walletBalance: provider.walletBalance,
        onTopUp: ({required accountId, required amount}) =>
            provider.topUpWallet(accountId: accountId, amount: amount),
      ),
    );
  }

  void _showTransferToBank(
    BuildContext context,
    WalletProvider provider,
    AccountProvider accountProvider,
    AuthProvider authProvider,
  ) {
    final userId = authProvider.currentUser?.id ?? '';
    final accounts = accountProvider.getAccountsByUserId(userId);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TransferToBankSheet(
        accounts: accounts,
        walletBalance: provider.walletBalance,
        onTransfer: ({required accountId, required amount}) =>
            provider.transferToBank(accountId: accountId, amount: amount),
      ),
    );
  }

  // ── Navigate to Send Money ────────────────────────────────────
  void _navigateToSendMoney(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (ctx) => UpiProvider(
            ctx.read<AuthProvider>(),
          ), // ✅ UpiProvider not upi_provider
          child: const SendMoneyScreen(),
        ),
      ),
    );
  }

  // ── Navigate to Scan QR ───────────────────────────────────────
  void _navigateToScanQr(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (ctx) => UpiProvider(
            ctx.read<AuthProvider>(),
          ), // ✅ UpiProvider not upi_provider
          child: const ScanQrScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final walletProvider = context.watch<WalletProvider>();
    final accountProvider = context.read<AccountProvider>();
    final authProvider = context.read<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'My Wallet',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: walletProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Wallet balance card ──────────────────────
                  WalletBalanceCard(
                    walletBalance: walletProvider.walletBalance,
                    dailyLimit: walletProvider.dailyLimit,
                    remainingDailyLimit: walletProvider.remainingDailyLimit,
                  ),

                  const SizedBox(height: 20),

                  // ── Action buttons ───────────────────────────
                  Row(
                    children: [
                      _buildActionButton(
                        icon: Icons.add_rounded,
                        label: 'Add Money',
                        color: const Color(0xFF0F6E56),
                        onTap: () => _showTopUp(
                          context,
                          walletProvider,
                          accountProvider,
                          authProvider,
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildActionButton(
                        icon: Icons.account_balance_outlined,
                        label: 'To Bank',
                        color: AppColors.primaryDark,
                        onTap: () => _showTransferToBank(
                          context,
                          walletProvider,
                          accountProvider,
                          authProvider,
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildActionButton(
                        icon: Icons.send_rounded,
                        label: 'Send',
                        color: const Color(0xFF7C3AED),
                        onTap: () => _navigateToSendMoney(context), // ✅ fixed
                      ),
                      const SizedBox(width: 12),
                      _buildActionButton(
                        icon: Icons.qr_code_rounded,
                        label: 'Pay QR',
                        color: const Color(0xFF0EA5E9),
                        onTap: () => _navigateToScanQr(context), // ✅ fixed
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── Account balance info ─────────────────────
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.primaryDark.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.account_balance_outlined,
                                color: AppColors.primaryDark,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Linked Bank Balance',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  '₹${walletProvider.accountBalance.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1A1A2E),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Icon(Icons.chevron_right, color: Colors.grey.shade400),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Transaction history ──────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Wallet History',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      Text(
                        '${walletProvider.history.length} transactions',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  if (walletProvider.history.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 48,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No transactions yet',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...walletProvider.history.map(
                      (txn) => WalletTransactionTile(transaction: txn),
                    ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
