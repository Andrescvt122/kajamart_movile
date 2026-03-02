class AuthSession {
  const AuthSession({
    required this.token,
    required this.userId,
    required this.roleId,
    required this.email,
    this.userName,
    required this.permissions,
  });

  final String token;
  final int userId;
  final int roleId;
  final String email;
  final String? userName;
  final Set<String> permissions;

  bool hasPermission(String permission) {
    return permissions.contains(permission.toLowerCase().trim());
  }
}
