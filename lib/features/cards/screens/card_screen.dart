// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:profinch_mobile_application/core/constants/colors.dart';
import 'package:profinch_mobile_application/data/models/card_model.dart';
import '../provider/card_provider.dart';
import '../widgets/card_widget.dart';
import '../widgets/card_limit_widget.dart';
import '../widgets/card_settings_tile.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'My Cards',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              // TODO: Navigate to apply card screen
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          tabs: const [
            Tab(text: 'Debit Card'),
            Tab(text: 'Credit Card'),
          ],
        ),
      ),
      body: Consumer<CardProvider>(
        builder: (context, provider, _) {
          return TabBarView(
            controller: _tabController,
            children: [
              _buildCardTab(context, provider.debitCard, provider),
              _buildCardTab(context, provider.creditCard, provider),
            ],
          );
        },
      ),
    );
  }

  // ── Card Tab ───────────────────────────────────────────────────
  Widget _buildCardTab(
      BuildContext context, CardModel card, CardProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Card visual ────────────────────────────────────────
          CardWidget(card: card),

          const SizedBox(height: 20),

          // ── Quick actions ──────────────────────────────────────
          Row(
            children: [
              _buildQuickAction(
                icon: card.isFrozen
                    ? Icons.ac_unit_rounded
                    : Icons.ac_unit_outlined,
                label: card.isFrozen ? 'Unfreeze' : 'Freeze',
                color: card.isFrozen ? Colors.lightBlue : AppColors.primary,
                onTap: () => provider.toggleFreeze(card.id),
              ),
              const SizedBox(width: 12),
              _buildQuickAction(
                icon: Icons.pin_outlined,
                label: 'Change PIN',
                color: AppColors.primary,
                onTap: () => _showChangePinDialog(context),
              ),
              const SizedBox(width: 12),
              _buildQuickAction(
                icon: Icons.block_outlined,
                label: 'Block Card',
                color: Colors.red,
                onTap: () => _showBlockCardDialog(context, card),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Credit limit bar (credit card only) ────────────────
          if (card.cardType == CardType.credit) ...[
            CardLimitWidget(card: card),
            const SizedBox(height: 20),
          ],

          // ── Reward points (credit card only) ──────────────────
          if (card.cardType == CardType.credit) ...[
            _buildRewardPoints(card),
            const SizedBox(height: 20),
          ],

          // ── ATM limit ──────────────────────────────────────────
          _buildAtmLimitCard(context, card, provider),

          const SizedBox(height: 20),

          // ── Card settings ──────────────────────────────────────
          const Text(
            'Card Settings',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
            ),
          ),

          const SizedBox(height: 12),

          CardSettingsTile(
            icon: Icons.language_rounded,
            title: 'International Transactions',
            subtitle: 'Enable payments outside India',
            value: card.isInternationalEnabled,
            onChanged: (_) => provider.toggleInternational(card.id),
          ),

          CardSettingsTile(
            icon: Icons.shopping_cart_outlined,
            title: 'Online Payments',
            subtitle: 'Enable e-commerce & app payments',
            value: card.isOnlinePaymentEnabled,
            onChanged: (_) => provider.toggleOnlinePayment(card.id),
          ),

          CardSettingsTile(
            icon: Icons.contactless_outlined,
            title: 'Contactless Payments',
            subtitle: 'Enable tap & pay (NFC)',
            value: true,
            onChanged: (_) {},
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ── Quick action button ────────────────────────────────────────
  Widget _buildQuickAction({
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── ATM Limit card ─────────────────────────────────────────────
  Widget _buildAtmLimitCard(
      BuildContext context, CardModel card, CardProvider provider) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Daily ATM Limit',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '₹${card.atmLimit.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          TextButton.icon(
            onPressed: () => _showAtmLimitDialog(context, card, provider),
            icon: const Icon(Icons.edit_outlined, size: 16),
            label: const Text('Change'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Reward points card ─────────────────────────────────────────
  Widget _buildRewardPoints(CardModel card) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF0F3460)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Reward Points',
                style: TextStyle(fontSize: 13, color: Colors.white70),
              ),
              const SizedBox(height: 4),
              Text(
                '${card.rewardPoints} pts',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                '≈ ₹342 cashback value',
                style: TextStyle(fontSize: 12, color: Colors.white54),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Navigate to redeem points screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Redeem'),
          ),
        ],
      ),
    );
  }

  // ── Dialogs ────────────────────────────────────────────────────
  void _showChangePinDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Change PIN'),
        content: const Text(
          'A PIN change request will be sent to your registered mobile number.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement PIN change
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showBlockCardDialog(BuildContext context, CardModel card) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Block Card'),
        content: Text(
          'Are you sure you want to permanently block card ending in ${card.cardNumber}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement card block
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Block'),
          ),
        ],
      ),
    );
  }

  void _showAtmLimitDialog(
      BuildContext context, CardModel card, CardProvider provider) {
    double selectedLimit = card.atmLimit;
    final limits = [10000.0, 25000.0, 50000.0, 100000.0];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Set ATM Limit',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 20),
              ...limits.map(
                (limit) => RadioListTile<double>(
                  value: limit,
                  groupValue: selectedLimit,
                  title: Text('₹${limit.toStringAsFixed(0)}'),
                  activeColor: AppColors.primary,
                  onChanged: (val) =>
                      setModalState(() => selectedLimit = val!),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    provider.updateAtmLimit(card.id, selectedLimit);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Save Limit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}