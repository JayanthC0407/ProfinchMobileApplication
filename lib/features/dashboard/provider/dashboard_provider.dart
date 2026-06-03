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

  bool showMoreServices = false;

    void toggleMoreServices() {
      showMoreServices = !showMoreServices;
      notifyListeners();
    }

  List<Map<String, dynamic>> transactions = [
    {
      'title': 'Salary Credit',
      'subtitle': 'Salary for May',
      'amount': '+ ₹75,000',
      'color': const Color.fromARGB(255, 94, 194, 97),
      'icon': Icons.arrow_downward,
      'bgColor': const Color(0xffDDF7E3),
    },
  ];
}