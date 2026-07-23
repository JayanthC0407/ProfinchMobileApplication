import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:profinch_mobile_application/core/constants/fonts_size.dart';
import 'package:profinch_mobile_application/core/constants/text_styles.dart';
import 'package:profinch_mobile_application/core/utils/responsive_text.dart';
import 'package:provider/provider.dart';
import 'package:profinch_mobile_application/core/constants/colors.dart';
import 'package:profinch_mobile_application/features/auth/provider/auth_provider.dart';
import '../provider/insurance_provider.dart';
import '../../../data/models/insurance_model.dart';
import '../../../data/dummy/dummy_insurance.dart';
import 'my_policies_screen.dart';
import 'buy_insurance_screen.dart';
import 'insurance_claims_screen.dart';
// ignore: unused_import
import 'premium_payment_screen.dart';
import 'plan_selection_screen.dart';

class InsuranceScreen extends StatelessWidget {
  const InsuranceScreen({super.key});

  @override
@override
Widget build(BuildContext context) {
  final user = context.read<AuthProvider>().currentUser!;
  return Consumer<InsuranceProvider>(
    builder: (context, provider, _) {
      final active = provider.getActivePolicies(user.id);
      final totalCoverage = provider.getTotalCoverage(user.id);
      final fmt = NumberFormat('#,##,##0', 'en_IN');

      return Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            // ── Gradient header ──────────────────────────
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.navy, AppColors.blueButton],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 4, 8, 0),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: AppColors.light),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
                      child: Text(
                        'Insurance',
                        style: TextStyle(
                          color: AppColors.light,
                          fontSize: RT.fs(context, 26),
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                      child: Text(
                        'Protect what matters',
                        style: AppTextStyles.whiteBody(context,
                            color: AppColors.light.withValues(alpha: 0.65)),
                      ),
                    ),
                    // Stats row inside header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.light.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                    color: AppColors.light
                                        .withValues(alpha: 0.2)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.policy_outlined,
                                      color: AppColors.light, size: 20),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Active Policies',
                                          style: AppTextStyles.whiteCaption(
                                              context)),
                                      Text('${active.length}',
                                          style: TextStyle(
                                            color: AppColors.light,
                                            fontSize:
                                                AppFontSize.large(context),
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.light.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                    color: AppColors.light
                                        .withValues(alpha: 0.2)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.shield_outlined,
                                      color: AppColors.light, size: 20),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Total Coverage',
                                            style:
                                                AppTextStyles.whiteCaption(
                                                    context)),
                                        Text(
                                          '₹${fmt.format(totalCoverage)}',
                                          style: TextStyle(
                                            color: AppColors.light,
                                            fontSize:
                                                AppFontSize.body(context),
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Scrollable body ───────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    _sectionTitle('Manage Insurance'),
                    const SizedBox(height: 12),
                    _manageCard(context),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _sectionTitle('Featured Plans'),
                        TextButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      const BuyInsuranceScreen())),
                          child: Text('View All',
                              style: TextStyle(
                                  color: AppColors.primary, fontSize: 13)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _featuredPlansRow(context),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
  Widget _statChip(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 11)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _sectionTitle(String t) => Text(t,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E)));

  Widget _manageCard(BuildContext context) {
    final items = [
      _ManageItem(Icons.policy_outlined,       'My Policies',      'View all your policies',      Colors.orange.shade50,   Colors.orange,      () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyPoliciesScreen()))),
      _ManageItem(Icons.add_circle_outline,    'Buy Insurance',    'Explore new plans',            Colors.blue.shade50,     Colors.blue,         () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BuyInsuranceScreen()))),
      _ManageItem(Icons.autorenew_outlined,    'Renew Policy',     'Renew your existing policies', Colors.purple.shade50,   Colors.purple,      () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyPoliciesScreen()))),
      _ManageItem(Icons.assignment_outlined,   'Claims',           'Raise and track claims',       Colors.red.shade50,      Colors.red,          () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InsuranceClaimsScreen()))),
      _ManageItem(Icons.payment_outlined,      'Premium Payment',  'Pay your policy premium',      Colors.green.shade50,    Colors.green,        () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyPoliciesScreen(openPremium: true)))),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: items.asMap().entries.map((e) {
          final i = e.key;
          final item = e.value;
          return Column(
            children: [
              ListTile(
                onTap: item.onTap,
                leading: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: item.bg, borderRadius: BorderRadius.circular(10)),
                  child: Icon(item.icon, color: item.color, size: 20),
                ),
                title: Text(item.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
                subtitle: Text(item.subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              ),
              if (i < items.length - 1)
                Divider(height: 1, indent: 68, color: Colors.grey.shade100),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _featuredPlansRow(BuildContext context) {
    final types = DummyInsurance.insuranceTypes;
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: types.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final t = types[i];
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => PlanSelectionScreen(typeConfig: t))),
            child: Container(
              width: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: _typeColor(t.type).withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_typeIcon(t.type), color: _typeColor(t.type), size: 22),
                  ),
                  const SizedBox(height: 8),
                  Text(t.name.split(' ').first,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E)),
                    textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _typeIcon(InsuranceType t) {
    switch (t) {
      case InsuranceType.health: return Icons.favorite_border_rounded;
      case InsuranceType.life:   return Icons.shield_outlined;
      case InsuranceType.motor:  return Icons.directions_car_outlined;
      case InsuranceType.travel: return Icons.flight_outlined;
      case InsuranceType.home:   return Icons.home_outlined;
    }
  }

  Color _typeColor(InsuranceType t) {
    switch (t) {
      case InsuranceType.health: return Colors.red;
      case InsuranceType.life:   return Colors.blue;
      case InsuranceType.motor:  return Colors.orange;
      case InsuranceType.travel: return Colors.teal;
      case InsuranceType.home:   return Colors.purple;
    }
  }
}

class _ManageItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color bg;
  final Color color;
  final VoidCallback onTap;
  _ManageItem(this.icon, this.title, this.subtitle, this.bg, this.color, this.onTap);
}