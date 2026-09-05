import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/error/failure_message.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/phone_formatter.dart';
import '../../../domain/entities/auth_session.dart';
import '../../../domain/entities/phone_number.dart';
import '../../../domain/usecases/sign_in.dart';
import '../auth_field.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._signIn) : super(const LoginState()) {
    on<LoginPhoneChanged>(_onPhoneChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  final SignIn _signIn;

  void _onPhoneChanged(LoginPhoneChanged event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        phone: PhoneNumber(UzbekPhoneFormatter.digitsOf(event.digits)),
        status: LoginStatus.editing,
        clearError: true,
      ),
    );
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(
      state.copyWith(
        password: event.password,
        status: LoginStatus.editing,
        clearError: true,
      ),
    );
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.isSubmitting) {
      return;
    }

    final Map<String, String> invalid = _validate();
    if (invalid.isNotEmpty) {
      emit(
        state.copyWith(status: LoginStatus.failed, fieldErrors: invalid),
      );
      return;
    }

    emit(state.copyWith(status: LoginStatus.submitting, clearError: true));

    final Either<Failure, AuthSession> result = await _signIn(
      SignInParams(phone: state.phone.e164, password: state.password),
    );

    emit(
      result.fold(
        (Failure failure) => state.copyWith(
          status: LoginStatus.failed,
          errorMessage: FailureMessage.of(failure),
          fieldErrors: _fieldErrorsOf(failure),
        ),
        (AuthSession session) => state.copyWith(
          status: LoginStatus.succeeded,
          session: session,
          clearError: true,
        ),
      ),
    );
  }

  Map<String, String> _validate() {
    return <String, String>{
      if (!state.phone.isComplete) AuthField.phone: AppStrings.validationPhone,
      if (state.password.isEmpty)
        AuthField.password: AppStrings.validationPassword,
    };
  }

  Map<String, String> _fieldErrorsOf(Failure failure) {
    if (failure is ValidationFailure) {
      return failure.fieldErrors;
    }
    if (failure is InvalidCredentialsFailure) {
      return <String, String>{AuthField.password: FailureMessage.of(failure)};
    }
    return const <String, String>{};
  }
}
