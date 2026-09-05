import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/auth/data/models/token_pair_model.dart';

class TokenStore {
  const TokenStore(this._storage);

  static const String _key = 'auth.tokenPair';
  static const AndroidOptions _android = AndroidOptions();
  static const IOSOptions _ios = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );

  final FlutterSecureStorage _storage;

  Future<TokenPairModel?> read() async {
    final String? raw = await _storage.read(
      key: _key,
      aOptions: _android,
      iOptions: _ios,
    );
    if (raw == null) {
      return null;
    }
    try {
      return TokenPairModel.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } on FormatException {
      await clear();
      return null;
    }
  }

  Future<void> write(TokenPairModel pair) {
    return _storage.write(
      key: _key,
      value: jsonEncode(pair.toJson()),
      aOptions: _android,
      iOptions: _ios,
    );
  }

  Future<void> clear() {
    return _storage.delete(key: _key, aOptions: _android, iOptions: _ios);
  }
}
