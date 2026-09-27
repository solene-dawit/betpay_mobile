abstract class RegistrationState {}

class RegistrationInitial extends RegistrationState {}

class RegistrationSubmitting extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {}

class RegistrationFailure extends RegistrationState {
  final String message;

  RegistrationFailure(this.message);
}