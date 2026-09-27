import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/auth_service.dart';
import '../../services/starpay_service.dart';

import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final StarPayService starPayService;
  final AuthService authService;

  PaymentBloc({
    required this.starPayService,
    required this.authService,
  }) : super(PaymentInitial()) {
    on<PayRentPressed>(_payRent);
  }

  Future<void> _payRent(
    PayRentPressed event,
    Emitter<PaymentState> emit,
  ) async {
    debugPrint('========================================');
    debugPrint('PAYMENT BLOC: PAY RENT PRESSED');
    debugPrint('========================================');

    emit(PaymentLoading());

    try {
      // Get logged-in tenant
      final user = await authService.getCurrentUser();

      debugPrint('PAYMENT BLOC: USER LOADED');
      debugPrint('Customer: ${user.fullName}');
      debugPrint('Phone: ${user.phone}');

      // Temporary rent amount
      const double rentAmount = 8500.0;

      debugPrint('PAYMENT BLOC: RENT AMOUNT: $rentAmount');
      debugPrint('PAYMENT BLOC: CREATING STARPAY PAYMENT...');

      // Create StarPay payment
      final payment = await starPayService.createPayment(
        amount: rentAmount,
        customerName: user.fullName,
        customerPhone: user.phone,
      );

      // ==========================================
      // STARPay PAYMENT RECEIVED BY BLOC
      // ==========================================

      debugPrint('========================================');
      debugPrint('PAYMENT BLOC: STARPAY PAYMENT RECEIVED');
      debugPrint('========================================');

      debugPrint('STATUS: ${payment.status}');
      debugPrint('MESSAGE: ${payment.message}');
      debugPrint('ORDER ID: ${payment.orderId}');
      debugPrint('PAYMENT STATUS: ${payment.paymentStatus}');
      debugPrint('AMOUNT: ${payment.amount}');
      debugPrint('CURRENCY: ${payment.currency}');
      debugPrint('PAYMENT URL: ${payment.paymentUrl}');
      debugPrint('REDIRECT URL: ${payment.redirectUrl}');
      debugPrint('EXPIRES AT: ${payment.expiresAt}');

      // ==========================================
      // CHECK PAYMENT URL
      // ==========================================

      if (payment.paymentUrl.trim().isEmpty) {
        throw Exception(
          'Payment was created but payment URL is empty.',
        );
      }

      debugPrint('========================================');
      debugPrint('PAYMENT BLOC: PAYMENT URL IS READY');
      debugPrint(
        'URL: ${payment.paymentUrl}',
      );
      debugPrint('========================================');

      // ==========================================
      // SEND PAYMENT DATA TO UI
      // ==========================================

      emit(
        PaymentSuccess(
          status: payment.status,
          message: payment.message,
          orderId: payment.orderId,
          paymentStatus: payment.paymentStatus,
          amount: payment.amount,
          currency: payment.currency,
          paymentUrl: payment.paymentUrl,
          redirectUrl: payment.redirectUrl,
          expiresAt: payment.expiresAt,
        ),
      );

      debugPrint(
        'PAYMENT BLOC: PaymentSuccess EMITTED',
      );
    } catch (e) {
      debugPrint('========================================');
      debugPrint('PAYMENT BLOC: PAYMENT FAILED');
      debugPrint('ERROR: $e');
      debugPrint('========================================');

      emit(
        PaymentFailure(
          message: e.toString().replaceFirst(
                'Exception: ',
                '',
              ),
        ),
      );
    }
  }
}