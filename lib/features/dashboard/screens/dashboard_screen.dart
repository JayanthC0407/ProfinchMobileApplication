import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/core/routes/app_routes.dart';
import 'package:profinch_mobile_application/features/analytics/screens/analytics_screen.dart';
import 'package:profinch_mobile_application/features/upi/provider/upi_provider.dart';
import 'package:profinch_mobile_application/features/upi/screens/receive_money_screen.dart';
import 'package:profinch_mobile_application/features/upi/screens/scan_qr_screen.dart';
import 'package:profinch_mobile_application/features/upi/screens/upi_home_screen.dart';
import 'package:profinch_mobile_application/features/accounts/provider/account_provider.dart';
import 'package:profinch_mobile_application/core/constants/fonts_size.dart';
import 'package:provider/provider.dart';

import '../provider/dashboard_provider.dart';
import '../widgets/balance_card.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/feature_item.dart';
import '../widgets/quick_action_item.dart';
import '../../auth/provider/auth_provider.dart';

// ✅ New transaction history module (replaces old map-based TransactionTile)
import 'package:profinch_mobile_application/features/Transactions/provider/transaction_provider.dart';
import 'package:profinch_mobile_application/features/Transactions/widgets/transaction_tile_widget.dart';
import 'package:profinch_mobile_application/features/Transactions/screens/transaction_history_screen.dart';
import 'package:profinch_mobile_application/features/notifications/provider/notification_provider.dart';

import 'package:profinch_mobile_application/core/constants/colors.dart';
import 'dart:typed_data';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashboardProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      });

      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, AppRoutes.profile),
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.accent,
                            child: ClipOval(
                              child: authProvider.profileImageBytes != null
                                  ? Image.memory(
                                      authProvider.profileImageBytes!,
                                      fit: BoxFit.cover,
                                      width: 48,
                                      height: 48,
                                    )
                                  : (user.profileImage.isNotEmpty
                                        ? Image.asset(
                                            user.profileImage,
                                            fit: BoxFit.cover,
                                            width: 48,
                                            height: 48,
                                            errorBuilder: (_, __, ___) =>
                                                _initialsText(
                                                  context,
                                                  user.username,
                                                ),
                                          )
                                        : _initialsText(
                                            context,
                                            user.username,
                                          )),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello, ${user.username} 👋",
                              style: TextStyle(
                                fontSize: AppFontSize.large(context),
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              "Welcome Back",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: AppFontSize.body(context),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Consumer<NotificationProvider>(
                      builder: (context, notifProvider, _) {
                        final unread = notifProvider.unreadCount(user.id);
                        return GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.notifications,
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              const Icon(
                                Icons.notifications_none,
                                size: 30,
                                color: Colors.white,
                              ),
                              if (unread > 0)
                                Positioned(
                                  right: -2,
                                  top: -2,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      unread > 9 ? '9+' : '$unread',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: AppFontSize.xs(context),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                // ── BALANCE CARD — swipeable between accounts ──────
                BalanceCard(
                  accounts: userAccounts,
                  selectedAccountId: selectedAccount.id,
                  isBalanceHidden: provider.isBalanceHidden,
                  onToggleVisibility: provider.toggleBalanceVisibility,
                  onChanged: (accountId) {
                    if (accountId == null) return;
                    provider.selectAccount(accountId);
                  },
                  // kept for signature compat, card now reads from accounts
                  balance: selectedAccount.availableBalance,
                  accountNumber: selectedAccount.accountNumber,
                  accountType: selectedAccount.accountType,
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
                              create: (ctx) => UpiProvider(
                                ctx.read<AuthProvider>(),
                                ctx.read<AccountProvider>(),
                              ),
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
                              create: (ctx) => UpiProvider(
                                ctx.read<AuthProvider>(),
                                ctx.read<AccountProvider>(),
                              ),
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
                              create: (ctx) => UpiProvider(
                                ctx.read<AuthProvider>(),
                                ctx.read<AccountProvider>(),
                              ),
                              child: const ScanQrScreen(),
                            ),
                          ),
                        ),
                      ),
                      QuickActionItem(
                        icon: Icons.account_balance_wallet,
                        title: "Wallet",
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoutes.wallet),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 26),

                // ── QUICK ACCESS HEADER ───────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Quick Access",
                      style: TextStyle(
                        fontSize: AppFontSize.large(context),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Edit",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: AppFontSize.body(context),
                      ),
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

                    FeatureItem(
                      icon: Icons.bar_chart,
                      title: "Analytics",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AnalyticsScreen(),
                          ),
                        );
                      },
                    ),

                    // Always visible items
                    FeatureItem(
                      icon: Icons.calculate,
                      title: "Calculator",
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.calculators);
                      },
                    ),

                    FeatureItem(
                      icon: Icons.receipt_long,
                      title: "Bills",
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.bills),
                    ),

                    FeatureItem(
                      icon: Icons.card_giftcard,
                      title: "Rewards",
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.rewards),
                    ),

                    // Show More button initially
                    if (!provider.showMoreServices)
                      FeatureItem(
                        icon: Icons.more_horiz,
                        title: "More",
                        onTap: () => provider.toggleMoreServices(),
                      ),

                    // Additional items when expanded
                    if (provider.showMoreServices) ...[
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

                      FeatureItem(
                        icon: Icons.security,
                        title: "Insurance",
                        onTap: () { Navigator.pushNamed(
                          context,
                          AppRoutes.insurance,
                        );
                        },
                      ),

                      FeatureItem(
                        icon: Icons.people,
                        title: "Benefic.",
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.beneficiaries);
                        },
                      ),

                      FeatureItem(
                        icon: Icons.expand_less,
                        title: "Less",
                        onTap: () => provider.toggleMoreServices(),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 26),

                // ── RECENT TRANSACTIONS HEADER ────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recent Transactions",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppFontSize.large(context),
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TransactionHistoryScreen(),
                        ),
                      ),
                      child: Text(
                        "See All",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: AppFontSize.body(context),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // ── RECENT TRANSACTION LIST (latest 2) ────────────
                // Listens directly to the shared TransactionProvider so
                // that any transaction recorded anywhere in the app
                // (UPI, transfer, withdrawal, EMI, loan, term deposit...)
                // appears here immediately, without a page reload.
                AnimatedBuilder(
                  animation: TransactionProvider.instance,
                  builder: (context, _) {
                    final recent = TransactionProvider.instance
                        .recentTransactions(count: 2);
                    return Column(
                      children: recent
                          .map(
                            (transaction) => TransactionTileWidget(
                              transaction: transaction,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const TransactionHistoryScreen(),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _initialsText(BuildContext context, String username) {
    return Text(
      username
          .trim()
          .split(' ')
          .where((e) => e.isNotEmpty)
          .take(2)
          .map((e) => e[0].toUpperCase())
          .join(),
      style: TextStyle(
        color: AppColors.light,
        fontSize: AppFontSize.body(context),
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
