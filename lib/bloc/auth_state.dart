part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}

class RegisterSuccess extends AuthState {
  final String message;
  final int userId;
  final String role;

  RegisterSuccess({
    required this.message,
    required this.userId,
    required this.role,
  });
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}