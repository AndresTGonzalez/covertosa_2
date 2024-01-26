import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());

class User {
  int? id;
  int? userid;
  String? email;
  String? password;
  String? name;
  String? surname;

  User({this.userid, this.email, this.password, this.name, this.surname});

  factory User.fromJson(Map<String, dynamic> json) => User(
      userid: json["userid"],
      email: json["email"],
      password: json["password"],
      name: json["name"],
      surname: json["surname"]);

  Map<String, dynamic> toJson() => {
        "userid": userid,
        "email": email,
        "password": password,
        "name": name,
        "surname": surname
      };
}
