import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/current_user.dart';

class AuthService {
  static const String baseUrl =
      'http://10.0.2.2:8080';

  static const FlutterSecureStorage _storage =
      FlutterSecureStorage();

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(
      '$baseUrl/api/login',
    );

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email.trim(),
        'password': password,
      }),
    );

    final responseBody = jsonDecode(
      response.body,
    );

    if (response.statusCode != 200) {
      throw Exception(
        responseBody['message'] ??
            response.body,
      );
    }

    final token = responseBody['token'];

    if (token == null ||
        token.toString().isEmpty) {
      throw Exception(
        'Login succeeded but no authentication token was returned.',
      );
    }

    await _storage.write(
      key: 'auth_token',
      value: token.toString(),
    );

    return responseBody;
  }

  Future<String?> getToken() async {
    return await _storage.read(
      key: 'auth_token',
    );
  }

  Future<CurrentUser> getCurrentUser() async {
    final token = await getToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        'No authentication token found.',
      );
    }

    final url = Uri.parse(
      '$baseUrl/api/me',
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load current user.',
      );
    }

    final responseBody = jsonDecode(
      response.body,
    );

    return CurrentUser.fromJson(
      responseBody['user'],
    );
  }

  Future<void> logout() async {
    await _storage.delete(
      key: 'auth_token',
    );
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();

    return token != null &&
        token.isNotEmpty;
  }
}