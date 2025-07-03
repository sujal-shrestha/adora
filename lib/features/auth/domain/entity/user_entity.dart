class UserEntity {
  final String name;
  final String email;
  final String password;
  final String? token;

  const UserEntity({
    required this.name,
    required this.email,
    required this.password,
    this.token,
  });

  // Factory constructor used when receiving user data from API (usually no password in response)
  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: '', // password not returned from server
      token: json['token'],
    );
  }

  // Used when sending data to API
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      if (token != null) 'token': token,
    };
  }
}
