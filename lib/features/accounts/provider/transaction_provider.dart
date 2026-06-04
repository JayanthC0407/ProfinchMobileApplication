import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/data/models/transaction_model.dart';
import 'package:profinch_mobile_application/data/dummy/dummy_transactions.dart';

enum TransactionFilter { all, credit, debit }

class TransactionProvider extends ChangeNotifier {
  final List<TransactionModel> _allTransactions =
      List.from(DummyTransactions.allTransactions);

  // ── Active filters ─────────────────────────────────────────────
  TransactionFilter _typeFilter = TransactionFilter.all;
  TransactionCategory? _categoryFilter;
  DateTimeRange? _dateRange;
  String _searchQuery = '';

  // ── Getters ────────────────────────────────────────────────────
  TransactionFilter get typeFilter => _typeFilter;
  TransactionCategory? get categoryFilter => _categoryFilter;
  DateTimeRange? get dateRange => _dateRange;
  String get searchQuery => _searchQuery;

  bool get hasActiveFilters =>
      _typeFilter != TransactionFilter.all ||
      _categoryFilter != null ||
      _dateRange != null ||
      _searchQuery.isNotEmpty;

  // ── Filtered transactions ──────────────────────────────────────
  List<TransactionModel> get filteredTransactions {
    List<TransactionModel> result = List.from(_allTransactions);

    // Filter by type
    if (_typeFilter == TransactionFilter.credit) {
      result = result.where((t) => t.type == TransactionType.credit).toList();
    } else if (_typeFilter == TransactionFilter.debit) {
      result = result.where((t) => t.type == TransactionType.debit).toList();
    }

    // Filter by category
    if (_categoryFilter != null) {
      result = result.where((t) => t.category == _categoryFilter).toList();
    }

    // Filter by date range
    if (_dateRange != null) {
      result = result.where((t) =>
        t.date.isAfter(_dateRange!.start.subtract(const Duration(days: 1))) &&
        t.date.isBefore(_dateRange!.end.add(const Duration(days: 1)))
      ).toList();
    }

    // Filter by search
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((t) =>
        t.title.toLowerCase().contains(q) ||
        t.description.toLowerCase().contains(q) ||
        (t.receiverName?.toLowerCase().contains(q) ?? false)
      ).toList();
    }

    // Sort by date descending
    result.sort((a, b) => b.date.compareTo(a.date));
    return result;
  }

  // ── Total credit / debit for filtered results ──────────────────
  double get totalCredit => filteredTransactions
      .where((t) => t.type == TransactionType.credit)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalDebit => filteredTransactions
      .where((t) => t.type == TransactionType.debit)
      .fold(0.0, (sum, t) => sum + t.amount);

  // ── Filter setters ─────────────────────────────────────────────
  void setTypeFilter(TransactionFilter filter) {
    _typeFilter = filter;
    notifyListeners();
  }

  void setCategoryFilter(TransactionCategory? category) {
    _categoryFilter = category;
    notifyListeners();
  }

  void setDateRange(DateTimeRange? range) {
    _dateRange = range;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearAllFilters() {
    _typeFilter = TransactionFilter.all;
    _categoryFilter = null;
    _dateRange = null;
    _searchQuery = '';
    notifyListeners();
  }
}