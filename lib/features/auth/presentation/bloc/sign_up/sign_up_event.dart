part of 'sign_up_bloc.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => const <Object?>[];
}

class SignUpNameChanged extends SignUpEvent {
  const SignUpNameChanged(this.name);

  final String name;

  @override
  List<Object?> get props => <Object?>[name];
}

class SignUpPhoneChanged extends SignUpEvent {
  const SignUpPhoneChanged(this.digits);

  final String digits;

  @override
  List<Object?> get props => <Object?>[digits];
}

class SignUpPasswordChanged extends SignUpEvent {
  const SignUpPasswordChanged(this.password);

  final String password;

  @override
  List<Object?> get props => <Object?>[password];
}

class SignUpSubmitted extends SignUpEvent {
  const SignUpSubmitted();
}
