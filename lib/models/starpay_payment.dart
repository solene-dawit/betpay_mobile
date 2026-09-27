class StarPayPayment {
  final String status;
  final String message;
  final String orderId;
  final String paymentStatus;
  final String amount;
  final String currency;
  final String paymentUrl;
  final String redirectUrl;
  final String expiresAt;

  StarPayPayment({
    required this.status,
    required this.message,
    required this.orderId,
    required this.paymentStatus,
    required this.amount,
    required this.currency,
    required this.paymentUrl,
    required this.redirectUrl,
    required this.expiresAt,
  });
}