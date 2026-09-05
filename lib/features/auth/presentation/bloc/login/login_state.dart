part of 'login_bloc.dart';

enum LoginStatus { editing, submitting, succeeded, failed }

class LoginState extends Equatable {
  const LoginState({
    this.phone = const PhoneNumber(''),
    this.password = '',
    this.status = LoginStatus.editing,
    this.errorMessage,
    this.fieldErrors = const <String, String>{},
    this.session,
  });

  final PhoneNumber phone;
  final String password;
  final LoginStatus status;
  final String? errorMessage;
  final Map<String, String> fieldErrors;
  final AuthSession? session;

  bool get isSubmitting => status == LoginStatus.submitting;

  bool hasFieldError(String field) => fieldErrors.containsKey(field);

  bool get hasAnyFieldError => fieldErrors.isNotEmpty;

  LoginState copyWith({
    PhoneNumber? phone,
    String? password,
    LoginStatus? status,
    String? errorMessage,
    Map<String, String>? fieldErrors,
    AuthSession? session,
    bool clearError = false,
  }) {
    return LoginState(
      phone: phone ?? this.phone,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      fieldErrors: clearError
          ? const <String, String>{}
          : fieldErrors ?? this.fieldErrors,
      session: session ?? this.session,
    );
  }

  @override
  List<Object?> get props =>
      <Object?>[phone, password, status, errorMessage, fieldErrors, session];
}
