class UserModel {
  String username;
  String email;
  String password;
  String uid;

  UserModel({
    required this.username,
    required this.email,
    required this.password,
    required this.uid,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'password': password,
        'uid': uid,
      };
}
