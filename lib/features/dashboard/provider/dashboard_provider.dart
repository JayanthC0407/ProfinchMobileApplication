import 'package:flutter/material.dart';

class DashboardProvider extends ChangeNotifier {

  String? selectedAccountId;

  void selectAccount(String accountId) {
    selectedAccountId = accountId;
    notifyListeners();
  }

  void resetToPrimary(String accountId) {
    selectedAccountId = accountId;
    notifyListeners();
  }

  List<Map<String, dynamic>> transactions = [
    {
      'title': 'Salary Credit',
      'subtitle': 'Salary for May',
      'amount': '+ ₹75,000',
      'color': Colors.green,
      'icon': Icons.arrow_downward,
      'bgColor': const Color(0xffDDF7E3),
    },
  ];
}