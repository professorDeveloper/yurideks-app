import '../../domain/entities/auth_session.dart';
import 'auth_user_model.dart';

class TokenPairModel extends AuthSession {
  const TokenPairModel({
    required AuthUserModel super.user,
    required super.accessToken,
    required super.refreshToken,
    required super.accessExpiresAt,
    required super.refreshExpiresAt,
  });

  factory TokenPairModel.fromJson(Map<String, dynamic> json) {
    return TokenPairModel(
      user: AuthUserModel.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      accessExpiresAt: DateTime.parse(json['accessExpiresAt'] as String),
      refreshExpiresAt: DateTime.parse(json['refreshExpiresAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'user': (user as AuthUserModel).toJson(),
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'accessExpiresAt': accessExpiresAt.toIso8601String(),
      'refreshExpiresAt': refreshExpiresAt.toIso8601String(),
    };
  }
}
