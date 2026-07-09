import 'dart:math';
import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/core/constants/colors.dart';
import 'package:profinch_mobile_application/core/constants/fonts_size.dart';
import 'package:profinch_mobile_application/core/constants/text_styles.dart';
import 'package:profinch_mobile_application/core/utils/responsive_text.dart';
import 'package:provider/provider.dart';
import '../../../data/models/loan_model.dart';
import '../../accounts/provider/account_provider.dart';
import '../../auth/provider/auth_provider.dart';
import '../provider/loan_provider.dart';
import '../../Transactions/provider/transaction_provider.dart';
import '../../notifications/provider/notification_provider.dart';
import '../../../data/models/notification_model.dart';

class ApplyLoanScreen extends StatefulWidget {
  const ApplyLoanScreen({super.key});

  @override
  State<ApplyLoanScreen> createState() => _ApplyLoanScreenState();
}

class _ApplyLoanScreenState extends State<ApplyLoanScreen> {
  final _formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final tenureController = TextEditingController();
  String loanType = "Personal Loan";
  String? selectedAccountId;
  bool autoPayEnabled = false;
  int autoPayDate = 5;
  double emiAmount = 0;

  @override
  void dispose() {
    amountController.dispose();
    tenureController.dispose();
    super.dispose();
  }

  void calculateEmi() {
    if (amountController.text.isEmpty || tenureController.text.isEmpty) return;
    final principal = double.parse(amountController.text);
    final tenure = int.parse(tenureController.text);
    const annualRate = 10.5;
    final monthlyRate = annualRate / 12 / 100;
    final emi = principal *
        monthlyRate *
        (pow(1 + monthlyRate, tenure) / (pow(1 + monthlyRate, tenure) - 1));
    setState(() => emiAmount = emi);
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.textSecondary,
            fontSize: AppFontSize.small(context)),
        filled: true,
        fillColor: AppColors.light,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      );

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final accountProvider =
        Provider.of<AccountProvider>(context, listen: false);
    final loanProvider = Provider.of<LoanProvider>(context, listen: false);
    final user = authProvider.currentUser!;
    final accounts = accountProvider.getAccountsByUserId(user.id);

    return Scaffold(
      backgroundColor: AppColors.background,

        appBar: AppBar(
    backgroundColor: AppColors.primaryDark, // Same color as Term Deposits
    elevation: 0,
    centerTitle: true,
    iconTheme: const IconThemeData(color: Colors.white),
    title: Text(
      'Apply for Loan',
      style: TextStyle(
        color: Colors.white,
        fontSize: AppFontSize.large(context),
        fontWeight: FontWeight.w700,
      ),
    ),
  ),

            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Loan type
                    Text('LOAN DETAILS',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: AppFontSize.xs(context),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        )),
                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      value: loanType,
                      decoration: _inputDecoration('Loan Type'),
                      dropdownColor: AppColors.light,
                      items: const [
                        DropdownMenuItem(value: 'Personal Loan',
                            child: Text('Personal Loan')),
                        DropdownMenuItem(value: 'Home Loan',
                            child: Text('Home Loan')),
                        DropdownMenuItem(value: 'Vehicle Loan',
                            child: Text('Vehicle Loan')),
                        DropdownMenuItem(value: 'Education Loan',
                            child: Text('Education Loan')),
                        DropdownMenuItem(value: 'Business Loan',
                            child: Text('Business Loan')),
                      ],
                      onChanged: (v) => setState(() => loanType = v!),
                    ),

                    const SizedBox(height: 14),

                    TextFormField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration('Loan Amount (₹)'),
                      validator: (v) => v == null || v.isEmpty
                          ? 'Enter loan amount' : null,
                    ),

                    const SizedBox(height: 14),

                    TextFormField(
                      controller: tenureController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration('Tenure (Months)'),
                      validator: (v) => v == null || v.isEmpty
                          ? 'Enter tenure' : null,
                    ),

                    const SizedBox(height: 20),

                    // Calculate EMI button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: calculateEmi,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        icon: const Icon(Icons.calculate_outlined, size: 18),
                        label: const Text('Calculate EMI'),
                      ),
                    ),

                    // EMI result
                    if (emiAmount > 0) ...[
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primaryDark, AppColors.primary],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Monthly EMI',
                                    style: AppTextStyles.whiteCaption(context)),
                                const SizedBox(height: 4),
                                Text(
                                  '₹ ${emiAmount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: AppColors.light,
                                    fontSize: RT.fs(context, 22),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const Icon(Icons.payments_outlined,
                                color: AppColors.light, size: 28),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    Text('REPAYMENT',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: AppFontSize.xs(context),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        )),
                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      value: selectedAccountId,
                      decoration: _inputDecoration('Repayment Account'),
                      dropdownColor: AppColors.light,
                      isExpanded: true,
                      items: accounts.map((account) {
                        return DropdownMenuItem(
                          value: account.id,
                          child: Text(
                            '${account.accountType}  •  ••••${account.accountNumber.substring(account.accountNumber.length - 4)}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (v) =>
                          setState(() => selectedAccountId = v),
                    ),

                    const SizedBox(height: 14),

                    // Auto pay toggle
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.light,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: SwitchListTile(
                        title: Text('Enable Auto Pay',
                            style: AppTextStyles.body(context)),
                        subtitle: Text('Auto deduct EMI on due date',
                            style: AppTextStyles.caption(context)),
                        value: autoPayEnabled,
                        activeColor: AppColors.primary,
                        onChanged: (v) =>
                            setState(() => autoPayEnabled = v),
                      ),
                    ),

                    if (autoPayEnabled) ...[
                      const SizedBox(height: 14),
                      DropdownButtonFormField<int>(
                        value: autoPayDate,
                        decoration: _inputDecoration('Auto Pay Date'),
                        dropdownColor: AppColors.light,
                        items: [1, 5, 10, 15, 20, 25].map((date) {
                          return DropdownMenuItem(
                              value: date, child: Text('${date}th of every month'));
                        }).toList(),
                        onChanged: (v) =>
                            setState(() => autoPayDate = v!),
                      ),
                    ],

                    const SizedBox(height: 32),

                    // Apply button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) return;
                          if (selectedAccountId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Select repayment account')),
                            );
                            return;
                          }
                          final amount =
                              double.parse(amountController.text);
                          final tenure =
                              int.parse(tenureController.text);
                          accountProvider.creditAccount(
                              selectedAccountId!, amount);
                          final loanId = DateTime.now()
                              .millisecondsSinceEpoch
                              .toString();
                          loanProvider.addLoan(LoanModel(
                            id: loanId,
                            userId: user.id,
                            loanType: loanType,
                            principalAmount: amount,
                            outstandingAmount: amount,
                            interestRate: 10.5,
                            tenureMonths: tenure,
                            emiAmount: emiAmount,
                            startDate: DateTime.now(),
                            endDate: DateTime.now()
                                .add(Duration(days: tenure * 30)),
                            repaymentAccountId: selectedAccountId!,
                            autoPayEnabled: autoPayEnabled,
                            autoPayDate: autoPayDate,
                            status: 'ACTIVE',
                          ));

context.read<NotificationProvider>().addNotification(
  NotificationModel(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    userId: user.id,
    title: 'Loan Application Successful',
    body:
        'Your $loanType of ₹${amount.toStringAsFixed(2)} has been successfully approved and credited to your account.',
    type: NotificationType.loan,
    createdAt: DateTime.now(),
  ),
);

                          TransactionProvider.instance
                              .recordLoanReimbursement(
                            accountId: selectedAccountId!,
                            amount: amount,
                            loanId: loanId,
                            balanceAfter: accountProvider
                                .getAccountById(selectedAccountId!)
                                .availableBalance,
                          );
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(24)),
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 72,
                                      height: 72,
                                      decoration: BoxDecoration(
                                        color: AppColors.successLight,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.check_rounded,
                                          color: AppColors.successDark,
                                          size: 36),
                                    ),
                                    const SizedBox(height: 20),
                                    Text('Loan Applied',
                                        style:
                                            AppTextStyles.title(context)),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Your loan application has been submitted successfully.',
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles
                                          .bodySecondary(context),
                                    ),
                                    const SizedBox(height: 24),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.blueButton,
                                          foregroundColor: AppColors.light,
                                          padding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 14),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      12)),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Done'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryDark,
                          foregroundColor: AppColors.light,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        child: Text('Apply for Loan',
                            style: TextStyle(
                              fontSize: AppFontSize.medium(context),
                              fontWeight: FontWeight.w700,
                            )),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }
}