import 'dart:convert';

Model ModelFromJson(String str) => Model.fromJson(json.decode(str));

String ModelToJson(Model data) => json.encode(data.toJson());
class Model {
  String firstName;
  String lastName;
  String email;
  String password;

  Model({
    this.firstName,
    this.lastName,
    this.email,
    this.password});
  factory Model.fromJson(Map<String, dynamic> json) => Model(
    // name: json["name"],
    // phone: json["phone"],
    // authKey: json["auth_key"],
    email: json["email"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    // "name": name,
    // "phone": phone,
    // "auth_key": authKey,
    "email": email,
    "password": password,
  };
}
