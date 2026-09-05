import 'package:equatable/equatable.dart';

enum UserRole { citizen, lawyer, admin }

class AuthUser extends Equatable {
  const AuthUser({
    required this.id,
    required this.role,
    required this.phone,
    required this.name,
  });

  final String id;
  final UserRole role;
  final String phone;
  final String name;

  bool get isCitizen => role == UserRole.citizen;

  @override
  List<Object?> get props => <Object?>[id, role, phone, name];
}
