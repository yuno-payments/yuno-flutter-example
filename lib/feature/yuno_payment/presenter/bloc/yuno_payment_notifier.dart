import 'package:example/feature/yuno_payment/domain/reposiotry/yuno_payment_repository.dart';
import 'package:flutter/material.dart';

enum ResultStatus {
  initial,
  loading,
  success,
  fail,
}

class YunoPaymentExampleNotifier extends ChangeNotifier {
  final YunoPaymentRepository _paymentRepository;
  YunoPaymentExampleNotifier({
    required YunoPaymentRepository paymentRepository,
  }) : _paymentRepository = paymentRepository;
  ResultStatus status = ResultStatus.initial;
  Future<void> createPayment({required String oneTimeToken}) async {
    try {
      status = ResultStatus.loading;
      await _paymentRepository.createPayment(oneTimeToken: oneTimeToken);
      status = ResultStatus.success;
    } catch (e) {
      status = ResultStatus.fail;
    }
    notifyListeners();
  }
}
