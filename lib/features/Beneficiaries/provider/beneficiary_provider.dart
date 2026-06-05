import 'package:flutter/material.dart';

import '../../../data/dummy/dummy_beneficiaries.dart';
import '../../../data/models/beneficiary_model.dart';

class BeneficiaryProvider
    extends ChangeNotifier {

  final List<BeneficiaryModel>
      _beneficiaries =
      List.from(
    DummyBeneficiaries.beneficiaries,
  );

  List<BeneficiaryModel>
      getBeneficiariesByUserId(
    String userId,
  ) {
    return _beneficiaries
        .where(
          (b) => b.userId == userId,
        )
        .toList();
  }

  void addBeneficiary(
    BeneficiaryModel beneficiary,
  ) {
    _beneficiaries.add(
      beneficiary,
    );

    notifyListeners();
  }

  void removeBeneficiary(
    String id,
  ) {
    _beneficiaries.removeWhere(
      (b) => b.id == id,
    );

    notifyListeners();
  }
}