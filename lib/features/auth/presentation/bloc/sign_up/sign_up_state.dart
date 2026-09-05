part of 'sign_up_bloc.dart';

enum SignUpStatus { editing, submitting, succeeded, failed }

class SignUpState extends Equatable {
  const SignUpState({
    this.name = '',
    this.phone = const PhoneNumber(''),
    this.password = '',
    this.status = SignUpStatus.editing,
    this.errorMessage,
    this.fieldErrors = const <String, String>{},
    this.session,
  });

  static const int minimumNameLength = 2;
  static const int minimumPasswordLength = 8;

  final String name;
  final PhoneNumber phone;
  final String password;
  final SignUpStatus status;
  final String? errorMessage;
  final Map<String, String> fieldErrors;
  final AuthSession? session;

  bool get isSubmitting => status == SignUpStatus.submitting;

  SignUpState copyWith({
    String? name,
    PhoneNumber? phone,
    String? password,
    SignUpStatus? status,
    String? errorMessage,
    Map<String, String>? fieldErrors,
    AuthSession? session,
    bool clearError = false,
  }) {
    return SignUpState(
      name: name ?? this.name,
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
  List<Object?> get props => <Object?>[
        name,
        phone,
        password,
        status,
        errorMessage,
        fieldErrors,
        session,
      ];
}
