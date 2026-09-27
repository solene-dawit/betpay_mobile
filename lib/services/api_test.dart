import 'package:flutter/foundation.dart';
import 'api_service.dart';

Future<void> testRegistrationApi() async {
  try {
    final result = await ApiService.registerUser(
      fullName: 'Flutter Test User',
      email: 'flutter@test.com',

      // International phone format
      phone: '+251912345688',

      // Ethiopia ISO code
      countryIso: 'ET',

      password: 'Password123',
      confirmPassword: 'Password123',
      role: 'tenant',
    );

    debugPrint('================================');
    debugPrint('REGISTRATION API SUCCESS');
    debugPrint(result.toString());
    debugPrint('================================');
  } catch (e) {
    debugPrint('================================');
    debugPrint('REGISTRATION API ERROR');
    debugPrint(e.toString());
    debugPrint('================================');
  }
}