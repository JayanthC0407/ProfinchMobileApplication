import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/data/dummy/dummy_accounts.dart';
import 'package:profinch_mobile_application/data/models/account_model.dart';

class AccountProvider extends ChangeNotifier {

  final List<AccountModel> _accounts =
      List.from(DummyAccounts.allAccounts);

  List<AccountModel> get accounts => _accounts;

  List<AccountModel> getAccountsByUserId(String userId) {
    return _accounts
        .where((account) => account.userId == userId)
        .toList();
  }

  double getTotalBalance(String userId) {
    return _accounts
        .where((account) => account.userId == userId)
        .fold(0, (sum, account) => sum + account.availableBalance);
  }

  AccountModel getAccountById(String accountId) {
    return _accounts.firstWhere(
      (account) => account.id == accountId,
    );
  }

  void debitAccount(String accountId, double amount) {
    final index = _accounts.indexWhere(
      (account) => account.id == accountId,
    );
    if (index == -1) return;
    final account = _accounts[index];
    _accounts[index] = account.copyWith(
      balance: account.balance - amount,
      availableBalance: account.availableBalance - amount,
    );
    notifyListeners();
  }

  void creditAccount(String accountId, double amount) {
    final index = _accounts.indexWhere(
      (account) => account.id == accountId,
    );
    if (index == -1) return;
    final account = _accounts[index];
    _accounts[index] = account.copyWith(
      balance: account.balance + amount,
      availableBalance: account.availableBalance + amount,
    );
    notifyListeners();
  }
}