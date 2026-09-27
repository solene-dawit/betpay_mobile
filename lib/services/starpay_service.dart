import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/starpay_payment.dart';

class StarPayService {
  static const String baseUrl = 'http://10.0.2.2:8080';

  // ==========================================
  // FORMAT ETHIOPIAN PHONE NUMBER
  // ==========================================

  String formatPhoneNumber(String phone) {
    phone = phone.trim();

    if (phone.startsWith('+')) {
      return phone;
    }

    if (phone.startsWith('251')) {
      return '+$phone';
    }

    if (phone.startsWith('0')) {
      return '+251${phone.substring(1)}';
    }

    return phone;
  }

  // ==========================================
  // CREATE STARPAY PAYMENT
  // ==========================================

  Future<StarPayPayment> createPayment({
    required double amount,
    required String customerName,
    required String customerPhone,
  }) async {
    final url = Uri.parse(
      '$baseUrl/api/payments/starpay',
    );

    final formattedPhone =
        formatPhoneNumber(customerPhone);

    // ==========================================
    // REQUEST BODY
    // ==========================================

    final body = {
      'amount': amount,
      'description': 'BetPay Rent Payment',
      'currency': 'ETB',
      'customerName': customerName,
      'customerPhoneNumber': formattedPhone,
      'items': [
        {
          'productId': 'BETPAY-RENT',
          'quantity': 1,
          'item_name': 'BetPay Rent Payment',
          'unit_price': amount,
        },
      ],
    };

    // ==========================================
    // FLUTTER → GO BACKEND
    // ==========================================

    debugPrint('');
    debugPrint(
      '================================================',
    );
    debugPrint(
      '        FLUTTER → GO BACKEND',
    );
    debugPrint(
      '================================================',
    );

    debugPrint('REQUEST URL: $url');
    debugPrint('METHOD: POST');
    debugPrint('CUSTOMER: $customerName');
    debugPrint('PHONE: $formattedPhone');
    debugPrint('AMOUNT: $amount');
    debugPrint('REQUEST BODY: ${jsonEncode(body)}');

    debugPrint(
      'Sending request to Go backend...',
    );

    // ==========================================
    // SEND REQUEST
    // ==========================================

    http.Response response;

    try {
      response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
    } catch (e) {
      debugPrint('');
      debugPrint(
        '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!',
      );
      debugPrint(
        'FLUTTER → GO BACKEND CONNECTION FAILED',
      );
      debugPrint(
        '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!',
      );
      debugPrint('ERROR: $e');

      throw Exception(
        'Could not connect to BetPay backend: $e',
      );
    }

    // ==========================================
    // GO BACKEND → FLUTTER
    // ==========================================

    debugPrint('');
    debugPrint(
      '================================================',
    );
    debugPrint(
      '        GO BACKEND → FLUTTER',
    );
    debugPrint(
      '================================================',
    );

    debugPrint(
      'Flutter received a response!',
    );

    debugPrint(
      'HTTP STATUS CODE: ${response.statusCode}',
    );

    debugPrint(
      'RAW RESPONSE BODY:',
    );

    debugPrint(response.body);

    // ==========================================
    // CONFIRM CONNECTION
    // ==========================================

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      debugPrint('');
      debugPrint(
        '****************************************',
      );
      debugPrint(
        'SUCCESS: FLUTTER RECEIVED GO RESPONSE',
      );
      debugPrint(
        '****************************************',
      );
    } else {
      debugPrint('');
      debugPrint(
        '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!',
      );
      debugPrint(
        'GO BACKEND RETURNED AN ERROR',
      );
      debugPrint(
        '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!',
      );
    }

    // ==========================================
    // CHECK HTTP STATUS
    // ==========================================

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        'Backend returned HTTP ${response.statusCode}: '
        '${response.body}',
      );
    }

    // ==========================================
    // DECODE JSON
    // ==========================================

    dynamic decoded;

    try {
      decoded = jsonDecode(response.body);
    } catch (e) {
      debugPrint(
        'JSON DECODING FAILED: $e',
      );

      throw Exception(
        'Backend response is not valid JSON.',
      );
    }

    debugPrint('');
    debugPrint(
      '================================================',
    );
    debugPrint(
      '        FLUTTER DECODED BACKEND DATA',
    );
    debugPrint(
      '================================================',
    );

    debugPrint(
      'DECODED DATA: $decoded',
    );

    // ==========================================
    // CHECK RESPONSE TYPE
    // ==========================================

    if (decoded is! Map<String, dynamic>) {
      throw Exception(
        'Backend returned invalid payment data.',
      );
    }

    final data = decoded;

    // ==========================================
    // READ STATUS
    // ==========================================

    final status =
        data['status']?.toString() ?? '';

    debugPrint(
      'BACKEND STATUS: $status',
    );

    // ==========================================
    // CHECK STARPAY SUCCESS
    // ==========================================

    if (status != 'success') {
      final message =
          data['message']?.toString() ??
              'StarPay payment creation failed.';

      debugPrint(
        'STARPAY FAILED: $message',
      );

      throw Exception(message);
    }

    // ==========================================
    // READ PAYMENT INFORMATION
    // ==========================================

    final message =
        data['message']?.toString() ?? '';

    final orderId =
        data['order_id']?.toString() ?? '';

    final paymentStatus =
        data['payment_status']?.toString() ?? '';

    final paymentAmount =
        data['amount']?.toString() ?? '';

    final currency =
        data['currency']?.toString() ?? '';

    final paymentUrl =
        data['payment_url']?.toString() ?? '';

    final redirectUrl =
        data['redirectUrl']?.toString() ?? '';

    final expiresAt =
        data['expires_at']?.toString() ?? '';

    // ==========================================
    // PRINT PAYMENT DATA
    // ==========================================

    debugPrint('');
    debugPrint(
      '================================================',
    );
    debugPrint(
      '        PAYMENT DATA RECEIVED BY FLUTTER',
    );
    debugPrint(
      '================================================',
    );

    debugPrint(
      'STATUS: $status',
    );

    debugPrint(
      'MESSAGE: $message',
    );

    debugPrint(
      'ORDER ID: $orderId',
    );

    debugPrint(
      'PAYMENT STATUS: $paymentStatus',
    );

    debugPrint(
      'AMOUNT: $paymentAmount',
    );

    debugPrint(
      'CURRENCY: $currency',
    );

    debugPrint(
      'PAYMENT URL: $paymentUrl',
    );

    debugPrint(
      'REDIRECT URL: $redirectUrl',
    );

    debugPrint(
      'EXPIRES AT: $expiresAt',
    );

    debugPrint(
      '================================================',
    );

    // ==========================================
    // CHECK PAYMENT URL
    // ==========================================

    if (paymentUrl.trim().isEmpty) {
      debugPrint('');
      debugPrint(
        '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!',
      );
      debugPrint(
        'PROBLEM: FLUTTER RECEIVED RESPONSE',
      );
      debugPrint(
        'BUT payment_url IS EMPTY',
      );
      debugPrint(
        '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!',
      );

      throw Exception(
        'StarPay returned success but no payment_url.',
      );
    }

    // ==========================================
    // PAYMENT URL SUCCESS
    // ==========================================

    debugPrint('');
    debugPrint(
      '****************************************',
    );
    debugPrint(
      '       PAYMENT URL SUCCESSFULLY RECEIVED',
    );
    debugPrint(
      '****************************************',
    );

    debugPrint(
      'ORDER ID: $orderId',
    );

    debugPrint(
      'PAYMENT URL: $paymentUrl',
    );

    debugPrint(
      'Flutter is ready to open StarPay.',
    );

    debugPrint(
      '****************************************',
    );

    // ==========================================
    // RETURN COMPLETE PAYMENT DATA
    // ==========================================

    return StarPayPayment(
      status: status,
      message: message,
      orderId: orderId,
      paymentStatus: paymentStatus,
      amount: paymentAmount,
      currency: currency,
      paymentUrl: paymentUrl,
      redirectUrl: redirectUrl,
      expiresAt: expiresAt,
    );
  }
}