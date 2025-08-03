class UserEntity {
  final String id;
  final String name;
  final String email;
  final String password;
  final String? token;
  final String? profilePic;
  final int credits;

  const UserEntity({
    this.id = '',
    required this.name,
    required this.email,
    required this.password,
    this.token,
    this.profilePic,
    this.credits = 20,

  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: '',
      token: json['token'],
      profilePic: json['profilePic'],
      credits: (json['credits'] is int) ? json['credits'] as int : 20,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      if (token != null) 'token': token,
      if (profilePic != null) 'profilePic': profilePic,
      'credits': credits,
    };
  }
}
