import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_config.dart';
import '../models/auth_user_model.dart';
import '../models/token_pair_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<TokenPairModel> signUp({
    required String name,
    required String phone,
    required String password,
  });

  Future<TokenPairModel> signIn({
    required String phone,
    required String password,
  });

  Future<void> signOut(String refreshToken);

  Future<AuthUserModel> readProfile();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<TokenPairModel> signUp({
    required String name,
    required String phone,
    required String password,
  }) async {
    final Response<dynamic> response = await _client.post(
      ApiConfig.signupPath,
      body: <String, dynamic>{
        'name': name,
        'phone': phone,
        'password': password,
        'role': 'CITIZEN',
      },
    );
    return TokenPairModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<TokenPairModel> signIn({
    required String phone,
    required String password,
  }) async {
    final Response<dynamic> response = await _client.post(
      ApiConfig.loginPath,
      body: <String, dynamic>{'phone': phone, 'password': password},
    );
    return TokenPairModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> signOut(String refreshToken) async {
    await _client.post(
      ApiConfig.logoutPath,
      body: <String, dynamic>{'refreshToken': refreshToken},
    );
  }

  @override
  Future<AuthUserModel> readProfile() async {
    final Response<dynamic> response = await _client.get(ApiConfig.mePath);
    final Map<String, dynamic> payload = response.data as Map<String, dynamic>;
    final Object? nested = payload['user'];
    return AuthUserModel.fromJson(
      nested is Map<String, dynamic> ? nested : payload,
    );
  }
}
