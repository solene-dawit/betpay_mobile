import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/api_service.dart';
import 'registration_event.dart';
import 'registration_state.dart';

class RegistrationBloc
    extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc() : super(RegistrationInitial()) {
    on<RegisterUser>(_registerUser);
  }

  Future<void> _registerUser(
    RegisterUser event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(RegistrationSubmitting());

    try {
      await ApiService.registerUser(
        fullName: event.fullName,
        email: event.email,

        // Phone is already converted to international format
        // by the registration screen.
        //
        // Example:
        // 0912345678 -> +251912345678
        phone: event.phone.trim(),

        // Country ISO code
        // Example:
        // Ethiopia -> ET
        // United States -> US
        // United Kingdom -> GB
        countryIso: event.countryIso,

        password: event.password,
        confirmPassword: event.confirmPassword,
        role: event.role,
      );

      emit(RegistrationSuccess());
    } catch (e) {
      emit(
        RegistrationFailure(
          e.toString(),
        ),
      );
    }
  }
}