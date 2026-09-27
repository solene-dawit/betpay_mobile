import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  // Android emulator connects to the Windows host through 10.0.2.2
  static const String baseUrl = 'http://10.0.2.2:8080';

  // ==========================================
  // REGISTER USER
  // ==========================================

  static Future<dynamic> registerUser({
    required String fullName,
    required String email,
    required String phone,
    required String countryIso,
    required String password,
    required String confirmPassword,
    required String role,
  }) async {
    // Phone has already been converted to international
    // format by the registration screen.
    //
    // Example:
    // 0912345678 -> +251912345678
    final normalizedPhone = phone.trim();

    // Country ISO code
    //
    // Examples:
    // Ethiopia -> ET
    // United States -> US
    // United Kingdom -> GB
    final normalizedCountryIso = countryIso.trim().toUpperCase();

    final response = await http.post(
      Uri.parse('$baseUrl/api/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'full_name': fullName.trim(),
        'email': email.trim(),
        'phone': normalizedPhone,
        'country_iso': normalizedCountryIso,
        'password': password,
        'confirm_password': confirmPassword,
        'role': role,
      }),
    );

    // ==========================================
    // SUCCESS
    // ==========================================

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return jsonDecode(response.body);
    }

    // ==========================================
    // ERROR
    // ==========================================

    try {
      final errorBody = jsonDecode(response.body);

      throw Exception(
        errorBody['message'] ??
            'Registration failed',
      );
    } catch (_) {
      throw Exception(
        'Registration failed: ${response.body}',
      );
    }
  }
}