import 'package:yurideks_app/core/network/token_store.dart';
import 'package:yurideks_app/features/auth/data/models/auth_user_model.dart';
import 'package:yurideks_app/features/auth/data/models/token_pair_model.dart';
import 'package:yurideks_app/features/auth/domain/entities/auth_user.dart';

TokenPairModel buildPair({
  String access = 'access-1',
  String refresh = 'refresh-1',
  Duration refreshFor = const Duration(days: 30),
}) {
  return TokenPairModel(
    user: const AuthUserModel(
      id: 'u-1',
      role: UserRole.citizen,
      phone: '+998901234567',
      name: 'Dilnoza Karimova',
    ),
    accessToken: access,
    refreshToken: refresh,
    accessExpiresAt: DateTime.now().add(const Duration(hours: 1)),
    refreshExpiresAt: DateTime.now().add(refreshFor),
  );
}

class FakeTokenStore implements TokenStore {
  FakeTokenStore([this._pair]);

  TokenPairModel? _pair;
  int writes = 0;
  int clears = 0;

  @override
  Future<TokenPairModel?> read() async => _pair;

  @override
  Future<void> write(TokenPairModel pair) async {
    _pair = pair;
    writes++;
  }

  @override
  Future<void> clear() async {
    _pair = null;
    clears++;
  }
}
