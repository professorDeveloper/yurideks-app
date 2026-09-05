import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/error/failure_message.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/phone_formatter.dart';
import '../../../domain/entities/auth_session.dart';
import '../../../domain/entities/phone_number.dart';
import '../../../domain/usecases/sign_up.dart';
import '../auth_field.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc(this._signUp) : super(const SignUpState()) {
    on<SignUpNameChanged>(_onNameChanged);
    on<SignUpPhoneChanged>(_onPhoneChanged);
    on<SignUpPasswordChanged>(_onPasswordChanged);
    on<SignUpSubmitted>(_onSubmitted);
  }

  final SignUp _signUp;

  void _onNameChanged(SignUpNameChanged event, Emitter<SignUpState> emit) {
    emit(
      state.copyWith(
        name: event.name,
        status: SignUpStatus.editing,
        clearError: true,
      ),
    );
  }

  void _onPhoneChanged(SignUpPhoneChanged event, Emitter<SignUpState> emit) {
    emit(
      state.copyWith(
        phone: PhoneNumber(UzbekPhoneFormatter.digitsOf(event.digits)),
        status: SignUpStatus.editing,
        clearError: true,
      ),
    );
  }

  void _onPasswordChanged(
    SignUpPasswordChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(
      state.copyWith(
        password: event.password,
        status: SignUpStatus.editing,
        clearError: true,
      ),
    );
  }

  Future<void> _onSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    if (state.isSubmitting) {
      return;
    }

    final Map<String, String> invalid = _validate();
    if (invalid.isNotEmpty) {
      emit(state.copyWith(status: SignUpStatus.failed, fieldErrors: invalid));
      return;
    }

    emit(state.copyWith(status: SignUpStatus.submitting, clearError: true));

    final Either<Failure, AuthSession> result = await _signUp(
      SignUpParams(
        name: state.name.trim(),
        phone: state.phone.e164,
        password: state.password,
      ),
    );

    emit(
      result.fold(
        (Failure failure) => state.copyWith(
          status: SignUpStatus.failed,
          errorMessage: FailureMessage.of(failure),
          fieldErrors: failure is ValidationFailure
              ? failure.fieldErrors
              : const <String, String>{},
        ),
        (AuthSession session) => state.copyWith(
          status: SignUpStatus.succeeded,
          session: session,
          clearError: true,
        ),
      ),
    );
  }

  Map<String, String> _validate() {
    return <String, String>{
      if (state.name.trim().length < SignUpState.minimumNameLength)
        AuthField.name: AppStrings.validationName,
      if (!state.phone.isComplete) AuthField.phone: AppStrings.validationPhone,
      if (state.password.isEmpty)
        AuthField.password: AppStrings.validationPassword
      else if (state.password.length < SignUpState.minimumPasswordLength)
        AuthField.password: AppStrings.validationPasswordShort,
    };
  }
}
