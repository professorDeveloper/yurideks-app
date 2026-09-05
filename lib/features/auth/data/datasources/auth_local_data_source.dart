import '../../../../core/network/token_store.dart';
import '../models/token_pair_model.dart';

abstract interface class AuthLocalDataSource {
  Future<TokenPairModel?> readSession();

  Future<void> writeSession(TokenPairModel session);

  Future<void> clearSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl(this._store);

  final TokenStore _store;

  @override
  Future<TokenPairModel?> readSession() => _store.read();

  @override
  Future<void> writeSession(TokenPairModel session) => _store.write(session);

  @override
  Future<void> clearSession() => _store.clear();
}
