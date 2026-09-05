import '../../domain/entities/auth_user.dart';

class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required super.id,
    required super.role,
    required super.phone,
    required super.name,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['id'] as String,
      role: _role(json['role'] as String?),
      phone: json['phone'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  static UserRole _role(String? raw) {
    return switch (raw) {
      'LAWYER' => UserRole.lawyer,
      'ADMIN' => UserRole.admin,
      _ => UserRole.citizen,
    };
  }

  static String encodeRole(UserRole role) {
    return switch (role) {
      UserRole.lawyer => 'LAWYER',
      UserRole.admin => 'ADMIN',
      UserRole.citizen => 'CITIZEN',
    };
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'role': encodeRole(role),
      'phone': phone,
      'name': name,
    };
  }
}
