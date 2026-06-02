import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/core/routes/app_routes.dart';
import 'package:provider/provider.dart';

import '../provider/dashboard_provider.dart';
import '../widgets/balance_card.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/feature_item.dart';
import '../widgets/quick_action_item.dart';
import '../widgets/transaction_tiles.dart';
import '../../auth/provider/auth_provider.dart';
import '../../../data/dummy/dummy_accounts.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashboardProvider>(context);

    final authProvider =
      Provider.of<AuthProvider>(context);

    final user = authProvider.currentUser!;

    final userAccounts =
      DummyAccounts.allAccounts
          .where((account) =>
              account.userId == user.id)
          .toList();

    final selectedAccount =
    userAccounts.firstWhere(
      (account) =>
          account.id ==
          (provider.selectedAccountId ??
              user.primaryAccountId),
      orElse: () => userAccounts.first,
    );
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/loginPhoneBg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ── HEADER ───────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          backgroundImage: AssetImage('images/avatar.jpg'),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello, ${user?.username ?? 'User'} 👋",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,       // ✅ white text
                              ),
                            ),
                            const SizedBox(height: 3),
                            const Text(
                              "Welcome Back",
                              style: TextStyle(
                                color: Colors.white70,     // ✅ white text
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Notification bell
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(
                          Icons.notifications_none,
                          size: 30,
                          color: Colors.white,             // ✅ white icon
                        ),
                        Positioned(
                          right: -2,
                          top: -2,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Text(
                              '3',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                // ── BALANCE CARD ──────────────────────────────────
                BalanceCard(
                  balance: selectedAccount.availableBalance,
                  accountNumber:
                      selectedAccount.accountNumber,
                  accountType:
                      selectedAccount.accountType,
                  accounts: userAccounts,
                  selectedAccountId:
                      selectedAccount.id,
                  onChanged: (accountId) {

                    if (accountId == null) return;

                    provider.selectAccount(accountId);
                  },
                ),

                const SizedBox(height: 22),

                // ── QUICK ACTIONS ─────────────────────────────────
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      QuickActionItem(icon: Icons.send, title: "Send"),
                      QuickActionItem(icon: Icons.add_circle_outline, title: "Add Money"),
                      QuickActionItem(icon: Icons.qr_code_scanner, title: "Scan"),
                      QuickActionItem(icon: Icons.account_balance_wallet, title: "Wallet"),
                    ],
                  ),
                ),

                const SizedBox(height: 26),

                // ── QUICK ACCESS HEADER ───────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Quick Access",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,               // ✅ white text
                      ),
                    ),
                    Text(
                      "Edit",
                      style: TextStyle(
                        color: Colors.white70,             // ✅ white text
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ── QUICK ACCESS GRID ─────────────────────────────
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,                 // ✅ gives more height
                  children: [
                    FeatureItem(
                      icon: Icons.account_balance,
                      title: "Accounts",
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.accounts,
                        );
                       },
                      ),
                    FeatureItem(icon: Icons.credit_card, title: "Cards"),
                    FeatureItem(icon: Icons.currency_rupee, title: "Loans"),
                    FeatureItem(icon: Icons.bar_chart, title: "Analytics"),
                    FeatureItem(icon: Icons.account_balance_wallet, title: "Wallet"),
                    FeatureItem(icon: Icons.receipt_long, title: "Bills"),
                    FeatureItem(icon: Icons.card_giftcard, title: "Rewards"),
                    FeatureItem(icon: Icons.more_horiz, title: "More"),
                  ],
                ),

                const SizedBox(height: 26),

                // ── RECENT TRANSACTIONS HEADER ────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Recent Transactions",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,               // ✅ white text
                      ),
                    ),
                    Text(
                      "See All",
                      style: TextStyle(
                        color: Colors.white70,             // ✅ white text
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // ── TRANSACTION LIST ──────────────────────────────
                ...provider.transactions.map(
                  (transaction) => TransactionTile(
                    title: transaction['title'],
                    subtitle: transaction['subtitle'],
                    amount: transaction['amount'],
                    amountColor: transaction['color'],
                    icon: transaction['icon'],
                    iconBg: transaction['bgColor'],
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}