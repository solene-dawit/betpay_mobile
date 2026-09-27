abstract class RegistrationEvent {}

class RegisterUser extends RegistrationEvent {
  final String fullName;

  final String email;

  // Phone is passed in international format.
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

  RegisterUser({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.countryIso,
    required this.password,
    required this.confirmPassword,
    required this.role,
  });
}