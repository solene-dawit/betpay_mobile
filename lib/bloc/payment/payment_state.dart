sealed class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final String status;
  final String message;
  final String orderId;
  final String paymentStatus;
  final String amount;
  final String currency;
  final String paymentUrl;
  final String redirectUrl;
  final String expiresAt;

  PaymentSuccess({
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

class PaymentFailure extends PaymentState {
  final String message;

  PaymentFailure({
    required this.message,
  });
}