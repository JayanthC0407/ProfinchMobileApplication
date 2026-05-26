import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/dashboard_provider.dart';
import '../widgets/balance_card.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/feature_item.dart';
import '../widgets/quick_action_item.dart';
import '../widgets/transaction_tiles.dart';
import 'package:provider/provider.dart';
import '../../auth/provider/auth_provider.dart';

class DashboardScreen extends StatelessWidget {

  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<DashboardProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    final user = authProvider.currentUser;

    return Scaffold(

      bottomNavigationBar: const BottomNavBar(),

      body: SafeArea(
        child: SingleChildScrollView(

          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 10,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Row(
                    children: [

                      const CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/150?img=12',
                        ),
                      ),

                      const SizedBox(width: 12),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            "Hello, ${user?.username ?? 'User'} 👋",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4),

                          const Text(
                            "Welcome Back",
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),

                  Stack(
                    children: [

                      const Icon(
                        Icons.notifications_none,
                        size: 30,
                      ),

                      Positioned(
                        right: 0,
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
                              fontSize: 10,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),

              const SizedBox(height: 25),

              /// BALANCE CARD
              BalanceCard(
                balance: provider.totalBalance,
              ),

              const SizedBox(height: 25),

              /// QUICK ACTIONS
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [

                    QuickActionItem(
                      icon: Icons.send,
                      title: "Send",
                    ),

                    QuickActionItem(
                      icon: Icons.add_circle_outline,
                      title: "Add Money",
                    ),

                    QuickActionItem(
                      icon: Icons.qr_code_scanner,
                      title: "Scan",
                    ),

                    QuickActionItem(
                      icon: Icons.account_balance_wallet,
                      title: "Wallet",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// QUICK ACCESS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [

                  Text(
                    "Quick Access",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    "Edit",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                crossAxisSpacing: 18,
                mainAxisSpacing: 20,
                children: const [

                  FeatureItem(
                    icon: Icons.account_balance,
                    title: "Accounts",
                  ),

                  FeatureItem(
                    icon: Icons.credit_card,
                    title: "Cards",
                  ),

                  FeatureItem(
                    icon: Icons.currency_rupee,
                    title: "Loans",
                  ),

                  FeatureItem(
                    icon: Icons.bar_chart,
                    title: "Analytics",
                  ),

                  FeatureItem(
                    icon: Icons.account_balance_wallet,
                    title: "Wallet",
                  ),

                  FeatureItem(
                    icon: Icons.receipt_long,
                    title: "Bills",
                  ),

                  FeatureItem(
                    icon: Icons.card_giftcard,
                    title: "Rewards",
                  ),

                  FeatureItem(
                    icon: Icons.more_horiz,
                    title: "More",
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// TRANSACTIONS
              const Text(
                "Recent Transactions",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),

              const SizedBox(height: 20),

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
            ],
          ),
        ),
      ),
    );
  }
}