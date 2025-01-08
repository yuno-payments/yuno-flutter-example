import 'package:example/feature/yuno_payment/domain/reposiotry/yuno_payment_repository.dart';

class YunoApi implements YunoPaymentRepository {
  @override
  Future<void> createPayment({
    required String oneTimeToken,
  }) async {
    // user Dio, Http, or any other http client to create the payment
    await Future.delayed(const Duration(seconds: 10));
    return;
  }
}
