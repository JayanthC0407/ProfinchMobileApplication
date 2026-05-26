import 'package:profinch_mobile_application/data/models/account_model.dart';

class DummyAccounts {
  DummyAccounts._();

  static final AccountModel primaryAccount = AccountModel(
    id: 'ACC001',
    userId: 'USR001',
    accountNumber: '1234 5678 9012',
    ifscCode: 'PRFN0001234',
    branchName: 'Mangaluru Main Branch',
    accountType: 'Savings',
    balance: 125450.75,
    availableBalance: 124950.75,
    isActive: true,
  );

  static final List<AccountModel> allAccounts = [
    primaryAccount,
    AccountModel(
      id: 'ACC002',
      userId: 'USR001',
      accountNumber: '9876 5432 1098',
      ifscCode: 'PRFN0001234',
      branchName: 'Mangaluru Main Branch',
      accountType: 'Current',
      balance: 45000.00,
      availableBalance: 45000.00,
      isActive: true,
    ),
    AccountModel(
      id: 'ACC003',
      userId: 'USR002',
      accountNumber: '1122 3344 5566',
      ifscCode: 'PRFN0005678',
      branchName: 'Bangalore Branch',
      accountType: 'Savings',
      balance: 78320.50,
      availableBalance: 78320.50,
      isActive: true,
    ),
  ];
}
