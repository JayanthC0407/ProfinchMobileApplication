import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/core/routes/app_routes.dart';

// ✅ Keep both — UPI imports (your branch) + AccountProvider (main branch)
import 'package:profinch_mobile_application/features/upi/provider/upi_provider.dart';
import 'package:profinch_mobile_application/features/upi/screens/receive_money_screen.dart';
import 'package:profinch_mobile_application/features/upi/screens/scan_qr_screen.dart';
import 'package:profinch_mobile_application/features/upi/screens/upi_home_screen.dart';
import 'package:profinch_mobile_application/features/accounts/provider/account_provider.dart';
import 'package:provider/provider.dart';

import '../provider/dashboard_provider.dart';
import '../widgets/balance_card.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/feature_item.dart';
import '../widgets/quick_action_item.dart';
import '../widgets/transaction_tiles.dart';
import '../../auth/provider/auth_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashboardProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser!;

    // ✅ Use AccountProvider (main branch) — cleaner approach
    final accountProvider = Provider.of<AccountProvider>(context);
    final userAccounts = accountProvider.getAccountsByUserId(user.id);

    final selectedAccount = userAccounts.firstWhere(
      (account) =>
          account.id == (provider.selectedAccountId ?? user.primaryAccountId),
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
                              "Hello, ${user.username} 👋",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 3),
                            const Text(
                              "Welcome Back",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(
                          Icons.notifications_none,
                          size: 30,
                          color: Colors.white,
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
                  accountNumber: selectedAccount.accountNumber,
                  accountType: selectedAccount.accountType,
                  accounts: userAccounts,
                  selectedAccountId: selectedAccount.id,
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
                    children: [
                      // ✅ Your UPI navigation kept
                      QuickActionItem(
                        icon: Icons.send,
                        title: "Pay to anyone",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChangeNotifierProvider(
                              create: (ctx) =>
                                  UpiProvider(ctx.read<AuthProvider>()),
                              child: const UpiHomeScreen(),
                            ),
                          ),
                        ),
                      ),
                      QuickActionItem(
                        icon: Icons.add_circle_outline,
                        title: "Receive",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChangeNotifierProvider(
                              create: (ctx) =>
                                  UpiProvider(ctx.read<AuthProvider>()),
                              child: const ReceiveMoneyScreen(),
                            ),
                          ),
                        ),
                      ),
                      QuickActionItem(
                        icon: Icons.qr_code_scanner,
                        title: "Scan",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChangeNotifierProvider(
                              create: (ctx) =>
                                  UpiProvider(ctx.read<AuthProvider>()),
                              child: const ScanQrScreen(),
                            ),
                          ),
                        ),
                      ),
                      QuickActionItem(
                        icon: Icons.account_balance_wallet,
                        title: "Wallet",
                      ),
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
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Edit",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ── QUICK ACCESS GRID ─────────────────────────────
                // ✅ Use teammate's expanded grid (More/Less toggle + Term Deposits)
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                  children: [
                    FeatureItem(
                      icon: Icons.account_balance,
                      title: "Accounts",
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.accounts),
                    ),

                    FeatureItem(
                      icon: Icons.credit_card,
                      title: "Cards",
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.cards),
                    ),

                    FeatureItem(
                      icon: Icons.currency_rupee,
                      title: "Loans",

                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.loans),
                    ),

                    const FeatureItem(
                      icon: Icons.bar_chart,
                      title: "Analytics",
                    ),

                    if (!provider.showMoreServices) ...[
                      const FeatureItem(
                        icon: Icons.account_balance_wallet,
                        title: "Wallet",
                      ),

                      const FeatureItem(
                        icon: Icons.receipt_long,
                        title: "Bills",
                      ),

                      const FeatureItem(
                        icon: Icons.card_giftcard,
                        title: "Rewards",
                      ),

                      FeatureItem(
                        icon: Icons.more_horiz,
                        title: "More",
                        onTap: () => provider.toggleMoreServices(),
                      ),
                    ] else ...[
                      FeatureItem(
                        icon: Icons.savings,
                        title: "Term Dep.",
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.termDeposits,
                        ),
                      ),

                      const FeatureItem(
                        icon: Icons.trending_up,
                        title: "Invest.",
                      ),

                      const FeatureItem(
                        icon: Icons.security,
                        title: "Insurance",
                      ),

                      const FeatureItem(
                        icon: Icons.support_agent,
                        title: "Service",
                      ),

                      const FeatureItem(
                        icon: Icons.description,
                        title: "Statements",
                      ),

                      FeatureItem(
                        icon: Icons.people,
                        title: "Benefic.",
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.beneficiaries);
                        },
                      ),

                      const FeatureItem(
                        icon: Icons.calculate,
                        title: "Calculator",
                      ),

                      FeatureItem(
                        icon: Icons.expand_less,
                        title: "Less",
                        onTap: () {
                          provider.toggleMoreServices();
                        },
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 26),

                // ── RECENT TRANSACTIONS HEADER ────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Recent Transactions",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.transactions),
                      child: const Text(
                        "See All",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
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
