import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/data/dummy/dummy_accounts.dart';
import 'package:profinch_mobile_application/data/models/account_model.dart';

class AccountProvider extends ChangeNotifier {

  List<AccountModel> getAccountsByUserId(String userId) {

    return DummyAccounts.allAccounts
        .where((account) => account.userId == userId)
        .toList();
  }


  double getTotalBalance(String userId) {

    return DummyAccounts.allAccounts
        .where((account) => account.userId == userId)
        .fold(
          0,
          (sum, account) => sum + account.balance,
        );
  }
}