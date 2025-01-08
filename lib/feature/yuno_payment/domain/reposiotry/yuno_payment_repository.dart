abstract interface class YunoPaymentRepository {
  Future<void> createPayment({required String oneTimeToken});
}
