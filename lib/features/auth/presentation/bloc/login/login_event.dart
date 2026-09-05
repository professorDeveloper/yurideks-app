part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => const <Object?>[];
}

class LoginPhoneChanged extends LoginEvent {
  const LoginPhoneChanged(this.digits);

  final String digits;

  @override
  List<Object?> get props => <Object?>[digits];
}

class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged(this.password);

  final String password;

  @override
  List<Object?> get props => <Object?>[password];
}

class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}
