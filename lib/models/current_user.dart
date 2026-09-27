class CurrentUser {
  final int id;
  final String fullName;
  final String email;
  final String phone;
  final String role;

  const CurrentUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
  });

  factory CurrentUser.fromJson(
    Map<String, dynamic> json,
  ) {
    return CurrentUser(
      id: json['id'] as int,
      fullName: json['full_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
    );
  }
}