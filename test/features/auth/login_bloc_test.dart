import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yurideks_app/core/constants/app_strings.dart';
import 'package:yurideks_app/core/error/failures.dart';
import 'package:yurideks_app/features/auth/domain/entities/auth_session.dart';
import 'package:yurideks_app/features/auth/domain/usecases/sign_in.dart';
import 'package:yurideks_app/features/auth/presentation/bloc/auth_field.dart';
import 'package:yurideks_app/features/auth/presentation/bloc/login/login_bloc.dart';

import '../../support/fake_token_store.dart';

class _MockSignIn extends Mock implements SignIn {}

void main() {
  late _MockSignIn signIn;
  final AuthSession session = buildPair();

  setUpAll(() {
    registerFallbackValue(const SignInParams(phone: '', password: ''));
  });

  setUp(() => signIn = _MockSignIn());

  blocTest<LoginBloc, LoginState>(
    'marks the empty password instead of silently ignoring the tap',
    build: () => LoginBloc(signIn),
    act: (LoginBloc bloc) => bloc
      ..add(const LoginPhoneChanged('90 123 45 67'))
      ..add(const LoginSubmitted()),
    verify: (LoginBloc bloc) {
      expect(
        bloc.state.fieldErrors[AuthField.password],
        AppStrings.validationPassword,
      );
      expect(bloc.state.fieldErrors.containsKey(AuthField.phone), isFalse);
      verifyNever(() => signIn(any()));
    },
  );

  blocTest<LoginBloc, LoginState>(
    'marks an incomplete phone and never calls the API',
    build: () => LoginBloc(signIn),
    act: (LoginBloc bloc) => bloc
      ..add(const LoginPhoneChanged('90 123'))
      ..add(const LoginPasswordChanged('correct-horse'))
      ..add(const LoginSubmitted()),
    verify: (LoginBloc bloc) {
      expect(
        bloc.state.fieldErrors[AuthField.phone],
        AppStrings.validationPhone,
      );
      verifyNever(() => signIn(any()));
    },
  );

  blocTest<LoginBloc, LoginState>(
    'accepts a short password because length is a sign-up rule, not a login one',
    build: () {
      when(() => signIn(any())).thenAnswer(
        (_) async => Right<Failure, AuthSession>(session),
      );
      return LoginBloc(signIn);
    },
    act: (LoginBloc bloc) => bloc
      ..add(const LoginPhoneChanged('901234567'))
      ..add(const LoginPasswordChanged('short'))
      ..add(const LoginSubmitted()),
    verify: (LoginBloc bloc) {
      expect(bloc.state.fieldErrors, isEmpty);
      verify(() => signIn(any())).called(1);
    },
  );

  blocTest<LoginBloc, LoginState>(
    'sends the phone in E.164 and surfaces the session',
    build: () {
      when(() => signIn(any())).thenAnswer(
        (_) async => Right<Failure, AuthSession>(session),
      );
      return LoginBloc(signIn);
    },
    act: (LoginBloc bloc) => bloc
      ..add(const LoginPhoneChanged('901234567'))
      ..add(const LoginPasswordChanged('correct-horse'))
      ..add(const LoginSubmitted()),
    verify: (LoginBloc bloc) {
      final SignInParams captured =
          verify(() => signIn(captureAny())).captured.single as SignInParams;
      expect(captured.phone, '+998901234567');
      expect(bloc.state.status, LoginStatus.succeeded);
      expect(bloc.state.session, session);
    },
  );

  blocTest<LoginBloc, LoginState>(
    'shows a readable message when the credentials are rejected',
    build: () {
      when(() => signIn(any())).thenAnswer(
        (_) async => const Left<Failure, AuthSession>(
          InvalidCredentialsFailure(),
        ),
      );
      return LoginBloc(signIn);
    },
    act: (LoginBloc bloc) => bloc
      ..add(const LoginPhoneChanged('901234567'))
      ..add(const LoginPasswordChanged('correct-horse'))
      ..add(const LoginSubmitted()),
    verify: (LoginBloc bloc) {
      expect(bloc.state.status, LoginStatus.failed);
      expect(bloc.state.errorMessage, AppStrings.invalidCredentials);
    },
  );

  blocTest<LoginBloc, LoginState>(
    'ignores a submit while one is already in flight',
    build: () {
      when(() => signIn(any())).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 30));
        return Right<Failure, AuthSession>(session);
      });
      return LoginBloc(signIn);
    },
    act: (LoginBloc bloc) => bloc
      ..add(const LoginPhoneChanged('901234567'))
      ..add(const LoginPasswordChanged('correct-horse'))
      ..add(const LoginSubmitted())
      ..add(const LoginSubmitted()),
    wait: const Duration(milliseconds: 80),
    verify: (_) => verify(() => signIn(any())).called(1),
  );

  blocTest<LoginBloc, LoginState>(
    'clears the error as soon as the user edits a field',
    build: () {
      when(() => signIn(any())).thenAnswer(
        (_) async => const Left<Failure, AuthSession>(
          InvalidCredentialsFailure(),
        ),
      );
      return LoginBloc(signIn);
    },
    act: (LoginBloc bloc) async {
      bloc
        ..add(const LoginPhoneChanged('901234567'))
        ..add(const LoginPasswordChanged('correct-horse'))
        ..add(const LoginSubmitted());
      await Future<void>.delayed(const Duration(milliseconds: 30));
      bloc.add(const LoginPasswordChanged('correct-horse-2'));
    },
    verify: (LoginBloc bloc) => expect(bloc.state.errorMessage, isNull),
  );
}
