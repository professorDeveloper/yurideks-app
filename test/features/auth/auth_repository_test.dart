import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yurideks_app/core/error/failures.dart';
import 'package:yurideks_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:yurideks_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:yurideks_app/features/auth/data/models/auth_user_model.dart';
import 'package:yurideks_app/features/auth/data/models/token_pair_model.dart';
import 'package:yurideks_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:yurideks_app/features/auth/domain/entities/auth_session.dart';

import '../../support/fake_token_store.dart';

class _FakeLocal implements AuthLocalDataSource {
  TokenPairModel? stored;
  int clears = 0;

  @override
  Future<void> clearSession() async {
    stored = null;
    clears++;
  }

  @override
  Future<TokenPairModel?> readSession() async => stored;

  @override
  Future<void> writeSession(TokenPairModel session) async => stored = session;
}

class _FakeRemote implements AuthRemoteDataSource {
  _FakeRemote({this.error});

  final Object? error;
  final List<String> revoked = <String>[];

  @override
  Future<AuthUserModel> readProfile() async => throw UnimplementedError();

  @override
  Future<TokenPairModel> signIn({
    required String phone,
    required String password,
  }) async {
    if (error != null) {
      throw error!;
    }
    return buildPair();
  }

  @override
  Future<TokenPairModel> signUp({
    required String name,
    required String phone,
    required String password,
  }) async {
    if (error != null) {
      throw error!;
    }
    return buildPair();
  }

  @override
  Future<void> signOut(String refreshToken) async {
    if (error != null) {
      throw error!;
    }
    revoked.add(refreshToken);
  }
}

DioException _http(int status, Map<String, dynamic> body) {
  final RequestOptions request = RequestOptions(path: '/api/mobile/auth/login');
  return DioException(
    requestOptions: request,
    response: Response<dynamic>(
      requestOptions: request,
      statusCode: status,
      data: body,
    ),
  );
}

void main() {
  test('a successful sign in stores the pair', () async {
    final _FakeLocal local = _FakeLocal();
    final AuthRepositoryImpl repository = AuthRepositoryImpl(
      _FakeRemote(),
      local,
    );

    final Either<Failure, AuthSession> result = await repository.signIn(
      phone: '+998901234567',
      password: 'correct-horse',
    );

    expect(result.isRight(), isTrue);
    expect(local.stored, isNotNull);
  });

  test('a rejected sign in stores nothing and maps the failure', () async {
    final _FakeLocal local = _FakeLocal();
    final AuthRepositoryImpl repository = AuthRepositoryImpl(
      _FakeRemote(
        error: _http(401, <String, dynamic>{
          'error': 'Notoʻgʻri',
          'code': 'errors.incorrectCredentials',
        }),
      ),
      local,
    );

    final Either<Failure, AuthSession> result = await repository.signIn(
      phone: '+998901234567',
      password: 'wrong',
    );

    expect(
      result.fold((Failure f) => f, (_) => null),
      isA<InvalidCredentialsFailure>(),
    );
    expect(local.stored, isNull);
  });

  test('a session with a dead refresh token reads as no session', () async {
    final _FakeLocal local = _FakeLocal()
      ..stored = buildPair(refreshFor: const Duration(days: -1));
    final AuthRepositoryImpl repository = AuthRepositoryImpl(
      _FakeRemote(),
      local,
    );

    final Either<Failure, AuthSession?> result = await repository.readSession();

    expect(result.getOrElse(() => buildPair()), isNull);
  });

  test('signing out revokes remotely and clears locally', () async {
    final _FakeLocal local = _FakeLocal()..stored = buildPair();
    final _FakeRemote remote = _FakeRemote();
    final AuthRepositoryImpl repository = AuthRepositoryImpl(remote, local);

    await repository.signOut();

    expect(remote.revoked, <String>['refresh-1']);
    expect(local.stored, isNull);
  });

  test('signing out clears locally even if the server refuses', () async {
    final _FakeLocal local = _FakeLocal()..stored = buildPair();
    final AuthRepositoryImpl repository = AuthRepositoryImpl(
      _FakeRemote(error: _http(500, <String, dynamic>{})),
      local,
    );

    final Either<Failure, Unit> result = await repository.signOut();

    expect(result.isRight(), isTrue);
    expect(local.stored, isNull);
  });
}
