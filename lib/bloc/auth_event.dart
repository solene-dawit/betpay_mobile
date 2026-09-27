part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class RegisterRequested extends AuthEvent {
  final String fullName;

  final String email;

  // International phone number.
  // Example: +251912345678
  final String phone;

  // Country ISO code.
  // Examples:
  // Ethiopia -> ET
  // United States -> US
  // United Kingdom -> GB
  // Kenya -> KE
  final String countryIso;

  final String password;

  final String confirmPassword;

  final String role;

  RegisterRequested({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.countryIso,
    required this.password,
    required this.confirmPassword,
    required this.role,
  });
}