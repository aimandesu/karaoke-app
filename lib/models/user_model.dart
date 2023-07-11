class UserModel {
  String username;
  String email;
  String password;
  String uid;
  String phoneNo;
  DateTime birthDate;

  UserModel({
    required this.username,
    required this.email,
    required this.password,
    required this.uid,
    required this.phoneNo,
    required this.birthDate,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'password': password,
        'uid': uid,
        'phoneNo': phoneNo,
        'birthDate': birthDate,
      };
}
