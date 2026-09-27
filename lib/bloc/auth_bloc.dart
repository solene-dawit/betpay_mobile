import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../services/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<RegisterRequested>(_register);
  }

  Future<void> _register(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final result = await ApiService.registerUser(
        fullName: event.fullName,
        email: event.email,

        // International phone number
        // Example: +251912345678
        phone: event.phone,

        // Country ISO code
        // Example: Ethiopia -> ET
        countryIso: event.countryIso,

        password: event.password,
        confirmPassword: event.confirmPassword,
        role: event.role,
      );

      emit(
        RegisterSuccess(
          message: result['message'],
          userId: result['user_id'],
          role: result['role'],
        ),
      );
    } catch (e) {
      emit(
        AuthError(
          e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}