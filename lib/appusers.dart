class AppUsers {
  final String email;
  final String name;
  final String password;
  final String username;
  final String id;
  final String userimage;

  AppUsers({
    required this.userimage,
    required this.email,
    required this.name,
    required this.password,
    required this.username,
    required this.id,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'password': password,
        'username': username,
        'id': id,
        'userimage': userimage,
      };

  static AppUsers fromJson(Map<String, dynamic> json) => AppUsers(
        email: json['email'],
        name: json['name'],
        password: json['password'],
        username: json['username'],
        id: json['id'],
        userimage: json['userimage'],
      );
}
