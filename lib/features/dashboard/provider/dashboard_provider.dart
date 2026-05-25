import 'package:flutter/material.dart';

class DashboardProvider extends ChangeNotifier {

  double totalBalance = 125430.50;

  List<Map<String, dynamic>> transactions = [

    {
      'title': 'Salary Credit',
      'subtitle': 'Salary for May',
      'amount': '+ ₹75,000',
      'color': Colors.green,
      'icon': Icons.arrow_downward,
      'bgColor': const Color(0xffDDF7E3),
    },

    {
      'title': 'Amazon Payment',
      'subtitle': 'Online Shopping',
      'amount': '- ₹2,450',
      'color': Colors.red,
      'icon': Icons.arrow_upward,
      'bgColor': const Color(0xffFFE1E1),
    },

    {
      'title': 'Rahul Savings A/c',
      'subtitle': 'Money Transfer',
      'amount': '- ₹5,000',
      'color': Colors.red,
      'icon': Icons.account_balance,
      'bgColor': const Color(0xffE8E2FF),
    },
  ];
}