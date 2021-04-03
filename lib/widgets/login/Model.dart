import 'dart:convert';

Model ModelFromJson(String str) => Model.fromJson(json.decode(str));

String ModelToJson(Model data) => json.encode(data.toJson());

class Model {
  Model ({
    this.name,
    this.phone,
    this.authKey,
    this.email,
    this.password,
});
  String email;
  String password;
  String name;
  String phone;
  String authKey;

  factory Model.fromJson(Map<String, dynamic> json) => Model(
    name: json["name"],
    phone: json["phone"],
    authKey: json["auth_key"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "phone": phone,
    "auth_key": authKey,
  };
}
