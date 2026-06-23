import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/core/constants/text_styles.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:profinch_mobile_application/core/constants/colors.dart';
import 'package:profinch_mobile_application/features/Transactions/provider/transaction_provider.dart';
import '../widgets/transaction_tile_widget.dart';
import '../widgets/transaction_filter_bar.dart';
import '../widgets/transaction_summary_card.dart';
import '../widgets/category_filter_sheet.dart';

import 'package:profinch_mobile_application/core/constants/fonts_size.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: TransactionProvider.instance,
      child: const _TransactionHistoryView(),
    );
  }
}

class _TransactionHistoryView extends StatefulWidget {
  const _TransactionHistoryView();

  @override
  State<_TransactionHistoryView> createState() =>
      _TransactionHistoryViewState();
}

class _TransactionHistoryViewState extends State<_TransactionHistoryView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Date range picker ──────────────────────────────────────────
  Future<void> _pickDateRange(
      BuildContext context, TransactionProvider provider) async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: now,
      initialDateRange: provider.dateRange ??
          DateTimeRange(
            start: now.subtract(const Duration(days: 30)),
            end: now,
          ),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.primaryDark,
            onPrimary: Colors.white,
            surface: AppColors.light,
            onSurface: AppColors.textPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) provider.setDateRange(picked);
  }

  // ── Category filter sheet ──────────────────────────────────────
  void _showCategoryFilter(
      BuildContext context, TransactionProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CategoryFilterSheet(
        selected: provider.categoryFilter,
        onSelected: provider.setCategoryFilter,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Transaction History',
          style: AppTextStyles.whiteTitle(context),
        ),
        actions: [
          Consumer<TransactionProvider>(
            builder: (context, provider, _) => provider.hasActiveFilters
                ? TextButton(
                    onPressed: () {
                      provider.clearAllFilters();
                      _searchController.clear();
                    },
                    child: Text(
                      'Clear',
                      style: AppTextStyles.whiteBody(context, color: AppColors.light.withValues(alpha: 0.7)),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, _) {
          final transactions = provider.filteredTransactions;

          return Column(
            children: [

              // ── Search + filter controls ───────────────────────
              Container(
                color: AppColors.primaryDark,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: [

                    // Search bar
                    Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.light,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: provider.setSearchQuery,
                        style: AppTextStyles.body(context),
                        decoration: InputDecoration(
                          hintText: 'Search transactions...',
                          hintStyle: AppTextStyles.bodySecondary(context, color: Colors.grey.shade400),
                          prefixIcon: const Icon(Icons.search,
                              size: 20, color: Colors.grey),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.close,
                                      size: 18, color: Colors.grey),
                                  onPressed: () {
                                    _searchController.clear();
                                    provider.setSearchQuery('');
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Filter chips row
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                      
                          // Type filter chips
                          
                            TransactionFilterBar(
                              selected: provider.typeFilter,
                              onChanged: provider.setTypeFilter,
                            ),
                          
                      
                          const SizedBox(width: 8),
                      
                          // Category filter button
                          GestureDetector(
                            onTap: () =>
                                _showCategoryFilter(context, provider),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: provider.categoryFilter != null
                                    ? Colors.white
                                    : Colors.white24,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.category_outlined,
                                    size: 16,
                                    color: provider.categoryFilter != null
                                        ? AppColors.primaryDark
                                        : Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Category',
                                    style: AppTextStyles.smallBold(context,
                                      color: provider.categoryFilter != null
                                          ? AppColors.primaryDark
                                          : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      
                          const SizedBox(width: 8),
                      
                          // Date range button
                          GestureDetector(
                            onTap: () => _pickDateRange(context, provider),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: provider.dateRange != null
                                    ? Colors.white
                                    : Colors.white24,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.date_range_outlined,
                                    size: 16,
                                    color: provider.dateRange != null
                                        ? AppColors.primaryDark
                                        : Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    provider.dateRange != null
                                        ? '${DateFormat('dd MMM').format(provider.dateRange!.start)} - ${DateFormat('dd MMM').format(provider.dateRange!.end)}'
                                        : 'Date',
                                    style: AppTextStyles.smallBold(context,
                                      color: provider.dateRange != null
                                          ? AppColors.primaryDark
                                          : Colors.white,
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

              // ── Body ───────────────────────────────────────────
              Expanded(
                child: transactions.isEmpty
                    ? _buildEmptyState()
                    : ListView(
                        padding: const EdgeInsets.all(16),
                        children: [

                          // Summary card
                          TransactionSummaryCard(
                            totalCredit: provider.totalCredit,
                            totalDebit: provider.totalDebit,
                          ),

                          const SizedBox(height: 14),

                          // Transaction count
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${transactions.length} transaction${transactions.length == 1 ? '' : 's'}',
                                style:  AppTextStyles.bodyBold(context),
                              ),
                              if (provider.hasActiveFilters)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryDark
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Filtered',
                                    style: AppTextStyles.smallBold(context, color: AppColors.primaryDark),
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Transaction list
                          ...transactions.map(
                            (txn) => TransactionTileWidget(transaction: txn),
                          ),

                          const SizedBox(height: 16),
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Empty state ────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long_outlined,
              size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No transactions found',
            style: AppTextStyles.labelBold(context, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: AppTextStyles.bodySecondary(context, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}