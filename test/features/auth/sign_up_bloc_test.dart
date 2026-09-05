import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yurideks_app/core/constants/app_strings.dart';
import 'package:yurideks_app/core/error/failures.dart';
import 'package:yurideks_app/features/auth/domain/entities/auth_session.dart';
import 'package:yurideks_app/features/auth/domain/usecases/sign_up.dart';
import 'package:yurideks_app/features/auth/presentation/bloc/auth_field.dart';
import 'package:yurideks_app/features/auth/presentation/bloc/sign_up/sign_up_bloc.dart';

import '../../support/fake_token_store.dart';

class _MockSignUp extends Mock implements SignUp {}

void main() {
  late _MockSignUp signUp;
  final AuthSession session = buildPair();

  setUpAll(() {
    registerFallbackValue(
      const SignUpParams(name: '', phone: '', password: ''),
    );
  });

  setUp(() => signUp = _MockSignUp());

  SignUpBloc fill(SignUpBloc bloc) {
    return bloc
      ..add(const SignUpNameChanged('Dilnoza Karimova'))
      ..add(const SignUpPhoneChanged('901234567'))
      ..add(const SignUpPasswordChanged('correct-horse'));
  }

  blocTest<SignUpBloc, SignUpState>(
    'marks the short name and never calls the API',
    build: () => SignUpBloc(signUp),
    act: (SignUpBloc bloc) => bloc
      ..add(const SignUpNameChanged('D'))
      ..add(const SignUpPhoneChanged('901234567'))
      ..add(const SignUpPasswordChanged('correct-horse'))
      ..add(const SignUpSubmitted()),
    verify: (SignUpBloc bloc) {
      expect(bloc.state.fieldErrors[AuthField.name], AppStrings.validationName);
      verifyNever(() => signUp(any()));
    },
  );

  blocTest<SignUpBloc, SignUpState>(
    'tells the user the password is too short rather than blocking the button',
    build: () => SignUpBloc(signUp),
    act: (SignUpBloc bloc) => bloc
      ..add(const SignUpNameChanged('Dilnoza Karimova'))
      ..add(const SignUpPhoneChanged('901234567'))
      ..add(const SignUpPasswordChanged('short'))
      ..add(const SignUpSubmitted()),
    verify: (SignUpBloc bloc) {
      expect(
        bloc.state.fieldErrors[AuthField.password],
        AppStrings.validationPasswordShort,
      );
      verifyNever(() => signUp(any()));
    },
  );

  blocTest<SignUpBloc, SignUpState>(
    'marks every empty field at once when nothing was filled in',
    build: () => SignUpBloc(signUp),
    act: (SignUpBloc bloc) => bloc.add(const SignUpSubmitted()),
    verify: (SignUpBloc bloc) {
      expect(bloc.state.fieldErrors.keys, <String>{
        AuthField.name,
        AuthField.phone,
        AuthField.password,
      });
      verifyNever(() => signUp(any()));
    },
  );

  blocTest<SignUpBloc, SignUpState>(
    'trims the name and normalises the phone before sending',
    build: () {
      when(() => signUp(any())).thenAnswer(
        (_) async => Right<Failure, AuthSession>(session),
      );
      return SignUpBloc(signUp);
    },
    act: (SignUpBloc bloc) => bloc
      ..add(const SignUpNameChanged('  Dilnoza Karimova  '))
      ..add(const SignUpPhoneChanged('90 123 45 67'))
      ..add(const SignUpPasswordChanged('correct-horse'))
      ..add(const SignUpSubmitted()),
    verify: (SignUpBloc bloc) {
      final SignUpParams sent =
          verify(() => signUp(captureAny())).captured.single as SignUpParams;
      expect(sent.name, 'Dilnoza Karimova');
      expect(sent.phone, '+998901234567');
      expect(bloc.state.status, SignUpStatus.succeeded);
    },
  );

  blocTest<SignUpBloc, SignUpState>(
    'reports an already registered phone with the server wording',
    build: () {
      when(() => signUp(any())).thenAnswer(
        (_) async => const Left<Failure, AuthSession>(
          PhoneAlreadyRegisteredFailure(),
        ),
      );
      return SignUpBloc(signUp);
    },
    act: (SignUpBloc bloc) => fill(bloc)..add(const SignUpSubmitted()),
    verify: (SignUpBloc bloc) {
      expect(bloc.state.status, SignUpStatus.failed);
      expect(bloc.state.errorMessage, AppStrings.phoneAlreadyRegistered);
    },
  );

  blocTest<SignUpBloc, SignUpState>(
    'keeps per-field messages from a validation failure',
    build: () {
      when(() => signUp(any())).thenAnswer(
        (_) async => const Left<Failure, AuthSession>(
          ValidationFailure(
            message: 'Tekshiring',
            fieldErrors: <String, String>{'password': 'Juda qisqa'},
          ),
        ),
      );
      return SignUpBloc(signUp);
    },
    act: (SignUpBloc bloc) => fill(bloc)..add(const SignUpSubmitted()),
    verify: (SignUpBloc bloc) {
      expect(bloc.state.fieldErrors['password'], 'Juda qisqa');
      expect(bloc.state.errorMessage, 'Tekshiring');
    },
  );
}
